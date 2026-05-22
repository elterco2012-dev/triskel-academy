-- Migración 027: Corrección de secuencias en planes Claude
-- Ejecutar en Supabase SQL Editor

-- ══════════════════════════════════════════════════════════════════
-- MAT: Avanzado II · Cierre Clásico - Claude
-- Problema: Kneeling Side Kick (pos 27) y Side Bend (pos 28) aparecían
--           DESPUÉS de Rocking (32) y Control Balance (33).
--           Secuencia correcta Return to Life: 27→28→29→30→31→32→33→34
--           También se agrega Crab (31) que faltaba entre Seal y Rocking.
-- ══════════════════════════════════════════════════════════════════
UPDATE triskel_banco_ejercicios
SET ejs = '[
  {"nombre":"Cien · piernas a 5cm del suelo","vt":"100 bombeos · nivel máximo · lumbar pegada en todo momento"},
  {"nombre":"Roll over · piernas al techo y abrir","vt":"5-6 rep · NO pasar de cervicales · abrir en el techo · bajar y volver"},
  {"nombre":"Corkscrew","vt":"4 rep c/lado · círculo completo de piernas · pelvis sube un lado"},
  {"nombre":"Hip circles en Teaser","vt":"4 círculos c/dirección · equilibrar en cóccix · brazos estables"},
  {"nombre":"Kneeling side kick D","vt":"8 rep · de rodillas · una pierna lateral · cadera estable"},
  {"nombre":"Kneeling side kick I","vt":"8 rep · espejo del lado derecho"},
  {"nombre":"Side bend D (plancha lateral)","vt":"5-6 rep · elevar cadera · arco de costado · cuerpo en línea"},
  {"nombre":"Side bend I","vt":"5-6 rep · espejo"},
  {"nombre":"Boomerang","vt":"5 rep · cruzar piernas · roll over → teaser → stretch · todo fluido"},
  {"nombre":"Seal · cerrar clase","vt":"8 rep · aplaudir al rodar · sin forzar · energía suave"},
  {"nombre":"Crab","vt":"4-5 rep · tomar tobillos desde arriba · rodar sobre vértebras · NO pasar de cervicales"},
  {"nombre":"Rocking","vt":"5-6 rep · tomar tobillos · balancear pecho-piernas · extensión total"},
  {"nombre":"Control balance","vt":"4-5 rep · piernas al techo · equilibrar en hombros · NO en cuello"},
  {"nombre":"Push up Pilates","vt":"5-6 rep · plank → bajar 3 tiempos → subir 1 · pies juntos · cuerpo recto"}
]'::jsonb
WHERE titulo = 'Avanzado II · Cierre Clásico - Claude';

-- ══════════════════════════════════════════════════════════════════
-- REFORMER: Intermedio III · Brazos y Core - Claude
-- Problema: Plan terminaba en Short spine sin Running/Semicírculo.
--           En Reformer Running es el cierre obligatorio de la clase.
-- ══════════════════════════════════════════════════════════════════
UPDATE triskel_banco_ejercicios
SET ejs = ejs || '[{"nombre":"Running · semicírculo","vt":"3 res. · running 16 rep · semicírculo 4 rep · cerrar clase"}]'::jsonb
WHERE titulo = 'Intermedio III · Brazos y Core - Claude'
  AND NOT (ejs @> '[{"nombre":"Running · semicírculo"}]'::jsonb);

-- ══════════════════════════════════════════════════════════════════
-- REFORMER: Avanzado III · Control y Equilibrio - Claude
-- Problema: Plan terminaba en Swan avanzado sin Running/Semicírculo.
-- ══════════════════════════════════════════════════════════════════
UPDATE triskel_banco_ejercicios
SET ejs = ejs || '[{"nombre":"Running · semicírculo","vt":"3 res. · running 24 rep · semicírculo 4 rep lento · cerrar"}]'::jsonb
WHERE titulo = 'Avanzado III · Control y Equilibrio - Claude'
  AND NOT (ejs @> '[{"nombre":"Running · semicírculo"}]'::jsonb);
