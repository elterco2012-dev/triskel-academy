-- Migración 028: Seguridad en tabla y RPCs de asistencia
-- Ejecutar en Supabase SQL Editor
--
-- PROBLEMA: triskel_asistencia no tenía RLS y las RPCs de asistencia
-- eran invocables por cualquiera con la anon key, sin verificación de
-- autenticación ni de rol. Cualquiera podía leer toda la asistencia o
-- sobreescribirla sin estar logueado.
--
-- SOLUCIÓN: habilitar RLS + reescribir funciones con gate de auth +
-- aplicar REVOKE/GRANT consistente con el resto del sistema (mig 021).

-- ── 1. RLS en la tabla de asistencia ─────────────────────────────────
ALTER TABLE triskel_asistencia ENABLE ROW LEVEL SECURITY;

-- Solo usuarios autenticados pueden leer (Amira + alumnas autenticadas).
-- La escritura directa queda bloqueada para todos; solo la RPC puede escribir.
DROP POLICY IF EXISTS "authenticated_read" ON triskel_asistencia;
CREATE POLICY "authenticated_read" ON triskel_asistencia
  FOR SELECT TO authenticated USING (true);

-- ── 2. Reescribir triskel_save_asistencia con gate de auth ────────────
-- Solo la profe (usuario autenticado que NO es alumna) puede guardar.
CREATE OR REPLACE FUNCTION triskel_save_asistencia(
  p_clase_id bigint,
  p_presentes bigint[]
) RETURNS jsonb
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  -- Bloquear llamadas sin sesión activa
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'No autorizado';
  END IF;
  -- Bloquear alumnas (solo la profe guarda asistencia)
  IF (SELECT count(*) FROM triskel_alumnas WHERE auth_user_id = auth.uid()) > 0 THEN
    RAISE EXCEPTION 'Acceso denegado';
  END IF;

  DELETE FROM triskel_asistencia WHERE clase_id = p_clase_id;
  IF array_length(coalesce(p_presentes, array[]::bigint[]), 1) > 0 THEN
    INSERT INTO triskel_asistencia (clase_id, alumna_id, presente)
    SELECT p_clase_id, unnest(p_presentes), true;
  END IF;
  RETURN jsonb_build_object('ok', true);
END;$$;

-- ── 3. Reescribir triskel_get_asistencia con gate de auth ─────────────
-- Solo la profe puede consultar asistencia de cualquier alumna/período.
-- Las alumnas ven su propia asistencia a través de triskel_get_mi_ficha.
CREATE OR REPLACE FUNCTION triskel_get_asistencia(
  p_alumna_id bigint DEFAULT NULL,
  p_desde     date   DEFAULT NULL,
  p_hasta     date   DEFAULT NULL
) RETURNS jsonb
LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  v_desde date := coalesce(p_desde, (current_date - interval '90 days')::date);
  v_hasta date := coalesce(p_hasta, current_date);
  v_result jsonb;
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'No autorizado';
  END IF;
  IF (SELECT count(*) FROM triskel_alumnas WHERE auth_user_id = auth.uid()) > 0 THEN
    RAISE EXCEPTION 'Acceso denegado';
  END IF;

  SELECT jsonb_agg(jsonb_build_object(
    'clase_id',  a.clase_id,
    'alumna_id', a.alumna_id,
    'presente',  a.presente,
    'fecha',     c.fecha
  ) ORDER BY c.fecha DESC)
  INTO v_result
  FROM triskel_asistencia a
  JOIN triskel_clases c ON c.id = a.clase_id
  WHERE (p_alumna_id IS NULL OR a.alumna_id = p_alumna_id)
    AND c.fecha >= v_desde
    AND c.fecha <= v_hasta;

  RETURN jsonb_build_object('ok', true, 'data', coalesce(v_result, '[]'::jsonb));
END;$$;

-- ── 4. REVOKE / GRANT — patrón consistente con migración 021 ──────────
REVOKE EXECUTE ON FUNCTION triskel_save_asistencia(bigint, bigint[])    FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION triskel_get_asistencia(bigint, date, date)   FROM PUBLIC;

GRANT  EXECUTE ON FUNCTION triskel_save_asistencia(bigint, bigint[])    TO authenticated;
GRANT  EXECUTE ON FUNCTION triskel_get_asistencia(bigint, date, date)   TO authenticated;
