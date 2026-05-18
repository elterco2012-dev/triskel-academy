-- =====================================================
-- Triskel Academy — Reinscripción (009)
-- Permite volver a inscribir a una alumna en un horario
-- del que fue dada de baja (activa=false)
-- Ejecutar completo en Supabase → SQL Editor
-- =====================================================

CREATE OR REPLACE FUNCTION triskel_insert_inscripcion(
  p_alumna_id  integer,
  p_horario_id integer,
  p_precio     numeric DEFAULT 0
)
RETURNS void LANGUAGE sql SECURITY DEFINER AS $$
  INSERT INTO triskel_inscripciones(alumna_id, horario_id, precio, activa)
  VALUES(p_alumna_id, p_horario_id, COALESCE(p_precio, 0), true)
  ON CONFLICT (alumna_id, horario_id)
  DO UPDATE SET activa = true, precio = EXCLUDED.precio;
$$;

GRANT EXECUTE ON FUNCTION triskel_insert_inscripcion(integer,integer,numeric) TO authenticated;
