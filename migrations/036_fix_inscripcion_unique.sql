-- 036: Recrear uq_inscripcion_alumna_horario como NOT DEFERRABLE
-- ON CONFLICT no soporta constraints DEFERRABLE como árbitro de conflicto.

ALTER TABLE triskel_inscripciones
  DROP CONSTRAINT IF EXISTS uq_inscripcion_alumna_horario;

ALTER TABLE triskel_inscripciones
  ADD CONSTRAINT uq_inscripcion_alumna_horario
    UNIQUE (alumna_id, horario_id);
