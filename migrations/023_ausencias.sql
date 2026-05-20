-- 023: Tabla de ausencias avisadas por alumnas

CREATE TABLE IF NOT EXISTS triskel_ausencias (
  id           serial PRIMARY KEY,
  alumna_id    integer NOT NULL REFERENCES triskel_alumnas(id) ON DELETE CASCADE,
  inscripcion_id integer REFERENCES triskel_inscripciones(id) ON DELETE SET NULL,
  fecha        date NOT NULL,
  motivo       text,
  created_at   timestamptz DEFAULT now()
);

CREATE UNIQUE INDEX IF NOT EXISTS triskel_ausencias_uq
  ON triskel_ausencias(alumna_id, COALESCE(inscripcion_id, 0), fecha);

-- Alumna reporta su propia ausencia
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

  INSERT INTO triskel_ausencias(alumna_id, inscripcion_id, fecha, motivo)
  VALUES(v_alumna_id, p_inscripcion_id, p_fecha, p_motivo)
  ON CONFLICT (alumna_id, COALESCE(inscripcion_id, 0), fecha)
  DO UPDATE SET motivo = EXCLUDED.motivo;

  RETURN jsonb_build_object('ok', true);
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_avisar_ausencia(integer, date, text) TO authenticated;

-- Profe consulta ausencias (por rango de fechas)
CREATE OR REPLACE FUNCTION triskel_get_ausencias(
  p_desde date DEFAULT NULL,
  p_hasta date DEFAULT NULL
)
RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  RETURN jsonb_build_object(
    'ok', true,
    'data', COALESCE((
      SELECT jsonb_agg(r ORDER BY r.fecha, r.created_at)
      FROM (
        SELECT
          a.id,
          a.alumna_id,
          a.inscripcion_id,
          a.fecha::text,
          a.motivo,
          a.created_at,
          al.nombre  AS alumna_nombre,
          al.apellido AS alumna_apellido,
          h.modalidad,
          h.dia,
          h.hora_inicio
        FROM triskel_ausencias a
        JOIN triskel_alumnas al ON al.id = a.alumna_id
        LEFT JOIN triskel_inscripciones i ON i.id = a.inscripcion_id
        LEFT JOIN triskel_horarios h ON h.id = i.horario_id
        WHERE (p_desde IS NULL OR a.fecha >= p_desde)
          AND (p_hasta IS NULL OR a.fecha <= p_hasta)
      ) r
    ), '[]'::jsonb)
  );
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_get_ausencias(date, date) TO authenticated;

NOTIFY pgrst, 'reload schema';
