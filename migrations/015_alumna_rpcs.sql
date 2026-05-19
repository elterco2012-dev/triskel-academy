-- 015: RPCs for alumna panel and teacher approval

-- ── ALUMNA: link her Supabase auth account to her alumna record ──────────────
CREATE OR REPLACE FUNCTION triskel_link_mi_cuenta(p_alumna_id integer)
RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_uid uuid := auth.uid();
BEGIN
  IF v_uid IS NULL THEN RETURN jsonb_build_object('ok',false,'msg','not authenticated'); END IF;
  -- Only allow linking if not already linked to a different user
  IF EXISTS(SELECT 1 FROM triskel_alumnas WHERE auth_user_id=v_uid AND id<>p_alumna_id) THEN
    RETURN jsonb_build_object('ok',false,'msg','ya vinculado a otra cuenta');
  END IF;
  UPDATE triskel_alumnas SET auth_user_id=v_uid WHERE id=p_alumna_id AND (auth_user_id IS NULL OR auth_user_id=v_uid);
  IF NOT FOUND THEN RETURN jsonb_build_object('ok',false,'msg','alumna no encontrada o ya vinculada'); END IF;
  RETURN jsonb_build_object('ok',true);
END;
$$;

-- ── ALUMNA: get her own ficha (profile + inscriptions + pagos + avisos) ───────
CREATE OR REPLACE FUNCTION triskel_get_mi_ficha()
RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  v_uid uuid := auth.uid();
  v_alumna_id integer;
  v_result jsonb;
BEGIN
  IF v_uid IS NULL THEN RETURN jsonb_build_object('ok',false,'msg','not authenticated'); END IF;
  SELECT id INTO v_alumna_id FROM triskel_alumnas WHERE auth_user_id=v_uid LIMIT 1;
  IF v_alumna_id IS NULL THEN RETURN jsonb_build_object('ok',false,'msg','alumna no vinculada'); END IF;

  SELECT jsonb_build_object(
    'ok', true,
    'alumna', row_to_json(a),
    'inscripciones', (
      SELECT jsonb_agg(jsonb_build_object(
        'id', i.id,
        'modalidad', i.modalidad,
        'dia', i.dia,
        'horario', i.horario,
        'activa', i.activa,
        'plan_nombre', pl.nombre,
        'precio', i.precio
      ) ORDER BY i.modalidad, i.dia)
      FROM triskel_inscripciones i
      LEFT JOIN triskel_planes pl ON pl.id = i.plan_id
      WHERE i.alumna_id = v_alumna_id AND i.activa = true
    ),
    'pagos', (
      SELECT jsonb_agg(row_to_json(p) ORDER BY p.mes DESC)
      FROM triskel_pagos p
      WHERE p.alumna_id = v_alumna_id
        AND p.mes >= to_char(now() - interval '6 months', 'YYYY-MM')
    ),
    'avisos', (
      SELECT jsonb_agg(row_to_json(av) ORDER BY av.created_at DESC)
      FROM triskel_avisos_pago av
      WHERE av.alumna_id = v_alumna_id
        AND av.mes >= to_char(now() - interval '6 months', 'YYYY-MM')
    )
  ) INTO v_result
  FROM triskel_alumnas a
  WHERE a.id = v_alumna_id;

  RETURN v_result;
END;
$$;

-- ── ALUMNA: save her profile photo URL ───────────────────────────────────────
CREATE OR REPLACE FUNCTION triskel_save_mi_foto(p_foto_url text)
RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_uid uuid := auth.uid();
BEGIN
  IF v_uid IS NULL THEN RETURN jsonb_build_object('ok',false,'msg','not authenticated'); END IF;
  UPDATE triskel_alumnas SET foto=p_foto_url WHERE auth_user_id=v_uid;
  IF NOT FOUND THEN RETURN jsonb_build_object('ok',false,'msg','alumna no encontrada'); END IF;
  RETURN jsonb_build_object('ok',true);
END;
$$;

-- ── ALUMNA: report payment ("Pagué") ─────────────────────────────────────────
CREATE OR REPLACE FUNCTION triskel_crear_aviso_pago(
  p_mes text,
  p_monto_declarado numeric DEFAULT NULL,
  p_nota text DEFAULT NULL
)
RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  v_uid uuid := auth.uid();
  v_alumna_id integer;
  v_aviso_id integer;
BEGIN
  IF v_uid IS NULL THEN RETURN jsonb_build_object('ok',false,'msg','not authenticated'); END IF;
  SELECT id INTO v_alumna_id FROM triskel_alumnas WHERE auth_user_id=v_uid LIMIT 1;
  IF v_alumna_id IS NULL THEN RETURN jsonb_build_object('ok',false,'msg','alumna no vinculada'); END IF;

  INSERT INTO triskel_avisos_pago(alumna_id, mes, monto_declarado, nota, estado)
  VALUES(v_alumna_id, p_mes, p_monto_declarado, p_nota, 'pendiente')
  ON CONFLICT(alumna_id, mes) DO UPDATE
    SET monto_declarado=EXCLUDED.monto_declarado,
        nota=EXCLUDED.nota,
        estado='pendiente',
        updated_at=now()
  RETURNING id INTO v_aviso_id;

  RETURN jsonb_build_object('ok',true,'aviso_id',v_aviso_id,'alumna_id',v_alumna_id);
END;
$$;

-- ── ALUMNA: save push subscription ───────────────────────────────────────────
CREATE OR REPLACE FUNCTION triskel_save_push_subscription(p_subscription jsonb, p_tipo text DEFAULT 'alumna')
RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_uid uuid := auth.uid();
BEGIN
  IF v_uid IS NULL THEN RETURN jsonb_build_object('ok',false,'msg','not authenticated'); END IF;
  INSERT INTO triskel_push_subscriptions(user_id, subscription, tipo, updated_at)
  VALUES(v_uid, p_subscription, p_tipo, now())
  ON CONFLICT(user_id) DO UPDATE
    SET subscription=EXCLUDED.subscription, tipo=EXCLUDED.tipo, updated_at=now();
  RETURN jsonb_build_object('ok',true);
END;
$$;

-- ── TEACHER: get all pending payment notices ──────────────────────────────────
CREATE OR REPLACE FUNCTION triskel_get_avisos_pendientes()
RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  RETURN (
    SELECT jsonb_agg(jsonb_build_object(
      'id', av.id,
      'alumna_id', av.alumna_id,
      'nombre', a.nombre,
      'apellido', a.apellido,
      'tel', a.tel,
      'mes', av.mes,
      'monto_declarado', av.monto_declarado,
      'nota', av.nota,
      'estado', av.estado,
      'created_at', av.created_at
    ) ORDER BY av.created_at DESC)
    FROM triskel_avisos_pago av
    JOIN triskel_alumnas a ON a.id = av.alumna_id
    WHERE av.estado = 'pendiente'
  );
END;
$$;

-- ── TEACHER: resolve a payment notice ────────────────────────────────────────
CREATE OR REPLACE FUNCTION triskel_resolver_aviso(p_id integer, p_accion text)
RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  v_av triskel_avisos_pago;
BEGIN
  SELECT * INTO v_av FROM triskel_avisos_pago WHERE id=p_id;
  IF NOT FOUND THEN RETURN jsonb_build_object('ok',false,'msg','aviso no encontrado'); END IF;

  UPDATE triskel_avisos_pago
  SET estado=p_accion, updated_at=now()
  WHERE id=p_id;

  -- If approved, also mark the corresponding pago as paid
  IF p_accion='aprobado' THEN
    UPDATE triskel_pagos
    SET pagado=true, fecha_pago=current_date
    WHERE alumna_id=v_av.alumna_id AND mes=v_av.mes AND pagado=false;
  END IF;

  RETURN jsonb_build_object('ok',true,'estado',p_accion);
END;
$$;

-- ── TEACHER: get all push subscriptions by type (for sending notifications) ──
CREATE OR REPLACE FUNCTION triskel_get_push_subscriptions(p_tipo text)
RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  RETURN (
    SELECT jsonb_agg(jsonb_build_object(
      'user_id', ps.user_id,
      'subscription', ps.subscription,
      'tipo', ps.tipo
    ))
    FROM triskel_push_subscriptions ps
    WHERE ps.tipo = p_tipo
  );
END;
$$;

-- ── ALUMNA: get alumna_id for current user (helper) ──────────────────────────
CREATE OR REPLACE FUNCTION triskel_get_mi_alumna_id()
RETURNS integer LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_uid uuid := auth.uid(); v_id integer;
BEGIN
  SELECT id INTO v_id FROM triskel_alumnas WHERE auth_user_id=v_uid LIMIT 1;
  RETURN v_id;
END;
$$;
