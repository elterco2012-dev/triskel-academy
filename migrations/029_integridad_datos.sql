-- Migración 029: Integridad de datos — constraints y correcciones
-- Ejecutar en Supabase SQL Editor
--
-- CONTEXTO: Auditoría de integridad detectó campos TEXT sin validación,
-- monto nullable que silencia errores en sumas, y UNIQUE de inscripciones
-- existente solo en RPC. Esta migración agrega restricciones que protegen
-- la base de datos de datos inconsistentes sin romper nada existente.
--
-- Se usa NOT VALID en todos los CHECK nuevos para no validar filas
-- históricas (safe para producción). Ejecutar VALIDATE luego si se desea
-- aplicar a datos históricos también.

-- ── 1. triskel_alumnas.estado ─────────────────────────────────────────
ALTER TABLE triskel_alumnas
  ADD CONSTRAINT chk_alumna_estado
    CHECK (estado IN ('activa', 'inactiva', 'pausada'))
    NOT VALID;

-- ── 2. triskel_horarios.modalidad ────────────────────────────────────
ALTER TABLE triskel_horarios
  ADD CONSTRAINT chk_horario_modalidad
    CHECK (modalidad IN ('mat', 'reformer', 'funcional'))
    NOT VALID;

-- ── 3. triskel_horarios.dia ───────────────────────────────────────────
ALTER TABLE triskel_horarios
  ADD CONSTRAINT chk_horario_dia
    CHECK (dia IN ('lun', 'mar', 'mie', 'jue', 'vie', 'sab', 'dom',
                   'lunes', 'martes', 'miercoles', 'jueves', 'viernes', 'sabado', 'domingo'))
    NOT VALID;

-- ── 4. triskel_pagos.mes — formato YYYY-MM ────────────────────────────
ALTER TABLE triskel_pagos
  ADD CONSTRAINT chk_pago_mes_formato
    CHECK (mes ~ '^\d{4}-(0[1-9]|1[0-2])$')
    NOT VALID;

-- ── 5. triskel_pagos.monto — eliminar NULLs y poner DEFAULT ──────────
-- Actualizar registros existentes con monto NULL a 0
UPDATE triskel_pagos SET monto = 0 WHERE monto IS NULL;

-- Ahora se puede agregar DEFAULT (no hace NOT NULL para no romper RPCs antiguas)
ALTER TABLE triskel_pagos
  ALTER COLUMN monto SET DEFAULT 0;

-- ── 6. triskel_banco_ejercicios.categoria ────────────────────────────
ALTER TABLE triskel_banco_ejercicios
  ADD CONSTRAINT chk_banco_categoria
    CHECK (categoria IN ('mat', 'reformer', 'funcional'))
    NOT VALID;

-- ── 7. triskel_avisos_pago.estado ────────────────────────────────────
ALTER TABLE triskel_avisos_pago
  ADD CONSTRAINT chk_aviso_estado
    CHECK (estado IN ('pendiente', 'aprobado', 'rechazado'))
    NOT VALID;

-- ── 8. UNIQUE formal en triskel_inscripciones ─────────────────────────
-- Actualmente solo se garantiza por ON CONFLICT en el RPC.
-- Se agrega como constraint de DB para proteger escritura directa.
ALTER TABLE triskel_inscripciones
  ADD CONSTRAINT uq_inscripcion_alumna_horario
    UNIQUE (alumna_id, horario_id)
    DEFERRABLE INITIALLY DEFERRED;
-- DEFERRABLE: permite upserts dentro de una transacción sin violar el constraint al vuelo.

-- ── 9. Eliminar columna muerta plan_id (si existe) ────────────────────
-- plan_id referencia a triskel_planes que nunca fue creada.
-- Solo se elimina si existe y no tiene datos (LEFT JOIN retorna NULL = sin impacto).
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'triskel_inscripciones' AND column_name = 'plan_id'
  ) THEN
    -- Verificar que no haya datos reales en la columna antes de borrar
    IF NOT EXISTS (SELECT 1 FROM triskel_inscripciones WHERE plan_id IS NOT NULL) THEN
      ALTER TABLE triskel_inscripciones DROP COLUMN plan_id;
      RAISE NOTICE 'Columna plan_id eliminada (estaba vacía).';
    ELSE
      RAISE NOTICE 'plan_id tiene datos — NO se eliminó. Revisar manualmente.';
    END IF;
  ELSE
    RAISE NOTICE 'Columna plan_id no existe, nada que hacer.';
  END IF;
END$$;

-- ── NOTA SOBRE CASCADE EN HORARIOS ────────────────────────────────────
-- RIESGO IDENTIFICADO (no se corrige aquí — requiere decisión de negocio):
-- Borrar un triskel_horarios dispara CASCADE sobre:
--   → triskel_clases (historial de clases)
--   → triskel_inscripciones → triskel_pagos (registros de cobro)
-- RECOMENDACIÓN: antes de borrar un horario, verificar en la app que no
-- tenga clases o pagos asociados y pedir confirmación explícita.

-- ── NOTA SOBRE AUSENCIAS VS ASISTENCIA ───────────────────────────────
-- triskel_ausencias: alumna reporta que no va (self-reported)
-- triskel_asistencia: Amira marca quiénes vinieron (attendance)
-- Los dos sistemas son independientes y pueden ser contradictorios.
-- No hay FK ni lógica de reconciliación entre ellos.
-- RECOMENDACIÓN: mostrar en la ficha de alumna ambas fuentes con etiqueta.
