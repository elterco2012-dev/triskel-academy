-- =====================================================
-- Triskel Academy — Capacidad por horario (006)
-- + triskel_save_alumna retorna el ID de la alumna
-- Ejecutar completo en Supabase → SQL Editor
-- =====================================================

-- Capacidad por horario
ALTER TABLE triskel_horarios ADD COLUMN IF NOT EXISTS capacidad integer;
UPDATE triskel_horarios SET capacidad = 5  WHERE modalidad = 'reformer'             AND capacidad IS NULL;
UPDATE triskel_horarios SET capacidad = 12 WHERE modalidad IN ('mat','funcional')   AND capacidad IS NULL;
ALTER TABLE triskel_horarios ALTER COLUMN capacidad SET DEFAULT 12;

-- triskel_save_alumna ahora retorna el ID (para crear inscripciones en el mismo paso)
DROP FUNCTION IF EXISTS triskel_save_alumna(text,text,text,text,text,text,integer,integer);

CREATE OR REPLACE FUNCTION triskel_save_alumna(
  p_nombre   text,
  p_apellido text    DEFAULT NULL,
  p_tel      text    DEFAULT NULL,
  p_email    text    DEFAULT NULL,
  p_notas    text    DEFAULT NULL,
  p_estado   text    DEFAULT 'activa',
  p_dia_pago integer DEFAULT NULL,
  p_id       integer DEFAULT NULL
)
RETURNS integer LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_id integer;
BEGIN
  IF p_id IS NOT NULL THEN
    UPDATE triskel_alumnas SET
      nombre=p_nombre, apellido=p_apellido, tel=p_tel,
      email=p_email, notas=p_notas, dia_pago=p_dia_pago
    WHERE id=p_id;
    v_id := p_id;
  ELSE
    INSERT INTO triskel_alumnas(nombre,apellido,tel,email,notas,estado,dia_pago)
    VALUES(p_nombre,p_apellido,p_tel,p_email,p_notas,COALESCE(NULLIF(p_estado,''),'activa'),p_dia_pago)
    RETURNING id INTO v_id;
  END IF;
  RETURN v_id;
END;
$$;

GRANT EXECUTE ON FUNCTION triskel_save_alumna(text,text,text,text,text,text,integer,integer) TO authenticated;
