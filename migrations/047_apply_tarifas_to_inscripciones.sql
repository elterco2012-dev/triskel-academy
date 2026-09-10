-- 047: Función para aplicar tarifas actuales a todas las inscripciones activas
-- Se llama desde el panel cuando la profe guarda nuevas tarifas y quiere
-- propagarlas a las alumnas existentes (agrupando por alumna+modalidad+hora_inicio)

CREATE OR REPLACE FUNCTION triskel_apply_tarifas_to_inscripciones(p_tarifas jsonb)
RETURNS integer LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  rec       record;
  v_total   integer;
  v_por_dia integer;
  v_updated integer := 0;
BEGIN
  IF triskel_is_alumna() THEN RETURN 0; END IF;
  FOR rec IN
    SELECT
      i.alumna_id,
      h.modalidad,
      h.hora_inicio,
      COUNT(*)                        AS cant_dias,
      ARRAY_AGG(i.id ORDER BY i.id)  AS insc_ids
    FROM triskel_inscripciones i
    JOIN triskel_horarios h ON h.id = i.horario_id
    WHERE i.activa = true
    GROUP BY i.alumna_id, h.modalidad, h.hora_inicio
  LOOP
    v_total := CASE rec.cant_dias
      WHEN 1 THEN (p_tarifas->>(rec.modalidad||'_1'))::integer
      WHEN 2 THEN (p_tarifas->>(rec.modalidad||'_2'))::integer
      ELSE NULL
    END;
    IF v_total IS NULL OR v_total = 0 THEN CONTINUE; END IF;
    v_por_dia := v_total / rec.cant_dias;
    UPDATE triskel_inscripciones SET precio = v_por_dia WHERE id = ANY(rec.insc_ids);
    v_updated := v_updated + rec.cant_dias;
  END LOOP;
  RETURN v_updated;
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_apply_tarifas_to_inscripciones(jsonb) TO authenticated;
