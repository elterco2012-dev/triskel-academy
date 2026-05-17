-- =====================================================
-- Triskel Academy — RPC Functions (004)
-- Workaround for PGRST205 schema cache bug.
-- All functions use SECURITY DEFINER so they run as
-- the table owner (postgres), bypassing role checks.
-- Ejecutar completo en Supabase → SQL Editor
-- =====================================================

-- ─── LOAD ALL ──────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION triskel_load_all()
RETURNS json LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  v_horarios json;
  v_alumnas json;
  v_inscripciones json;
  v_clases json;
  v_pagos json;
BEGIN
  SELECT COALESCE((
    SELECT json_agg(t ORDER BY
      CASE t.dia WHEN 'lun' THEN 0 WHEN 'mar' THEN 1
                 WHEN 'mie' THEN 2 WHEN 'jue' THEN 3
                 WHEN 'vie' THEN 4 ELSE 5 END,
      t.hora_inicio)
    FROM triskel_horarios t
  ), '[]'::json) INTO v_horarios;

  SELECT COALESCE((
    SELECT json_agg(t ORDER BY t.nombre)
    FROM triskel_alumnas t
  ), '[]'::json) INTO v_alumnas;

  SELECT COALESCE((
    SELECT json_agg(
      jsonb_build_object(
        'id', i.id,
        'alumna_id', i.alumna_id,
        'horario_id', i.horario_id,
        'precio', i.precio,
        'activa', i.activa,
        'triskel_alumnas', jsonb_build_object('nombre', a.nombre),
        'triskel_horarios', jsonb_build_object(
          'dia', h.dia, 'hora_inicio', h.hora_inicio,
          'hora_fin', h.hora_fin, 'modalidad', h.modalidad)
      )
    )
    FROM triskel_inscripciones i
    LEFT JOIN triskel_alumnas a ON a.id = i.alumna_id
    LEFT JOIN triskel_horarios h ON h.id = i.horario_id
    WHERE i.activa = true
  ), '[]'::json) INTO v_inscripciones;

  SELECT COALESCE((
    SELECT json_agg(t)
    FROM (SELECT * FROM triskel_clases ORDER BY fecha DESC LIMIT 200) t
  ), '[]'::json) INTO v_clases;

  SELECT COALESCE((
    SELECT json_agg(t)
    FROM (SELECT * FROM triskel_pagos ORDER BY mes DESC LIMIT 500) t
  ), '[]'::json) INTO v_pagos;

  RETURN json_build_object(
    'horarios',      v_horarios,
    'alumnas',       v_alumnas,
    'inscripciones', v_inscripciones,
    'clases',        v_clases,
    'pagos',         v_pagos
  );
END;
$$;

-- ─── ALUMNAS ───────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION triskel_save_alumna(
  p_nombre   text,
  p_apellido text    DEFAULT NULL,
  p_tel      text    DEFAULT NULL,
  p_email    text    DEFAULT NULL,
  p_notas    text    DEFAULT NULL,
  p_estado   text    DEFAULT 'activa',
  p_id       integer DEFAULT NULL
)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  IF p_id IS NOT NULL THEN
    UPDATE triskel_alumnas SET
      nombre   = p_nombre,
      apellido = p_apellido,
      tel      = p_tel,
      email    = p_email,
      notas    = p_notas
    WHERE id = p_id;
  ELSE
    INSERT INTO triskel_alumnas(nombre, apellido, tel, email, notas, estado)
    VALUES(p_nombre, p_apellido, p_tel, p_email, p_notas,
           COALESCE(NULLIF(p_estado,''), 'activa'));
  END IF;
END;
$$;

-- ─── INSCRIPCIONES ─────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION triskel_insert_inscripcion(
  p_alumna_id  integer,
  p_horario_id integer,
  p_precio     numeric DEFAULT 0
)
RETURNS void LANGUAGE sql SECURITY DEFINER AS $$
  INSERT INTO triskel_inscripciones(alumna_id, horario_id, precio, activa)
  VALUES(p_alumna_id, p_horario_id, COALESCE(p_precio, 0), true);
$$;

CREATE OR REPLACE FUNCTION triskel_deactivate_inscripcion(p_id integer)
RETURNS void LANGUAGE sql SECURITY DEFINER AS $$
  UPDATE triskel_inscripciones SET activa = false WHERE id = p_id;
$$;

-- ─── CLASES ────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION triskel_save_clase(
  p_horario_id integer,
  p_fecha      date,
  p_ejercicios json    DEFAULT '[]',
  p_notas      text    DEFAULT NULL,
  p_id         integer DEFAULT NULL
)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  IF p_id IS NOT NULL THEN
    UPDATE triskel_clases SET
      horario_id = p_horario_id,
      fecha      = p_fecha,
      ejercicios = p_ejercicios::jsonb,
      notas      = p_notas
    WHERE id = p_id;
  ELSE
    INSERT INTO triskel_clases(horario_id, fecha, ejercicios, notas)
    VALUES(p_horario_id, p_fecha,
           COALESCE(p_ejercicios, '[]')::jsonb, p_notas);
  END IF;
END;
$$;

CREATE OR REPLACE FUNCTION triskel_delete_clase(p_id integer)
RETURNS void LANGUAGE sql SECURITY DEFINER AS $$
  DELETE FROM triskel_clases WHERE id = p_id;
$$;

-- ─── PAGOS ─────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION triskel_insert_pago(
  p_alumna_id     integer,
  p_inscripcion_id integer,
  p_mes           text,
  p_monto         numeric DEFAULT 0
)
RETURNS void LANGUAGE sql SECURITY DEFINER AS $$
  INSERT INTO triskel_pagos(alumna_id, inscripcion_id, mes, monto, pagado)
  VALUES(p_alumna_id, p_inscripcion_id, p_mes, COALESCE(p_monto, 0), false);
$$;

CREATE OR REPLACE FUNCTION triskel_mark_pago(
  p_id         integer,
  p_pagado     boolean,
  p_fecha_pago text DEFAULT NULL
)
RETURNS void LANGUAGE sql SECURITY DEFINER AS $$
  UPDATE triskel_pagos SET
    pagado     = p_pagado,
    fecha_pago = CASE WHEN p_fecha_pago IS NULL THEN NULL
                      ELSE p_fecha_pago::date END
  WHERE id = p_id;
$$;

-- ─── PING (diagnóstico) ────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION triskel_ping()
RETURNS text LANGUAGE sql SECURITY DEFINER AS $$
  SELECT 'pong — ' || now()::text;
$$;

-- ─── GRANTS ────────────────────────────────────────────────────────────────
GRANT EXECUTE ON FUNCTION triskel_ping()                                              TO authenticated, anon;
GRANT EXECUTE ON FUNCTION triskel_load_all()                                          TO authenticated, anon;
GRANT EXECUTE ON FUNCTION triskel_save_alumna(text,text,text,text,text,text,integer)  TO authenticated;
GRANT EXECUTE ON FUNCTION triskel_insert_inscripcion(integer,integer,numeric)         TO authenticated;
GRANT EXECUTE ON FUNCTION triskel_deactivate_inscripcion(integer)                     TO authenticated;
GRANT EXECUTE ON FUNCTION triskel_save_clase(integer,date,json,text,integer)          TO authenticated;
GRANT EXECUTE ON FUNCTION triskel_delete_clase(integer)                               TO authenticated;
GRANT EXECUTE ON FUNCTION triskel_insert_pago(integer,integer,text,numeric)           TO authenticated;
GRANT EXECUTE ON FUNCTION triskel_mark_pago(integer,boolean,text)                     TO authenticated;
