-- 020: Config, banco de ejercicios y fixes de recordatorios

-- ── 1. Fix triskel_send_payment_reminders: excluir también avisos 'pendiente' ──
CREATE OR REPLACE FUNCTION triskel_send_payment_reminders()
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  v_edge_url  text    := 'https://dplzkrdgnynyyunmrawr.supabase.co/functions/v1/send-push';
  v_anon_key  text    := 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRwbHprcmRnbnlueXl1bm1yYXdyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzkwMjg2OTMsImV4cCI6MjA5NDYwNDY5M30.B-J4yJf1lnyR0isMeaCIKHeCCRd7mJe1Do-_6yxbVow';
  v_mes       text    := to_char(now() AT TIME ZONE 'America/Argentina/Buenos_Aires', 'YYYY-MM');
  v_today     integer := extract(day from now() AT TIME ZONE 'America/Argentina/Buenos_Aires')::integer;
  v_tipo      text;
  rec         record;
BEGIN
  FOR rec IN
    SELECT DISTINCT
      a.id          AS alumna_id,
      a.nombre,
      a.auth_user_id,
      a.dia_pago
    FROM triskel_alumnas a
    WHERE a.auth_user_id IS NOT NULL
      AND a.estado = 'activa'
      AND (
        -- primer recordatorio: en el dia_pago
        (a.dia_pago = v_today)
        OR
        -- segundo recordatorio: 5 días después del dia_pago
        (a.dia_pago IS NOT NULL AND a.dia_pago + 5 = v_today)
      )
      AND EXISTS (
        SELECT 1 FROM triskel_inscripciones i
        WHERE i.alumna_id = a.id AND i.activa = true
      )
      AND NOT EXISTS (
        SELECT 1 FROM triskel_pagos p
        WHERE p.alumna_id = a.id AND p.mes = v_mes AND p.pagado = true
      )
      AND NOT EXISTS (
        SELECT 1 FROM triskel_avisos_pago av
        WHERE av.alumna_id = a.id AND av.mes = v_mes
          AND av.estado IN ('aprobado', 'pendiente')
      )
  LOOP
    PERFORM net.http_post(
      url     := v_edge_url,
      headers := jsonb_build_object(
        'Content-Type',  'application/json',
        'Authorization', 'Bearer ' || v_anon_key
      ),
      body    := jsonb_build_object(
        'tipo',           'recordatorio_pago',
        'target_user_id', rec.auth_user_id::text,
        'nombre',         rec.nombre,
        'mes',            v_mes
      )
    );
  END LOOP;
END;
$$;

-- ── 2. Fix triskel_resolver_aviso: validar inscripciones antes de INSERT ───────
CREATE OR REPLACE FUNCTION triskel_resolver_aviso(p_id integer, p_accion text)
RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  v_av         triskel_avisos_pago;
  v_insc_count integer;
  v_por_insc   numeric;
BEGIN
  IF p_accion NOT IN ('aprobado','rechazado') THEN
    RETURN jsonb_build_object('ok',false,'msg','accion invalida');
  END IF;
  SELECT * INTO v_av FROM triskel_avisos_pago WHERE id=p_id AND estado='pendiente';
  IF NOT FOUND THEN
    RETURN jsonb_build_object('ok',false,'msg','aviso no encontrado o ya resuelto');
  END IF;
  UPDATE triskel_avisos_pago SET estado=p_accion, updated_at=now() WHERE id=p_id;
  IF p_accion='aprobado' THEN
    UPDATE triskel_pagos
    SET pagado=true, fecha_pago=current_date, nota=v_av.nota
    WHERE alumna_id=v_av.alumna_id AND mes=v_av.mes AND pagado=false;
    IF NOT FOUND THEN
      SELECT COUNT(*) INTO v_insc_count
      FROM triskel_inscripciones WHERE alumna_id=v_av.alumna_id AND activa=true;
      IF v_insc_count = 0 THEN
        -- rollback: revertir el aviso a pendiente
        UPDATE triskel_avisos_pago SET estado='pendiente', updated_at=now() WHERE id=p_id;
        RETURN jsonb_build_object('ok',false,'msg','La alumna no tiene inscripciones activas');
      END IF;
      v_por_insc := CASE
        WHEN v_av.monto_declarado IS NOT NULL
        THEN ROUND(v_av.monto_declarado / v_insc_count)
        ELSE NULL
      END;
      INSERT INTO triskel_pagos(alumna_id, inscripcion_id, mes, monto, pagado, fecha_pago, nota)
      SELECT v_av.alumna_id, i.id, v_av.mes,
             COALESCE(v_por_insc, i.precio), true, current_date, v_av.nota
      FROM triskel_inscripciones i
      WHERE i.alumna_id=v_av.alumna_id AND i.activa=true
      ON CONFLICT DO NOTHING;
    END IF;
  END IF;
  RETURN jsonb_build_object('ok',true,'estado',p_accion);
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_resolver_aviso(integer, text) TO authenticated;

-- ── 3. Tabla triskel_configuracion ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS triskel_configuracion (
  key        text PRIMARY KEY,
  value      jsonb NOT NULL DEFAULT '{}',
  updated_at timestamptz DEFAULT now()
);
ALTER TABLE triskel_configuracion ENABLE ROW LEVEL SECURITY;
-- Solo authenticated puede leer (la profesora), SECURITY DEFINER para escribir
CREATE POLICY "auth_read" ON triskel_configuracion FOR SELECT TO authenticated USING (true);
REVOKE SELECT ON triskel_configuracion FROM anon;

-- RPC para obtener toda la configuración
CREATE OR REPLACE FUNCTION triskel_get_configuracion()
RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_uid uuid := auth.uid();
BEGIN
  IF v_uid IS NULL THEN RETURN jsonb_build_object('ok',false,'msg','not authenticated'); END IF;
  RETURN (SELECT jsonb_object_agg(key, value) FROM triskel_configuracion);
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_get_configuracion() TO authenticated;

-- RPC para guardar un valor de configuración
CREATE OR REPLACE FUNCTION triskel_save_configuracion(p_key text, p_value jsonb)
RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_uid uuid := auth.uid();
BEGIN
  IF v_uid IS NULL THEN RETURN jsonb_build_object('ok',false,'msg','not authenticated'); END IF;
  INSERT INTO triskel_configuracion(key, value, updated_at) VALUES(p_key, p_value, now())
  ON CONFLICT(key) DO UPDATE SET value=EXCLUDED.value, updated_at=now();
  RETURN jsonb_build_object('ok',true);
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_save_configuracion(text, jsonb) TO authenticated;

-- ── 4. Tabla triskel_banco_ejercicios ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS triskel_banco_ejercicios (
  id       serial PRIMARY KEY,
  categoria text NOT NULL,  -- 'mat', 'reformer', 'funcional'
  titulo   text NOT NULL,
  ejs      jsonb NOT NULL DEFAULT '[]',
  orden    integer NOT NULL DEFAULT 0
);
ALTER TABLE triskel_banco_ejercicios ENABLE ROW LEVEL SECURITY;
CREATE POLICY "auth_read" ON triskel_banco_ejercicios FOR SELECT TO authenticated USING (true);
REVOKE SELECT ON triskel_banco_ejercicios FROM anon;

-- RPC para obtener el banco completo
CREATE OR REPLACE FUNCTION triskel_get_banco()
RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_uid uuid := auth.uid();
BEGIN
  IF v_uid IS NULL THEN RETURN jsonb_build_object('ok',false); END IF;
  RETURN jsonb_build_object(
    'ok', true,
    'data', (
      SELECT jsonb_object_agg(categoria, tarjetas)
      FROM (
        SELECT categoria, jsonb_agg(jsonb_build_object('id',id,'titulo',titulo,'ejs',ejs) ORDER BY orden, id) AS tarjetas
        FROM triskel_banco_ejercicios
        GROUP BY categoria
      ) t
    )
  );
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_get_banco() TO authenticated;

CREATE OR REPLACE FUNCTION triskel_save_banco_tarjeta(p_id integer, p_categoria text, p_titulo text, p_ejs jsonb, p_orden integer DEFAULT 0)
RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_uid uuid := auth.uid(); v_new_id integer;
BEGIN
  IF v_uid IS NULL THEN RETURN jsonb_build_object('ok',false,'msg','not authenticated'); END IF;
  IF p_id IS NULL OR p_id = 0 THEN
    INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES(p_categoria,p_titulo,p_ejs,p_orden) RETURNING id INTO v_new_id;
  ELSE
    UPDATE triskel_banco_ejercicios SET categoria=p_categoria,titulo=p_titulo,ejs=p_ejs,orden=p_orden WHERE id=p_id;
    v_new_id := p_id;
  END IF;
  RETURN jsonb_build_object('ok',true,'id',v_new_id);
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_save_banco_tarjeta(integer, text, text, jsonb, integer) TO authenticated;

CREATE OR REPLACE FUNCTION triskel_delete_banco_tarjeta(p_id integer)
RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_uid uuid := auth.uid();
BEGIN
  IF v_uid IS NULL THEN RETURN jsonb_build_object('ok',false,'msg','not authenticated'); END IF;
  DELETE FROM triskel_banco_ejercicios WHERE id=p_id;
  RETURN jsonb_build_object('ok',true);
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_delete_banco_tarjeta(integer) TO authenticated;

-- ── Seed data para triskel_banco_ejercicios ───────────────────────────────────
DO $seed$
BEGIN
IF NOT EXISTS (SELECT 1 FROM triskel_banco_ejercicios LIMIT 1) THEN

-- MAT --
INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('mat','Banda elástica I','[{"nombre":"Banda elástica en tobillos, elevo brazos cabeza y hombros","vt":"8 rep · rotado al lateral derecho, elevo pierna derecha"},{"nombre":"Cien","vt":"100 bombeos · apertura"},{"nombre":"Idem 1","vt":"lado contrario"},{"nombre":"Cien","vt":"100 bombeos · círculos con brazos"},{"nombre":"De lateral, pierna extendida","vt":"8 círculos c/dirección"}]',0);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('mat','Disco I','[{"nombre":"Sentadas con piernas extendidas, disco en mano derecha","vt":"8 rep · apertura al lateral"},{"nombre":"Spine stretch","vt":"6 rep · alargar columna al frente"},{"nombre":"Idem 1","vt":"mano izquierda"},{"nombre":"Piernas en apertura, rotar al lateral, llevar el disco por encima de la cabeza","vt":"6 rep c/lado"},{"nombre":"Pies al ancho de la cadera, llevo el disco por encima","vt":"8 rep · disco detrás de la cabeza"},{"nombre":"Idem 4","vt":""},{"nombre":"Leg push con remo cerrado","vt":"10 rep c/lado"},{"nombre":"Swimming con flete rodillas","vt":"20 alternados"},{"nombre":"Idem 7","vt":"lado contrario"},{"nombre":"Teaser","vt":"6 rep · disco al frente"}]',1);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('mat','Disco II','[{"nombre":"Sentadas con piernas extendidas, disco en mano derecha","vt":"8 rep · apertura al lateral"},{"nombre":"Spine stretch","vt":"6 rep"},{"nombre":"Idem 1","vt":"mano izquierda"},{"nombre":"Piernas extendidas","vt":"8 rep · flexión de un codo a 90°"},{"nombre":"Thing stretch","vt":"6 rep c/lado"},{"nombre":"Idem 4","vt":"lado contrario"},{"nombre":"Piernas en apertura, rotar al lateral, llevar el disco por encima de la cabeza","vt":"6 rep c/lado"},{"nombre":"Pies al ancho de la cadera, llevo el disco por encima","vt":"8 rep · disco detrás de la cabeza"},{"nombre":"Idem 4","vt":""},{"nombre":"Leg push con remo cerrado","vt":"10 rep c/lado"},{"nombre":"Swimming con flete rodillas","vt":"20 alternados"},{"nombre":"Idem 7","vt":""},{"nombre":"Teaser","vt":"6 rep"}]',2);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('mat','Disco III','[{"nombre":"Estocada con disco","vt":"10 rep c/lado · vuelo lateral"},{"nombre":"Peso muerto, un pie atrás","vt":"10 rep c/lado · elevo el disco"},{"nombre":"Sentadilla lateral","vt":"10 rep c/lado · vuelo frontal con el disco"},{"nombre":"Sentadilla común","vt":"10 rep · elevar el disco por encima de la cabeza"},{"nombre":"Idem 3","vt":""},{"nombre":"Idem 2","vt":""},{"nombre":"Idem 1","vt":""},{"nombre":"Tracciono disco (arrodillada)","vt":"8 rep c/lado · elevo pierna en extensión"},{"nombre":"Thing stretch","vt":"6 rep c/lado"},{"nombre":"Idem 8","vt":"lado contrario"},{"nombre":"Stomage","vt":"8 rep"}]',3);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('mat','Bastón I','[{"nombre":"Bastón con brazos extendidos, pies al suelo, elevo cabeza y hombros luego extiendo piernas","vt":"8 rep · círculos hacia un lado al final"},{"nombre":"Teaser","vt":"6 rep · apertura"},{"nombre":"Cien","vt":"100 bombeos · rotar el bastón de un lateral a otro"},{"nombre":"Idem 1","vt":"círculos al lado contrario al final"},{"nombre":"Puente de hombros con flexión de pierna derecha","vt":"8 rep · llevar el bastón hacia atrás"},{"nombre":"Cien para aductores","vt":"100 bombeos · bastón entre rodillas"},{"nombre":"Idem 5","vt":"pierna izquierda"},{"nombre":"De lateral, elevación de pierna","vt":"8 rep · luego círculos 5 c/dirección"},{"nombre":"Stomage llevando el bastón por encima de la cabeza","vt":"8 rep"},{"nombre":"Llevarlo atrás","vt":"8 rep · por encima de la cabeza"},{"nombre":"Stomage masaje","vt":"8 rep"},{"nombre":"Idem 8","vt":"lado contrario"},{"nombre":"Leg push hacia el otro lado","vt":"10 rep c/lado"},{"nombre":"Plancha iso","vt":"30 seg"}]',4);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('mat','Bastón II','[{"nombre":"Estocada con bastón detrás del homoplato","vt":"10 rep c/lado · llevo el bastón por encima de la cabeza"},{"nombre":"Peso muerto, un pie atrás","vt":"10 rep c/lado · elevo el bastón"},{"nombre":"Sentadilla lateral","vt":"10 rep c/lado · bastón por encima de la cabeza, elevo el talón"},{"nombre":"Sentadilla común","vt":"10 rep · elevar el bastón por encima de la cabeza"},{"nombre":"Trabajo para tobillos","vt":"15 rep · talones arriba y abajo"},{"nombre":"Idem 3","vt":""},{"nombre":"Idem 2","vt":""},{"nombre":"Idem 1","vt":""},{"nombre":"Pierna en extensión (arrodillada)","vt":"8 rep c/lado · inclino el tronco hacia la pierna extendida"},{"nombre":"Thing stretch","vt":"6 rep c/lado"},{"nombre":"Idem 9","vt":"lado contrario"},{"nombre":"Apoyo codo, plancha lateral, despego la cadera","vt":"8 rep c/lado · elevo la pierna"},{"nombre":"Leg push","vt":"10 rep c/lado"},{"nombre":"Plancha alta abro y cierro","vt":"10 rep"},{"nombre":"Idem 7","vt":""},{"nombre":"Idem 6","vt":""},{"nombre":"Idem 5","vt":""},{"nombre":"Stomage","vt":"8 rep"}]',5);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('mat','Funcional I (estocada)','[{"nombre":"Estocada","vt":"10 rep c/lado · llevo el pie de atrás al lateral"},{"nombre":"Peso muerto, un pie atrás","vt":"10 rep c/lado · elevo los brazos"},{"nombre":"Sentadilla lateral","vt":"10 rep c/lado · brazos al lateral de la cabeza"},{"nombre":"Sentadilla común","vt":"10 rep · elevar brazos al lateral"},{"nombre":"Idem 3","vt":""},{"nombre":"Idem 2","vt":""},{"nombre":"Idem 1","vt":""},{"nombre":"Peso muerto a 2 pies","vt":"10 rep"},{"nombre":"Plancha elevando una pierna (arrodillada)","vt":"8 rep c/lado"},{"nombre":"Flexiones de brazos","vt":"8-10 rep"},{"nombre":"Idem 9","vt":""},{"nombre":"Stomage","vt":"8 rep"}]',6);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('mat','Banda elástica II','[{"nombre":"Banda elástica en tobillos, elevo brazos cabeza y hombros","vt":"8 rep · elevo pierna derecha"},{"nombre":"Cien","vt":"100 bombeos · apertura"},{"nombre":"Idem 1","vt":"pierna izquierda"},{"nombre":"Cien","vt":"100 bombeos · tijera"},{"nombre":"De lateral, piernas extendidas","vt":"8 círculos c/dirección"},{"nombre":"Apoyo codo, elevo pierna dándole tensión a la banda","vt":"10 rep c/lado"},{"nombre":"Leg push","vt":"10 rep c/lado"},{"nombre":"Plancha alta abro y cierro","vt":"10 rep"},{"nombre":"Idem 7","vt":""},{"nombre":"Idem 6","vt":""},{"nombre":"Idem 5","vt":"lado contrario"},{"nombre":"Stomage","vt":"8 rep"}]',7);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('mat','Clásico I','[{"nombre":"Leg circle a un pie","vt":"5 círculos c/dirección · pierna contraria idem"},{"nombre":"Double leg stretch","vt":"8 rep"},{"nombre":"Idem 1","vt":""},{"nombre":"Leg pull back a una pierna","vt":"8 rep c/lado"},{"nombre":"Cien","vt":"100 bombeos"},{"nombre":"Idem 4","vt":"pierna contraria"},{"nombre":"Shoulder bridge a una pierna","vt":"8 rep c/lado · cadera arriba"},{"nombre":"Leg circle con ambas piernas","vt":"5 círculos c/dirección"},{"nombre":"Idem 8","vt":"sentido contrario"},{"nombre":"Hip circle","vt":"5 círculos c/dirección"},{"nombre":"Stomage","vt":"8 rep"},{"nombre":"Basic back extension","vt":"8 rep · manos bajo la frente"}]',8);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('mat','Clásico II','[{"nombre":"Círculo a una pierna","vt":"5 círculos c/dirección · ambas piernas"},{"nombre":"Vela","vt":"6 rep · sostener 3 seg arriba"},{"nombre":"Idem 1","vt":"pierna contraria"},{"nombre":"De cúbito lateral, trabajo para oblicuo y aductor","vt":"10 rep c/lado"},{"nombre":"Elevación de pierna","vt":"10 rep c/lado"},{"nombre":"Thing stretch","vt":"6 rep c/lado"},{"nombre":"Idem 5","vt":"lado contrario"},{"nombre":"Idem 4","vt":"lado contrario"},{"nombre":"Swimming","vt":"20-30 alternados"},{"nombre":"Leg push","vt":"10 rep c/lado"},{"nombre":"Plancha","vt":"30-40 seg"},{"nombre":"Idem 11","vt":""},{"nombre":"Stomage","vt":"8 rep"}]',9);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('mat','Clásico III','[{"nombre":"Leg circle pierna derecha","vt":"5 círculos c/dirección"},{"nombre":"Cien","vt":"100 bombeos"},{"nombre":"Idem 1","vt":"pierna izquierda"},{"nombre":"The coordination","vt":"8 rep · abrir-cerrar-doblar-estirar"},{"nombre":"Sirena","vt":"6 rep c/lado · elongar lateral"},{"nombre":"Postural con un brazo al lateral","vt":"8 rep · escápulas juntas"},{"nombre":"Postural codos a 90°","vt":"8 rep · apertura"},{"nombre":"Idem otro brazo","vt":""},{"nombre":"Idem 5","vt":"lado contrario"},{"nombre":"De lateral para oblicuo","vt":"10 rep c/lado"},{"nombre":"Stomage","vt":"8 rep"},{"nombre":"Idem 11","vt":"lado contrario"}]',10);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('mat','Brazos','[{"nombre":"Sirena para tríceps","vt":"8 rep c/lado · codo pegado a la oreja"},{"nombre":"Elevación de pierna con patada adelante","vt":"10 rep c/lado"},{"nombre":"Leg push","vt":"10 rep c/lado"},{"nombre":"Plancha abro y cierro","vt":"10 rep"},{"nombre":"Flexiones de brazos","vt":"8-10 rep"},{"nombre":"Plancha toco hombros","vt":"10 rep · no rotar cadera"},{"nombre":"Leg push","vt":"10 rep c/lado"},{"nombre":"Idem 2","vt":"pierna contraria"},{"nombre":"Idem 1","vt":"lado contrario"},{"nombre":"Plancha subo y bajo","vt":"8 rep c/lado · codo-codo-mano-mano"}]',11);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('mat','Manos a la cabeza','[{"nombre":"Manos a la cabeza, pies al suelo, elevo cabeza y hombros luego extiendo piernas","vt":"8 rep · círculos hacia un lado al final"},{"nombre":"Teaser","vt":"6 rep · apertura"},{"nombre":"Cien","vt":"100 bombeos"},{"nombre":"Idem 1","vt":"círculos al lado contrario"},{"nombre":"Roll up","vt":"6-8 rep"},{"nombre":"Sentadas, apertura de brazo derecho al lateral","vt":"8 rep · luego círculos"},{"nombre":"Codos a 90° abriendo al lateral","vt":"8 rep · flexión y extensión de codo"},{"nombre":"Sentadas, llevar los brazos hacia atrás","vt":"8 rep · pecho abierto"},{"nombre":"Leg push","vt":"10 rep c/lado"},{"nombre":"Plancha tocando hombros","vt":"10 rep · no rotar cadera"},{"nombre":"Leg push hacia el otro lado","vt":"10 rep c/lado"},{"nombre":"Plancha iso","vt":"30-40 seg"}]',12);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('mat','Foam Roller I','[{"nombre":"Foam roller bajo la columna, brazos abiertos · respiración","vt":"8 respiraciones · apertura de pecho"},{"nombre":"Roller bajo la columna, rodillas al pecho, leg circles","vt":"5 círculos c/dirección · luego frog"},{"nombre":"Cien con roller bajo la columna","vt":"100 bombeos · piernas en mesa, no perder roller"},{"nombre":"Roller bajo la columna, roll hacia un lateral","vt":"8 rep · masaje dorsal lento"},{"nombre":"Roller bajo el sacro, puente de hombros","vt":"8 rep · luego una pierna"},{"nombre":"De pie sobre el roller, sentadilla","vt":"8 rep lentas · equilibrio, manos libres"},{"nombre":"Roller al frente, apoyo manos, plancha","vt":"30 seg · luego rodilla al pecho alternada"},{"nombre":"Sentadas, roller en la espalda, rodar hacia atrás y volver","vt":"6 rep · articular vértebra a vértebra"},{"nombre":"De lado, roller bajo el costado, masaje IT band","vt":"30 seg c/lado · luego cuádriceps"},{"nombre":"Stomage con roller","vt":"8 rep · roller bajo el pecho"}]',13);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('mat','Pelota I','[{"nombre":"Pelota bajo la zona lumbar, piernas a 90°, leg circles","vt":"5 círculos c/dirección · luego frog"},{"nombre":"Pelota bajo el sacro, puente de hombros","vt":"8 rep · luego una pierna extendida"},{"nombre":"Cien con pelota entre rodillas","vt":"100 bombeos · apretar pelota al bombear"},{"nombre":"Pelota entre rodillas, abdominal con rotación","vt":"10 rep c/lado · oblicuo"},{"nombre":"Sentadilla con pelota entre rodillas","vt":"10 rep · luego pulsos 10 rep"},{"nombre":"De lateral, pelota entre tobillos, elevo piernas","vt":"10 rep c/lado · luego círculos"},{"nombre":"Pelota detrás de la cabeza, plancha","vt":"30 seg · luego rodilla al pecho 8 rep"},{"nombre":"Roll back con pelota","vt":"6-8 rep · pelota al frente, rodar y volver"},{"nombre":"Stomage apoyando la pelota","vt":"8 rep · pelota bajo el pecho"},{"nombre":"Estiramiento final: pelota bajo la columna torácica","vt":"1 min · apertura de pecho, respiración"}]',14);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('mat','Básico I','[{"nombre":"Boca arriba · activación de transverso, respiración con expansión costal","vt":"8 respiraciones · mano en panza, sentir que sube"},{"nombre":"Pelvis en neutro · impronta, toma de conciencia","vt":"8 rep · alternar neutro e impronta, sin apuro"},{"nombre":"Puente de hombros","vt":"8 rep · sostener 2 seg arriba · mod: solo subir cadera sin sostener"},{"nombre":"Cien · piernas en mesa (rodillas a 90°)","vt":"50 bombeos para empezar · mod: pies en el suelo si molesta el cuello"},{"nombre":"Single leg stretch","vt":"8 rep c/lado · mod: no levantar la cabeza si hay tensión cervical"},{"nombre":"Idem 3 · una pierna extendida al frente","vt":"mod: mantener pierna más alta si molesta la lumbar"},{"nombre":"Leg circle a un pie · pequeño, controlado","vt":"5 círculos c/dirección · mod: rodilla doblada si hay tensión"},{"nombre":"Idem 7 · pierna contraria","vt":""},{"nombre":"De lateral · clam","vt":"10 rep c/lado · con banda en muslos · mod: sin banda"},{"nombre":"De lateral · elevación de pierna extendida","vt":"10 rep c/lado · mod: rodilla doblada"},{"nombre":"Idem 9 y 10 · cambia de lado","vt":""},{"nombre":"Cuadrupedia · gato / vaca, respiración","vt":"8 rep · exhalar en gato, inhalar en vaca"},{"nombre":"Cuadrupedia · brazo y pierna opuesta en extensión","vt":"8 rep c/lado · mod: solo el brazo o solo la pierna"},{"nombre":"Stomage básico · solo levanto pecho","vt":"8 rep · manos bajo la frente, codos al suelo · mod: no llegar alto"}]',15);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('mat','Básico II','[{"nombre":"Cien · piernas a 90°","vt":"100 bombeos · mod: extiende piernas a 45° si tolera"},{"nombre":"Roll up · con ayuda de manos en los muslos","vt":"6-8 rep · mod: con rodillas dobladas"},{"nombre":"Single leg stretch","vt":"8 rep c/lado · mod: cabeza apoyada"},{"nombre":"Double leg stretch","vt":"8 rep · mod: solo brazos si molesta lumbar"},{"nombre":"Leg circle amplio a un pie","vt":"5 círculos c/dirección · mod: círculo pequeño"},{"nombre":"Idem 5 · pierna contraria","vt":""},{"nombre":"Puente de hombros · una pierna extendida","vt":"8 rep c/lado · luego pulsos 8 rep · mod: ambas piernas dobladas"},{"nombre":"Rolling like a ball · básico","vt":"8 rep · mod: pies en el suelo si hay vértigo"},{"nombre":"De lateral · pierna extendida, círculos","vt":"8 círculos c/dirección c/lado · mod: rodilla doblada"},{"nombre":"De lateral · patada adelante y atrás","vt":"8 rep c/lado · mod: rango de movimiento pequeño"},{"nombre":"Idem 9 y 10 · cambia de lado","vt":""},{"nombre":"Swimming · solo piernas","vt":"20 alternados · luego sumo brazos · mod: solo brazos"},{"nombre":"Cuadrupedia · extensión alternada, más rápido","vt":"10 rep c/lado · mod: pausar entre rep"},{"nombre":"Stomage","vt":"8 rep · mod: manos bajo la frente"}]',16);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('mat','Intermedio — Secuencia progresiva','[{"nombre":"Cien","vt":"100 bombeos · piernas a 45° o extendidas"},{"nombre":"Roll up","vt":"6-8 rep · sin ayuda de manos"},{"nombre":"Leg circles a un pie · amplio","vt":"5 círculos c/dirección"},{"nombre":"Idem 3 · pierna contraria","vt":""},{"nombre":"Rolling like a ball","vt":"8 rep · sin tocar el suelo con pies"},{"nombre":"Single leg stretch · double leg stretch","vt":"8 rep c/u · fluir entre los dos"},{"nombre":"Scissors · lower lift","vt":"8 rep c/lado scissors · 8 rep lower lift"},{"nombre":"Criss cross","vt":"8 rep c/lado · codo al rodilla opuesta"},{"nombre":"Spine stretch","vt":"6 rep · exhalar al elongar"},{"nombre":"Saw","vt":"4-5 rep c/lado · rotar desde la cintura"},{"nombre":"Swan básico","vt":"6 rep · codos cerca del cuerpo"},{"nombre":"Single leg kick","vt":"8 rep c/lado · cadera en el suelo"},{"nombre":"De lateral · serie completa (elevación, círculos, patada adelante/atrás)","vt":"8-10 rep cada ejercicio"},{"nombre":"Idem 13 · cambia de lado","vt":""},{"nombre":"Teaser básico · piernas en mesa","vt":"6 rep · bajar lento 4 tiempos"},{"nombre":"Swimming","vt":"20-30 alternados · no balancear tronco"},{"nombre":"Stomage","vt":"8 rep"}]',17);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('mat','Avanzado — Secuencia clásica','[{"nombre":"Cien · piernas bajas, sin apoyar","vt":"100 bombeos · piernas a 5 cm del suelo"},{"nombre":"Roll up · roll over","vt":"6 rep cada uno · roll over: no pasar de cervicales"},{"nombre":"Leg circles amplios a un pie","vt":"5 círculos c/dirección · pelvis estable"},{"nombre":"Idem 3 · pierna contraria","vt":""},{"nombre":"Rolling like a ball","vt":"8 rep · sin tocar el suelo"},{"nombre":"Series de 5 completas · single / double / scissors / lower lift / criss cross","vt":"8-10 rep c/u sin descanso entre ejercicios"},{"nombre":"Spine stretch con extensión de torácica","vt":"5-6 rep · extender torácica al final"},{"nombre":"Open leg rocker","vt":"6-8 rep · equilibrio en el cóccix"},{"nombre":"Corkscrew","vt":"4 rep c/lado · círculo completo de piernas"},{"nombre":"Saw","vt":"5 rep c/lado · rotar máximo"},{"nombre":"Swan dive","vt":"6 rep · balancear pecho-piernas alternado"},{"nombre":"Double leg kick","vt":"4-6 rep c/lado · extender al máximo"},{"nombre":"Neck pull","vt":"6-8 rep · manos detrás de la cabeza, no jalar"},{"nombre":"Jackknife","vt":"5-6 rep · piernas al techo, bajar a 45°"},{"nombre":"De lateral · serie completa avanzada","vt":"10 rep cada ejercicio · fluir sin pausa"},{"nombre":"Idem 15 · cambia de lado","vt":""},{"nombre":"Teaser · variación a un pie","vt":"5-6 rep c/u · sin apoyar la espalda"},{"nombre":"Boomerang","vt":"5 rep · control total de la secuencia"},{"nombre":"Swimming avanzado · rápido","vt":"30-40 alternados · ritmo sostenido"},{"nombre":"Leg pull front · leg pull back","vt":"6 rep c/lado c/ejercicio"}]',18);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('mat','Aro Mágico I','[{"nombre":"Boca arriba, aro entre rodillas · cien","vt":"100 bombeos · apretar el aro al bombear"},{"nombre":"Aro entre rodillas · puente de hombros","vt":"8 rep · luego una pierna"},{"nombre":"Aro entre rodillas · single leg stretch","vt":"8 rep c/lado · apretar el aro"},{"nombre":"Aro entre manos extendidas al techo · elevo cabeza y hombros","vt":"8 rep · luego círculos laterales"},{"nombre":"Sentadas, aro al frente · spine stretch","vt":"6 rep · empujar el aro al elongar"},{"nombre":"Sentadas, aro entre tobillos · leg circle","vt":"5 círculos c/dirección"},{"nombre":"De lateral, aro entre tobillos · elevación de pierna","vt":"10 rep c/lado"},{"nombre":"Idem 7 · cambia de lado","vt":""},{"nombre":"De pie, aro entre muslos · sentadilla","vt":"10 rep · luego pulsos 10 rep"},{"nombre":"Stomage con aro bajo la frente","vt":"8 rep · apretar aro al subir"}]',19);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('mat','Aro Mágico II','[{"nombre":"Boca arriba, aro entre manos al techo · roll up","vt":"6-8 rep · aro guía el movimiento"},{"nombre":"Aro entre rodillas · series de 5","vt":"8 rep c/ejercicio · apretar entre rep"},{"nombre":"Aro entre tobillos · tijera","vt":"8 rep c/lado"},{"nombre":"Aro entre manos, brazos al techo · teaser","vt":"6 rep · bajar lento 4 tiempos"},{"nombre":"Aro entre manos · remo sentada, apertura al lateral","vt":"8 rep c/lado"},{"nombre":"Aro entre manos detrás de la cabeza · apertura de pecho","vt":"8 rep · codos atrás, pecho abierto"},{"nombre":"De lateral, aro entre tobillos · serie completa","vt":"8-10 rep cada ejercicio"},{"nombre":"Idem 7 · cambia de lado","vt":""},{"nombre":"De pie, aro entre muslos · sentadilla profunda","vt":"10 rep · talones en el suelo"},{"nombre":"Aro entre manos al frente · press frontal de pie","vt":"10 rep · no elevar hombros"},{"nombre":"Stomage con aro bajo el pecho","vt":"8 rep · apretar aro al extender"}]',20);

-- FUNCIONAL --
INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('funcional','Agosto','[{"nombre":"CORE · Plancha toco hombros · 40seg","vt":"Press de hombros · 20 desc"},{"nombre":"CORE · Sit ups con elevación de disco · 40seg","vt":"Disco arriba tijera · 20 desc"},{"nombre":"PIERNAS · Estocada hacia adelante · 40seg","vt":"Abro y cierro con salto · 20 desc"},{"nombre":"PIERNAS · Sentadilla con Rusa · 40seg","vt":"Sentadilla de lateral al step · 20 desc"},{"nombre":"CARDIO · Saltos al frente (step) · 40seg","vt":"Plancha · 20 desc"},{"nombre":"CARDIO · Escalera abro y cierro · 40seg","vt":"Vuelvo en trote · 20 desc"},{"nombre":"ESPALDA · Remo abierto con discos · 40seg","vt":"Vuelo Frontal · 20 desc"},{"nombre":"ESPALDA · Apertura hacia el lateral con discos · 40seg","vt":"Bíceps · 20 desc"},{"nombre":"PIERNAS · Sentadilla abriendo y cerrando (banda elástica) · 40seg","vt":"Apertura de lateral dando tensión a la banda · 20 desc"},{"nombre":"CORE · Mountain Climbers · 40seg","vt":"Sentadilla · 20 desc"},{"nombre":"PECHO · Flexiones de brazos · 40seg","vt":"Plancha · 20 desc"},{"nombre":"PECHO · Codos a 90° con discos · 40seg","vt":"Vuelo Frontal · 20 desc"},{"nombre":"CORE · Bicicleta · 40seg","vt":"Barquito · 20 desc"},{"nombre":"CORE · Plancha paso el disco de un lado a otro · 40seg","vt":"Abro y cierro pies · 20 desc"},{"nombre":"PIERNAS · Sentadilla Sumo · 40seg","vt":"Vuelo Frontal · 20 desc"},{"nombre":"PIERNAS · Estocada con step y rusa · 40seg","vt":"Rodilla al pecho · 20 desc"},{"nombre":"CARDIO · Saltos al step de frente · 40seg","vt":"Mountain Climbers · 20 desc"},{"nombre":"CARDIO · Correr de lateral · 40seg","vt":"Vuelvo con rodillas arriba · 20 desc"},{"nombre":"ESPALDA · Remo cerrado · 40seg","vt":"Vuelo lateral · 20 desc"},{"nombre":"ESPALDA · Remo cerrado · 40seg","vt":"Tríceps · 20 desc"},{"nombre":"PIERNAS · Sentadilla ISO (banda elástica) · 40seg","vt":"Abro y cierro · 20 desc"},{"nombre":"CORE · Plancha Oruga · 40seg","vt":"Salto · 20 desc"},{"nombre":"PECHO · Flexión de Brazos · 40seg","vt":"Plancha lateral · 20 desc"},{"nombre":"PECHO · Disco al Pecho · 40seg","vt":"Press de hombros · 20 desc"}]',0);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('funcional','Septiembre','[{"nombre":"CORE · Plancha rodillas al pecho (pelota 2kg) · 40seg","vt":"Press de hombros con pelota · 20 desc"},{"nombre":"PIERNAS · Estocada hacia atrás (pelota 3kg) · 40seg","vt":"Sentadilla lateral · 20 desc"},{"nombre":"CARDIO · Sentadilla pop con aro · 40seg","vt":"Salto adentro del aro · 20 desc"},{"nombre":"CORE · Mountain Climbers · 40seg","vt":"Sentadilla · 20 desc"},{"nombre":"PIERNAS · Sentadilla sumo · 40seg","vt":"Vuelo frontal con disco · 20 desc"},{"nombre":"ESPALDA · Remo cerrado · 40seg","vt":"Press de hombros · 20 desc"},{"nombre":"PECHO · Flexiones de brazos · 40seg","vt":"Plancha · 20 desc"},{"nombre":"CARDIO · Trote lateral · 40seg","vt":"Rodillas arriba · 20 desc"},{"nombre":"CORE · Sit ups con disco · 40seg","vt":"Disco arriba tijera · 20 desc"},{"nombre":"PIERNAS · Estocada adelante · 40seg","vt":"Abro y cierro con salto · 20 desc"}]',1);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('funcional','Octubre','[{"nombre":"CORE · Plancha rodillas al pecho (balón) · 40seg","vt":"Press de hombros con pelota · 20 desc"},{"nombre":"CARDIO · Sentadilla pop con escalera · 40seg","vt":"Trote · 20 desc"},{"nombre":"ESPALDA · Remo cerrado con barra · 40seg","vt":"Sentadilla pop · 20 desc"},{"nombre":"CORE · Mountain Climbers · 40seg","vt":"Sentadilla · 20 desc"},{"nombre":"PIERNAS · Estocada adelante · 40seg","vt":"Rodilla al pecho · 20 desc"},{"nombre":"PECHO · Flexiones de brazos · 40seg","vt":"Plancha lateral · 20 desc"},{"nombre":"PIERNAS · Sentadilla sumo · 40seg","vt":"Vuelo frontal con disco · 20 desc"},{"nombre":"ESPALDA · Apertura lateral con discos · 40seg","vt":"Bíceps · 20 desc"},{"nombre":"CARDIO · Saltos de frente · 40seg","vt":"Mountain Climbers · 20 desc"},{"nombre":"CORE · Bicicleta · 40seg","vt":"Barquito · 20 desc"}]',2);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('funcional','Noviembre','[{"nombre":"ESPALDA · Remo cerrado con banda amarilla · 40seg","vt":"Tríceps · 20 desc"},{"nombre":"CORE · Cortitos con disco arriba · 40seg","vt":"Bisagra con disco arriba · 20 desc"},{"nombre":"PIERNAS · Peso muerto romano con disco · 40seg","vt":"Giro de disco · 20 desc"},{"nombre":"CARDIO · Trote lateral · 40seg","vt":"Rodillas arriba · 20 desc"},{"nombre":"CORE · Mountain Climbers · 40seg","vt":"Sentadilla · 20 desc"},{"nombre":"PIERNAS · Estocada adelante · 40seg","vt":"Abro y cierro con salto · 20 desc"},{"nombre":"PECHO · Flexiones de brazos · 40seg","vt":"Plancha · 20 desc"},{"nombre":"ESPALDA · Remo abierto con discos · 40seg","vt":"Vuelo frontal · 20 desc"},{"nombre":"CORE · Plancha toco hombros · 40seg","vt":"Press de hombros · 20 desc"},{"nombre":"PIERNAS · Sentadilla sumo · 40seg","vt":"Vuelo frontal con disco · 20 desc"}]',3);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('funcional','Diciembre','[{"nombre":"CORE · Plancha baja al step · 40seg","vt":"Saltos de frente · 20 desc"},{"nombre":"ESPALDA · Vuelo lateral con tronco a 45° con discos · 40seg","vt":"Pullover · 20 desc"},{"nombre":"CARDIO · En step de lateral · 40seg","vt":"Sentadilla común · 20 desc"},{"nombre":"CORE · Mountain Climbers · 40seg","vt":"Sentadilla · 20 desc"},{"nombre":"PIERNAS · Estocada con barra · 40seg","vt":"Rodilla al pecho · 20 desc"},{"nombre":"PECHO · Flexiones de brazos · 40seg","vt":"Plancha lateral · 20 desc"},{"nombre":"PIERNAS · Sentadilla ISO · 40seg","vt":"Abro y cierro · 20 desc"},{"nombre":"ESPALDA · Remo cerrado · 40seg","vt":"Press de hombros · 20 desc"},{"nombre":"CORE · Sit ups con disco · 40seg","vt":"Disco arriba tijera · 20 desc"},{"nombre":"CARDIO · Correr de lateral · 40seg","vt":"Rodillas arriba · 20 desc"}]',4);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('funcional','Enero','[{"nombre":"CORE · Plancha rodillas al pecho (pelota 2kg) · 40seg","vt":"Press de hombros con pelota · 20 desc"},{"nombre":"PIERNAS · Estocada adelante con barra · 40seg","vt":"Despego talones · 20 desc"},{"nombre":"ESPALDA · Boca arriba con discos a 90°, llevo al techo · 40seg","vt":"Pullover · 20 desc"},{"nombre":"CORE · Mountain Climbers · 40seg","vt":"Sentadilla · 20 desc"},{"nombre":"PIERNAS · Sentadilla sumo · 40seg","vt":"Vuelo frontal con disco · 20 desc"},{"nombre":"PECHO · Flexiones de brazos · 40seg","vt":"Plancha · 20 desc"},{"nombre":"ESPALDA · Remo cerrado · 40seg","vt":"Tríceps · 20 desc"},{"nombre":"CARDIO · Saltos al frente · 40seg","vt":"Mountain Climbers · 20 desc"},{"nombre":"CORE · Bicicleta · 40seg","vt":"Barquito · 20 desc"},{"nombre":"PIERNAS · Peso muerto a un pie · 40seg","vt":"Rodilla al pecho · 20 desc"}]',5);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('funcional','Febrero','[{"nombre":"CORE · Plancha baja · 40seg","vt":"Elevación de cadera para oblicuo (rodilla apoyo) · 20 desc"},{"nombre":"ESPALDA · Remo cerrado con barra · 40seg","vt":"Press de hombros · 20 desc"},{"nombre":"PIERNAS · Sentadilla común con discos · 40seg","vt":"30 desc"},{"nombre":"CORE · Mountain Climbers · 40seg","vt":"Sentadilla · 20 desc"},{"nombre":"PIERNAS · Estocada lateral · 40seg","vt":"Rodilla al pecho · 20 desc"},{"nombre":"PECHO · Codos a 90° con discos · 40seg","vt":"Vuelo frontal · 20 desc"},{"nombre":"ESPALDA · Remo abierto con discos · 40seg","vt":"Bíceps · 20 desc"},{"nombre":"CARDIO · Trote lateral · 40seg","vt":"Rodillas arriba · 20 desc"},{"nombre":"CORE · Sit ups · 40seg","vt":"Tijera · 20 desc"},{"nombre":"PIERNAS · Peso muerto romano con disco · 40seg","vt":"Giro de disco · 20 desc"}]',6);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('funcional','Marzo','[{"nombre":"CORE · Bisagra a un pie con discos · 40seg (10 rep)","vt":"Extensión de piernas subir y bajar · 20 desc"},{"nombre":"PIERNAS · Estocada adelante con step · 40seg","vt":"Bíceps con disco (4 rep) · 20 desc"},{"nombre":"ESPALDA · Banda elástica: brazos extendidos, llevo al pecho · 40seg","vt":"Tracción al frente · 20 desc"},{"nombre":"CORE · Mountain Climbers · 40seg","vt":"Sentadilla · 20 desc"},{"nombre":"PIERNAS · Sentadilla sumo · 40seg (6 rep)","vt":"Vuelo frontal con disco (4 rep) · 20 desc"},{"nombre":"PECHO · Flexiones de brazos · 40seg","vt":"Plancha · 20 desc"},{"nombre":"ESPALDA · Remo cerrado · 40seg","vt":"Press de hombros · 20 desc"},{"nombre":"CARDIO · Saltos de frente · 40seg","vt":"Mountain Climbers · 20 desc"},{"nombre":"CORE · Plancha toco hombros · 40seg","vt":"Press de hombros · 20 desc"},{"nombre":"PIERNAS · Peso muerto romano con disco · 40seg","vt":"Giro de disco · 20 desc"}]',7);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('funcional','Abril','[{"nombre":"CORE · Ruedita · 40seg","vt":"30 desc"},{"nombre":"PIERNAS · Sentadilla pistols · 40seg","vt":"30 desc"},{"nombre":"ESPALDA · Remo cerrado con barra · 40seg","vt":"Press de hombros · 20 desc"},{"nombre":"CORE · Mountain Climbers · 40seg","vt":"Sentadilla · 20 desc"},{"nombre":"PIERNAS · Estocada adelante con step · 40seg","vt":"Rodilla al pecho · 20 desc"},{"nombre":"PECHO · Flexiones de brazos · 40seg","vt":"Plancha · 20 desc"},{"nombre":"ESPALDA · Apertura lateral con discos · 40seg","vt":"Bíceps · 20 desc"},{"nombre":"CARDIO · Trote con rodillas arriba · 40seg","vt":"30 desc"},{"nombre":"CORE · Sit ups con disco · 40seg","vt":"Disco arriba tijera · 20 desc"},{"nombre":"PIERNAS · Sentadilla ISO con banda elástica · 40seg","vt":"Abro y cierro · 20 desc"}]',8);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('funcional','Mayo','[{"nombre":"CORE · Dead bug · 40seg","vt":"Supine toe tops · 20 desc"},{"nombre":"PIERNAS · Pistols · 40seg","vt":"30 desc"},{"nombre":"ESPALDA · Jalón a pecho con banda · 40seg","vt":"Unilateral · 20 desc"},{"nombre":"CORE · Mountain Climbers · 40seg","vt":"Sentadilla · 20 desc"},{"nombre":"PIERNAS · Thrusters con mancuernas · 40seg","vt":"30 desc"},{"nombre":"PECHO · Flexiones de brazos · 40seg","vt":"Plancha · 20 desc"},{"nombre":"ESPALDA · Remo cerrado con barra · 40seg","vt":"Press de hombros · 20 desc"},{"nombre":"CARDIO · Saltos de frente con step · 40seg","vt":"Mountain Climbers · 20 desc"},{"nombre":"CORE · Plancha toco hombros · 40seg","vt":"30 desc"},{"nombre":"PIERNAS · Sentadilla sumo · 40seg","vt":"Vuelo frontal con disco · 20 desc"}]',9);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('funcional','Junio','[{"nombre":"CORE · Plancha baja con elevación de cadera · 40seg","vt":"Rodilla al codo · 20 desc"},{"nombre":"PIERNAS · Sentadilla búlgara con disco · 40seg","vt":"Rodilla al pecho · 20 desc"},{"nombre":"ESPALDA · Remo abierto con banda elástica · 40seg","vt":"Vuelo lateral · 20 desc"},{"nombre":"CORE · Mountain Climbers · 40seg","vt":"Sentadilla · 20 desc"},{"nombre":"PIERNAS · Estocada lateral · 40seg","vt":"Vuelo frontal con disco · 20 desc"},{"nombre":"PECHO · Flexiones de brazos en diamante · 40seg","vt":"Plancha · 20 desc"},{"nombre":"ESPALDA · Jalón al pecho con banda · 40seg","vt":"Press de hombros · 20 desc"},{"nombre":"CARDIO · Salto con step lateral · 40seg","vt":"Trote · 20 desc"},{"nombre":"CORE · Sit ups con giro con disco · 40seg","vt":"Disco arriba y abajo · 20 desc"},{"nombre":"PIERNAS · Peso muerto a una pierna · 40seg","vt":"Rodilla al pecho · 20 desc"}]',10);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('funcional','Julio','[{"nombre":"CORE · Ruedita · 40seg","vt":"Dead bug · 20 desc"},{"nombre":"PIERNAS · Sentadilla sumo con mancuerna · 40seg","vt":"Vuelo frontal · 20 desc"},{"nombre":"ESPALDA · Tracción al frente con banda · 40seg","vt":"Pullover · 20 desc"},{"nombre":"CORE · Mountain Climbers · 40seg","vt":"Sentadilla · 20 desc"},{"nombre":"PIERNAS · Estocada adelante con barra · 40seg","vt":"Abro y cierro con salto · 20 desc"},{"nombre":"PECHO · Flexiones de brazos · 40seg","vt":"Plancha lateral · 20 desc"},{"nombre":"ESPALDA · Remo cerrado · 40seg","vt":"Bíceps · 20 desc"},{"nombre":"CARDIO · Escalera lateral · 40seg","vt":"Vuelvo en trote · 20 desc"},{"nombre":"CORE · Bicicleta · 40seg","vt":"Barquito · 20 desc"},{"nombre":"PIERNAS · Sentadilla ISO con banda · 40seg","vt":"Abro y cierro · 20 desc"}]',11);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('funcional','Principiante I','[{"nombre":"CORE · Cortitos (elevación cabeza y hombros) · 30seg","vt":"Sostengo arriba · 30 desc"},{"nombre":"PIERNAS · Sentadilla clásica · 30seg","vt":"30 desc"},{"nombre":"ESPALDA · Remo cerrado con banda liviana · 30seg","vt":"30 desc"},{"nombre":"CORE · Plancha con rodillas al suelo · 30seg","vt":"30 desc"},{"nombre":"PIERNAS · Estocada estática · 30seg","vt":"30 desc"},{"nombre":"PECHO · Flexiones con rodillas · 30seg","vt":"30 desc"},{"nombre":"ESPALDA · Superman (boca abajo, elevo brazos y piernas) · 30seg","vt":"30 desc"},{"nombre":"CORE · Bicicleta lenta · 30seg","vt":"30 desc"},{"nombre":"PIERNAS · Puente de glúteos · 30seg","vt":"Una pierna · 30 desc"},{"nombre":"CARDIO · Marcha con rodillas altas · 30seg","vt":"30 desc"}]',12);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('funcional','Principiante II','[{"nombre":"CORE · Dead bug básico · 30seg","vt":"30 desc"},{"nombre":"PIERNAS · Sentadilla sumo · 30seg","vt":"30 desc"},{"nombre":"ESPALDA · Remo abierto con banda liviana · 30seg","vt":"30 desc"},{"nombre":"CORE · Plancha lateral con rodilla al suelo · 30seg","vt":"30 desc"},{"nombre":"PIERNAS · Peso muerto con disco · 30seg","vt":"30 desc"},{"nombre":"PECHO · Flexiones con rodillas · 30seg","vt":"30 desc"},{"nombre":"CORE · Sit ups básico · 30seg","vt":"30 desc"},{"nombre":"PIERNAS · Estocada con paso adelante · 30seg","vt":"30 desc"},{"nombre":"ESPALDA · Vuelo lateral con tronco a 45° con discos · 30seg","vt":"30 desc"},{"nombre":"CARDIO · Step lateral · 30seg","vt":"30 desc"}]',13);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('funcional','Tren Superior','[{"nombre":"PECHO · Flexiones de brazos · 40seg","vt":"Plancha · 20 desc"},{"nombre":"ESPALDA · Remo cerrado con disco · 40seg","vt":"Press de hombros · 20 desc"},{"nombre":"HOMBROS · Vuelo frontal con disco · 40seg","vt":"Vuelo lateral · 20 desc"},{"nombre":"BÍCEPS · Curl con disco bilateral · 40seg","vt":"Unilateral · 20 desc"},{"nombre":"TRÍCEPS · Extensión sobre la cabeza con disco · 40seg","vt":"Patada atrás · 20 desc"},{"nombre":"ESPALDA · Vuelo lateral tronco a 45° con discos · 40seg","vt":"Remo abierto · 20 desc"},{"nombre":"PECHO · Codos a 90° con discos · 40seg","vt":"Pullover · 20 desc"},{"nombre":"HOMBROS · Press Arnold con discos · 40seg","vt":"30 desc"},{"nombre":"CORE · Plancha iso · 40seg","vt":"Plancha toco hombros · 20 desc"},{"nombre":"CORE · Mountain Climbers · 40seg","vt":"30 desc"}]',14);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('funcional','Glúteos y Piernas','[{"nombre":"GLÚTEOS · Puente de glúteos · 40seg","vt":"Una pierna · 20 desc"},{"nombre":"PIERNAS · Sentadilla sumo profunda · 40seg","vt":"Vuelo frontal con disco · 20 desc"},{"nombre":"GLÚTEOS · Patada en cuadrupedia · círculos · 40seg","vt":"Extensión pierna recta · 20 desc"},{"nombre":"PIERNAS · Estocada lateral · 40seg","vt":"Vuelo frontal con disco · 20 desc"},{"nombre":"GLÚTEOS · Abducción con banda en tobillo de pie · 40seg","vt":"30 desc"},{"nombre":"PIERNAS · Peso muerto romano a dos pies con disco · 40seg","vt":"A un pie · 20 desc"},{"nombre":"GLÚTEOS · Sentadilla ISO contra la pared · 40seg","vt":"Abro y cierro con banda · 20 desc"},{"nombre":"PIERNAS · Step al banco · 40seg","vt":"Rodilla al pecho · 20 desc"},{"nombre":"GLÚTEOS · Clam con banda en muslos · 40seg","vt":"30 desc"},{"nombre":"CARDIO · Saltos con sentadilla · 40seg","vt":"30 desc"}]',15);

-- REFORMER --
INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('reformer','Básico I','[{"nombre":"Footwork · punta y flex","vt":"3 res. · luego talones"},{"nombre":"Footwork · arco","vt":"3 res. · luego una pierna"},{"nombre":"Frog","vt":"2 res. · rango pequeño, sin forzar cadera"},{"nombre":"Leg circles en Frog","vt":"2 res. · hacia adentro y hacia afuera"},{"nombre":"Cien","vt":"1 res. · piernas en mesa, sin bajar"},{"nombre":"Coordinación","vt":"1 res. · lenta, contar en voz alta"},{"nombre":"Elefante","vt":"1 res. · columna redondeada, empujar desde el core"},{"nombre":"Rodillas en el carro · redondo","vt":"2 res. · luego columna recta"},{"nombre":"Running","vt":"3 res. · talones alternados, carro quieto al final"},{"nombre":"Plancha en pie · iso","vt":"2 res. · manos en barra, alinear hombros"}]',0);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('reformer','Básico II','[{"nombre":"Footwork · punta / flex / talón / arco","vt":"3 res. · 8 rep cada uno"},{"nombre":"Frog · leg circles","vt":"2 res. · frog 8 rep, circles 4 cada lado"},{"nombre":"Cien","vt":"1 res. · piernas a 45°, si tolera bajar más"},{"nombre":"Coordinación","vt":"1 res. · coordinar respiración con movimiento"},{"nombre":"Remo desde el pecho · palmas arriba","vt":"1 res. liviano · codos pegados"},{"nombre":"Estómago masaje · redondo","vt":"3 res. · luego columna recta 2 res."},{"nombre":"Elefante","vt":"1 res. · luego una pierna levantada"},{"nombre":"Rodillas en el carro · redondo","vt":"2 res. · luego oblicuo"},{"nombre":"Side stretch en el carro","vt":"1 res. · carro quieto, elongar lateral"},{"nombre":"Running · semicírculo","vt":"3 res. · running 16 rep, semicírculo 4 rep"},{"nombre":"Plancha en pie · subir y bajar","vt":"2 res. · bajar lento 4 tiempos"}]',1);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('reformer','Intermedio I','[{"nombre":"Footwork completo · punta / flex / talón / arco / una pierna","vt":"3 res. · 8 rep cada posición"},{"nombre":"Cien","vt":"1 res. · piernas extendidas a 45° o abajo"},{"nombre":"Coordinación","vt":"1 res. · rápida, énfasis en extensión de piernas"},{"nombre":"Remo desde la cadera","vt":"1 res. · luego desde el pecho, palmas abajo"},{"nombre":"Caja corta · redondo","vt":"carro quieto · 1 res. · luego columna recta"},{"nombre":"Caja corta · oblicuo","vt":"carro quieto · 1 res. · luego stretch lateral"},{"nombre":"Árbol","vt":"carro quieto · 1 res. · pierna al techo, bajar lento"},{"nombre":"Estómago masaje completo · redondo / columna recta / twist / reaching","vt":"redondo 3 res. → columna recta 2 res. → twist 2 res. → reaching 1 res."},{"nombre":"Elefante","vt":"1 res. · una pierna levantada"},{"nombre":"Rodillas en el carro · redondo / oblicuo","vt":"2 res. · luego pies en el aire"},{"nombre":"Tendon stretch","vt":"2 res. · de pie en borde del carro"},{"nombre":"Running · semicírculo","vt":"3 res. · running 16 rep, semicírculo 4 rep"}]',2);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('reformer','Intermedio II','[{"nombre":"Footwork · énfasis una pierna","vt":"3 res. · 10 rep cada pierna"},{"nombre":"Hip work · frog / leg circles / up-down / apertura","vt":"2 res. · 6-8 rep cada variación"},{"nombre":"Cien","vt":"1 res. · piernas bajas, con variación de piernas"},{"nombre":"Remo completo · desde el pecho y desde la cadera","vt":"1 res. · 4 rep cada uno, énfasis cierre escápulas"},{"nombre":"Caja corta completa · redondo / plano / oblicuo / stretch / árbol","vt":"carro quieto · 1 res. · 4-6 rep cada ejercicio"},{"nombre":"Caja larga · pulling straps","vt":"2 res. · luego T-press, extender hasta límite"},{"nombre":"Estómago masaje completo","vt":"redondo 3 res. → reaching 1 res., fluir entre variaciones"},{"nombre":"Side splits","vt":"2 res. · pies en plataforma, abrir controlado"},{"nombre":"Serpiente / Torsión principiante","vt":"2 res. · 3 rep cada lado, cuidar hombros"},{"nombre":"Tendon stretch","vt":"2 res. · de pie, rodillas semiflexionadas"},{"nombre":"Running · semicírculo","vt":"3 res. · running 20 rep, semicírculo 4 rep"}]',3);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('reformer','Avanzado I','[{"nombre":"Footwork rápido · series completas","vt":"3-4 res. · ritmo sostenido, 10 rep cada posición"},{"nombre":"Hip work completo","vt":"2 res. · frog / circles / up-down / openings, 6 rep c/u"},{"nombre":"Cien · piernas bajas","vt":"1 res. · piernas a 10 cm del suelo, sin compensar lumbar"},{"nombre":"Remo completo","vt":"1 res. · desde pecho y cadera, 4 rep lentas cada uno"},{"nombre":"Caja corta completa · con torsión","vt":"carro quieto · 1 res. · torsión profunda en oblicuo"},{"nombre":"Caja larga · pulling straps / T-press / arabesco","vt":"2-3 res. · arabesco: una pierna al techo"},{"nombre":"Estómago masaje · reaching / twist avanzado","vt":"reaching 1 res. · twist 2 res. · rotación máxima"},{"nombre":"Serpiente / Torsión","vt":"2 res. · 4 rep cada lado, cadera arriba en torsión"},{"nombre":"Star","vt":"1-2 res. · de lateral, elevar pierna y brazo superior"},{"nombre":"Side splits · con salto","vt":"1 res. · aterrizar suave, absorber con piernas"},{"nombre":"Tendon stretch · avanzado","vt":"2 res. · piernas estiradas, columna en flex"},{"nombre":"Running rápido · semicírculo","vt":"3 res. · running 24 rep, semicírculo 4 rep lento"}]',4);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('reformer','Piernas y Glúteos','[{"nombre":"Footwork · énfasis arco y una pierna","vt":"3 res. · arco 10 rep, una pierna 8 rep c/lado"},{"nombre":"Hip work · frog / leg circles amplios / up-down","vt":"2 res. · amplitud máxima, círculos grandes"},{"nombre":"Leg circles de pie en el reformer","vt":"1 res. · manos en barra, pierna libre en círculo"},{"nombre":"Estocada en el reformer · pie en carro","vt":"2 res. · 8 rep, luego pulsos 8 rep"},{"nombre":"Side splits · abrir y cerrar","vt":"2 res. · con curl de tobillo al abrir"},{"nombre":"Glúteo en cuadrupedia · carro al frente","vt":"1 res. · pierna extendida, empujar carro con rodilla"},{"nombre":"Rodillas en el carro · pies en el aire","vt":"2 res. · énfasis en apretar glúteo al extender"},{"nombre":"Puente en el reformer · una pierna","vt":"2 res. · hombros en plataforma, cadera arriba"},{"nombre":"Running largo","vt":"3 res. · ampliar rango, luego semicírculo profundo"}]',5);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('reformer','Core y Columna','[{"nombre":"Cien · variaciones de piernas","vt":"1 res. · cambiar posición de piernas cada 10 bombeos"},{"nombre":"Coordinación · avanzado","vt":"1 res. · piernas bajan más, velocidad mayor"},{"nombre":"Remo desde el pecho · énfasis core","vt":"1 res. · activar transverso antes de cada rep"},{"nombre":"Caja corta · redondo profundo","vt":"carro quieto · 1 res. · luego oblicuo, 5 rep cada uno"},{"nombre":"Árbol · control lumbar","vt":"carro quieto · 1 res. · bajar la pierna muy despacio"},{"nombre":"Estómago masaje · twist con rotación","vt":"2 res. · rotación máxima, codo al frente"},{"nombre":"Plancha en pie · rotación de cadera","vt":"2 res. · rotar cadera sin mover hombros"},{"nombre":"Serpiente · control de core","vt":"2 res. · entrada lenta, sostener 2 segundos arriba"},{"nombre":"Short spine","vt":"2 res. · articular vértebra a vértebra, no llegar al cuello"},{"nombre":"Semicírculo · lento y controlado","vt":"3 res. · 4 tiempos para bajar, 4 para subir"}]',6);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('reformer','Brazos y Remo','[{"nombre":"Footwork · calentamiento","vt":"3 res. · punta / flex / arco, 6 rep cada uno"},{"nombre":"Remo desde el pecho · palmas arriba","vt":"1 res. · luego palmas abajo, codos 90°"},{"nombre":"Remo desde el pecho · codos al frente","vt":"1 res. · luego apertura lateral, escápulas juntas"},{"nombre":"Remo desde la cadera · brazos abiertos","vt":"1 res. · elongar columna al extender"},{"nombre":"Tracción bilateral con correas · brazos al techo","vt":"1 res. liviano · bajar lento, escápulas abajo"},{"nombre":"Tracción unilateral con correas · rotación","vt":"1 res. liviano · rotar tronco al bajar"},{"nombre":"Bíceps con correas · sentada","vt":"1 res. · codos fijos, luego de pie"},{"nombre":"Tríceps con correas · codos pegados al cuerpo","vt":"1 res. · extender hacia atrás sin mover codo"},{"nombre":"Shoulder press con correas","vt":"1 res. · subir lateral a 90° y presionar al techo"},{"nombre":"Hug a tree · abrazar el árbol con correas","vt":"1 res. · mantener altura de hombros, arcos"},{"nombre":"Swimming con correas · control de escápulas","vt":"1 res. liviano · boca abajo en caja, alternar"},{"nombre":"Running final","vt":"3 res. · 16 rep suave para cerrar"}]',7);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('reformer','Avanzado II','[{"nombre":"Footwork rápido · énfasis arco y una pierna","vt":"3-4 res. · una pierna: 10 rep sin compensar cadera"},{"nombre":"Hip work avanzado · frog / circles / up-down / openings","vt":"2 res. · amplitud total, control de pelvis"},{"nombre":"Cien · piernas muy bajas, sin apoyar","vt":"1 res. · piernas a 5 cm, lumbar pegada al carro"},{"nombre":"Rowing series completa · desde pecho / cadera","vt":"1 res. · 4 rep lentas, cerrar ojos para sentir"},{"nombre":"Caja corta con torsión profunda","vt":"carro quieto · 1 res. · llevar codo al opuesto"},{"nombre":"Caja larga completa · pulling straps / T-press / arabesco","vt":"2-3 res. · arabesco: sostener 3 seg arriba"},{"nombre":"Stomach massage · twist avanzado / reaching","vt":"twist 2 res. · reaching 1 res. · no perder longitud"},{"nombre":"Serpiente / Torsión avanzada","vt":"2 res. · 4 rep cada lado, cadera al techo"},{"nombre":"Star","vt":"1-2 res. · elevar pierna y brazo, sostener 3 seg"},{"nombre":"Mermaid (Sirena) en el reformer","vt":"1 res. · lateral, arco de costado, volver controlado"},{"nombre":"Side splits · con salto controlado","vt":"1 res. · aterrizar suave, absorber con rodillas"},{"nombre":"Control balance / Tendon stretch avanzado","vt":"2 res. · de pie, columna en flexión total"}]',8);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('reformer','Espalda y Postura','[{"nombre":"Footwork · énfasis elongación de columna","vt":"3 res. · imaginar crecer hacia el techo al empujar"},{"nombre":"Short spine","vt":"2 res. · articular despacio, no pasar de cervicales"},{"nombre":"Semicírculo · foco en articulación vertebral","vt":"3 res. · 4 tiempos bajar, 4 subir"},{"nombre":"Pulling straps · tronco en extensión","vt":"2-3 res. · boca abajo en caja, luego T-press"},{"nombre":"Caja corta · plano con énfasis en extensión torácica","vt":"carro quieto · 1 res. · arquear suavemente sin cervicales"},{"nombre":"Caja larga · swan básico e intermedio","vt":"2 res. · manos en barra, extensión de dorsal"},{"nombre":"Remo completo · escápulas en foco","vt":"1 res. · bajar escápulas antes de cada movimiento"},{"nombre":"Rowing · zip up / shave the head","vt":"1 res. · zip up: codos al techo / shave: codos atrás"},{"nombre":"Plancha en pie · elongación","vt":"2 res. · alargar columna, no hundir lumbar"},{"nombre":"Estiramiento lateral en el carro","vt":"1 res. · carro quieto, elongar desde cadera"},{"nombre":"Cat stretch · columna en flexión y extensión alternadas","vt":"1 res. · muy lento, vértebra a vértebra"},{"nombre":"Running final lento","vt":"3 res. · ritmo lento, cerrar con conciencia corporal"}]',9);

INSERT INTO triskel_banco_ejercicios(categoria,titulo,ejs,orden) VALUES
('reformer','Embarazo / Postparto','[{"nombre":"Footwork suave · punta y flex","vt":"2 res. · sin extensión lumbar, luego talones"},{"nombre":"Footwork · arco y una pierna · lento","vt":"2 res. · sin forzar rango, pausar si hay presión"},{"nombre":"Clam en el reformer · de lateral, carro estático","vt":"carro quieto · 0 res. · activar suelo pélvico"},{"nombre":"De lateral · elevación de pierna con carro estático","vt":"carro quieto · 0 res. · no rotar cadera"},{"nombre":"Remo sentada sin flexión profunda · palmas arriba","vt":"1 res. liviano · columna recta todo el tiempo"},{"nombre":"Estiramiento cuádriceps · de rodillas en el carro","vt":"carro quieto · 0 res. · manos en barra"},{"nombre":"Cat / cow en el reformer","vt":"carro quieto · 0-1 res. · muy suave, respiración guiada"},{"nombre":"Puente suave en el reformer","vt":"2 res. · hombros en plataforma, no forzar glúteo"},{"nombre":"Respiración y activación de suelo pélvico","vt":"0 res. · carro quieto · 8 respiraciones conscientes"},{"nombre":"Running muy suave","vt":"2 res. · talones alternados, rango reducido, sin extensión"}]',10);

END IF;
END $seed$;

NOTIFY pgrst, 'reload schema';
