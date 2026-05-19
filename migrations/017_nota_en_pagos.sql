-- 017: Store nota from aviso in triskel_pagos

ALTER TABLE triskel_pagos ADD COLUMN IF NOT EXISTS nota text;

-- Update resolver to copy nota from aviso when approving
CREATE OR REPLACE FUNCTION triskel_resolver_aviso(p_id integer, p_accion text)
RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  v_av triskel_avisos_pago;
BEGIN
  SELECT * INTO v_av FROM triskel_avisos_pago WHERE id=p_id;
  IF NOT FOUND THEN RETURN jsonb_build_object('ok',false,'msg','aviso no encontrado'); END IF;

  UPDATE triskel_avisos_pago SET estado=p_accion, updated_at=now() WHERE id=p_id;

  IF p_accion='aprobado' THEN
    UPDATE triskel_pagos
    SET pagado=true, fecha_pago=current_date, nota=v_av.nota
    WHERE alumna_id=v_av.alumna_id AND mes=v_av.mes AND pagado=false;

    IF NOT FOUND THEN
      INSERT INTO triskel_pagos(alumna_id, inscripcion_id, mes, monto, pagado, fecha_pago, nota)
      SELECT v_av.alumna_id, i.id, v_av.mes,
             COALESCE(v_av.monto_declarado, i.precio), true, current_date, v_av.nota
      FROM triskel_inscripciones i
      WHERE i.alumna_id=v_av.alumna_id AND i.activa=true
      LIMIT 1
      ON CONFLICT DO NOTHING;
    END IF;
  END IF;

  RETURN jsonb_build_object('ok',true,'estado',p_accion);
END;
$$;

GRANT EXECUTE ON FUNCTION triskel_resolver_aviso(integer, text) TO authenticated;
NOTIFY pgrst, 'reload schema';
