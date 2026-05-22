-- Migración 026: Nuevas planificaciones con progresión correcta
-- Principio fundamental aplicado en TODOS los planes:
--   · Los ejercicios en la misma posición corporal se agrupan (no saltar entre supino/prono/sentado)
--   · La dificultad sube dentro de cada clase (activación → trabajo → intensidad → cierre)
--   · El orden clásico de Pilates (Cien → Roll Up → ... → Push-ups) se respeta en los planes Mat clásicos
--   · En Reformer: siempre empieza Footwork, termina Running
--   · En Funcional: calentamiento → trabajo principal → vuelta a la calma

-- ══════════════════════════════════════════════════════════════════
-- MAT — 5 nuevos planes
-- ══════════════════════════════════════════════════════════════════

-- Mat 1: Secuencia completa 45min siguiendo el orden clásico estricto de Joseph Pilates
INSERT INTO triskel_banco_ejercicios(categoria, titulo, ejs, orden)
SELECT 'mat', 'Mat Completo 45min · Secuencia Clásica - Claude', '[
  {"nombre":"Respiración diafragmática · activar transverso","vt":"8 rep · mano en panza · inhalar 4 · exhalar 4"},
  {"nombre":"Cien · piernas a 45°","vt":"100 bombeos · lumbar pegada · exhalar en 5 bombeos"},
  {"nombre":"Roll up","vt":"6-8 rep · sin ayuda · articular vértebra a vértebra"},
  {"nombre":"Leg circles D · amplio","vt":"5 círculos c/dirección · pelvis estable en todo momento"},
  {"nombre":"Leg circles I · amplio","vt":"5 círculos c/dirección · pelvis estable"},
  {"nombre":"Rolling like a ball","vt":"8 rep · sin tocar pies · inhalar al rodar · exhalar al subir"},
  {"nombre":"Single leg stretch","vt":"8 rep c/lado · fluir sin pausa al cambiar pierna"},
  {"nombre":"Double leg stretch","vt":"8 rep · exhalar al extender · piernas bajas sin compensar lumbar"},
  {"nombre":"Scissors","vt":"8 rep c/lado · pierna baja no toca el suelo"},
  {"nombre":"Lower lift","vt":"8 rep · lumbar pegada todo el tiempo · sin balancear"},
  {"nombre":"Criss cross","vt":"8 rep c/lado · codo a rodilla opuesta · no jalar cuello"},
  {"nombre":"Spine stretch forward","vt":"6 rep · exhalar profundo al elongar · cada rep llegar más lejos"},
  {"nombre":"Open leg rocker","vt":"6-8 rep · equilibrar en cóccix · NO tocar piso con pies"},
  {"nombre":"Saw","vt":"5 rep c/lado · rotar desde la cintura · no mover cadera"},
  {"nombre":"Swan básico","vt":"6 rep · codos pegados · extensión torácica · no llevar cuello atrás"},
  {"nombre":"Single leg kick","vt":"8 rep c/lado · cadera en suelo · extender al máximo"},
  {"nombre":"De lateral D · serie (elevación + círculos + patada)","vt":"8-10 rep c/ejercicio · completar toda la serie antes de girar"},
  {"nombre":"De lateral I · serie (elevación + círculos + patada)","vt":"8-10 rep c/ejercicio · espejo del lado derecho"},
  {"nombre":"Swimming","vt":"20-30 alternados · no balancear el tronco · ritmo sostenido"},
  {"nombre":"Teaser · piernas en mesa","vt":"6 rep · bajar 4 tiempos · no dejar caer la espalda"},
  {"nombre":"Stomage · cierre","vt":"8 rep · manos bajo la frente · elongar columna"}
]'::jsonb, 200
WHERE NOT EXISTS (SELECT 1 FROM triskel_banco_ejercicios WHERE titulo='Mat Completo 45min · Secuencia Clásica - Claude');

-- Mat 2: Cadena Posterior (glúteos, isquiotibiales, erectores) — toda la clase en decúbito prono/supino
INSERT INTO triskel_banco_ejercicios(categoria, titulo, ejs, orden)
SELECT 'mat', 'Cadena Posterior Mat - Claude', '[
  {"nombre":"Puente de hombros · 4 tiempos subir · 4 bajar","vt":"8 rep · activar glúteo y core antes de cada rep"},
  {"nombre":"Puente a una pierna D · extendida al frente","vt":"8 rep · pelvis estable · sin rotar cadera"},
  {"nombre":"Puente a una pierna I · extendida al frente","vt":"8 rep · espejo del lado derecho"},
  {"nombre":"Shoulder bridge avanzado","vt":"6 rep c/lado · pierna extendida arriba · bajar lento 4 tiempos"},
  {"nombre":"[transición a prono] Sphinx hold","vt":"30 seg · antebrazos en suelo · elongar columna · respirar"},
  {"nombre":"Swan prep · codos doblados","vt":"8 rep · extensión torácica · codos pegados · sin llevar cuello"},
  {"nombre":"Swan pleno · brazos extendidos","vt":"6 rep · máxima extensión controlada · no forzar lumbar"},
  {"nombre":"Single leg kick","vt":"8 rep c/lado · cadera en suelo · patear glúteo · extender y patear"},
  {"nombre":"Double leg kick","vt":"6 rep c/lado · extender al máximo · sostener 1 seg en extensión"},
  {"nombre":"Locust · elevar pecho y piernas a la vez","vt":"6 rep · sostener 2 seg · exhalar al bajar"},
  {"nombre":"Swimming · ritmo sostenido","vt":"30 alternados · no balancear tronco · brazos y piernas largos"},
  {"nombre":"[transición a supino] Leg pull back","vt":"6 rep c/lado · sin hundir cadera · apoyada en manos"},
  {"nombre":"Child pose · estiramiento final","vt":"40 seg · rodillas separadas · respirar profundo · soltar tensión"}
]'::jsonb, 201
WHERE NOT EXISTS (SELECT 1 FROM triskel_banco_ejercicios WHERE titulo='Cadena Posterior Mat - Claude');

-- Mat 3: Apertura de Cadera y Trabajo Lateral — agrupado por posición (supino → lateral D → lateral I → cuadrupedia)
INSERT INTO triskel_banco_ejercicios(categoria, titulo, ejs, orden)
SELECT 'mat', 'Apertura de Cadera y Lateral - Claude', '[
  {"nombre":"Frog · boca arriba","vt":"10 rep · talones juntos · rodillas abren · pelvis en neutro"},
  {"nombre":"Clam D · con banda en muslos","vt":"10 rep · rango sin compensar pelvis · solo la cadera rota"},
  {"nombre":"Clam I · con banda","vt":"10 rep · espejo del lado derecho"},
  {"nombre":"Leg circles D · boca arriba","vt":"5 círculos c/dirección · pelvis estable · circulos amplios"},
  {"nombre":"Leg circles I · boca arriba","vt":"5 círculos c/dirección"},
  {"nombre":"Puente de hombros","vt":"8 rep · apretar glúteo al subir · sostener 2 seg"},
  {"nombre":"[lateral D] Elevación de pierna · lenta","vt":"10 rep · pierna activa · no rotar el tronco"},
  {"nombre":"Círculos D","vt":"5 círculos c/dirección · pierna activa · amplitud controlada"},
  {"nombre":"Patada adelante y atrás D","vt":"8 rep · rango de movimiento completo sin compensar"},
  {"nombre":"Inner thigh lift D · pierna inferior","vt":"12 rep · pierna de abajo sube · lento y controlado"},
  {"nombre":"[lateral I] Idem 4 ejercicios · lado izquierdo","vt":"misma cantidad de rep · completar todo antes de cambiar"},
  {"nombre":"[cuadrupedia] Donkey kicks D","vt":"12 rep · cadera neutra · pierna al techo sin rotar"},
  {"nombre":"Fire hydrant D","vt":"12 rep · codo abierto · no mover el tronco"},
  {"nombre":"Idem D ambos · lado izquierdo","vt":"12 rep c/ejercicio"},
  {"nombre":"Cat/cow con respiración · cierre","vt":"8 rep · exhalar en gato · inhalar en vaca · liberar tensión"}
]'::jsonb, 202
WHERE NOT EXISTS (SELECT 1 FROM triskel_banco_ejercicios WHERE titulo='Apertura de Cadera y Lateral - Claude');

-- Mat 4: Trabajo de Core Completo — todas las series clásicas de abdominales en orden progresivo
INSERT INTO triskel_banco_ejercicios(categoria, titulo, ejs, orden)
SELECT 'mat', 'Core Completo · Series Clásicas - Claude', '[
  {"nombre":"Imprinting · activar transverso","vt":"8 rep · sin apuro · sentir la columna en neutro"},
  {"nombre":"Curl up básico · solo cabeza y hombros","vt":"10 rep · 4 tiempos subir · exhalar al subir"},
  {"nombre":"Cien · piernas en mesa","vt":"100 bombeos · brazo arriba-abajo 2cm · exhalar en 5"},
  {"nombre":"Cien avanzado · piernas a 45°","vt":"50 bombeos adicionales · piernas más bajas si tolera lumbar"},
  {"nombre":"Roll up","vt":"6-8 rep · sin impulso · articular toda la columna"},
  {"nombre":"Single leg stretch","vt":"8 rep c/lado · manos en tibia y tobillo · alternar fluido"},
  {"nombre":"Double leg stretch","vt":"8 rep · brazos al techo al extender piernas · exhalar"},
  {"nombre":"Scissors","vt":"8 rep c/lado · pierna baja NO toca suelo · lumbar pegada"},
  {"nombre":"Lower lift","vt":"8 rep · piernas a 90° bajan a 45° · lumbar siempre pegada"},
  {"nombre":"Criss cross","vt":"8 rep c/lado · codo a rodilla opuesta · no jalar cuello"},
  {"nombre":"Hollow body hold","vt":"20-30 seg · brazos y piernas a 45° · lumbar en suelo"},
  {"nombre":"Teaser básico · piernas en mesa","vt":"6 rep · bajar 4 tiempos · sin caer"},
  {"nombre":"Teaser completo · piernas extendidas","vt":"5-6 rep · sostener 2 seg arriba · sin apoyar espalda"},
  {"nombre":"Rolling like a ball · cierre","vt":"8 rep · liberar tensión lumbar · rodar suave"}
]'::jsonb, 203
WHERE NOT EXISTS (SELECT 1 FROM triskel_banco_ejercicios WHERE titulo='Core Completo · Series Clásicas - Claude');

-- Mat 5: Avanzado II · Cierre Clásico (completa la secuencia donde termina Avanzado I)
INSERT INTO triskel_banco_ejercicios(categoria, titulo, ejs, orden)
SELECT 'mat', 'Avanzado II · Cierre Clásico - Claude', '[
  {"nombre":"Cien · piernas a 5cm del suelo","vt":"100 bombeos · nivel máximo · lumbar pegada en todo momento"},
  {"nombre":"Roll over · piernas al techo y abrir","vt":"5-6 rep · NO pasar de cervicales · abrir en el techo · bajar y volver"},
  {"nombre":"Corkscrew","vt":"4 rep c/lado · círculo completo de piernas · pelvis sube un lado"},
  {"nombre":"Hip circles en Teaser","vt":"4 círculos c/dirección · equilibrar en cóccix · brazos estables"},
  {"nombre":"Rocking","vt":"5-6 rep · tomar tobillos · balancear pecho-piernas · extensión total"},
  {"nombre":"Control balance","vt":"4-5 rep · piernas al techo · equilibrar en hombros · NO en cuello"},
  {"nombre":"Kneeling side kick D","vt":"8 rep · de rodillas · una pierna lateral · cadera estable"},
  {"nombre":"Kneeling side kick I","vt":"8 rep · espejo del lado derecho"},
  {"nombre":"Side bend D (plancha lateral)","vt":"5-6 rep · elevar cadera · arco de costado · cuerpo en línea"},
  {"nombre":"Side bend I","vt":"5-6 rep · espejo"},
  {"nombre":"Boomerang","vt":"5 rep · cruzar piernas · roll over → teaser → stretch → todo fluido"},
  {"nombre":"Seal · cerrar clase","vt":"8 rep · aplaudir al rodar · sin forzar · energía suave"},
  {"nombre":"Push up Pilates","vt":"5-6 rep · plank → bajar 3 tiempos → subir 1 · pies juntos · cuerpo recto"}
]'::jsonb, 204
WHERE NOT EXISTS (SELECT 1 FROM triskel_banco_ejercicios WHERE titulo='Avanzado II · Cierre Clásico - Claude');

-- ══════════════════════════════════════════════════════════════════
-- REFORMER — 5 nuevos planes + corrección Express 30min
-- ══════════════════════════════════════════════════════════════════

-- Reformer 1: Hip Work Serie Completa — dedicado al trabajo de cadera con progresión interna
INSERT INTO triskel_banco_ejercicios(categoria, titulo, ejs, orden)
SELECT 'reformer', 'Hip Work · Serie Completa - Claude', '[
  {"nombre":"Footwork punta · calentamiento","vt":"3 res. · 10 rep · activar cuádriceps y core"},
  {"nombre":"Footwork flex","vt":"3 res. · 10 rep · empujar desde el talón"},
  {"nombre":"Footwork talones","vt":"2 res. · estirar isquiotibiales al extender"},
  {"nombre":"Frog básico","vt":"2 res. · 8 rep · talones juntos · rodillas abren · pelvis quieta"},
  {"nombre":"Frog con suelo pélvico","vt":"2 res. · 8 rep · exhalar y activar SP al extender"},
  {"nombre":"Leg circles en Frog D","vt":"2 res. · 5 círculos c/dirección · abrir con control · pelvis estable"},
  {"nombre":"Leg circles en Frog I","vt":"2 res. · 5 círculos c/dirección"},
  {"nombre":"Up-down D · pierna al techo y baja controlado","vt":"2 res. · 8 rep · pelvis NO sube al elevar"},
  {"nombre":"Up-down I","vt":"2 res. · 8 rep"},
  {"nombre":"Hip openings D · apertura hacia afuera","vt":"2 res. · 6 rep lento · pelvis quieta · rango sin compensar"},
  {"nombre":"Hip openings I","vt":"2 res. · 6 rep"},
  {"nombre":"Short spine · articulación post hip-work","vt":"2 res. · articular vértebra a vértebra · no pasar de cervicales"},
  {"nombre":"Cien · core activado","vt":"1 res. · 100 bombeos · piernas a 45°"},
  {"nombre":"Running · cierre calma","vt":"3 res. · talones alternados · 16 rep · carro quieto al final"}
]'::jsonb, 200
WHERE NOT EXISTS (SELECT 1 FROM triskel_banco_ejercicios WHERE titulo='Hip Work · Serie Completa - Claude');

-- Reformer 2: Long Stretch Serie — serie de planchas y elongación completa en secuencia
INSERT INTO triskel_banco_ejercicios(categoria, titulo, ejs, orden)
SELECT 'reformer', 'Long Stretch · Serie Completa - Claude', '[
  {"nombre":"Footwork completo · 4 posiciones","vt":"3 res. · fluir entre punta-flex-talón-arco sin parar"},
  {"nombre":"Cien","vt":"1 res. · piernas a 45° · preparar core para planchas"},
  {"nombre":"Coordinación","vt":"1 res. · exhalar al extender piernas · preparar respiración"},
  {"nombre":"Long stretch · plancha completa","vt":"2 res. · manos en barra · cuerpo en línea · empujar carro con pies"},
  {"nombre":"Down stretch · caderas adelante","vt":"2 res. · cadera hacia barra · extensión torácica máxima · codos pegados"},
  {"nombre":"Up stretch · V invertida","vt":"2 res. · acercar pies a manos · elevar caderas · columna larga"},
  {"nombre":"Elefante · columna redondeada","vt":"2 res. · push desde el core · NO usar cadera"},
  {"nombre":"Knee stretch redondo · curva C","vt":"2 res. · columna en C profunda · sin llegar al tope"},
  {"nombre":"Knee stretch plano · columna recta","vt":"2 res. · espalda paralela al suelo"},
  {"nombre":"Knee stretch oblicuo D","vt":"2 res. · rotar tronco al extender · luego pies en el aire"},
  {"nombre":"Knee stretch oblicuo I","vt":"2 res. · espejo del lado derecho"},
  {"nombre":"Short spine · contramovimiento","vt":"2 res. · articular después de todas las planchas · contraer columna"},
  {"nombre":"Running · recuperación","vt":"3 res. · talones alternados · recuperar movilidad de tobillos"}
]'::jsonb, 201
WHERE NOT EXISTS (SELECT 1 FROM triskel_banco_ejercicios WHERE titulo='Long Stretch · Serie Completa - Claude');

-- Reformer 3: Short Box Serie Completa — trabajo completo de caja corta en progresión
INSERT INTO triskel_banco_ejercicios(categoria, titulo, ejs, orden)
SELECT 'reformer', 'Short Box · Serie Completa - Claude', '[
  {"nombre":"Footwork completo · todas las posiciones","vt":"3 res. · calentamiento · fluir sin pausa"},
  {"nombre":"Stomach massage redondo","vt":"3 res. · calentar flexión/extensión columna · preparar para short box"},
  {"nombre":"Caja corta · redondo","vt":"carro quieto · 1 res. · 6 rep · curva C · rodar desde lumbar"},
  {"nombre":"Caja corta · plano con extensión torácica","vt":"carro quieto · 1 res. · 6 rep · arquear desde torácica · NO lumbar"},
  {"nombre":"Caja corta · oblicuo D","vt":"carro quieto · 1 res. · 5 rep · torsión máxima desde torso"},
  {"nombre":"Caja corta · oblicuo I","vt":"carro quieto · 1 res. · 5 rep · espejo"},
  {"nombre":"Caja corta · stretch lateral D","vt":"carro quieto · 1 res. · 5 rep · elongar costado"},
  {"nombre":"Caja corta · stretch lateral I","vt":"carro quieto · 1 res. · 5 rep"},
  {"nombre":"Árbol D · pierna al techo","vt":"carro quieto · 1 res. · 5 rep · bajar pierna MUY despacio 4 tiempos"},
  {"nombre":"Árbol I","vt":"carro quieto · 1 res. · 5 rep"},
  {"nombre":"Running · cierre","vt":"3 res. · 16 rep · recuperar movilidad · carro quieto al final"}
]'::jsonb, 202
WHERE NOT EXISTS (SELECT 1 FROM triskel_banco_ejercicios WHERE titulo='Short Box · Serie Completa - Claude');

-- Reformer 4: Avanzado · Rotación y Control
INSERT INTO triskel_banco_ejercicios(categoria, titulo, ejs, orden)
SELECT 'reformer', 'Avanzado · Rotación y Control - Claude', '[
  {"nombre":"Footwork rápido · series completas","vt":"3 res. · todas las posiciones sin pausa · ritmo sostenido"},
  {"nombre":"Hip work completo","vt":"2 res. · frog / circles / up-down / openings · 6 rep c/u"},
  {"nombre":"Cien · piernas a 10cm del suelo","vt":"1 res. · máxima demanda · lumbar pegada"},
  {"nombre":"Coordinación avanzada","vt":"1 res. · piernas muy bajas · velocidad mayor"},
  {"nombre":"Stomach massage twist D","vt":"2 res. · 5 rep · rotación máxima · codo al frente · no perder longitud"},
  {"nombre":"Stomach massage twist I","vt":"2 res. · 5 rep"},
  {"nombre":"Stomach massage reaching","vt":"1 res. · elongar al máximo · columna larga"},
  {"nombre":"Caja corta oblicuo D profundo","vt":"1 res. · 5 rep · llevar codo a rodilla opuesta"},
  {"nombre":"Caja corta oblicuo I profundo","vt":"1 res. · 5 rep"},
  {"nombre":"Serpiente D","vt":"2 res. · 4 rep · cadera al techo · entrada lenta"},
  {"nombre":"Serpiente I","vt":"2 res. · 4 rep"},
  {"nombre":"Torsión D","vt":"2 res. · 4 rep · rotación completa · sin perder el eje"},
  {"nombre":"Torsión I","vt":"2 res. · 4 rep"},
  {"nombre":"Mermaid (Sirena) D · arco lateral","vt":"1 res. · arco de costado completo · volver controlado"},
  {"nombre":"Mermaid I","vt":"1 res."},
  {"nombre":"Running lento · recuperación","vt":"3 res. · cerrar con conciencia corporal"}
]'::jsonb, 203
WHERE NOT EXISTS (SELECT 1 FROM triskel_banco_ejercicios WHERE titulo='Avanzado · Rotación y Control - Claude');

-- Reformer 5: Básico III · Presentación de Long Box (primera vez en caja larga)
INSERT INTO triskel_banco_ejercicios(categoria, titulo, ejs, orden)
SELECT 'reformer', 'Básico III · Long Box Primera Vez - Claude', '[
  {"nombre":"Footwork punta y flex","vt":"3 res. · calentamiento · activar piernas"},
  {"nombre":"Footwork talones","vt":"2 res. · luego arco · estirar isquios"},
  {"nombre":"Frog · rango cómodo","vt":"2 res. · 8 rep · calentar cadera"},
  {"nombre":"Cien","vt":"1 res. · piernas a 45° · 100 bombeos · preparar core"},
  {"nombre":"Coordinación","vt":"1 res. · lenta · explicar la respiración"},
  {"nombre":"Remo desde el pecho · palmas arriba","vt":"1 res. liviano · codos pegados · extender y cerrar"},
  {"nombre":"Caja larga · boca abajo · posición base","vt":"2 res. · explicar ubicación · manos en barra · no empujar aún"},
  {"nombre":"Pulling straps · primera presentación","vt":"2 res. · 6 rep · brazos atrás · extensión dorsal · suave"},
  {"nombre":"T-press · primera presentación","vt":"2 res. · 6 rep · brazos en T · escápulas juntas · no elevar hombros"},
  {"nombre":"Swan básico en long box","vt":"2 res. · 5 rep · codos pegados · extensión torácica · sin forzar cuello"},
  {"nombre":"Stomach massage redondo · vuelta a flexión","vt":"2 res. · contraer después de toda la extensión"},
  {"nombre":"Running + semicírculo · cierre","vt":"3 res. · running 12 rep · semicírculo 3 rep · cierre consciente"}
]'::jsonb, 204
WHERE NOT EXISTS (SELECT 1 FROM triskel_banco_ejercicios WHERE titulo='Básico III · Long Box Primera Vez - Claude');

-- CORRECCIÓN: Express 30min — la versión original era demasiado abreviada
-- Se reemplaza por una versión que mantiene el orden correcto con los tiempos necesarios
UPDATE triskel_banco_ejercicios
SET ejs = '[
  {"nombre":"Footwork completo · punta / flex / talón / arco","vt":"2 res. · 8 rep cada posición · fluir sin pausa"},
  {"nombre":"Frog · leg circles","vt":"2 res. · frog 6 rep · circles 4 c/dirección"},
  {"nombre":"Cien","vt":"1 res. · piernas a 45° · 100 bombeos"},
  {"nombre":"Coordinación","vt":"1 res. · exhalar al extender piernas"},
  {"nombre":"Remo desde el pecho","vt":"1 res. · codos pegados · 6 rep rápidas"},
  {"nombre":"Caja corta · redondo y plano","vt":"carro quieto · 1 res. · 4 rep cada uno"},
  {"nombre":"Pulling straps","vt":"2 res. · 6 rep · extensión torácica"},
  {"nombre":"Short spine","vt":"2 res. · articular columna · no pasar de cervicales"},
  {"nombre":"Stomach massage redondo","vt":"2 res. · 6 rep · énfasis curva abdominal"},
  {"nombre":"Side splits","vt":"1-2 res. · 6 rep · abrir y cerrar controlado"},
  {"nombre":"Running + semicírculo","vt":"2 res. · running 12 rep · semicírculo 3 rep · cierre"}
]'::jsonb
WHERE titulo = 'Express 30 min';

-- ══════════════════════════════════════════════════════════════════
-- FUNCIONAL — 5 nuevos planes con estructura calentamiento → trabajo → vuelta
-- ══════════════════════════════════════════════════════════════════

-- Funcional 1: Calentamiento Dinámico (para usar como apertura de cualquier clase funcional)
INSERT INTO triskel_banco_ejercicios(categoria, titulo, ejs, orden)
SELECT 'funcional', 'Calentamiento Dinámico - Claude', '[
  {"nombre":"Marcha activa con rodillas altas · 90seg","vt":"progresivo · elevar FC suavemente · brazos activos"},
  {"nombre":"Movilidad de cadera · rotaciones de pie · 8 c/lado","vt":"manos en cadera · círculos amplios · de pie"},
  {"nombre":"Hip hinge básico · bisagra de cadera · 15 rep","vt":"sin peso · empujar cadera atrás · columna neutra"},
  {"nombre":"Sentadilla con peso corporal · 15 rep","vt":"descender controlado · rodillas siguen pies"},
  {"nombre":"Lunge estático D · 10 rep","vt":"rodilla atrás casi toca el suelo · torso erguido"},
  {"nombre":"Lunge estático I · 10 rep","vt":"espejo del lado derecho"},
  {"nombre":"Apertura de pecho · entrelazar manos detrás · 3 rep","vt":"sostener 5 seg · no llevar la cabeza · pecho abierto"},
  {"nombre":"Band pull apart · 15 rep","vt":"activar escápulas · codos rectos · sin encoger hombros"},
  {"nombre":"Dead bug básico · 8 rep","vt":"activar core · brazo-pierna opuestos · lumbar en suelo"},
  {"nombre":"Puente de glúteos · 12 rep","vt":"activar glúteos para la clase · sostener 1 seg arriba"},
  {"nombre":"Jumping jacks suaves · 30 seg","vt":"elevar FC final · ya listos para trabajar"}
]'::jsonb, 200
WHERE NOT EXISTS (SELECT 1 FROM triskel_banco_ejercicios WHERE titulo='Calentamiento Dinámico - Claude');

-- Funcional 2: Circuito Fuerza Compuesta (movimientos compuestos, reps lentas, fuerza pura)
INSERT INTO triskel_banco_ejercicios(categoria, titulo, ejs, orden)
SELECT 'funcional', 'Circuito Fuerza Compuesta - Claude', '[
  {"nombre":"PIERNAS · Sentadilla profunda con disco · 40seg","vt":"12 rep lentas · descender 3 tiempos · subir 1 · pausa 25"},
  {"nombre":"ESPALDA · Peso muerto convencional con disco · 40seg","vt":"10 rep · bisagra de cadera · columna neutra · pausa 25"},
  {"nombre":"PECHO · Flexiones completas · 40seg","vt":"máximo controlado · bajar 3 tiempos · sin hundir lumbar · pausa 25"},
  {"nombre":"ESPALDA · Remo cerrado con barra · 40seg","vt":"10-12 rep · codos pegados · escápulas juntas al final · pausa 25"},
  {"nombre":"PIERNAS · Estocada caminando con discos · 40seg","vt":"8 pasos c/lado · rodilla casi toca suelo · pausa 25"},
  {"nombre":"HOMBROS · Press militar de pie · 40seg","vt":"10 rep · no arquear lumbar · bajar lento 2 tiempos · pausa 25"},
  {"nombre":"PIERNAS · Sentadilla búlgara D · 40seg","vt":"10 rep · pie atrás en banco · torso recto · pausa 25"},
  {"nombre":"PIERNAS · Sentadilla búlgara I · 40seg","vt":"10 rep · espejo · pausa 25"},
  {"nombre":"CORE · Plancha iso · 40seg","vt":"cuerpo en línea · activar todo · no dejar caer cadera · pausa 20"},
  {"nombre":"CORE · Dead bug lento · cierre · 40seg","vt":"8 rep · sin apuro · vuelta suave · pausa 20"}
]'::jsonb, 201
WHERE NOT EXISTS (SELECT 1 FROM triskel_banco_ejercicios WHERE titulo='Circuito Fuerza Compuesta - Claude');

-- Funcional 3: Cardio Escalado (intensidad progresiva de menor a mayor en cada circuito)
INSERT INTO triskel_banco_ejercicios(categoria, titulo, ejs, orden)
SELECT 'funcional', 'Cardio Escalado · Intensidad Progresiva - Claude', '[
  {"nombre":"ACTIVACIÓN · Paso lateral con toque · 40seg","vt":"FC baja · cuerpo despierto · pausa 20"},
  {"nombre":"MOVILIDAD · Sentadilla suave · 40seg","vt":"FC moderada · calentamiento de piernas · pausa 20"},
  {"nombre":"CARDIO I · Mountain Climbers lento · 40seg","vt":"FC sube gradual · core activo · pausa 20"},
  {"nombre":"PIERNAS I · Estocada adelante · 40seg","vt":"controlado · FC moderada · pausa 20"},
  {"nombre":"CARDIO II · Jumping jacks · 40seg","vt":"ritmo constante · FC subiendo · pausa 20"},
  {"nombre":"PIERNAS II · Sentadilla sumo explosiva al subir · 40seg","vt":"bajar lento · subir rápido · FC en alza · pausa 20"},
  {"nombre":"CARDIO III · Saltos con sentadilla · 40seg","vt":"alta intensidad · absorber con piernas · pausa 25"},
  {"nombre":"PECHO · Flexiones completas · 40seg","vt":"mantener calidad · pausa 20"},
  {"nombre":"CARDIO IV · Burpees sin salto · 40seg","vt":"máxima demanda · técnica no negociable · pausa 30"},
  {"nombre":"VUELTA · Marcha activa suave · 90seg","vt":"bajar FC progresivamente · respiración controlada"}
]'::jsonb, 202
WHERE NOT EXISTS (SELECT 1 FROM triskel_banco_ejercicios WHERE titulo='Cardio Escalado · Intensidad Progresiva - Claude');

-- Funcional 4: Tren Inferior Completo (glúteos + piernas con progresión anatómica)
INSERT INTO triskel_banco_ejercicios(categoria, titulo, ejs, orden)
SELECT 'funcional', 'Tren Inferior Completo - Claude', '[
  {"nombre":"ACTIVACIÓN · Puente de glúteos · 40seg","vt":"12 rep lentas · activar glúteos antes del trabajo de pie · pausa 20"},
  {"nombre":"GLÚTEOS · Clam con banda en muslos · 40seg","vt":"10 rep c/lado · activar glúteo medio antes de cargar · pausa 20"},
  {"nombre":"PIERNAS · Sentadilla sumo con disco · 40seg","vt":"12 rep · apretar glúteo al subir · pausa 20"},
  {"nombre":"GLÚTEOS · Hip thrust con banco · 40seg","vt":"12 rep · sostener 1 seg arriba · apretar glúteo al máximo · pausa 20"},
  {"nombre":"PIERNAS · Estocada reversa D · 40seg","vt":"10 rep · rodilla atrás · torso recto · pausa 20"},
  {"nombre":"PIERNAS · Estocada reversa I · 40seg","vt":"10 rep · espejo · pausa 20"},
  {"nombre":"GLÚTEOS · Patada en cuadrupedia D · 40seg","vt":"12 rep · cadera neutra · extender pierna recta al máximo · pausa 20"},
  {"nombre":"GLÚTEOS · Patada en cuadrupedia I · 40seg","vt":"12 rep · pausa 20"},
  {"nombre":"PIERNAS · Peso muerto a una pierna D · 40seg","vt":"10 rep · equilibrio · columna neutra · pausa 20"},
  {"nombre":"PIERNAS · Peso muerto a una pierna I · 40seg","vt":"10 rep · pausa 20"},
  {"nombre":"CORE · Plancha iso · cierre · 40seg","vt":"sostener · trabajo de core después de piernas · pausa 20"},
  {"nombre":"VUELTA · Estiramiento isquios + glúteo · 2min","vt":"30 seg c/ejercicio c/lado · pigeon + isquio · bajar FC"}
]'::jsonb, 203
WHERE NOT EXISTS (SELECT 1 FROM triskel_banco_ejercicios WHERE titulo='Tren Inferior Completo - Claude');

-- Funcional 5: Clase Completa Full Body 60min (estructura modelo con warm-up + trabajo + cierre)
INSERT INTO triskel_banco_ejercicios(categoria, titulo, ejs, orden)
SELECT 'funcional', 'Clase Completa Full Body 60min - Claude', '[
  {"nombre":"── CALENTAMIENTO 8min ──","vt":"marcha activa · movilidad cadera · hip hinge · sentadilla peso cuerpo"},
  {"nombre":"CORE · Dead bug · 40seg","vt":"activar core · pausa 20 · inicio del trabajo"},
  {"nombre":"PIERNAS · Sentadilla goblet · 40seg","vt":"pausa 20"},
  {"nombre":"GLÚTEOS · Hip thrust · 40seg","vt":"pausa 20"},
  {"nombre":"ESPALDA · Remo cerrado · 40seg","vt":"pausa 20"},
  {"nombre":"PECHO · Flexiones · 40seg","vt":"pausa 20"},
  {"nombre":"HOMBROS · Press Arnold · 40seg","vt":"pausa 20"},
  {"nombre":"── SEGUNDA VUELTA más intensa ──","vt":"mismos grupos musculares · subir peso o rep"},
  {"nombre":"PIERNAS · Sentadilla búlgara D · 40seg","vt":"pausa 20"},
  {"nombre":"PIERNAS · Sentadilla búlgara I · 40seg","vt":"pausa 20"},
  {"nombre":"GLÚTEOS · Peso muerto una pierna D · 40seg","vt":"pausa 20"},
  {"nombre":"GLÚTEOS · Peso muerto una pierna I · 40seg","vt":"pausa 20"},
  {"nombre":"CARDIO · Mountain Climbers · 40seg","vt":"pausa 20"},
  {"nombre":"CARDIO · Saltos con sentadilla · 40seg","vt":"pausa 25"},
  {"nombre":"── FINALIZADOR DE CORE 8min ──","vt":"planchas · bicicleta · holllow hold · dead bug"},
  {"nombre":"── CIERRE 5min ──","vt":"estiramiento cuádriceps · isquios · glúteo · cat-cow · respiración final"}
]'::jsonb, 204
WHERE NOT EXISTS (SELECT 1 FROM triskel_banco_ejercicios WHERE titulo='Clase Completa Full Body 60min - Claude');
