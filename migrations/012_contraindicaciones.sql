-- =====================================================
-- Triskel Academy — Contraindicaciones médicas (012)
-- Campo permanente separado de observaciones generales
-- Ejecutar completo en Supabase → SQL Editor
-- =====================================================

ALTER TABLE triskel_alumnas
  ADD COLUMN IF NOT EXISTS contraindicaciones text;

CREATE OR REPLACE FUNCTION triskel_save_alumna(
  p_nombre           text,
  p_apellido         text    DEFAULT NULL,
  p_tel              text    DEFAULT NULL,
  p_email            text    DEFAULT NULL,
  p_notas            text    DEFAULT NULL,
  p_estado           text    DEFAULT 'activa',
  p_dia_pago         integer DEFAULT NULL,
  p_fecha_nacimiento date    DEFAULT NULL,
  p_id               integer DEFAULT NULL,
  p_contraindicaciones text  DEFAULT NULL
)
RETURNS integer LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_id integer;
BEGIN
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
