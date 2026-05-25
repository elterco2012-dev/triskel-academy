-- 044: Actualizar precios de inscripciones según modalidad y días por semana
-- El sistema SUMA los precios de las inscripciones del mismo grupo → dividir en partes iguales

DO $$
DECLARE
  rec       record;
  v_total   integer;
  v_por_dia integer;
BEGIN
  FOR rec IN
    SELECT
      a.id       AS alumna_id,
      a.nombre,
      a.apellido,
      h.modalidad,
      COUNT(*)   AS cant_dias,
      ARRAY_AGG(i.id ORDER BY i.id) AS insc_ids
    FROM triskel_inscripciones i
    JOIN triskel_horarios h ON h.id = i.horario_id
    JOIN triskel_alumnas a  ON a.id = i.alumna_id
    WHERE i.activa = true AND i.precio = 0
    GROUP BY a.id, a.nombre, a.apellido, h.modalidad
  LOOP
    -- Precio total del plan según modalidad + cantidad de días
    v_total := CASE rec.modalidad
      WHEN 'reformer' THEN
        CASE rec.cant_dias WHEN 1 THEN 31000 ELSE 37000 END
      WHEN 'mat' THEN
        CASE rec.cant_dias WHEN 1 THEN 27000 ELSE 33000 END
      WHEN 'funcional' THEN
        CASE rec.cant_dias WHEN 1 THEN 27000 WHEN 2 THEN 33000 ELSE 39000 END
      ELSE 0
    END;

    -- Dividir en partes iguales entre las inscripciones (así la suma = precio del plan)
    v_por_dia := v_total / rec.cant_dias;

    UPDATE triskel_inscripciones
    SET precio = v_por_dia
    WHERE id = ANY(rec.insc_ids);

    RAISE NOTICE '% % | % | % día/s → $% total ($% c/u)',
      rec.nombre, rec.apellido, rec.modalidad, rec.cant_dias, v_total, v_por_dia;
  END LOOP;
END $$;

-- Verificar:
-- SELECT a.nombre, a.apellido, h.modalidad,
--        STRING_AGG(h.dia, '+' ORDER BY h.dia) AS dias,
--        SUM(i.precio) AS total_mes
-- FROM triskel_inscripciones i
-- JOIN triskel_horarios h ON h.id = i.horario_id
-- JOIN triskel_alumnas a  ON a.id = i.alumna_id
-- WHERE i.activa = true
-- GROUP BY a.nombre, a.apellido, h.modalidad
-- ORDER BY a.nombre, h.modalidad;
