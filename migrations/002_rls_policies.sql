-- =====================================================
-- Triskel Academy — RLS Policies
-- Ejecutar en Supabase SQL Editor
-- =====================================================
-- Habilitar RLS en todas las tablas
ALTER TABLE triskel_horarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE triskel_alumnas ENABLE ROW LEVEL SECURITY;
ALTER TABLE triskel_inscripciones ENABLE ROW LEVEL SECURITY;
ALTER TABLE triskel_clases ENABLE ROW LEVEL SECURITY;
ALTER TABLE triskel_pagos ENABLE ROW LEVEL SECURITY;

-- Eliminar políticas existentes para evitar conflictos
DROP POLICY IF EXISTS "auth_all" ON triskel_horarios;
DROP POLICY IF EXISTS "auth_all" ON triskel_alumnas;
DROP POLICY IF EXISTS "auth_all" ON triskel_inscripciones;
DROP POLICY IF EXISTS "auth_all" ON triskel_clases;
DROP POLICY IF EXISTS "auth_all" ON triskel_pagos;
DROP POLICY IF EXISTS "allow_authenticated" ON triskel_horarios;
DROP POLICY IF EXISTS "allow_authenticated" ON triskel_alumnas;
DROP POLICY IF EXISTS "allow_authenticated" ON triskel_inscripciones;
DROP POLICY IF EXISTS "allow_authenticated" ON triskel_clases;
DROP POLICY IF EXISTS "allow_authenticated" ON triskel_pagos;

-- Permitir todo para usuarios autenticados
CREATE POLICY "auth_all" ON triskel_horarios FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "auth_all" ON triskel_alumnas FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "auth_all" ON triskel_inscripciones FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "auth_all" ON triskel_clases FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "auth_all" ON triskel_pagos FOR ALL TO authenticated USING (true) WITH CHECK (true);
