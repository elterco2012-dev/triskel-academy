-- =====================================================
-- Triskel Academy — Security Fixes (021)
-- Ejecutar completo en Supabase → SQL Editor
-- =====================================================

-- ── 1. CRÍTICO: Revocar triskel_load_all del rol anon ────────────────────────
REVOKE EXECUTE ON FUNCTION triskel_load_all() FROM anon;


-- ── 2. CRÍTICO: Función helper triskel_is_alumna ─────────────────────────────
CREATE OR REPLACE FUNCTION triskel_is_alumna()
RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER AS $$
  SELECT EXISTS(SELECT 1 FROM triskel_alumnas WHERE auth_user_id = auth.uid())
$$;
GRANT EXECUTE ON FUNCTION triskel_is_alumna() TO authenticated;


-- ── 2a. triskel_save_alumna con validación de rol ─────────────────────────────
-- Firma actual (012_contraindicaciones.sql): text,text,text,text,text,text,integer,date,integer,text
CREATE OR REPLACE FUNCTION triskel_save_alumna(
  p_nombre             text,
  p_apellido           text    DEFAULT NULL,
  p_tel                text    DEFAULT NULL,
  p_email              text    DEFAULT NULL,
  p_notas              text    DEFAULT NULL,
  p_estado             text    DEFAULT 'activa',
  p_dia_pago           integer DEFAULT NULL,
  p_fecha_nacimiento   date    DEFAULT NULL,
  p_id                 integer DEFAULT NULL,
  p_contraindicaciones text    DEFAULT NULL
)
RETURNS integer LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_id integer;
BEGIN
  IF triskel_is_alumna() THEN
    RETURN NULL;
  END IF;
  IF p_id IS NOT NULL THEN
    UPDATE triskel_alumnas SET
      nombre=p_nombre, apellido=p_apellido, tel=p_tel,
      email=p_email, notas=p_notas, dia_pago=p_dia_pago,
      fecha_nacimiento=p_fecha_nacimiento,
      contraindicaciones=p_contraindicaciones
    WHERE id=p_id;
    v_id := p_id;
  ELSE
    INSERT INTO triskel_alumnas(nombre,apellido,tel,email,notas,estado,dia_pago,fecha_nacimiento,contraindicaciones)
    VALUES(p_nombre,p_apellido,p_tel,p_email,p_notas,
           COALESCE(NULLIF(p_estado,''),'activa'),p_dia_pago,p_fecha_nacimiento,p_contraindicaciones)
    RETURNING id INTO v_id;
  END IF;
  RETURN v_id;
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_save_alumna(text,text,text,text,text,text,integer,date,integer,text) TO authenticated;


-- ── 2b. triskel_set_estado_alumna con validación de rol ───────────────────────
CREATE OR REPLACE FUNCTION triskel_set_estado_alumna(p_id integer, p_estado text)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  IF triskel_is_alumna() THEN
    RETURN;
  END IF;
  UPDATE triskel_alumnas SET estado = p_estado WHERE id = p_id;
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_set_estado_alumna(integer,text) TO authenticated;


-- ── 2c. triskel_insert_inscripcion con validación de rol ──────────────────────
-- Firma actual (009_reinscripcion.sql): integer,integer,numeric
CREATE OR REPLACE FUNCTION triskel_insert_inscripcion(
  p_alumna_id  integer,
  p_horario_id integer,
  p_precio     numeric DEFAULT 0
)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  IF triskel_is_alumna() THEN
    RETURN;
  END IF;
  INSERT INTO triskel_inscripciones(alumna_id, horario_id, precio, activa)
  VALUES(p_alumna_id, p_horario_id, COALESCE(p_precio, 0), true)
  ON CONFLICT (alumna_id, horario_id)
  DO UPDATE SET activa = true, precio = EXCLUDED.precio;
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_insert_inscripcion(integer,integer,numeric) TO authenticated;


-- ── 2d. triskel_deactivate_inscripcion con validación de rol ──────────────────
CREATE OR REPLACE FUNCTION triskel_deactivate_inscripcion(p_id integer)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  IF triskel_is_alumna() THEN
    RETURN;
  END IF;
  UPDATE triskel_inscripciones SET activa = false WHERE id = p_id;
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_deactivate_inscripcion(integer) TO authenticated;


-- ── 2e. triskel_insert_pago con validación de rol ─────────────────────────────
-- Firma actual (010_pago_directo.sql): integer,integer,text,numeric,boolean,text
CREATE OR REPLACE FUNCTION triskel_insert_pago(
  p_alumna_id      integer,
  p_inscripcion_id integer,
  p_mes            text,
  p_monto          numeric  DEFAULT 0,
  p_pagado         boolean  DEFAULT true,
  p_fecha_pago     text     DEFAULT NULL
)
RETURNS integer LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_id integer;
BEGIN
  IF triskel_is_alumna() THEN
    RETURN NULL;
  END IF;
  INSERT INTO triskel_pagos(alumna_id, inscripcion_id, mes, monto, pagado, fecha_pago)
  VALUES(p_alumna_id, p_inscripcion_id, p_mes, COALESCE(p_monto,0),
         COALESCE(p_pagado,true),
         CASE WHEN COALESCE(p_pagado,true) THEN COALESCE(p_fecha_pago, CURRENT_DATE::text)::date ELSE NULL END)
  ON CONFLICT (alumna_id, inscripcion_id, mes)
  DO UPDATE SET
    monto      = EXCLUDED.monto,
    pagado     = EXCLUDED.pagado,
    fecha_pago = EXCLUDED.fecha_pago
  RETURNING id INTO v_id;
  RETURN v_id;
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_insert_pago(integer,integer,text,numeric,boolean,text) TO authenticated;


-- ── 2f. triskel_marcar_pagos_ids con validación de rol ────────────────────────
-- Firma actual (019_critical_fixes.sql): integer[],boolean,date
CREATE OR REPLACE FUNCTION triskel_marcar_pagos_ids(
  p_ids        integer[],
  p_pagado     boolean,
  p_fecha_pago date DEFAULT NULL
)
RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  IF triskel_is_alumna() THEN
    RETURN jsonb_build_object('ok', false, 'msg', 'no autorizado');
  END IF;
  UPDATE triskel_pagos
  SET pagado     = p_pagado,
      fecha_pago = CASE WHEN p_pagado THEN COALESCE(p_fecha_pago, current_date) ELSE NULL END,
      updated_at = now()
  WHERE id = ANY(p_ids);
  RETURN jsonb_build_object('ok',true,'updated',array_length(p_ids,1));
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_marcar_pagos_ids(integer[], boolean, date) TO authenticated;


-- ── 2g. triskel_insertar_pagos_plan con validación de rol ─────────────────────
-- Firma actual (019_critical_fixes.sql): integer,integer[],text,numeric,boolean,date
CREATE OR REPLACE FUNCTION triskel_insertar_pagos_plan(
  p_alumna_id   integer,
  p_insc_ids    integer[],
  p_mes         text,
  p_monto_total numeric,
  p_pagado      boolean DEFAULT true,
  p_fecha_pago  date    DEFAULT NULL
)
RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  v_count    integer := array_length(p_insc_ids, 1);
  v_por_insc numeric := CASE WHEN v_count > 0 THEN ROUND(p_monto_total / v_count) ELSE p_monto_total END;
  v_fecha    date    := COALESCE(p_fecha_pago, current_date);
BEGIN
  IF triskel_is_alumna() THEN
    RETURN jsonb_build_object('ok', false, 'msg', 'no autorizado');
  END IF;
  INSERT INTO triskel_pagos(alumna_id, inscripcion_id, mes, monto, pagado, fecha_pago)
  SELECT p_alumna_id, unnest(p_insc_ids), p_mes, v_por_insc,
         p_pagado, CASE WHEN p_pagado THEN v_fecha ELSE NULL END
  ON CONFLICT (alumna_id, inscripcion_id, mes)
  DO UPDATE SET monto=EXCLUDED.monto, pagado=EXCLUDED.pagado,
                fecha_pago=EXCLUDED.fecha_pago, updated_at=now();
  RETURN jsonb_build_object('ok',true);
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_insertar_pagos_plan(integer, integer[], text, numeric, boolean, date) TO authenticated;


-- ── 2h. triskel_delete_clase con validación de rol ────────────────────────────
CREATE OR REPLACE FUNCTION triskel_delete_clase(p_id integer)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  IF triskel_is_alumna() THEN
    RETURN;
  END IF;
  DELETE FROM triskel_clases WHERE id = p_id;
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_delete_clase(integer) TO authenticated;


-- ── 2i. triskel_save_observacion con validación de rol ────────────────────────
CREATE OR REPLACE FUNCTION triskel_save_observacion(
  p_alumna_id integer,
  p_texto     text,
  p_fecha     date    DEFAULT CURRENT_DATE,
  p_id        integer DEFAULT NULL
)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  IF triskel_is_alumna() THEN
    RETURN;
  END IF;
  IF p_id IS NOT NULL THEN
    UPDATE triskel_observaciones SET fecha=p_fecha, texto=p_texto WHERE id=p_id;
  ELSE
    INSERT INTO triskel_observaciones(alumna_id,fecha,texto) VALUES(p_alumna_id,p_fecha,p_texto);
  END IF;
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_save_observacion(integer,text,date,integer) TO authenticated;


-- ── 2j. triskel_delete_observacion con validación de rol ──────────────────────
CREATE OR REPLACE FUNCTION triskel_delete_observacion(p_id integer)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  IF triskel_is_alumna() THEN
    RETURN;
  END IF;
  DELETE FROM triskel_observaciones WHERE id = p_id;
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_delete_observacion(integer) TO authenticated;


-- ── 3. CRÍTICO: Bloquear triskel_link_mi_cuenta — prevenir account takeover ───
REVOKE EXECUTE ON FUNCTION triskel_link_mi_cuenta(integer) FROM authenticated;
REVOKE EXECUTE ON FUNCTION triskel_link_mi_cuenta(integer) FROM anon;


-- ── 4. ALTO: triskel_get_avisos_pendientes — solo profesora ───────────────────
CREATE OR REPLACE FUNCTION triskel_get_avisos_pendientes()
RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  IF triskel_is_alumna() THEN
    RETURN '[]'::jsonb;
  END IF;
  RETURN (
    SELECT jsonb_agg(jsonb_build_object(
      'id', av.id,
      'alumna_id', av.alumna_id,
      'nombre', a.nombre,
      'apellido', a.apellido,
      'tel', a.tel,
      'mes', av.mes,
      'monto_declarado', av.monto_declarado,
      'nota', av.nota,
      'estado', av.estado,
      'created_at', av.created_at
    ) ORDER BY av.created_at DESC)
    FROM triskel_avisos_pago av
    JOIN triskel_alumnas a ON a.id = av.alumna_id
    WHERE av.estado = 'pendiente'
  );
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_get_avisos_pendientes() TO authenticated;


-- ── 5. ALTO: triskel_save_push_subscription — forzar tipo según rol ───────────
CREATE OR REPLACE FUNCTION triskel_save_push_subscription(p_subscription jsonb, p_tipo text DEFAULT 'alumna')
RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_uid uuid := auth.uid();
BEGIN
  IF v_uid IS NULL THEN RETURN jsonb_build_object('ok',false,'msg','not authenticated'); END IF;
  -- Si el caller es alumna, forzar tipo 'alumna' (prevenir spoofing de tipo 'teacher')
  IF triskel_is_alumna() THEN
    p_tipo := 'alumna';
  END IF;
  INSERT INTO triskel_push_subscriptions(user_id, subscription, tipo, updated_at)
  VALUES(v_uid, p_subscription, p_tipo, now())
  ON CONFLICT(user_id) DO UPDATE
    SET subscription=EXCLUDED.subscription, tipo=EXCLUDED.tipo, updated_at=now();
  RETURN jsonb_build_object('ok',true);
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_save_push_subscription(jsonb, text) TO authenticated;


-- ── 6. ALTO: Revocar triskel_get_push_subscriptions del rol authenticated ─────
REVOKE EXECUTE ON FUNCTION triskel_get_push_subscriptions(text) FROM authenticated;
-- Solo accesible vía Edge Functions con service_role


-- ── 7. MEDIO: RLS policies explícitas para triskel_horarios y triskel_clases ──
DROP POLICY IF EXISTS "authenticated_read" ON triskel_horarios;
CREATE POLICY "authenticated_read" ON triskel_horarios FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "authenticated_read" ON triskel_clases;
CREATE POLICY "authenticated_read" ON triskel_clases FOR SELECT TO authenticated USING (true);


-- ── 8. BAJO: triskel_crear_aviso_pago con validación de longitud ──────────────
CREATE OR REPLACE FUNCTION triskel_crear_aviso_pago(
  p_mes text,
  p_monto_declarado numeric DEFAULT NULL,
  p_nota text DEFAULT NULL
)
RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  v_uid uuid := auth.uid();
  v_alumna_id integer;
  v_aviso_id integer;
BEGIN
  IF v_uid IS NULL THEN RETURN jsonb_build_object('ok',false,'msg','not authenticated'); END IF;
  IF char_length(p_nota) > 500 THEN
    RETURN jsonb_build_object('ok', false, 'msg', 'nota demasiado larga');
  END IF;
  SELECT id INTO v_alumna_id FROM triskel_alumnas WHERE auth_user_id=v_uid LIMIT 1;
  IF v_alumna_id IS NULL THEN RETURN jsonb_build_object('ok',false,'msg','alumna no vinculada'); END IF;

  INSERT INTO triskel_avisos_pago(alumna_id, mes, monto_declarado, nota, estado)
  VALUES(v_alumna_id, p_mes, p_monto_declarado, p_nota, 'pendiente')
  ON CONFLICT(alumna_id, mes) DO UPDATE
    SET monto_declarado=EXCLUDED.monto_declarado,
        nota=EXCLUDED.nota,
        estado='pendiente',
        updated_at=now()
  RETURNING id INTO v_aviso_id;

  RETURN jsonb_build_object('ok',true,'aviso_id',v_aviso_id,'alumna_id',v_alumna_id);
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_crear_aviso_pago(text, numeric, text) TO authenticated;

-- ── 9. ALTO: Fix cron — usar service_role key en lugar de anon key ────────────
-- PREREQUISITO: ejecutar UNA VEZ con tu service_role key (Dashboard → Settings → API):
--   ALTER DATABASE postgres SET "app.supabase_service_key" = 'tu_service_role_key';
CREATE OR REPLACE FUNCTION triskel_send_payment_reminders()
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  v_edge_url  text    := 'https://dplzkrdgnynyyunmrawr.supabase.co/functions/v1/send-push';
  v_auth_key  text    := COALESCE(current_setting('app.supabase_service_key', true), '');
  v_mes       text    := to_char(now() AT TIME ZONE 'America/Argentina/Buenos_Aires', 'YYYY-MM');
  v_today     integer := extract(day from now() AT TIME ZONE 'America/Argentina/Buenos_Aires')::integer;
  rec         record;
BEGIN
  IF v_auth_key = '' THEN RETURN; END IF;
  FOR rec IN
    SELECT DISTINCT a.id AS alumna_id, a.nombre, a.auth_user_id, a.dia_pago
    FROM triskel_alumnas a
    WHERE a.auth_user_id IS NOT NULL
      AND a.estado = 'activa'
      AND (a.dia_pago = v_today OR (a.dia_pago IS NOT NULL AND a.dia_pago + 5 = v_today))
      AND EXISTS (SELECT 1 FROM triskel_inscripciones i WHERE i.alumna_id = a.id AND i.activa = true)
      AND NOT EXISTS (SELECT 1 FROM triskel_pagos p WHERE p.alumna_id = a.id AND p.mes = v_mes AND p.pagado = true)
      AND NOT EXISTS (SELECT 1 FROM triskel_avisos_pago av WHERE av.alumna_id = a.id AND av.mes = v_mes AND av.estado IN ('aprobado', 'pendiente'))
  LOOP
    PERFORM net.http_post(
      url     := v_edge_url,
      headers := jsonb_build_object('Content-Type', 'application/json', 'Authorization', 'Bearer ' || v_auth_key),
      body    := jsonb_build_object('tipo', 'recordatorio_pago', 'target_user_id', rec.auth_user_id::text, 'nombre', rec.nombre, 'mes', v_mes)
    );
  END LOOP;
END;
$$;

NOTIFY pgrst, 'reload schema';

NOTIFY pgrst, 'reload schema';
