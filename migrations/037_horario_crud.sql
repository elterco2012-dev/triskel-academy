-- 037: RPCs para crear, editar y eliminar horarios desde el panel
-- También actualiza chk_horario_modalidad para incluir 'esferodinamia'

-- ── 1. Ampliar constraint de modalidad en horarios ────────────────────────────
ALTER TABLE triskel_horarios DROP CONSTRAINT IF EXISTS chk_horario_modalidad;
ALTER TABLE triskel_horarios
  ADD CONSTRAINT chk_horario_modalidad
    CHECK (modalidad IN ('mat', 'reformer', 'funcional', 'esferodinamia'));

-- ── 2. Upsert de horario (crear o editar) ─────────────────────────────────────
CREATE OR REPLACE FUNCTION triskel_upsert_horario(
  p_modalidad  text,
  p_dia        text,
  p_hora_inicio text,
  p_hora_fin   text,
  p_capacidad  integer DEFAULT 12,
  p_id         integer DEFAULT NULL
)
RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  v_id integer;
BEGIN
  IF triskel_is_alumna() THEN
    RETURN jsonb_build_object('ok', false, 'msg', 'no autorizado');
  END IF;

  IF p_modalidad NOT IN ('mat','reformer','funcional','esferodinamia') THEN
    RETURN jsonb_build_object('ok', false, 'msg', 'modalidad inválida');
  END IF;

  IF p_dia NOT IN ('lun','mar','mie','jue','vie','sab','dom') THEN
    RETURN jsonb_build_object('ok', false, 'msg', 'día inválido');
  END IF;

  IF p_hora_inicio IS NULL OR p_hora_fin IS NULL THEN
    RETURN jsonb_build_object('ok', false, 'msg', 'horario incompleto');
  END IF;

  IF p_id IS NOT NULL THEN
    UPDATE triskel_horarios SET
      modalidad   = p_modalidad,
      dia         = p_dia,
      hora_inicio = p_hora_inicio,
      hora_fin    = p_hora_fin,
      capacidad   = COALESCE(p_capacidad, 12)
    WHERE id = p_id;
    v_id := p_id;
  ELSE
    INSERT INTO triskel_horarios(modalidad, dia, hora_inicio, hora_fin, capacidad)
    VALUES (p_modalidad, p_dia, p_hora_inicio, p_hora_fin, COALESCE(p_capacidad, 12))
    RETURNING id INTO v_id;
  END IF;

  RETURN jsonb_build_object('ok', true, 'id', v_id);
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_upsert_horario(text,text,text,text,integer,integer) TO authenticated;

-- ── 3. Eliminar horario (solo si no tiene inscripciones activas) ───────────────
CREATE OR REPLACE FUNCTION triskel_delete_horario(p_id integer)
RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  v_insc integer;
BEGIN
  IF triskel_is_alumna() THEN
    RETURN jsonb_build_object('ok', false, 'msg', 'no autorizado');
  END IF;

  SELECT COUNT(*) INTO v_insc
  FROM triskel_inscripciones
  WHERE horario_id = p_id AND activa = true;

  IF v_insc > 0 THEN
    RETURN jsonb_build_object('ok', false, 'msg', 'El horario tiene alumnas inscriptas. Dales de baja antes de eliminarlo.');
  END IF;

  DELETE FROM triskel_horarios WHERE id = p_id;

  RETURN jsonb_build_object('ok', true);
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_delete_horario(integer) TO authenticated;
