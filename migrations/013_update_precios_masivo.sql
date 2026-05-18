-- =====================================================
-- Triskel Academy — Actualización masiva de precios (013)
-- Aplica un factor multiplicador a todas las inscripciones
-- activas de una modalidad dada
-- Ejecutar completo en Supabase → SQL Editor
-- =====================================================

CREATE OR REPLACE FUNCTION triskel_update_precios_modalidad(
  p_modalidad text,
  p_factor    numeric
)
RETURNS integer LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_count integer;
BEGIN
  UPDATE triskel_inscripciones
  SET precio = ROUND(precio * p_factor)
  WHERE activa = true
    AND horario_id IN (
      SELECT id FROM triskel_horarios WHERE modalidad = p_modalidad
    );
  GET DIAGNOSTICS v_count = ROW_COUNT;
  RETURN v_count;
END;
$$;

GRANT EXECUTE ON FUNCTION triskel_update_precios_modalidad(text, numeric) TO authenticated;
