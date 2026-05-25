-- 045: Agregar campo notas a triskel_horarios

ALTER TABLE triskel_horarios ADD COLUMN IF NOT EXISTS notas text;

CREATE OR REPLACE FUNCTION triskel_save_horario_notas(p_id integer, p_notas text)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  IF triskel_is_alumna() THEN RETURN; END IF;
  UPDATE triskel_horarios SET notas = p_notas WHERE id = p_id;
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_save_horario_notas(integer, text) TO authenticated;
