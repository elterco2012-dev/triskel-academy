-- 035: Permitir aprobar avisos aunque la alumna no tenga inscripciones activas
-- Antes: bloqueaba con "La alumna no tiene inscripciones activas"
-- Ahora: aprueba el aviso igualmente; simplemente no crea filas en triskel_pagos

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
    -- Intentar actualizar pago existente
    UPDATE triskel_pagos
    SET pagado=true, fecha_pago=current_date, nota=v_av.nota
    WHERE alumna_id=v_av.alumna_id AND mes=v_av.mes AND pagado=false;

    IF NOT FOUND THEN
      SELECT COUNT(*) INTO v_insc_count
      FROM triskel_inscripciones WHERE alumna_id=v_av.alumna_id AND activa=true;

      IF v_insc_count > 0 THEN
        v_por_insc := CASE
          WHEN v_av.monto_declarado IS NOT NULL
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
      -- Si no hay inscripciones, aprobamos el aviso igual (sin crear triskel_pagos)
    END IF;
  END IF;

  RETURN jsonb_build_object('ok',true,'estado',p_accion);
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_resolver_aviso(integer, text) TO authenticated;
