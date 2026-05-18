-- =====================================================
-- Triskel Academy — Mejoras (007)
-- Lista de espera, observaciones, cumpleaños, pausa
-- Ejecutar completo en Supabase → SQL Editor
-- =====================================================

-- 1. Lista de espera
CREATE TABLE IF NOT EXISTS triskel_lista_espera (
  id         SERIAL PRIMARY KEY,
  alumna_id  INTEGER NOT NULL REFERENCES triskel_alumnas(id) ON DELETE CASCADE,
  horario_id INTEGER NOT NULL REFERENCES triskel_horarios(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(alumna_id, horario_id)
);
ALTER TABLE triskel_lista_espera ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "allow_auth_espera" ON triskel_lista_espera;
CREATE POLICY "allow_auth_espera" ON triskel_lista_espera FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- 2. Observaciones de alumna
CREATE TABLE IF NOT EXISTS triskel_observaciones (
  id         SERIAL PRIMARY KEY,
  alumna_id  INTEGER NOT NULL REFERENCES triskel_alumnas(id) ON DELETE CASCADE,
  fecha      DATE NOT NULL DEFAULT CURRENT_DATE,
  texto      TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE triskel_observaciones ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "allow_auth_obs" ON triskel_observaciones;
CREATE POLICY "allow_auth_obs" ON triskel_observaciones FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- 3. Cumpleaños en alumnas (formato texto DD/MM)
ALTER TABLE triskel_alumnas ADD COLUMN IF NOT EXISTS cumpleanos TEXT;

-- 4. triskel_save_alumna con cumpleaños + retorna ID
DROP FUNCTION IF EXISTS triskel_save_alumna(text,text,text,text,text,text,integer,integer);

CREATE OR REPLACE FUNCTION triskel_save_alumna(
  p_nombre     text,
  p_apellido   text    DEFAULT NULL,
  p_tel        text    DEFAULT NULL,
  p_email      text    DEFAULT NULL,
  p_notas      text    DEFAULT NULL,
  p_estado     text    DEFAULT 'activa',
  p_dia_pago   integer DEFAULT NULL,
  p_cumpleanos text    DEFAULT NULL,
  p_id         integer DEFAULT NULL
)
RETURNS integer LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_id integer;
BEGIN
  IF p_id IS NOT NULL THEN
    UPDATE triskel_alumnas SET
      nombre=p_nombre, apellido=p_apellido, tel=p_tel,
      email=p_email, notas=p_notas, dia_pago=p_dia_pago,
      cumpleanos=p_cumpleanos
    WHERE id=p_id;
    v_id := p_id;
  ELSE
    INSERT INTO triskel_alumnas(nombre,apellido,tel,email,notas,estado,dia_pago,cumpleanos)
    VALUES(p_nombre,p_apellido,p_tel,p_email,p_notas,
           COALESCE(NULLIF(p_estado,''),'activa'),p_dia_pago,p_cumpleanos)
    RETURNING id INTO v_id;
  END IF;
  RETURN v_id;
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_save_alumna(text,text,text,text,text,text,integer,text,integer) TO authenticated;

-- 5. Cambiar estado (activa / pausada / baja)
CREATE OR REPLACE FUNCTION triskel_set_estado_alumna(p_id integer, p_estado text)
RETURNS void LANGUAGE sql SECURITY DEFINER AS $$
  UPDATE triskel_alumnas SET estado = p_estado WHERE id = p_id;
$$;
GRANT EXECUTE ON FUNCTION triskel_set_estado_alumna(integer,text) TO authenticated;

-- 6. Lista de espera RPCs
CREATE OR REPLACE FUNCTION triskel_insert_espera(p_alumna_id integer, p_horario_id integer)
RETURNS void LANGUAGE sql SECURITY DEFINER AS $$
  INSERT INTO triskel_lista_espera(alumna_id, horario_id)
  VALUES(p_alumna_id, p_horario_id)
  ON CONFLICT(alumna_id, horario_id) DO NOTHING;
$$;
GRANT EXECUTE ON FUNCTION triskel_insert_espera(integer,integer) TO authenticated;

CREATE OR REPLACE FUNCTION triskel_remove_espera(p_id integer)
RETURNS void LANGUAGE sql SECURITY DEFINER AS $$
  DELETE FROM triskel_lista_espera WHERE id = p_id;
$$;
GRANT EXECUTE ON FUNCTION triskel_remove_espera(integer) TO authenticated;

-- 7. Observaciones RPCs
CREATE OR REPLACE FUNCTION triskel_save_observacion(
  p_alumna_id integer,
  p_texto     text,
  p_fecha     date    DEFAULT CURRENT_DATE,
  p_id        integer DEFAULT NULL
)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  IF p_id IS NOT NULL THEN
    UPDATE triskel_observaciones SET fecha=p_fecha, texto=p_texto WHERE id=p_id;
  ELSE
    INSERT INTO triskel_observaciones(alumna_id,fecha,texto) VALUES(p_alumna_id,p_fecha,p_texto);
  END IF;
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_save_observacion(integer,text,date,integer) TO authenticated;

CREATE OR REPLACE FUNCTION triskel_delete_observacion(p_id integer)
RETURNS void LANGUAGE sql SECURITY DEFINER AS $$
  DELETE FROM triskel_observaciones WHERE id = p_id;
$$;
GRANT EXECUTE ON FUNCTION triskel_delete_observacion(integer) TO authenticated;

-- 8. triskel_load_all actualizado (incluye espera y observaciones)
CREATE OR REPLACE FUNCTION triskel_load_all()
RETURNS json LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  v_horarios      json; v_alumnas    json; v_inscripciones json;
  v_clases        json; v_pagos      json;
  v_espera        json; v_observaciones json;
BEGIN
  SELECT COALESCE((SELECT json_agg(t ORDER BY
    CASE t.dia WHEN 'lun' THEN 0 WHEN 'mar' THEN 1 WHEN 'mie' THEN 2
               WHEN 'jue' THEN 3 WHEN 'vie' THEN 4 ELSE 5 END, t.hora_inicio)
    FROM triskel_horarios t),'[]'::json) INTO v_horarios;

  SELECT COALESCE((SELECT json_agg(t ORDER BY t.nombre)
    FROM triskel_alumnas t),'[]'::json) INTO v_alumnas;

  SELECT COALESCE((SELECT json_agg(jsonb_build_object(
      'id',i.id,'alumna_id',i.alumna_id,'horario_id',i.horario_id,
      'precio',i.precio,'activa',i.activa,
      'triskel_alumnas',jsonb_build_object('nombre',a.nombre),
      'triskel_horarios',jsonb_build_object('dia',h.dia,'hora_inicio',h.hora_inicio,
        'hora_fin',h.hora_fin,'modalidad',h.modalidad)))
    FROM triskel_inscripciones i
    LEFT JOIN triskel_alumnas a ON a.id=i.alumna_id
    LEFT JOIN triskel_horarios h ON h.id=i.horario_id
    WHERE i.activa=true),'[]'::json) INTO v_inscripciones;

  SELECT COALESCE((SELECT json_agg(t)
    FROM (SELECT * FROM triskel_clases ORDER BY fecha DESC LIMIT 200) t),'[]'::json) INTO v_clases;

  SELECT COALESCE((SELECT json_agg(t)
    FROM (SELECT * FROM triskel_pagos ORDER BY mes DESC LIMIT 500) t),'[]'::json) INTO v_pagos;

  SELECT COALESCE((SELECT json_agg(jsonb_build_object(
      'id',e.id,'alumna_id',e.alumna_id,'horario_id',e.horario_id,'created_at',e.created_at)
    ORDER BY e.created_at)
    FROM triskel_lista_espera e),'[]'::json) INTO v_espera;

  SELECT COALESCE((SELECT json_agg(t ORDER BY t.fecha DESC, t.created_at DESC)
    FROM triskel_observaciones t),'[]'::json) INTO v_observaciones;

  RETURN json_build_object(
    'horarios',v_horarios,'alumnas',v_alumnas,'inscripciones',v_inscripciones,
    'clases',v_clases,'pagos',v_pagos,'espera',v_espera,'observaciones',v_observaciones
  );
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_load_all() TO authenticated, anon;
