-- =====================================================
-- Triskel Academy — Fix acceso a tablas
-- Ejecutar en Supabase → SQL Editor
-- =====================================================

-- Deshabilitar RLS en todas las tablas triskel_
-- (panel de uso interno, el acceso lo controla el login de Supabase Auth)
ALTER TABLE triskel_horarios     DISABLE ROW LEVEL SECURITY;
ALTER TABLE triskel_alumnas      DISABLE ROW LEVEL SECURITY;
ALTER TABLE triskel_inscripciones DISABLE ROW LEVEL SECURITY;
ALTER TABLE triskel_clases       DISABLE ROW LEVEL SECURITY;
ALTER TABLE triskel_pagos        DISABLE ROW LEVEL SECURITY;

-- Dar permisos completos al rol authenticated
GRANT ALL ON triskel_horarios      TO authenticated;
GRANT ALL ON triskel_alumnas       TO authenticated;
GRANT ALL ON triskel_inscripciones TO authenticated;
GRANT ALL ON triskel_clases        TO authenticated;
GRANT ALL ON triskel_pagos         TO authenticated;

-- Dar permisos de lectura al rol anon (necesario para el apikey header)
GRANT SELECT ON triskel_horarios      TO anon;
GRANT SELECT ON triskel_alumnas       TO anon;
GRANT SELECT ON triskel_inscripciones TO anon;
GRANT SELECT ON triskel_clases        TO anon;
GRANT SELECT ON triskel_pagos         TO anon;
