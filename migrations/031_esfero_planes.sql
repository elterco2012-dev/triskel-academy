-- 031: Planes de Esferodinamia para triskel_banco_ejercicios
-- INSERT directo (no requiere auth context, ejecutar como postgres en SQL Editor)

-- Paso 1: ampliar el CHECK constraint para incluir esferodinamia
ALTER TABLE triskel_banco_ejercicios
  DROP CONSTRAINT IF EXISTS chk_banco_categoria;

ALTER TABLE triskel_banco_ejercicios
  ADD CONSTRAINT chk_banco_categoria
    CHECK (categoria IN ('mat', 'reformer', 'funcional', 'esferodinamia'));

-- Paso 2: insertar los 14 planes
INSERT INTO triskel_banco_ejercicios(categoria, titulo, ejs, orden) VALUES
('esferodinamia','Esfero Iniciacion','[
  {"nombre":"Sedestacion dinamica en pelota","vt":"Pies apoyados, columna larga, manos en muslos - 2 min"},
  {"nombre":"Marcha sentada en pelota","vt":"Alternar rodillas, ritmo suave - 40 seg"},
  {"nombre":"Circulos de cadera sobre pelota","vt":"Circulos amplios hacia ambos lados - 8 cada lado"},
  {"nombre":"Inclinacion lateral sentada","vt":"Brazo estira hacia el techo, cadera firme - 8 cada lado"},
  {"nombre":"Rotacion de tronco sentada","vt":"Manos en nuca, rotar lento mirando al costado - 8 cada lado"},
  {"nombre":"Puente de cadera con pies en pelota","vt":"Talones sobre pelota, subir y mantener 3 seg - 10 rep"},
  {"nombre":"Apertura toracica sobre pelota","vt":"Pelota bajo escapulas, brazos abiertos, cabeza apoyada - 30 seg"},
  {"nombre":"Elongacion lumbar sobre pelota","vt":"Abdomen sobre pelota, brazos y piernas cuelgan - 30 seg"}
]'::jsonb, 0),

('esferodinamia','Esfero Movilidad Columna','[
  {"nombre":"Rebote suave sentada","vt":"Ritmo natural, activar transverso - 1 min"},
  {"nombre":"Flexion lateral sobre pelota","vt":"Un costado sobre pelota, brazo arriba - 30 seg cada lado"},
  {"nombre":"Cat-cow con manos en pelota","vt":"Manos sobre pelota, flexion y extension de columna - 10 rep"},
  {"nombre":"Rotacion con bajada lateral","vt":"Pelota frente al pecho, rotar y bajar al lado - 8 cada lado"},
  {"nombre":"Apertura toracica supina","vt":"Pelota bajo columna toracica, brazos en cruz - 40 seg"},
  {"nombre":"Rodamiento de pelota por columna","vt":"De pie, pelota entre espalda y pared, rodar suave - 1 min"},
  {"nombre":"Extension de espalda sobre pelota","vt":"Cadera sobre pelota, manos en nuca, extender - 12 rep"},
  {"nombre":"Elongacion de psoas con pelota","vt":"Rodilla en suelo, pie adelante sobre pelota - 30 seg cada lado"}
]'::jsonb, 1),

('esferodinamia','Esfero Core Profundo','[
  {"nombre":"Curl abdominal sobre pelota","vt":"Lumbar apoyada en pelota, subir lento - 15 rep"},
  {"nombre":"Dead bug con pelota entre rodillas","vt":"Prono, pelota entre rodillas, brazos extienden - 10 rep"},
  {"nombre":"Plancha con rodillas en pelota","vt":"Rodillas sobre pelota, cuerpo recto - 30 seg"},
  {"nombre":"Oblicuos sobre pelota","vt":"Pelota bajo costado, mano en nuca, elevar - 12 cada lado"},
  {"nombre":"Extension bilateral en pelota","vt":"Abdomen sobre pelota, elevar brazos y piernas - 10 rep"},
  {"nombre":"Hollow hold con pelota","vt":"Supino, pelota entre pies, bajar piernas extendidas - 10 rep"},
  {"nombre":"Sedestacion activa con pelota entre rodillas","vt":"Comprimir pelota pequenya, activar suelo pelvico - 20 seg"},
  {"nombre":"Roll-out en rodillas","vt":"Manos en pelota, extender hacia adelante - 10 rep"}
]'::jsonb, 2),

('esferodinamia','Esfero Piernas y Gluteos','[
  {"nombre":"Sentadilla con pelota en pared","vt":"Pelota entre espalda y pared, bajar a 90 grados - 15 rep"},
  {"nombre":"Puente en pelota con marcha","vt":"Talones sobre pelota, subir cadera y alternar rodillas - 10 rep"},
  {"nombre":"Estocada con mano en pelota","vt":"Pelota al costado como apoyo, estocada profunda - 10 cada lado"},
  {"nombre":"Extension unilateral de cadera en pelota","vt":"Abdomen sobre pelota, elevar una pierna extendida - 12 cada lado"},
  {"nombre":"Curl de isquiotibiales en pelota","vt":"Supino, pies sobre pelota, flexionar rodillas hacia gluteos - 12 rep"},
  {"nombre":"Abduccion lateral con pelota","vt":"Pelota entre rodilla y pared, elevar pierna libre - 15 cada lado"},
  {"nombre":"Sentadilla sumo con pelota frente al pecho","vt":"Pies abiertos, bajar lento, pelota de contrapeso - 12 rep"},
  {"nombre":"Puente unipodal con pelota","vt":"Un talon en pelota, el otro elevado - 10 cada lado"}
]'::jsonb, 3),

('esferodinamia','Esfero Equilibrio y Propiocepcion','[
  {"nombre":"Equilibrio unipodal junto a pelota","vt":"Una mano apoyada en pelota, elevar rodilla contraria - 30 seg cada lado"},
  {"nombre":"Equilibrio prono en pelota","vt":"Abdomen sobre pelota, elevar manos del suelo - 20 seg"},
  {"nombre":"Marcha sobre pelota en decubito","vt":"Pies sobre pelota, alternar elevaciones de pierna - 10 cada lado"},
  {"nombre":"Sentadilla con cierre de ojos","vt":"Pelota en pared, cerrar ojos al bajar - 10 rep"},
  {"nombre":"Plancha con pies en pelota","vt":"Pies sobre pelota, mantener posicion - 30 seg"},
  {"nombre":"Zancada inversa con pelota","vt":"Pie trasero sobre pelota, bajar controlado - 10 cada lado"},
  {"nombre":"Lanzamiento y atrape de pelota en equilibrio","vt":"Un pie, lanzar y atrapar pelota pequenya - 15 rep cada lado"},
  {"nombre":"Equilibrio lateral en pelota","vt":"Costado sobre pelota, elevar cadera del suelo - 20 seg cada lado"}
]'::jsonb, 4),

('esferodinamia','Esfero Fuerza Funcional','[
  {"nombre":"Push up con manos en pelota","vt":"Palmas sobre pelota, descender al pecho - 12 rep"},
  {"nombre":"Pike con pelota roll-out","vt":"Pies en pelota, cadera al techo manteniendo piernas rectas - 10 rep"},
  {"nombre":"Flexiones declinadas con pies en pelota","vt":"Pies en pelota, manos en suelo - 10 rep"},
  {"nombre":"Curl de biceps con pelota comprimida","vt":"Pelota pequenya entre palmas, comprimir al subir - 15 rep"},
  {"nombre":"Press de hombros sentada en pelota","vt":"Con mancuernas livianas, sentada activa - 15 rep"},
  {"nombre":"Remo prono sobre pelota","vt":"Abdomen en pelota, mancuernas hacia cadera - 12 rep"},
  {"nombre":"Sentadilla con salto desde pelota","vt":"Pies en pelota chata, sentadilla explosiva - 10 rep"},
  {"nombre":"Plancha a T con pelota","vt":"Una mano en pelota, rotar a plancha lateral - 8 cada lado"}
]'::jsonb, 5),

('esferodinamia','Esfero Circuito Completo','[
  {"nombre":"Rebote y marcha sentada","vt":"Calentamiento 2 min"},
  {"nombre":"Circulos de cadera y rotacion tronco","vt":"8 cada lado"},
  {"nombre":"Sentadilla con pelota en pared","vt":"3 series - 12 rep"},
  {"nombre":"Curl abdominal sobre pelota","vt":"3 series - 15 rep"},
  {"nombre":"Puente en pelota con marcha","vt":"3 series - 10 rep"},
  {"nombre":"Plancha con rodillas en pelota","vt":"3 series - 30 seg"},
  {"nombre":"Extension de espalda sobre pelota","vt":"2 series - 12 rep"},
  {"nombre":"Apertura toracica y elongacion lumbar","vt":"Vuelta a la calma - 1 min cada una"}
]'::jsonb, 6),

('esferodinamia','Esfero Postparto','[
  {"nombre":"Sedestacion dinamica en pelota","vt":"Columna larga, respiracion profunda - 2 min"},
  {"nombre":"Rebote suave con respiracion","vt":"Inhalar por nariz, exhalar por boca - 1 min"},
  {"nombre":"Circulos de cadera lentos","vt":"Amplios y conscientes, 6 cada lado"},
  {"nombre":"Inclinacion pelvica sentada","vt":"Bascular pelvis adelante y atras - 10 rep"},
  {"nombre":"Puente de cadera con pies en pelota","vt":"Activar gluteos y transverso, lento - 10 rep"},
  {"nombre":"Abduccion lateral con pelota","vt":"Pelota entre rodilla y pared, suave - 12 cada lado"},
  {"nombre":"Cat-cow con manos en pelota","vt":"Movilizar columna sin forzar - 10 rep"},
  {"nombre":"Elongacion lumbar sobre pelota","vt":"Abdomen sobre pelota, relajar completamente - 40 seg"}
]'::jsonb, 7),

('esferodinamia','Esfero Adultas Mayores','[
  {"nombre":"Sedestacion dinamica en pelota","vt":"Sin tiempo limite - a ritmo propio"},
  {"nombre":"Marcha sentada en pelota","vt":"Manos en muslos como apoyo - 30 seg"},
  {"nombre":"Rotacion de tronco sentada","vt":"Rango libre, sin forzar - 6 cada lado"},
  {"nombre":"Extension de rodillas sentada","vt":"Una pierna a la vez, lento - 10 cada lado"},
  {"nombre":"Elevacion de talones sentada","vt":"Talones al suelo y arriba alternando - 15 rep"},
  {"nombre":"Puente de cadera con pies en pelota","vt":"Manos en suelo como apoyo extra - 8 rep"},
  {"nombre":"Apertura toracica sobre pelota","vt":"Pelota bajo escapulas, respirar profundo - 40 seg"},
  {"nombre":"Elongacion lateral sentada","vt":"Brazo sube por encima, lado a lado - 5 cada lado"}
]'::jsonb, 8),

('esferodinamia','Esfero Hombros y Espalda Alta','[
  {"nombre":"Rotacion de hombros sobre pelota","vt":"Sentada, circulos amplios adelante y atras - 8 cada direccion"},
  {"nombre":"Apertura de brazos sobre pelota","vt":"Pelota bajo espalda media, brazos en cruz - 40 seg"},
  {"nombre":"Press de hombros sentada en pelota","vt":"Con mancuernas livianas o sin carga - 15 rep"},
  {"nombre":"Remo prono sobre pelota","vt":"Abdomen en pelota, codos hacia techo - 12 rep"},
  {"nombre":"W-Y-T sobre pelota","vt":"Prono en pelota, formas de letras con brazos - 8 rep cada forma"},
  {"nombre":"Rotacion externa de hombros en pelota","vt":"Codo apoyado en pelota, girar antebrazo - 12 cada lado"},
  {"nombre":"Apertura toracica con rodillo de pelota","vt":"Rodar pelota por columna toracica - 1 min"},
  {"nombre":"Elongacion de trapecios sobre pelota","vt":"Cabeza deja caer, manos sueltas - 30 seg"}
]'::jsonb, 9),

('esferodinamia','Esfero Elongacion Total','[
  {"nombre":"Elongacion lumbar sobre pelota","vt":"Abdomen sobre pelota, brazos y piernas cuelgan - 1 min"},
  {"nombre":"Apertura toracica sobre pelota","vt":"Pelota bajo escapulas, brazos en cruz - 1 min"},
  {"nombre":"Elongacion de psoas con pelota","vt":"Rodilla en suelo, pie sobre pelota - 45 seg cada lado"},
  {"nombre":"Elongacion de isquiotibiales con pelota","vt":"Talon sobre pelota, columna larga, leve inclinacion - 40 seg cada lado"},
  {"nombre":"Flexion lateral sobre pelota","vt":"Costado sobre pelota, brazo arriba - 45 seg cada lado"},
  {"nombre":"Apertura de cadera en pelota","vt":"Sentada, un tobillo sobre rodilla contraria - 40 seg cada lado"},
  {"nombre":"Elongacion de cuadriceps con pelota","vt":"De pie, pie sobre pelota detras, cadera extendida - 30 seg cada lado"},
  {"nombre":"Relajacion total sobre pelota","vt":"Abdomen sobre pelota, ojos cerrados, respiracion libre - 2 min"}
]'::jsonb, 10),

('esferodinamia','Esfero Suelo Pelvico y Core Bajo','[
  {"nombre":"Sedestacion activa con pelota entre rodillas","vt":"Comprimir y soltar con la respiracion - 15 rep"},
  {"nombre":"Inclinacion pelvica sentada","vt":"Bascular adelante al exhalar, atras al inhalar - 12 rep"},
  {"nombre":"Puente de cadera con compresion de pelota","vt":"Pelota entre rodillas, comprimir al subir - 12 rep"},
  {"nombre":"Sentadilla lenta con pelota en pared","vt":"Bajar 4 tiempos, activar suelo pelvico al subir - 10 rep"},
  {"nombre":"Dead bug con pelota entre rodillas","vt":"Comprimir pelota durante todo el movimiento - 8 cada lado"},
  {"nombre":"Heel drop con pelota","vt":"Supino, pelota entre rodillas, bajar talones alternados - 10 cada lado"},
  {"nombre":"Mariposa sentada con pelota","vt":"Pelota en manos presionada contra pecho, plantas de pies juntas - 40 seg"},
  {"nombre":"Respiracion diafragmatica en pelota","vt":"Manos en costillas, expansion lateral - 10 respiraciones"}
]'::jsonb, 11),

('esferodinamia','Esfero Respiracion y Relajacion','[
  {"nombre":"Rebote suave con respiracion","vt":"Ritmo del rebote igual ritmo respiratorio - 2 min"},
  {"nombre":"Respiracion diafragmatica en pelota","vt":"Manos en costillas, exhalar largo - 8 respiraciones"},
  {"nombre":"Ondulacion de columna sentada","vt":"Caida hacia adelante al exhalar, subir al inhalar - 8 rep"},
  {"nombre":"Rotacion lenta con respiracion","vt":"Exhalar al rotar, inhalar al centrar - 6 cada lado"},
  {"nombre":"Apertura toracica sobre pelota","vt":"Respirar expandiendo pecho, sin tension - 1 min"},
  {"nombre":"Elongacion lateral con respiracion","vt":"Exhalar al profundizar la elongacion - 5 cada lado"},
  {"nombre":"Balanceo prono sobre pelota","vt":"Abdomen sobre pelota, balancear suavemente - 1 min"},
  {"nombre":"Relajacion total sobre pelota","vt":"Brazos y piernas sueltos, cierre de clase - 3 min"}
]'::jsonb, 12),

('esferodinamia','Esfero Rehabilitacion Lumbar','[
  {"nombre":"Inclinacion pelvica sentada","vt":"Sin rango forzado, movimiento minimo y consciente - 10 rep"},
  {"nombre":"Cat-cow con manos en pelota","vt":"Lento, sin dolor, rango libre - 8 rep"},
  {"nombre":"Elongacion lumbar sobre pelota","vt":"Dejar caer el peso, respirar - 1 min"},
  {"nombre":"Puente de cadera con pies en pelota","vt":"Solo subir a neutro, sin hiperextender - 10 rep"},
  {"nombre":"Rotacion de tronco sentada","vt":"Rango minimo, sin compensar con cadera - 6 cada lado"},
  {"nombre":"Sedestacion activa con pelota entre rodillas","vt":"Activar transverso suavemente - 15 rep"},
  {"nombre":"Extension de espalda sobre pelota","vt":"Rango muy pequenyo, sin forzar columna baja - 8 rep"},
  {"nombre":"Apertura toracica sobre pelota","vt":"Foco en movilizar toracica, lumbar apoyada - 1 min"}
]'::jsonb, 13);
