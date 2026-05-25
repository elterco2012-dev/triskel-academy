-- 038: Fix triskel_avisar_ausencia — reemplazar ON CONFLICT con expresión
-- por UPDATE+INSERT explícito que no depende del índice funcional.

CREATE OR REPLACE FUNCTION triskel_avisar_ausencia(
  p_inscripcion_id integer,
  p_fecha          date,
  p_motivo         text DEFAULT NULL
)
RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  v_uid       uuid    := auth.uid();
  v_alumna_id integer;
BEGIN
  SELECT id INTO v_alumna_id FROM triskel_alumnas WHERE auth_user_id = v_uid LIMIT 1;
  IF v_alumna_id IS NULL THEN
    RETURN jsonb_build_object('ok', false, 'msg', 'cuenta no vinculada');
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM triskel_inscripciones
    WHERE id = p_inscripcion_id AND alumna_id = v_alumna_id
  ) THEN
    RETURN jsonb_build_object('ok', false, 'msg', 'inscripcion no encontrada');
  END IF;

  -- Upsert sin ON CONFLICT sobre expresión funcional
  UPDATE triskel_ausencias
  SET motivo = p_motivo
  WHERE alumna_id = v_alumna_id
    AND inscripcion_id = p_inscripcion_id
    AND fecha = p_fecha;

  IF NOT FOUND THEN
    INSERT INTO triskel_ausencias(alumna_id, inscripcion_id, fecha, motivo)
    VALUES(v_alumna_id, p_inscripcion_id, p_fecha, p_motivo);
  END IF;

  RETURN jsonb_build_object('ok', true);
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_avisar_ausencia(integer, date, text) TO authenticated;
