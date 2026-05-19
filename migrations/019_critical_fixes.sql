-- 019: Critical security and data integrity fixes

-- ── 1. RLS: Reemplazar políticas permisivas por políticas restrictivas ─────────
ALTER TABLE triskel_alumnas ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "auth_full" ON triskel_alumnas;
CREATE POLICY "alumna_select_own" ON triskel_alumnas
  FOR SELECT TO authenticated
  USING (auth_user_id = auth.uid());

ALTER TABLE triskel_inscripciones ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "auth_full" ON triskel_inscripciones;
CREATE POLICY "alumna_select_own" ON triskel_inscripciones
  FOR SELECT TO authenticated
  USING (alumna_id IN (
    SELECT id FROM triskel_alumnas WHERE auth_user_id = auth.uid()
  ));

ALTER TABLE triskel_pagos ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "auth_full" ON triskel_pagos;
CREATE POLICY "alumna_select_own" ON triskel_pagos
  FOR SELECT TO authenticated
  USING (alumna_id IN (
    SELECT id FROM triskel_alumnas WHERE auth_user_id = auth.uid()
  ));

ALTER TABLE triskel_avisos_pago ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "auth_full" ON triskel_avisos_pago;
CREATE POLICY "alumna_select_own" ON triskel_avisos_pago
  FOR SELECT TO authenticated
  USING (alumna_id IN (
    SELECT id FROM triskel_alumnas WHERE auth_user_id = auth.uid()
  ));

ALTER TABLE triskel_push_subscriptions ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "auth_full" ON triskel_push_subscriptions;
CREATE POLICY "own_subscription" ON triskel_push_subscriptions
  FOR ALL TO authenticated
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

ALTER TABLE triskel_horarios ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "auth_full" ON triskel_horarios;

ALTER TABLE triskel_clases ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "auth_full" ON triskel_clases;

ALTER TABLE triskel_espera ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "auth_full" ON triskel_espera;

ALTER TABLE triskel_observaciones ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "auth_full" ON triskel_observaciones;

REVOKE SELECT ON triskel_alumnas       FROM anon;
REVOKE SELECT ON triskel_pagos         FROM anon;
REVOKE SELECT ON triskel_inscripciones FROM anon;
REVOKE SELECT ON triskel_clases        FROM anon;
REVOKE SELECT ON triskel_espera        FROM anon;
REVOKE SELECT ON triskel_observaciones FROM anon;

-- ── 2. Fix triskel_resolver_aviso ─────────────────────────────────────────────
CREATE OR REPLACE FUNCTION triskel_resolver_aviso(p_id integer, p_accion text)
RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  v_av         triskel_avisos_pago;
  v_insc_count integer;
  v_por_insc   numeric;
BEGIN
  IF p_accion NOT IN ('aprobado','rechazado') THEN
    RETURN jsonb_build_object('ok',false,'msg','accion invalida');
  END IF;
  SELECT * INTO v_av FROM triskel_avisos_pago WHERE id=p_id AND estado='pendiente';
  IF NOT FOUND THEN
    RETURN jsonb_build_object('ok',false,'msg','aviso no encontrado o ya resuelto');
  END IF;
  UPDATE triskel_avisos_pago SET estado=p_accion, updated_at=now() WHERE id=p_id;
  IF p_accion='aprobado' THEN
    UPDATE triskel_pagos
    SET pagado=true, fecha_pago=current_date, nota=v_av.nota
    WHERE alumna_id=v_av.alumna_id AND mes=v_av.mes AND pagado=false;
    IF NOT FOUND THEN
      SELECT COUNT(*) INTO v_insc_count
      FROM triskel_inscripciones WHERE alumna_id=v_av.alumna_id AND activa=true;
      v_por_insc := CASE
        WHEN v_insc_count > 0 AND v_av.monto_declarado IS NOT NULL
        THEN ROUND(v_av.monto_declarado / v_insc_count)
        ELSE NULL
      END;
      INSERT INTO triskel_pagos(alumna_id, inscripcion_id, mes, monto, pagado, fecha_pago, nota)
      SELECT v_av.alumna_id, i.id, v_av.mes,
             COALESCE(v_por_insc, i.precio), true, current_date, v_av.nota
      FROM triskel_inscripciones i
      WHERE i.alumna_id=v_av.alumna_id AND i.activa=true
      ON CONFLICT DO NOTHING;
    END IF;
  END IF;
  RETURN jsonb_build_object('ok',true,'estado',p_accion);
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_resolver_aviso(integer, text) TO authenticated;

-- ── 3. Fix triskel_save_mi_foto ───────────────────────────────────────────────
CREATE OR REPLACE FUNCTION triskel_save_mi_foto(p_foto_url text)
RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_uid uuid := auth.uid();
BEGIN
  IF v_uid IS NULL THEN RETURN jsonb_build_object('ok',false,'msg','not authenticated'); END IF;
  UPDATE triskel_alumnas SET foto_url=p_foto_url WHERE auth_user_id=v_uid;
  IF NOT FOUND THEN RETURN jsonb_build_object('ok',false,'msg','alumna no encontrada'); END IF;
  RETURN jsonb_build_object('ok',true);
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_save_mi_foto(text) TO authenticated;

-- ── 4. Fix triskel_get_mi_ficha ───────────────────────────────────────────────
CREATE OR REPLACE FUNCTION triskel_get_mi_ficha()
RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  v_uid       uuid := auth.uid();
  v_alumna_id integer;
  v_result    jsonb;
BEGIN
  IF v_uid IS NULL THEN RETURN jsonb_build_object('ok',false,'msg','not authenticated'); END IF;
  SELECT id INTO v_alumna_id FROM triskel_alumnas WHERE auth_user_id=v_uid LIMIT 1;
  IF v_alumna_id IS NULL THEN RETURN jsonb_build_object('ok',false,'msg','alumna no vinculada'); END IF;
  SELECT jsonb_build_object(
    'ok', true,
    'alumna', row_to_json(a),
    'inscripciones', (
      SELECT jsonb_agg(jsonb_build_object(
        'id',i.id,'horario_id',i.horario_id,
        'modalidad',h.modalidad,'dia',h.dia,
        'horario',h.hora_inicio||'–'||h.hora_fin,
        'activa',COALESCE(i.activa,true),'precio',i.precio
      ) ORDER BY h.modalidad, h.dia)
      FROM triskel_inscripciones i
      JOIN triskel_horarios h ON h.id=i.horario_id
      WHERE i.alumna_id=v_alumna_id
    ),
    'pagos', (
      SELECT jsonb_agg(row_to_json(p) ORDER BY p.mes DESC)
      FROM triskel_pagos p
      WHERE p.alumna_id=v_alumna_id
        AND p.mes>=to_char(now()-interval '6 months','YYYY-MM')
    ),
    'avisos', (
      SELECT jsonb_agg(row_to_json(av) ORDER BY av.created_at DESC)
      FROM triskel_avisos_pago av
      WHERE av.alumna_id=v_alumna_id
        AND av.mes>=to_char(now()-interval '6 months','YYYY-MM')
    )
  ) INTO v_result
  FROM triskel_alumnas a WHERE a.id=v_alumna_id;
  RETURN v_result;
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_get_mi_ficha() TO authenticated;

-- ── 5. RPCs atómicas para pagos de plan multi-día ─────────────────────────────
CREATE OR REPLACE FUNCTION triskel_marcar_pagos_ids(
  p_ids        integer[],
  p_pagado     boolean,
  p_fecha_pago date DEFAULT NULL
)
RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  UPDATE triskel_pagos
  SET pagado     = p_pagado,
      fecha_pago = CASE WHEN p_pagado THEN COALESCE(p_fecha_pago, current_date) ELSE NULL END,
      updated_at = now()
  WHERE id = ANY(p_ids);
  RETURN jsonb_build_object('ok',true,'updated',array_length(p_ids,1));
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_marcar_pagos_ids(integer[], boolean, date) TO authenticated;

CREATE OR REPLACE FUNCTION triskel_insertar_pagos_plan(
  p_alumna_id   integer,
  p_insc_ids    integer[],
  p_mes         text,
  p_monto_total numeric,
  p_pagado      boolean DEFAULT true,
  p_fecha_pago  date    DEFAULT NULL
)
RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  v_count    integer := array_length(p_insc_ids, 1);
  v_por_insc numeric := CASE WHEN v_count > 0 THEN ROUND(p_monto_total / v_count) ELSE p_monto_total END;
  v_fecha    date    := COALESCE(p_fecha_pago, current_date);
BEGIN
  INSERT INTO triskel_pagos(alumna_id, inscripcion_id, mes, monto, pagado, fecha_pago)
  SELECT p_alumna_id, unnest(p_insc_ids), p_mes, v_por_insc,
         p_pagado, CASE WHEN p_pagado THEN v_fecha ELSE NULL END
  ON CONFLICT (alumna_id, inscripcion_id, mes)
  DO UPDATE SET monto=EXCLUDED.monto, pagado=EXCLUDED.pagado,
                fecha_pago=EXCLUDED.fecha_pago, updated_at=now();
  RETURN jsonb_build_object('ok',true);
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_insertar_pagos_plan(integer, integer[], text, numeric, boolean, date) TO authenticated;

-- ── 6. Corregir sintaxis cron de migration 018 ────────────────────────────────
DO $$ BEGIN
  PERFORM cron.unschedule('triskel-payment-reminders');
EXCEPTION WHEN OTHERS THEN NULL;
END $$;

SELECT cron.schedule(
  'triskel-payment-reminders',
  '0 12 * * *',
  'SELECT triskel_send_payment_reminders()'
);

-- ── 7. Índices de performance ─────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_pagos_alumna_mes      ON triskel_pagos(alumna_id, mes);
CREATE INDEX IF NOT EXISTS idx_pagos_mes_pagado      ON triskel_pagos(mes, pagado);
CREATE INDEX IF NOT EXISTS idx_clases_horario_fecha  ON triskel_clases(horario_id, fecha);
CREATE INDEX IF NOT EXISTS idx_inscripciones_horario ON triskel_inscripciones(horario_id);
CREATE INDEX IF NOT EXISTS idx_inscripciones_alumna  ON triskel_inscripciones(alumna_id);
CREATE INDEX IF NOT EXISTS idx_avisos_alumna_mes     ON triskel_avisos_pago(alumna_id, mes);
CREATE INDEX IF NOT EXISTS idx_alumnas_auth_user     ON triskel_alumnas(auth_user_id);

NOTIFY pgrst, 'reload schema';
