-- =====================================================
-- Triskel Academy — Fix definitivo de acceso (003)
-- Ejecutar completo en Supabase → SQL Editor
-- =====================================================

-- 1. Eliminar TODAS las políticas existentes de triskel_
DO $$
DECLARE r record;
BEGIN
  FOR r IN SELECT policyname, tablename FROM pg_policies
    WHERE tablename LIKE 'triskel_%'
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I', r.policyname, r.tablename);
  END LOOP;
END $$;

-- 2. Re-habilitar RLS (Supabase v2 requiere RLS para exponer tablas via REST)
ALTER TABLE triskel_horarios      ENABLE ROW LEVEL SECURITY;
ALTER TABLE triskel_alumnas       ENABLE ROW LEVEL SECURITY;
ALTER TABLE triskel_inscripciones ENABLE ROW LEVEL SECURITY;
ALTER TABLE triskel_clases        ENABLE ROW LEVEL SECURITY;
ALTER TABLE triskel_pagos         ENABLE ROW LEVEL SECURITY;

-- 3. Crear políticas permisivas para authenticated
CREATE POLICY "auth_full" ON triskel_horarios      FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "auth_full" ON triskel_alumnas       FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "auth_full" ON triskel_inscripciones FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "auth_full" ON triskel_clases        FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "auth_full" ON triskel_pagos         FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- 4. Asegurar grants a nivel schema y tabla
GRANT USAGE ON SCHEMA public TO authenticated, anon;
GRANT ALL ON triskel_horarios      TO authenticated;
GRANT ALL ON triskel_alumnas       TO authenticated;
GRANT ALL ON triskel_inscripciones TO authenticated;
GRANT ALL ON triskel_clases        TO authenticated;
GRANT ALL ON triskel_pagos         TO authenticated;
GRANT SELECT ON triskel_horarios      TO anon;
GRANT SELECT ON triskel_alumnas       TO anon;
GRANT SELECT ON triskel_inscripciones TO anon;
GRANT SELECT ON triskel_clases        TO anon;
GRANT SELECT ON triskel_pagos         TO anon;

-- 5. Función de diagnóstico para verificar acceso
CREATE OR REPLACE FUNCTION triskel_ping()
RETURNS text LANGUAGE sql SECURITY DEFINER AS $$
  SELECT 'ok: ' || count(*)::text || ' horarios encontrados' FROM triskel_horarios;
$$;
GRANT EXECUTE ON FUNCTION triskel_ping() TO anon, authenticated;

-- 6. Reload schema cache
NOTIFY pgrst, 'reload schema';
