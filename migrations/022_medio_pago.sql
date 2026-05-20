-- 022: Agrega p_nota a RPCs de registro de pagos para etiquetar medio de pago

CREATE OR REPLACE FUNCTION triskel_insert_pago(
  p_alumna_id     integer,
  p_inscripcion_id integer,
  p_mes           text,
  p_monto         numeric,
  p_pagado        boolean DEFAULT true,
  p_fecha_pago    text    DEFAULT NULL,
  p_nota          text    DEFAULT NULL
)
RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  INSERT INTO triskel_pagos(alumna_id, inscripcion_id, mes, monto, pagado, fecha_pago, nota)
  VALUES(p_alumna_id, p_inscripcion_id, p_mes, p_monto, p_pagado,
         CASE WHEN p_pagado THEN COALESCE(p_fecha_pago::date, current_date) ELSE NULL END,
         p_nota)
  ON CONFLICT (alumna_id, inscripcion_id, mes)
  DO UPDATE SET monto=EXCLUDED.monto, pagado=EXCLUDED.pagado,
                fecha_pago=EXCLUDED.fecha_pago, nota=EXCLUDED.nota;
  RETURN jsonb_build_object('ok',true);
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_insert_pago(integer,integer,text,numeric,boolean,text,text) TO authenticated;

CREATE OR REPLACE FUNCTION triskel_insertar_pagos_plan(
  p_alumna_id   integer,
  p_insc_ids    integer[],
  p_mes         text,
  p_monto_total numeric,
  p_pagado      boolean DEFAULT true,
  p_fecha_pago  date    DEFAULT NULL,
  p_nota        text    DEFAULT NULL
)
RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  v_count    integer := array_length(p_insc_ids, 1);
  v_por_insc numeric := CASE WHEN v_count > 0 THEN ROUND(p_monto_total / v_count) ELSE p_monto_total END;
  v_fecha    date    := COALESCE(p_fecha_pago, current_date);
BEGIN
  INSERT INTO triskel_pagos(alumna_id, inscripcion_id, mes, monto, pagado, fecha_pago, nota)
  SELECT p_alumna_id, unnest(p_insc_ids), p_mes, v_por_insc,
         p_pagado, CASE WHEN p_pagado THEN v_fecha ELSE NULL END,
         p_nota
  ON CONFLICT (alumna_id, inscripcion_id, mes)
  DO UPDATE SET monto=EXCLUDED.monto, pagado=EXCLUDED.pagado,
                fecha_pago=EXCLUDED.fecha_pago, nota=EXCLUDED.nota;
  RETURN jsonb_build_object('ok',true);
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_insertar_pagos_plan(integer,integer[],text,numeric,boolean,date,text) TO authenticated;

NOTIFY pgrst, 'reload schema';
