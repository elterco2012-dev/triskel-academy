-- 024: Marcar planes creados por Claude + agregar nuevas planificaciones
-- Run in Supabase SQL Editor

-- ── 1. Marcar planes creados por Claude con " - Claude" ─────────────────────
-- Estos planes fueron agregados por el asistente Claude (no estaban en el Excel original de Amira)

UPDATE triskel_banco_ejercicios
SET titulo = titulo || ' - Claude'
WHERE titulo IN (
  -- Mat (agregados en commits 16973af y 56d99a9)
  'Core Intensivo',
  'Cadera y Movilidad',
  'Básico III · Suelo Pélvico',
  'Movilidad y Elongación',
  'Embarazo / Postparto',
  'Básico IV · Columna',
  -- Funcional
  'HIIT Avanzado',
  'Movilidad y Cooldown',
  'Full Body Express',
  'Glúteos y Piernas II',
  'Tren Superior II',
  'Core Profundo',
  -- Reformer
  'Express 30 min',
  'Cadera y Suelo Pélvico',
  'Intermedio III · Brazos y Core',
  'Avanzado III · Control y Equilibrio',
  'Embarazo / Postparto Reformer'
)
AND titulo NOT LIKE '% - Claude';

-- ── 2. Nuevas planificaciones Mat ────────────────────────────────────────────
-- Solo insertar si no existen (idempotente)

-- Mat: Postura y Alineación (énfasis en impronta, neutro, elongación vertebral)
INSERT INTO triskel_banco_ejercicios(categoria, titulo, ejs, orden)
SELECT 'mat', 'Postura y Alineación - Claude', '[
  {"nombre":"Imprinting lumbar","vt":"8 rep · sentir columna en neutro e impronta"},
  {"nombre":"Pelvis en neutro · respiración diafragmática","vt":"8 respiraciones · mano en costillas"},
  {"nombre":"Puente de hombros lento","vt":"8 rep · articular vértebra a vértebra · 4 tiempos subir"},
  {"nombre":"Cuadrupedia gato/vaca","vt":"8 rep · exhalar en gato · inhalar en vaca"},
  {"nombre":"Cuadrupedia extensión alternada","vt":"8 rep c/lado · cadera neutra · columna larga"},
  {"nombre":"Sphinx hold","vt":"30 seg · antebrazos en suelo · pecho abierto"},
  {"nombre":"Swan básico","vt":"6 rep · extensión torácica · codos pegados"},
  {"nombre":"Spine stretch forward","vt":"6 rep · exhalar profundo al elongar"},
  {"nombre":"Spine twist","vt":"5 rep c/lado · sentada · rotar desde el torso"},
  {"nombre":"Mermaid stretch","vt":"5 rep c/lado · elongar costado"},
  {"nombre":"Stomage básico","vt":"8 rep · manos bajo la frente"},
  {"nombre":"Child pose","vt":"40 seg · rodillas separadas · respirar profundo"}
]'::jsonb, 100
WHERE NOT EXISTS (SELECT 1 FROM triskel_banco_ejercicios WHERE titulo='Postura y Alineación - Claude');

-- Mat: Apertura de Cadera (movilidad articular y elongación)
INSERT INTO triskel_banco_ejercicios(categoria, titulo, ejs, orden)
SELECT 'mat', 'Apertura de Cadera - Claude', '[
  {"nombre":"Puente de hombros","vt":"8 rep · sostener 2 seg arriba"},
  {"nombre":"Clam","vt":"10 rep c/lado · con banda · rango sin compensar pelvis"},
  {"nombre":"Leg circles","vt":"5 círculos c/dirección · pelvis estable"},
  {"nombre":"Idem · pierna contraria","vt":""},
  {"nombre":"Donkey kicks","vt":"12 rep c/lado · cadera neutra · sin rotar"},
  {"nombre":"Fire hydrant","vt":"12 rep c/lado · no rotar el tronco"},
  {"nombre":"Pierna cruzada · estiramiento de glúteo","vt":"40 seg c/lado · respirar"},
  {"nombre":"De lateral · elevación de pierna","vt":"10 rep c/lado"},
  {"nombre":"De lateral · círculos","vt":"5 círculos c/dirección · pierna activa"},
  {"nombre":"Banana stretch","vt":"30 seg c/lado · elongar desde costilla a cadera"},
  {"nombre":"Hip rolls","vt":"8 rep c/lado · sin levantar hombros"},
  {"nombre":"Rolling like a ball","vt":"6-8 rep · liberar tensión lumbar"}
]'::jsonb, 101
WHERE NOT EXISTS (SELECT 1 FROM triskel_banco_ejercicios WHERE titulo='Apertura de Cadera - Claude');

-- Mat: Bajo Impacto / Recuperación (para días de baja energía o dolencias)
INSERT INTO triskel_banco_ejercicios(categoria, titulo, ejs, orden)
SELECT 'mat', 'Bajo Impacto y Recuperación - Claude', '[
  {"nombre":"Respiración diafragmática con suelo pélvico","vt":"8 rep · inhalar · exhalar y apretar suave"},
  {"nombre":"Imprinting lumbar","vt":"8 rep · sin esfuerzo · sentir la columna"},
  {"nombre":"Puente básico suave","vt":"6 rep · sin tensión · sostener 2 seg"},
  {"nombre":"Curl up · variación lenta","vt":"8 rep · 4 tiempos subir · 4 bajar"},
  {"nombre":"Single leg stretch · cabeza apoyada","vt":"8 rep c/lado · solo las piernas"},
  {"nombre":"Clam muy suave","vt":"8 rep c/lado · sin banda · rango cómodo"},
  {"nombre":"Cuadrupedia gato/vaca","vt":"8 rep · exhalar en gato · inhalar en vaca"},
  {"nombre":"Child pose","vt":"40 seg · rodillas separadas · respirar profundo"},
  {"nombre":"Spine stretch sentada","vt":"5 rep · elongar sin forzar"},
  {"nombre":"Mermaid stretch suave","vt":"4 rep c/lado · nunca forzar"},
  {"nombre":"Stomage básico","vt":"6 rep · solo cabeza y pecho · manos bajo la frente"},
  {"nombre":"Balanceo del niño","vt":"30 seg · estiramiento lumbar · respirar profundo"}
]'::jsonb, 102
WHERE NOT EXISTS (SELECT 1 FROM triskel_banco_ejercicios WHERE titulo='Bajo Impacto y Recuperación - Claude');

-- Mat: Glúteos y Piernas (foco específico en tren inferior)
INSERT INTO triskel_banco_ejercicios(categoria, titulo, ejs, orden)
SELECT 'mat', 'Glúteos y Piernas - Claude', '[
  {"nombre":"Puente de hombros","vt":"10 rep · apretar glúteo al subir · sostener 2 seg"},
  {"nombre":"Puente a una pierna","vt":"8 rep c/lado · sin bajar la cadera"},
  {"nombre":"Puente marcha","vt":"10 rep c/lado · alternar piernas en el aire"},
  {"nombre":"Clam","vt":"12 rep c/lado · con banda en muslos"},
  {"nombre":"Fire hydrant","vt":"12 rep c/lado · en cuadrupedia · cadera quieta"},
  {"nombre":"Donkey kicks","vt":"12 rep c/lado · extender pierna · luego círculos 5 c/dir"},
  {"nombre":"Inner thigh lift","vt":"12 rep c/lado · de lado · pierna inferior sube"},
  {"nombre":"De lateral · serie completa","vt":"10 rep c/ejercicio · elevación, círculos, patada"},
  {"nombre":"Idem · cambia de lado","vt":""},
  {"nombre":"Leg circles","vt":"5 círculos c/dirección c/pierna"},
  {"nombre":"Swimming","vt":"20-30 alternados · control del tronco"},
  {"nombre":"Shoulder bridge avanzado","vt":"6 rep c/lado · pierna extendida arriba · bajar lento"}
]'::jsonb, 103
WHERE NOT EXISTS (SELECT 1 FROM triskel_banco_ejercicios WHERE titulo='Glúteos y Piernas - Claude');

-- ── 3. Nuevas planificaciones Reformer ──────────────────────────────────────

-- Reformer: Básico Completo (introducción a todas las series)
INSERT INTO triskel_banco_ejercicios(categoria, titulo, ejs, orden)
SELECT 'reformer', 'Básico Completo - Claude', '[
  {"nombre":"Footwork punta y flex","vt":"3 res. · 8 rep cada uno · talones, arco, punta"},
  {"nombre":"Footwork talones","vt":"2 res. · luego Running"},
  {"nombre":"Cien","vt":"1 res. · piernas a 45° · 100 bombeos"},
  {"nombre":"Frog","vt":"2 res. · rango cómodo · pelvis neutra"},
  {"nombre":"Leg circles en frog","vt":"2 res. · 4 c/dirección · abrir controlado"},
  {"nombre":"Coordinación","vt":"1 res. · exhalar al extender piernas"},
  {"nombre":"Hug a tree","vt":"1 res. · mantener altura de hombros · arcos lentos"},
  {"nombre":"Press de pecho acostada","vt":"2 res. · correas · empujar al techo"},
  {"nombre":"Caja corta redondo","vt":"carro quieto · 1 res. · 6 rep · curva C"},
  {"nombre":"Swan básico","vt":"2 res. · manos en barra · codos pegados"},
  {"nombre":"Knee stretch redondo","vt":"2 res. · columna en C · sin llegar al tope"},
  {"nombre":"Running","vt":"2 res. · talones alternados · carro quieto al final"}
]'::jsonb, 100
WHERE NOT EXISTS (SELECT 1 FROM triskel_banco_ejercicios WHERE titulo='Básico Completo - Claude');

-- Reformer: Tren Superior enfocado (brazos, espalda, hombros)
INSERT INTO triskel_banco_ejercicios(categoria, titulo, ejs, orden)
SELECT 'reformer', 'Tren Superior - Claude', '[
  {"nombre":"Footwork punta y flex","vt":"2 res. · calentamiento"},
  {"nombre":"Remo desde el pecho palmas arriba","vt":"1 res. · codos pegados · extender y cerrar"},
  {"nombre":"Remo desde la cadera","vt":"1 res. · elongar columna al extender"},
  {"nombre":"Rowing zip up","vt":"1 res. · codos al techo · escápulas"},
  {"nombre":"Rowing shave the head","vt":"1 res. · codos atrás · apertura torácica"},
  {"nombre":"Hug a tree","vt":"1 res. · mantener altura hombros · arcos lentos"},
  {"nombre":"Chest expansion de pie","vt":"1 res. · correas atrás · apertura de pecho"},
  {"nombre":"Bíceps con correas sentada","vt":"1 res. · codos fijos · luego de pie"},
  {"nombre":"Tríceps con correas","vt":"1 res. · codo fijo · extender sin mover hombro"},
  {"nombre":"Pulling straps","vt":"2-3 res. · extensión de dorsal · boca abajo en caja"},
  {"nombre":"T-press","vt":"2 res. · brazos en T · escápulas juntas"},
  {"nombre":"Svelte arm series","vt":"1 res. · 4 movimientos enlazados · fluido"}
]'::jsonb, 101
WHERE NOT EXISTS (SELECT 1 FROM triskel_banco_ejercicios WHERE titulo='Tren Superior - Claude');

-- Reformer: Hip & Legs Focus (cadera, piernas, glúteos)
INSERT INTO triskel_banco_ejercicios(categoria, titulo, ejs, orden)
SELECT 'reformer', 'Cadera y Piernas - Claude', '[
  {"nombre":"Footwork punta y flex","vt":"3 res. · calentamiento completo"},
  {"nombre":"Footwork una pierna","vt":"2 res. · 8 rep c/pierna · controlar rodilla"},
  {"nombre":"Frog","vt":"2 res. · 10 rep · pelvis neutra"},
  {"nombre":"Up-down","vt":"2 res. · piernas al techo y bajan controlado"},
  {"nombre":"Hip openings","vt":"2 res. · apertura hacia afuera · pelvis quieta"},
  {"nombre":"Side lying series","vt":"2 res. · de lado · elevación y bajar controlado"},
  {"nombre":"Long box leg work","vt":"2 res. · boca abajo en caja · correas en pies"},
  {"nombre":"Estocada en el reformer","vt":"2 res. · 8 rep · pie en carro · torso erguido"},
  {"nombre":"Kneeling lunge","vt":"2 res. · de rodillas · flexión y extensión"},
  {"nombre":"Side splits","vt":"2 res. · abrir controlado · pies en plataforma"},
  {"nombre":"Walking en reformer","vt":"2 res. · de pie · alternar piernas · postura activa"},
  {"nombre":"Running","vt":"2 res. · recuperación · talones alternados"}
]'::jsonb, 102
WHERE NOT EXISTS (SELECT 1 FROM triskel_banco_ejercicios WHERE titulo='Cadera y Piernas - Claude');

-- Reformer: Avanzado Completo (secuencia clásica adaptada a reformer)
INSERT INTO triskel_banco_ejercicios(categoria, titulo, ejs, orden)
SELECT 'reformer', 'Avanzado Secuencia Completa - Claude', '[
  {"nombre":"Footwork completo","vt":"3 res. · punta · talón · arco · 4ª posición · una pierna"},
  {"nombre":"Cien","vt":"1 res. · piernas a 45° · bombear fuerte"},
  {"nombre":"Coordinación","vt":"1 res. · exhalar al extender · manos arriba"},
  {"nombre":"Short spine","vt":"2 res. · articular vértebra a vértebra · sin apoyar cuello"},
  {"nombre":"Semicírculo","vt":"3 res. · 4 tiempos bajar, 4 subir · cadera a techo"},
  {"nombre":"Teaser en reformer","vt":"2 res. · correas en pies · equilibrio controlado"},
  {"nombre":"Long stretch","vt":"2 res. · plancha · empujar carro con pies"},
  {"nombre":"Down stretch","vt":"2 res. · caderas adelante · extensión torácica máxima"},
  {"nombre":"Up stretch","vt":"2 res. · V invertida · acercar pies a manos"},
  {"nombre":"Serpiente","vt":"2 res. · 4 rep c/lado · cadera arriba · sin compensar"},
  {"nombre":"Torsión","vt":"2 res. · 4 rep c/lado · rotación máxima"},
  {"nombre":"Star","vt":"1-2 res. · elevar pierna y brazo superior · control total"},
  {"nombre":"Side splits","vt":"2 res. · abrir controlado"},
  {"nombre":"Standing split lateral","vt":"1 res. · de pie · pierna lateral · equilibrio"},
  {"nombre":"Running","vt":"2 res. · vuelta lenta · recuperación"}
]'::jsonb, 103
WHERE NOT EXISTS (SELECT 1 FROM triskel_banco_ejercicios WHERE titulo='Avanzado Secuencia Completa - Claude');

-- ── 4. Nuevas planificaciones Funcional ─────────────────────────────────────

-- Funcional: Cuerpo Completo Intermedio
INSERT INTO triskel_banco_ejercicios(categoria, titulo, ejs, orden)
SELECT 'funcional', 'Cuerpo Completo Intermedio - Claude', '[
  {"nombre":"CORE · Plancha iso · 40seg","vt":"Mountain Climbers · 20 desc"},
  {"nombre":"PIERNAS · Sentadilla goblet · 40seg","vt":"Wall sit · 20 desc"},
  {"nombre":"GLÚTEOS · Puente a una pierna · 40seg","vt":"Clam con banda · 20 desc"},
  {"nombre":"ESPALDA · Remo cerrado · 40seg","vt":"Vuelo lateral · 20 desc"},
  {"nombre":"PECHO · Flexiones completas · 40seg","vt":"Fondos entre sillas · 20 desc"},
  {"nombre":"HOMBROS · Press Arnold · 40seg","vt":"Vuelo lateral de pie · 20 desc"},
  {"nombre":"PIERNAS · Estocada adelante · 40seg","vt":"Desplante reverso · 20 desc"},
  {"nombre":"CORE · Dead bug · 40seg","vt":"Hollow body hold · 20 desc"},
  {"nombre":"GLÚTEOS · Hip thrust con banco · 40seg","vt":"Glute bridge march · 20 desc"},
  {"nombre":"CARDIO · Saltos con sentadilla · 40seg","vt":"Recuperación lateral shuffle · 20 desc"}
]'::jsonb, 100
WHERE NOT EXISTS (SELECT 1 FROM triskel_banco_ejercicios WHERE titulo='Cuerpo Completo Intermedio - Claude');

-- Funcional: Glúteos y Piernas Avanzado
INSERT INTO triskel_banco_ejercicios(categoria, titulo, ejs, orden)
SELECT 'funcional', 'Glúteos y Piernas Avanzado - Claude', '[
  {"nombre":"GLÚTEOS · Hip thrust con banco · 40seg","vt":"Glute bridge march · 20 desc"},
  {"nombre":"PIERNAS · Sentadilla búlgara D · 40seg","vt":"Sentadilla ISO · 20 desc"},
  {"nombre":"PIERNAS · Sentadilla búlgara I · 40seg","vt":"Sentadilla ISO · 20 desc"},
  {"nombre":"GLÚTEOS · Sumo deadlift · 40seg","vt":"Clamshell con banda · 20 desc"},
  {"nombre":"PIERNAS · Peso muerto a un pie D · 40seg","vt":"Hip thrust a una pierna D · 20 desc"},
  {"nombre":"PIERNAS · Peso muerto a un pie I · 40seg","vt":"Hip thrust a una pierna I · 20 desc"},
  {"nombre":"GLÚTEOS · Patada en cuadrupedia D · 40seg","vt":"Fire hydrant D · 20 desc"},
  {"nombre":"GLÚTEOS · Patada en cuadrupedia I · 40seg","vt":"Fire hydrant I · 20 desc"},
  {"nombre":"PIERNAS · Step up con mancuerna · 40seg","vt":"Box squat · 20 desc"},
  {"nombre":"CARDIO · Saltos con sentadilla · 40seg","vt":"Recuperación lateral shuffle · 20 desc"}
]'::jsonb, 101
WHERE NOT EXISTS (SELECT 1 FROM triskel_banco_ejercicios WHERE titulo='Glúteos y Piernas Avanzado - Claude');

-- Funcional: HIIT Full Body (trabajo cardiovascular + fuerza)
INSERT INTO triskel_banco_ejercicios(categoria, titulo, ejs, orden)
SELECT 'funcional', 'HIIT Full Body - Claude', '[
  {"nombre":"CARDIO · Jumping jacks · 40seg","vt":"Trote con rodillas arriba · 20 desc"},
  {"nombre":"PIERNAS · Sentadilla clásica · 40seg","vt":"Wall sit · 20 desc"},
  {"nombre":"CARDIO · Mountain climbers · 40seg","vt":"Plancha iso · 20 desc"},
  {"nombre":"PECHO · Flexiones completas · 40seg","vt":"Plancha lateral · 20 desc"},
  {"nombre":"CARDIO · Saltos al frente · 40seg","vt":"Recuperación lateral · 20 desc"},
  {"nombre":"GLÚTEOS · Puente de glúteos · 40seg","vt":"Clam con banda · 20 desc"},
  {"nombre":"ESPALDA · Remo cerrado · 40seg","vt":"Press de hombros · 20 desc"},
  {"nombre":"CARDIO · Burpees · 40seg","vt":"Marcha activa recuperación · 20 desc"},
  {"nombre":"CORE · Bicicleta · 40seg","vt":"Barquito · 20 desc"},
  {"nombre":"CARDIO · Star jumps · 40seg","vt":"Vuelta lenta · estiramiento final · 30 desc"}
]'::jsonb, 102
WHERE NOT EXISTS (SELECT 1 FROM triskel_banco_ejercicios WHERE titulo='HIIT Full Body - Claude');

-- Funcional: Movilidad y Cierre (enfriamiento estructurado)
INSERT INTO triskel_banco_ejercicios(categoria, titulo, ejs, orden)
SELECT 'funcional', 'Movilidad y Cierre - Claude', '[
  {"nombre":"CORE · Plancha iso · 30seg","vt":"20 desc"},
  {"nombre":"PIERNAS · Sentadilla suave · 30seg","vt":"20 desc"},
  {"nombre":"Estiramiento de psoas de pie","vt":"40 seg c/lado · una rodilla en suelo"},
  {"nombre":"Pierna cruzada · estiramiento de glúteo","vt":"40 seg c/lado · respirar"},
  {"nombre":"Cuadrupedia gato/vaca","vt":"8 rep · soltar la tensión"},
  {"nombre":"Child pose con elongación lateral","vt":"30 seg c/lado · exhalar profundo"},
  {"nombre":"Swan y child alternados","vt":"5 rep · fluir entre extensión y flexión"},
  {"nombre":"Mermaid stretch bilateral","vt":"5 rep c/lado · sentada · respirar al elongar"},
  {"nombre":"Spine twist lento","vt":"5 rep c/lado · desde el torso · no forzar"},
  {"nombre":"Respiración diafragmática final","vt":"8 respiraciones profundas · cerrar la clase"}
]'::jsonb, 103
WHERE NOT EXISTS (SELECT 1 FROM triskel_banco_ejercicios WHERE titulo='Movilidad y Cierre - Claude');
