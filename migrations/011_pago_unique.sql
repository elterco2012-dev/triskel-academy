-- =====================================================
-- Triskel Academy — Unique constraint en pagos (011)
-- Necesario para que ON CONFLICT funcione en triskel_insert_pago
-- Ejecutar completo en Supabase → SQL Editor
-- =====================================================

-- 1. Agregar constraint UNIQUE (por si hay duplicados previos, borrarlos primero)
DELETE FROM triskel_pagos a USING triskel_pagos b
  WHERE a.id > b.id
    AND a.alumna_id = b.alumna_id
    AND a.inscripcion_id = b.inscripcion_id
    AND a.mes = b.mes;

ALTER TABLE triskel_pagos
  DROP CONSTRAINT IF EXISTS uq_pago_insc_mes;

ALTER TABLE triskel_pagos
  ADD CONSTRAINT uq_pago_insc_mes UNIQUE (alumna_id, inscripcion_id, mes);

-- 2. Recrear triskel_insert_pago con ON CONFLICT apuntando al constraint
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
         CASE WHEN COALESCE(p_pagado,true)
              THEN COALESCE(p_fecha_pago, CURRENT_DATE::text)::date
              ELSE NULL END)
  ON CONFLICT ON CONSTRAINT uq_pago_insc_mes
  DO UPDATE SET
    monto      = EXCLUDED.monto,
    pagado     = EXCLUDED.pagado,
    fecha_pago = EXCLUDED.fecha_pago
  RETURNING id INTO v_id;
  RETURN v_id;
END;
$$;

GRANT EXECUTE ON FUNCTION triskel_insert_pago(integer,integer,text,numeric,boolean,text) TO authenticated;
