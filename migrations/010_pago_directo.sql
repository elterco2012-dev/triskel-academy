-- =====================================================
-- Triskel Academy — Pago directo (010)
-- triskel_insert_pago acepta p_pagado y p_fecha_pago
-- para registrar y marcar pagado en un solo paso
-- Ejecutar completo en Supabase → SQL Editor
-- =====================================================

CREATE OR REPLACE FUNCTION triskel_insert_pago(
  p_alumna_id      integer,
  p_inscripcion_id integer,
  p_mes            text,
  p_monto          numeric  DEFAULT 0,
  p_pagado         boolean  DEFAULT true,
  p_fecha_pago     text     DEFAULT NULL
)
RETURNS integer LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_id integer;
BEGIN
  INSERT INTO triskel_pagos(alumna_id, inscripcion_id, mes, monto, pagado, fecha_pago)
  VALUES(p_alumna_id, p_inscripcion_id, p_mes, COALESCE(p_monto,0),
         COALESCE(p_pagado,true),
         CASE WHEN COALESCE(p_pagado,true) THEN COALESCE(p_fecha_pago, CURRENT_DATE::text) ELSE NULL END)
  RETURNING id INTO v_id;
  RETURN v_id;
END;
$$;

GRANT EXECUTE ON FUNCTION triskel_insert_pago(integer,integer,text,numeric,boolean,text) TO authenticated;
