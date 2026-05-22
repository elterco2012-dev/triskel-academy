-- Migración 030: Proteger historial contra borrado accidental de horarios
-- Ejecutar en Supabase SQL Editor
--
-- PROBLEMA: Borrar un horario disparaba CASCADE sobre triskel_clases,
-- triskel_inscripciones y (por cascada adicional) triskel_pagos. Un
-- click en el panel de Supabase podía destruir meses de historial
-- financiero de forma irrecuperable.
--
-- SOLUCIÓN: Cambiar ON DELETE CASCADE → ON DELETE RESTRICT en las FK
-- de las tablas que guardan datos valiosos. La base de datos bloquea el
-- borrado si hay datos dependientes y obliga a limpiar primero.
--
-- triskel_lista_espera se deja en CASCADE: son entradas transitorias
-- sin valor histórico, es correcto que se limpien solas.

-- ── triskel_clases (historial de clases y ejercicios) ────────────────
DO $$
DECLARE v TEXT;
BEGIN
  SELECT constraint_name INTO v
  FROM information_schema.table_constraints tc
  JOIN information_schema.key_column_usage kcu
    USING (constraint_name, table_schema, table_name)
  WHERE tc.table_name = 'triskel_clases'
    AND kcu.column_name = 'horario_id'
    AND tc.constraint_type = 'FOREIGN KEY';
  IF v IS NOT NULL THEN
    EXECUTE 'ALTER TABLE triskel_clases DROP CONSTRAINT ' || quote_ident(v);
  END IF;
END$$;

ALTER TABLE triskel_clases
  ADD CONSTRAINT triskel_clases_horario_id_fkey
  FOREIGN KEY (horario_id) REFERENCES triskel_horarios(id)
  ON DELETE RESTRICT;

-- ── triskel_inscripciones (inscripciones → arrastra pagos) ───────────
DO $$
DECLARE v TEXT;
BEGIN
  SELECT constraint_name INTO v
  FROM information_schema.table_constraints tc
  JOIN information_schema.key_column_usage kcu
    USING (constraint_name, table_schema, table_name)
  WHERE tc.table_name = 'triskel_inscripciones'
    AND kcu.column_name = 'horario_id'
    AND tc.constraint_type = 'FOREIGN KEY';
  IF v IS NOT NULL THEN
    EXECUTE 'ALTER TABLE triskel_inscripciones DROP CONSTRAINT ' || quote_ident(v);
  END IF;
END$$;

ALTER TABLE triskel_inscripciones
  ADD CONSTRAINT triskel_inscripciones_horario_id_fkey
  FOREIGN KEY (horario_id) REFERENCES triskel_horarios(id)
  ON DELETE RESTRICT;

-- ── Resultado esperado ────────────────────────────────────────────────
-- Intentar borrar un horario con clases o inscripciones devolverá:
--   ERROR: update or delete on table "triskel_horarios" violates
--   foreign key constraint ... on table "triskel_clases"
-- Para borrar un horario primero hay que:
--   1. Desinscribir todas las alumnas del horario
--   2. Borrar o reasignar todas las clases del horario
-- Esto es el comportamiento correcto: el borrado requiere intención explícita.
