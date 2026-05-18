-- =====================================================
-- Triskel Academy — Payment Day (005)
-- Agrega dia_pago a alumnas y actualiza triskel_save_alumna
-- Ejecutar completo en Supabase → SQL Editor
-- =====================================================

ALTER TABLE triskel_alumnas
ADD COLUMN IF NOT EXISTS dia_pago integer CHECK (dia_pago >= 1 AND dia_pago <= 31);

-- Reemplazar función con nueva firma que incluye dia_pago
DROP FUNCTION IF EXISTS triskel_save_alumna(text,text,text,text,text,text,integer);

CREATE OR REPLACE FUNCTION triskel_save_alumna(
  p_nombre   text,
  p_apellido text    DEFAULT NULL,
  p_tel      text    DEFAULT NULL,
  p_email    text    DEFAULT NULL,
  p_notas    text    DEFAULT NULL,
  p_estado   text    DEFAULT 'activa',
  p_dia_pago integer DEFAULT NULL,
  p_id       integer DEFAULT NULL
)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  IF p_id IS NOT NULL THEN
    UPDATE triskel_alumnas SET
      nombre   = p_nombre,
      apellido = p_apellido,
      tel      = p_tel,
      email    = p_email,
      notas    = p_notas,
      dia_pago = p_dia_pago
    WHERE id = p_id;
  ELSE
    INSERT INTO triskel_alumnas(nombre, apellido, tel, email, notas, estado, dia_pago)
    VALUES(p_nombre, p_apellido, p_tel, p_email, p_notas,
           COALESCE(NULLIF(p_estado,''), 'activa'), p_dia_pago);
  END IF;
END;
$$;

GRANT EXECUTE ON FUNCTION triskel_save_alumna(text,text,text,text,text,text,integer,integer) TO authenticated;
