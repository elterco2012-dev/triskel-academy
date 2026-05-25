-- 031: Planes de Esferodinamia para triskel_banco_ejercicios
-- INSERT directo (no requiere auth context, ejecutar como postgres en SQL Editor)

INSERT INTO triskel_banco_ejercicios(categoria, titulo, ejs, orden) VALUES
('esferodinamia','Esfero Iniciación','[
  {"nombre":"Sedestación dinámica en pelota","vt":"Pies apoyados, columna larga, manos en muslos · 2 min"},
  {"nombre":"Marcha sentada en pelota","vt":"Alternar rodillas, ritmo suave · 40 seg"},
  {"nombre":"Círculos de cadera sobre pelota","vt":"Círculos amplios hacia ambos lados · 8 cada lado"},
  {"nombre":"Inclinación lateral sentada","vt":"Brazo estira hacia el techo, cadera firme · 8 cada lado"},
  {"nombre":"Rotación de tronco sentada","vt":"Manos en nuca, rotar lento mirando al costado · 8 cada lado"},
  {"nombre":"Puente de cadera con pies en pelota","vt":"Talones sobre pelota, subir y mantener 3 seg · 10 rep"},
  {"nombre":"Apertura torácica sobre pelota","vt":"Pelota bajo escápulas, brazos abiertos, cabeza apoyada · 30 seg"},
  {"nombre":"Elongación lumbar sobre pelota","vt":"Abdomen sobre pelota, brazos y piernas cuelgan · 30 seg"}
]'::jsonb, 0),

('esferodinamia','Esfero Movilidad Columna','[
  {"nombre":"Rebote suave sentada","vt":"Ritmo natural, activar transverso · 1 min"},
  {"nombre":"Flexión lateral sobre pelota","vt":"Un costado sobre pelota, brazo arriba · 30 seg cada lado"},
  {"nombre":"Cat-cow con manos en pelota","vt":"Manos sobre pelota, flexión y extensión de columna · 10 rep"},
  {"nombre":"Rotación con bajada lateral","vt":"Pelota frente al pecho, rotar y bajar al lado · 8 cada lado"},
  {"nombre":"Apertura torácica supina","vt":"Pelota bajo columna torácica, brazos en cruz · 40 seg"},
  {"nombre":"Rodamiento de pelota por columna","vt":"De pie, pelota entre espalda y pared, rodar suave · 1 min"},
  {"nombre":"Extensión de espalda sobre pelota","vt":"Cadera sobre pelota, manos en nuca, extender · 12 rep"},
  {"nombre":"Elongación de psoas con pelota","vt":"Rodilla en suelo, pie adelante sobre pelota · 30 seg cada lado"}
]'::jsonb, 1),

('esferodinamia','Esfero Core Profundo','[
  {"nombre":"Curl abdominal sobre pelota","vt":"Lumbar apoyada en pelota, subir lento · 15 rep"},
  {"nombre":"Dead bug con pelota entre rodillas","vt":"Prono, pelota entre rodillas, brazos extienden · 10 rep"},
  {"nombre":"Plancha con rodillas en pelota","vt":"Rodillas sobre pelota, cuerpo recto · 30 seg"},
  {"nombre":"Oblicuos sobre pelota","vt":"Pelota bajo costado, mano en nuca, elevar · 12 cada lado"},
  {"nombre":"Extensión bilateral en pelota","vt":"Abdomen sobre pelota, elevar brazos y piernas · 10 rep"},
  {"nombre":"Hollow hold con pelota","vt":"Supino, pelota entre pies, bajar piernas extendidas · 10 rep"},
  {"nombre":"Sedestación activa con pelota entre rodillas","vt":"Comprimir pelota pequeña, activar suelo pélvico · 20 seg"},
  {"nombre":"Roll-out en rodillas","vt":"Manos en pelota, extender hacia adelante · 10 rep"}
]'::jsonb, 2),

('esferodinamia','Esfero Piernas y Glúteos','[
  {"nombre":"Sentadilla con pelota en pared","vt":"Pelota entre espalda y pared, bajar a 90° · 15 rep"},
  {"nombre":"Puente en pelota con marcha","vt":"Talones sobre pelota, subir cadera y alternar rodillas · 10 rep"},
  {"nombre":"Estocada con mano en pelota","vt":"Pelota al costado como apoyo, estocada profunda · 10 cada lado"},
  {"nombre":"Extensión unilateral de cadera en pelota","vt":"Abdomen sobre pelota, elevar una pierna extendida · 12 cada lado"},
  {"nombre":"Curl de isquiotibiales en pelota","vt":"Supino, pies sobre pelota, flexionar rodillas hacia glúteos · 12 rep"},
  {"nombre":"Abducción lateral con pelota","vt":"Pelota entre rodilla y pared, elevar pierna libre · 15 cada lado"},
  {"nombre":"Sentadilla sumo con pelota frente al pecho","vt":"Pies abiertos, bajar lento, pelota de contrapeso · 12 rep"},
  {"nombre":"Puente unipodal con pelota","vt":"Un talón en pelota, el otro elevado · 10 cada lado"}
]'::jsonb, 3),

('esferodinamia','Esfero Equilibrio y Propiocepción','[
  {"nombre":"Equilibrio unipodal junto a pelota","vt":"Una mano apoyada en pelota, elevar rodilla contraria · 30 seg cada lado"},
  {"nombre":"Equilibrio prono en pelota","vt":"Abdomen sobre pelota, elevar manos del suelo · 20 seg"},
  {"nombre":"Marcha sobre pelota en decúbito","vt":"Pies sobre pelota, alternar elevaciones de pierna · 10 cada lado"},
  {"nombre":"Sentadilla con cierre de ojos","vt":"Pelota en pared, cerrar ojos al bajar · 10 rep"},
  {"nombre":"Plancha con pies en pelota","vt":"Pies sobre pelota, mantener posición · 30 seg"},
  {"nombre":"Zancada inversa con pelota","vt":"Pie trasero sobre pelota, bajar controlado · 10 cada lado"},
  {"nombre":"Lanzamiento y atrape de pelota en equilibrio","vt":"Un pie, lanzar y atrapar pelota pequeña · 15 rep cada lado"},
  {"nombre":"Equilibrio lateral en pelota","vt":"Costado sobre pelota, elevar cadera del suelo · 20 seg cada lado"}
]'::jsonb, 4),

('esferodinamia','Esfero Fuerza Funcional','[
  {"nombre":"Push up con manos en pelota","vt":"Palmas sobre pelota, descender al pecho · 12 rep"},
  {"nombre":"Pike con pelota (roll-out)","vt":"Pies en pelota, cadera al techo manteniendo piernas rectas · 10 rep"},
  {"nombre":"Flexiones declinadas con pies en pelota","vt":"Pies en pelota, manos en suelo · 10 rep"},
  {"nombre":"Curl de bíceps con pelota comprimida","vt":"Pelota pequeña entre palmas, comprimir al subir · 15 rep"},
  {"nombre":"Press de hombros sentada en pelota","vt":"Con mancuernas livianas, sentada activa · 15 rep"},
  {"nombre":"Remo prono sobre pelota","vt":"Abdomen en pelota, mancuernas hacia cadera · 12 rep"},
  {"nombre":"Sentadilla con salto desde pelota","vt":"Pies en pelota chata, sentadilla explosiva · 10 rep"},
  {"nombre":"Plancha a T con pelota","vt":"Una mano en pelota, rotar a plancha lateral · 8 cada lado"}
]'::jsonb, 5),

('esferodinamia','Esfero Circuito Completo','[
  {"nombre":"Rebote y marcha sentada","vt":"Calentamiento 2 min"},
  {"nombre":"Círculos de cadera + rotación tronco","vt":"8 cada lado"},
  {"nombre":"Sentadilla con pelota en pared","vt":"3 series · 12 rep"},
  {"nombre":"Curl abdominal sobre pelota","vt":"3 series · 15 rep"},
  {"nombre":"Puente en pelota con marcha","vt":"3 series · 10 rep"},
  {"nombre":"Plancha con rodillas en pelota","vt":"3 series · 30 seg"},
  {"nombre":"Extensión de espalda sobre pelota","vt":"2 series · 12 rep"},
  {"nombre":"Apertura torácica + elongación lumbar","vt":"Vuelta a la calma · 1 min cada una"}
]'::jsonb, 6),

('esferodinamia','Esfero Postparto','[
  {"nombre":"Sedestación dinámica en pelota","vt":"Columna larga, respiración profunda · 2 min"},
  {"nombre":"Rebote suave con respiración","vt":"Inhalar por nariz, exhalar por boca · 1 min"},
  {"nombre":"Círculos de cadera lentos","vt":"Amplios y conscientes, 6 cada lado"},
  {"nombre":"Inclinación pélvica sentada","vt":"Bascular pelvis adelante y atrás · 10 rep"},
  {"nombre":"Puente de cadera con pies en pelota","vt":"Activar glúteos y transverso, lento · 10 rep"},
  {"nombre":"Abducción lateral con pelota","vt":"Pelota entre rodilla y pared, suave · 12 cada lado"},
  {"nombre":"Cat-cow con manos en pelota","vt":"Movilizar columna sin forzar · 10 rep"},
  {"nombre":"Elongación lumbar sobre pelota","vt":"Abdomen sobre pelota, relajar completamente · 40 seg"}
]'::jsonb, 7),

('esferodinamia','Esfero Adultas Mayores','[
  {"nombre":"Sedestación dinámica en pelota","vt":"Sin tiempo límite · a ritmo propio"},
  {"nombre":"Marcha sentada en pelota","vt":"Manos en muslos como apoyo · 30 seg"},
  {"nombre":"Rotación de tronco sentada","vt":"Rango libre, sin forzar · 6 cada lado"},
  {"nombre":"Extensión de rodillas sentada","vt":"Una pierna a la vez, lento · 10 cada lado"},
  {"nombre":"Elevación de talones sentada","vt":"Talones al suelo y arriba alternando · 15 rep"},
  {"nombre":"Puente de cadera con pies en pelota","vt":"Manos en suelo como apoyo extra · 8 rep"},
  {"nombre":"Apertura torácica sobre pelota","vt":"Pelota bajo escápulas, respirar profundo · 40 seg"},
  {"nombre":"Elongación lateral sentada","vt":"Brazo sube por encima, lado a lado · 5 cada lado"}
]'::jsonb, 8),

('esferodinamia','Esfero Hombros y Espalda Alta','[
  {"nombre":"Rotación de hombros sobre pelota","vt":"Sentada, círculos amplios adelante y atrás · 8 cada dirección"},
  {"nombre":"Apertura de brazos sobre pelota","vt":"Pelota bajo espalda media, brazos en cruz · 40 seg"},
  {"nombre":"Press de hombros sentada en pelota","vt":"Con mancuernas livianas o sin carga · 15 rep"},
  {"nombre":"Remo prono sobre pelota","vt":"Abdomen en pelota, codos hacia techo · 12 rep"},
  {"nombre":"W-Y-T sobre pelota","vt":"Prono en pelota, formas de letras con brazos · 8 rep cada forma"},
  {"nombre":"Rotación externa de hombros en pelota","vt":"Codo apoyado en pelota, girar antebrazo · 12 cada lado"},
  {"nombre":"Apertura torácica con rodillo de pelota","vt":"Rodar pelota por columna torácica · 1 min"},
  {"nombre":"Elongación de trapecios sobre pelota","vt":"Cabeza deja caer, manos sueltas · 30 seg"}
]'::jsonb, 9),

('esferodinamia','Esfero Elongación Total','[
  {"nombre":"Elongación lumbar sobre pelota","vt":"Abdomen sobre pelota, brazos y piernas cuelgan · 1 min"},
  {"nombre":"Apertura torácica sobre pelota","vt":"Pelota bajo escápulas, brazos en cruz · 1 min"},
  {"nombre":"Elongación de psoas con pelota","vt":"Rodilla en suelo, pie sobre pelota · 45 seg cada lado"},
  {"nombre":"Elongación de isquiotibiales con pelota","vt":"Talón sobre pelota, columna larga, leve inclinación · 40 seg cada lado"},
  {"nombre":"Flexión lateral sobre pelota","vt":"Costado sobre pelota, brazo arriba · 45 seg cada lado"},
  {"nombre":"Apertura de cadera en pelota","vt":"Sentada, un tobillo sobre rodilla contraria · 40 seg cada lado"},
  {"nombre":"Elongación de cuádriceps con pelota","vt":"De pie, pie sobre pelota detrás, cadera extendida · 30 seg cada lado"},
  {"nombre":"Relajación total sobre pelota","vt":"Abdomen sobre pelota, ojos cerrados, respiración libre · 2 min"}
]'::jsonb, 10),

('esferodinamia','Esfero Suelo Pélvico y Core Bajo','[
  {"nombre":"Sedestación activa con pelota entre rodillas","vt":"Comprimir y soltar con la respiración · 15 rep"},
  {"nombre":"Inclinación pélvica sentada","vt":"Bascular adelante al exhalar, atrás al inhalar · 12 rep"},
  {"nombre":"Puente de cadera con compresión de pelota","vt":"Pelota entre rodillas, comprimir al subir · 12 rep"},
  {"nombre":"Sentadilla lenta con pelota en pared","vt":"Bajar 4 tiempos, activar suelo pélvico al subir · 10 rep"},
  {"nombre":"Dead bug con pelota entre rodillas","vt":"Comprimir pelota durante todo el movimiento · 8 cada lado"},
  {"nombre":"Heel drop con pelota","vt":"Supino, pelota entre rodillas, bajar talones alternados · 10 cada lado"},
  {"nombre":"Mariposa sentada con pelota","vt":"Pelota en manos presionada contra pecho, plantas de pies juntas · 40 seg"},
  {"nombre":"Respiración diafragmática en pelota","vt":"Manos en costillas, expansión lateral · 10 respiraciones"}
]'::jsonb, 11),

('esferodinamia','Esfero Respiración y Relajación','[
  {"nombre":"Rebote suave con respiración","vt":"Ritmo del rebote = ritmo respiratorio · 2 min"},
  {"nombre":"Respiración diafragmática en pelota","vt":"Manos en costillas, exhalar largo · 8 respiraciones"},
  {"nombre":"Ondulación de columna sentada","vt":"Caída hacia adelante al exhalar, subir al inhalar · 8 rep"},
  {"nombre":"Rotación lenta con respiración","vt":"Exhalar al rotar, inhalar al centrar · 6 cada lado"},
  {"nombre":"Apertura torácica sobre pelota","vt":"Respirar expandiendo pecho, sin tensión · 1 min"},
  {"nombre":"Elongación lateral con respiración","vt":"Exhalar al profundizar la elongación · 5 cada lado"},
  {"nombre":"Balanceo prono sobre pelota","vt":"Abdomen sobre pelota, balancear suavemente · 1 min"},
  {"nombre":"Relajación total sobre pelota","vt":"Brazos y piernas sueltos, cierre de clase · 3 min"}
]'::jsonb, 12),

('esferodinamia','Esfero Rehabilitación Lumbar','[
  {"nombre":"Inclinación pélvica sentada","vt":"Sin rango forzado, movimiento mínimo y consciente · 10 rep"},
  {"nombre":"Cat-cow con manos en pelota","vt":"Lento, sin dolor, rango libre · 8 rep"},
  {"nombre":"Elongación lumbar sobre pelota","vt":"Dejar caer el peso, respirar · 1 min"},
  {"nombre":"Puente de cadera con pies en pelota","vt":"Solo subir a neutro, sin hiperextender · 10 rep"},
  {"nombre":"Rotación de tronco sentada","vt":"Rango mínimo, sin compensar con cadera · 6 cada lado"},
  {"nombre":"Sedestación activa con pelota entre rodillas","vt":"Activar transverso suavemente · 15 rep"},
  {"nombre":"Extensión de espalda sobre pelota","vt":"Rango muy pequeño, sin forzar columna baja · 8 rep"},
  {"nombre":"Apertura torácica sobre pelota","vt":"Foco en movilizar torácica, lumbar apoyada · 1 min"}
]'::jsonb, 13);
