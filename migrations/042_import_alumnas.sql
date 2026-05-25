-- 042: Importación masiva de alumnas desde Excel
-- Generado automáticamente. Revisar antes de ejecutar.

DO $$
DECLARE
  v_id  integer;
  v_hid integer;
BEGIN

  -- ── Uma Gomez ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Uma',
    p_apellido           := 'Gomez',
    p_tel                := '5491171191005',
    p_email              := 'gomezuma2010@gmail.com',
    p_dni                := '50415207',
    p_fecha_nacimiento   := '2010-07-17',
    p_dia_pago           := 2,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='funcional' AND dia='vie' AND hora_inicio='09:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: funcional vie 09:00 para Uma Gomez';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='funcional' AND dia='lun' AND hora_inicio='19:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: funcional lun 19:00 para Uma Gomez';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='funcional' AND dia='mie' AND hora_inicio='19:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: funcional mie 19:00 para Uma Gomez';
  END IF;

  -- ── Anita Cerrato ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Anita',
    p_apellido           := 'Cerrato',
    p_tel                := '5491122987759',
    p_email              := 'anitacerrato24@gmail.com',
    p_dni                := '44241485',
    p_fecha_nacimiento   := '2003-02-24',
    p_dia_pago           := 1,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='funcional' AND dia='vie' AND hora_inicio='09:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: funcional vie 09:00 para Anita Cerrato';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='funcional' AND dia='lun' AND hora_inicio='19:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: funcional lun 19:00 para Anita Cerrato';
  END IF;

  -- ── Luciana Perez ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Luciana',
    p_apellido           := 'Perez',
    p_tel                := '5491133516590',
    p_email              := 'lucianavanesaperez1982@gmail.com',
    p_dni                := '29292122',
    p_fecha_nacimiento   := '1982-03-04',
    p_dia_pago           := 2,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='funcional' AND dia='vie' AND hora_inicio='09:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: funcional vie 09:00 para Luciana Perez';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='funcional' AND dia='lun' AND hora_inicio='19:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: funcional lun 19:00 para Luciana Perez';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='funcional' AND dia='mie' AND hora_inicio='19:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: funcional mie 19:00 para Luciana Perez';
  END IF;

  -- ── Isabel Da Luz Fernandez ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Isabel',
    p_apellido           := 'Da Luz Fernandez',
    p_tel                := '5491139305716',
    p_email              := NULL,
    p_dni                := '11917553',
    p_fecha_nacimiento   := '1955-03-28',
    p_dia_pago           := 6,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='lun' AND hora_inicio='09:15' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer lun 09:15 para Isabel Da Luz Fernandez';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='mie' AND hora_inicio='09:15' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer mie 09:15 para Isabel Da Luz Fernandez';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='funcional' AND dia='vie' AND hora_inicio='09:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: funcional vie 09:00 para Isabel Da Luz Fernandez';
  END IF;

  -- ── Lara Bolea ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Lara',
    p_apellido           := 'Bolea',
    p_tel                := '5492226684077',
    p_email              := 'lara.bolea17@gmail.com',
    p_dni                := '42323024',
    p_fecha_nacimiento   := '2000-06-17',
    p_dia_pago           := 13,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='mat' AND dia='jue' AND hora_inicio='18:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: mat jue 18:00 para Lara Bolea';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='mat' AND dia='lun' AND hora_inicio='18:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: mat lun 18:00 para Lara Bolea';
  END IF;

  -- ── Flavia Giselle Becker ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Flavia',
    p_apellido           := 'Giselle Becker',
    p_tel                := '5491154165929',
    p_email              := 'flaviabecker81@hotmail.com',
    p_dni                := '28862311',
    p_fecha_nacimiento   := '1981-05-09',
    p_dia_pago           := 19,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='mar' AND hora_inicio='17:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer mar 17:00 para Flavia Giselle Becker';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='jue' AND hora_inicio='17:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer jue 17:00 para Flavia Giselle Becker';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='mat' AND dia='mar' AND hora_inicio='09:15' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: mat mar 09:15 para Flavia Giselle Becker';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='mat' AND dia='jue' AND hora_inicio='09:15' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: mat jue 09:15 para Flavia Giselle Becker';
  END IF;

  -- ── Maria Villavicencio ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Maria',
    p_apellido           := 'Villavicencio',
    p_tel                := '5491162361607',
    p_email              := 'maritavillavicencio@hotmail.com',
    p_dni                := '24824149',
    p_fecha_nacimiento   := '1975-09-18',
    p_dia_pago           := 4,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='lun' AND hora_inicio='10:15' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer lun 10:15 para Maria Villavicencio';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='mie' AND hora_inicio='10:15' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer mie 10:15 para Maria Villavicencio';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='mat' AND dia='mar' AND hora_inicio='09:15' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: mat mar 09:15 para Maria Villavicencio';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='mat' AND dia='jue' AND hora_inicio='09:15' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: mat jue 09:15 para Maria Villavicencio';
  END IF;

  -- ── Gabriela Perez ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Gabriela',
    p_apellido           := 'Perez',
    p_tel                := '5491154505264',
    p_email              := 'gvperez@hotmail.com',
    p_dni                := '24819252',
    p_fecha_nacimiento   := '1975-08-09',
    p_dia_pago           := 22,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='funcional' AND dia='vie' AND hora_inicio='09:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: funcional vie 09:00 para Gabriela Perez';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='lun' AND hora_inicio='08:15' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer lun 08:15 para Gabriela Perez';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='mie' AND hora_inicio='08:15' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer mie 08:15 para Gabriela Perez';
  END IF;

  -- ── Stephanie Pintos Pelayo ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Stephanie',
    p_apellido           := 'Pintos Pelayo',
    p_tel                := '5491121836473',
    p_email              := 'stephaniepintosp@gmail.com',
    p_dni                := '93939434',
    p_fecha_nacimiento   := '1987-10-31',
    p_dia_pago           := 2,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='mat' AND dia='mie' AND hora_inicio='18:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: mat mie 18:00 para Stephanie Pintos Pelayo';
  END IF;

  -- ── Magali Avril Pighetti Becker ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Magali',
    p_apellido           := 'Avril Pighetti Becker',
    p_tel                := '5491159970641',
    p_email              := 'magalipighettibecker@gmail.com',
    p_dni                := '51509591',
    p_fecha_nacimiento   := '2011-11-23',
    p_dia_pago           := 19,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='mar' AND hora_inicio='17:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer mar 17:00 para Magali Avril Pighetti Becker';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='jue' AND hora_inicio='17:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer jue 17:00 para Magali Avril Pighetti Becker';
  END IF;

  -- ── Catalina Ezcurra ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Catalina',
    p_apellido           := 'Ezcurra',
    p_tel                := '5491128504537',
    p_email              := 'catalinaezcurra@gmail.com',
    p_dni                := '49959524',
    p_fecha_nacimiento   := '2009-12-14',
    p_dia_pago           := 13,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='mar' AND hora_inicio='18:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer mar 18:00 para Catalina Ezcurra';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='jue' AND hora_inicio='18:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer jue 18:00 para Catalina Ezcurra';
  END IF;

  -- ── Paula Velasco ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Paula',
    p_apellido           := 'Velasco',
    p_tel                := '5492226683406',
    p_email              := 'paulavelasco55@gmail.com',
    p_dni                := '40425555',
    p_fecha_nacimiento   := '1998-01-26',
    p_dia_pago           := 27,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='lun' AND hora_inicio='09:15' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer lun 09:15 para Paula Velasco';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='mie' AND hora_inicio='09:15' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer mie 09:15 para Paula Velasco';
  END IF;

  -- ── Julieta Cornador ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Julieta',
    p_apellido           := 'Cornador',
    p_tel                := '5491156391897',
    p_email              := 'julieta.cornador@gmail.com',
    p_dni                := '39353563',
    p_fecha_nacimiento   := '1995-12-05',
    p_dia_pago           := 3,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='mar' AND hora_inicio='18:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer mar 18:00 para Julieta Cornador';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='jue' AND hora_inicio='18:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer jue 18:00 para Julieta Cornador';
  END IF;

  -- ── Lucia Cesar ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Lucia',
    p_apellido           := 'Cesar',
    p_tel                := '5491169706698',
    p_email              := 'lucia.cesar@gmail.com',
    p_dni                := '38960016',
    p_fecha_nacimiento   := '1996-03-27',
    p_dia_pago           := 8,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='lun' AND hora_inicio='08:15' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer lun 08:15 para Lucia Cesar';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='mie' AND hora_inicio='08:15' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer mie 08:15 para Lucia Cesar';
  END IF;

  -- ── Karen Juarez ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Karen',
    p_apellido           := 'Juarez',
    p_tel                := '5491127719314',
    p_email              := 'miaajuarez7@gmail.com',
    p_dni                := '38948989',
    p_fecha_nacimiento   := '1995-12-02',
    p_dia_pago           := 3,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='mar' AND hora_inicio='18:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer mar 18:00 para Karen Juarez';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='jue' AND hora_inicio='18:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer jue 18:00 para Karen Juarez';
  END IF;

  -- ── Julieta Larrosa ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Julieta',
    p_apellido           := 'Larrosa',
    p_tel                := '5492226685112',
    p_email              := 'julietasollarrosa@gmail.com',
    p_dni                := '38150986',
    p_fecha_nacimiento   := '1994-05-10',
    p_dia_pago           := 14,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='mar' AND hora_inicio='10:15' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer mar 10:15 para Julieta Larrosa';
  END IF;

  -- ── Micaela Aguilar ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Micaela',
    p_apellido           := 'Aguilar',
    p_tel                := '5491151330302',
    p_email              := 'micaaguilar57@gmail.com',
    p_dni                := '36542717',
    p_fecha_nacimiento   := '1992-06-14',
    p_dia_pago           := 18,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='funcional' AND dia='lun' AND hora_inicio='19:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: funcional lun 19:00 para Micaela Aguilar';
  END IF;

  -- ── Silvina Canosa Sanchez ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Silvina',
    p_apellido           := 'Canosa Sanchez',
    p_tel                := '5491156914976',
    p_email              := 'scanosasanchez@abc.gov.com',
    p_dni                := '33027872',
    p_fecha_nacimiento   := '1987-04-18',
    p_dia_pago           := 25,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='mie' AND hora_inicio='10:15' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer mie 10:15 para Silvina Canosa Sanchez';
  END IF;

  -- ── Sol Penín ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Sol',
    p_apellido           := 'Penín',
    p_tel                := '5491136528889',
    p_email              := 'solpenin@gmail.com',
    p_dni                := '31646680',
    p_fecha_nacimiento   := '1985-02-02',
    p_dia_pago           := 8,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='funcional' AND dia='lun' AND hora_inicio='19:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: funcional lun 19:00 para Sol Penín';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='funcional' AND dia='mie' AND hora_inicio='19:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: funcional mie 19:00 para Sol Penín';
  END IF;

  -- ── Soledad Garavano ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Soledad',
    p_apellido           := 'Garavano',
    p_tel                := '5491140469912',
    p_email              := 'soledad.garavano@gmail.com',
    p_dni                := '31415455',
    p_fecha_nacimiento   := '1985-01-25',
    p_dia_pago           := 3,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='mar' AND hora_inicio='18:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer mar 18:00 para Soledad Garavano';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='jue' AND hora_inicio='18:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer jue 18:00 para Soledad Garavano';
  END IF;

  -- ── Natalia Baldomero ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Natalia',
    p_apellido           := 'Baldomero',
    p_tel                := '5492226442749',
    p_email              := 'nataliabaldomero@gmail.com',
    p_dni                := '28867235',
    p_fecha_nacimiento   := '1981-07-22',
    p_dia_pago           := 6,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='lun' AND hora_inicio='09:15' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer lun 09:15 para Natalia Baldomero';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='mie' AND hora_inicio='09:15' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer mie 09:15 para Natalia Baldomero';
  END IF;

  -- ── Gabriela Billordo ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Gabriela',
    p_apellido           := 'Billordo',
    p_tel                := '5491153472466',
    p_email              := 'bil.gabriela@gmail.com',
    p_dni                := '28098760',
    p_fecha_nacimiento   := '1980-05-03',
    p_dia_pago           := 12,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='mat' AND dia='lun' AND hora_inicio='18:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: mat lun 18:00 para Gabriela Billordo';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='mat' AND dia='mie' AND hora_inicio='18:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: mat mie 18:00 para Gabriela Billordo';
  END IF;

  -- ── Ximena Luque ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Ximena',
    p_apellido           := 'Luque',
    p_tel                := '5491123008388',
    p_email              := 'draximenaluque@gmail.com',
    p_dni                := '27089514',
    p_fecha_nacimiento   := '1978-12-15',
    p_dia_pago           := 9,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='mie' AND hora_inicio='09:15' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer mie 09:15 para Ximena Luque';
  END IF;

  -- ── Priscila Sanz ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Priscila',
    p_apellido           := 'Sanz',
    p_tel                := '5491131721419',
    p_email              := 'priscilasanz79@gmail.com',
    p_dni                := '26589330',
    p_fecha_nacimiento   := '1979-05-01',
    p_dia_pago           := 7,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='mat' AND dia='lun' AND hora_inicio='18:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: mat lun 18:00 para Priscila Sanz';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='mat' AND dia='mie' AND hora_inicio='18:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: mat mie 18:00 para Priscila Sanz';
  END IF;

  -- ── Lidia Bianciotto ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Lidia',
    p_apellido           := 'Bianciotto',
    p_tel                := '5493515727265',
    p_email              := 'lbianciotto2014@gmail.com',
    p_dni                := '26168614',
    p_fecha_nacimiento   := '1977-10-31',
    p_dia_pago           := 2,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='mat' AND dia='lun' AND hora_inicio='18:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: mat lun 18:00 para Lidia Bianciotto';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='mat' AND dia='mie' AND hora_inicio='18:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: mat mie 18:00 para Lidia Bianciotto';
  END IF;

  -- ── Paola Bilello ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Paola',
    p_apellido           := 'Bilello',
    p_tel                := '5492226688468',
    p_email              := 'polibilello@yahoo.com.ar',
    p_dni                := '26044345',
    p_fecha_nacimiento   := '1977-06-20',
    p_dia_pago           := 12,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='mar' AND hora_inicio='10:15' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer mar 10:15 para Paola Bilello';
  END IF;

  -- ── Martha Alberto ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Martha',
    p_apellido           := 'Alberto',
    p_tel                := '5491161906208',
    p_email              := 'marthu06@gmail.com',
    p_dni                := '24844729',
    p_fecha_nacimiento   := '1976-03-06',
    p_dia_pago           := 2,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='mat' AND dia='mar' AND hora_inicio='09:15' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: mat mar 09:15 para Martha Alberto';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='mat' AND dia='jue' AND hora_inicio='09:15' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: mat jue 09:15 para Martha Alberto';
  END IF;

  -- ── Stella Maris Samorano ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Stella',
    p_apellido           := 'Maris Samorano',
    p_tel                := '5492226531146',
    p_email              := 'estelasamorano@hotmail.com',
    p_dni                := '23830977',
    p_fecha_nacimiento   := '1974-08-13',
    p_dia_pago           := 28,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='jue' AND hora_inicio='16:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer jue 16:00 para Stella Maris Samorano';
  END IF;

  -- ── Marcela Rasquetti ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Marcela',
    p_apellido           := 'Rasquetti',
    p_tel                := '5492226474013',
    p_email              := 'marcelarasquetti@gmail.com',
    p_dni                := '23568659',
    p_fecha_nacimiento   := '1974-02-13',
    p_dia_pago           := 26,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='mar' AND hora_inicio='17:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer mar 17:00 para Marcela Rasquetti';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='jue' AND hora_inicio='17:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer jue 17:00 para Marcela Rasquetti';
  END IF;

  -- ── Claudia Soriano ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Claudia',
    p_apellido           := 'Soriano',
    p_tel                := '5492226552325',
    p_email              := 'claucasares586@gmail.com',
    p_dni                := '22696426',
    p_fecha_nacimiento   := '1972-04-09',
    p_dia_pago           := 4,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='lun' AND hora_inicio='09:15' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer lun 09:15 para Claudia Soriano';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='mie' AND hora_inicio='09:15' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer mie 09:15 para Claudia Soriano';
  END IF;

  -- ── Mónica Coronel ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Mónica',
    p_apellido           := 'Coronel',
    p_tel                := '5492226517205',
    p_email              := 'monicacoronel165@gmail.com',
    p_dni                := '20555211',
    p_fecha_nacimiento   := '1969-02-15',
    p_dia_pago           := 23,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='mat' AND dia='lun' AND hora_inicio='18:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: mat lun 18:00 para Mónica Coronel';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='mat' AND dia='mie' AND hora_inicio='18:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: mat mie 18:00 para Mónica Coronel';
  END IF;

  -- ── Veronica Iraola ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Veronica',
    p_apellido           := 'Iraola',
    p_tel                := '5491138626886',
    p_email              := 'veronicairaola2268@gmail.com',
    p_dni                := '20446005',
    p_fecha_nacimiento   := '1968-07-22',
    p_dia_pago           := 2,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='mat' AND dia='mar' AND hora_inicio='09:15' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: mat mar 09:15 para Veronica Iraola';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='mat' AND dia='jue' AND hora_inicio='09:15' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: mat jue 09:15 para Veronica Iraola';
  END IF;

  -- ── Analia Marcela Menakian ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Analia',
    p_apellido           := 'Marcela Menakian',
    p_tel                := '5492226607927',
    p_email              := 'analiamenakian@yahoo.com.ar',
    p_dni                := '18478185',
    p_fecha_nacimiento   := '1967-12-07',
    p_dia_pago           := 4,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='mar' AND hora_inicio='10:15' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer mar 10:15 para Analia Marcela Menakian';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='jue' AND hora_inicio='10:15' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer jue 10:15 para Analia Marcela Menakian';
  END IF;

  -- ── Mirta Amarilla ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Mirta',
    p_apellido           := 'Amarilla',
    p_tel                := '5491138702901',
    p_email              := 'mirta.amarilla2017@gmail.com',
    p_dni                := '18248516',
    p_fecha_nacimiento   := '1965-10-25',
    p_dia_pago           := 10,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='mat' AND dia='lun' AND hora_inicio='18:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: mat lun 18:00 para Mirta Amarilla';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='mat' AND dia='mie' AND hora_inicio='18:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: mat mie 18:00 para Mirta Amarilla';
  END IF;

  -- ── Fernanda Perez Armari ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Fernanda',
    p_apellido           := 'Perez Armari',
    p_tel                := '5491159930484',
    p_email              := 'ferperezarmari@gmail.com.ar',
    p_dni                := '17907070',
    p_fecha_nacimiento   := '1966-05-03',
    p_dia_pago           := 26,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='mar' AND hora_inicio='17:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer mar 17:00 para Fernanda Perez Armari';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='jue' AND hora_inicio='17:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer jue 17:00 para Fernanda Perez Armari';
  END IF;

  -- ── Silvia Laura Velazquez ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Silvia',
    p_apellido           := 'Laura Velazquez',
    p_tel                := '5492226490809',
    p_email              := 'silvialauravelazquez@gmail.com',
    p_dni                := '16910396',
    p_fecha_nacimiento   := '1964-06-30',
    p_dia_pago           := 1,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='mar' AND hora_inicio='16:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer mar 16:00 para Silvia Laura Velazquez';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='jue' AND hora_inicio='16:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer jue 16:00 para Silvia Laura Velazquez';
  END IF;

  -- ── Claudia Iraola ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Claudia',
    p_apellido           := 'Iraola',
    p_tel                := '5491161241942',
    p_email              := 'claudiairaola@gmail.com',
    p_dni                := '16910135',
    p_fecha_nacimiento   := '1965-01-18',
    p_dia_pago           := 3,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='mar' AND hora_inicio='16:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer mar 16:00 para Claudia Iraola';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='jue' AND hora_inicio='16:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer jue 16:00 para Claudia Iraola';
  END IF;

  -- ── Sandra Zampone ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Sandra',
    p_apellido           := 'Zampone',
    p_tel                := '5492226517518',
    p_email              := 'sandrazampone@yahoo.com.ar',
    p_dni                := '16527529',
    p_fecha_nacimiento   := '1963-10-08',
    p_dia_pago           := 24,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='mar' AND hora_inicio='10:15' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer mar 10:15 para Sandra Zampone';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='jue' AND hora_inicio='10:15' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer jue 10:15 para Sandra Zampone';
  END IF;

  -- ── Maria Andrea Bottero ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Maria',
    p_apellido           := 'Andrea Bottero',
    p_tel                := '5493402448210',
    p_email              := 'andreabottero2016@gmail.com',
    p_dni                := '16527522',
    p_fecha_nacimiento   := '1961-11-17',
    p_dia_pago           := 24,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='mar' AND hora_inicio='16:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer mar 16:00 para Maria Andrea Bottero';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='jue' AND hora_inicio='16:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer jue 16:00 para Maria Andrea Bottero';
  END IF;

  -- ── Adriana Iraola ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Adriana',
    p_apellido           := 'Iraola',
    p_tel                := '5492226682787',
    p_email              := 'adrianamonica2668@gmail.com',
    p_dni                := '16004904',
    p_fecha_nacimiento   := '1962-01-26',
    p_dia_pago           := 6,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='lun' AND hora_inicio='08:15' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer lun 08:15 para Adriana Iraola';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='mie' AND hora_inicio='08:15' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer mie 08:15 para Adriana Iraola';
  END IF;

  -- ── Irma Rosa Vilas ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Irma',
    p_apellido           := 'Rosa Vilas',
    p_tel                := '5492226515475',
    p_email              := NULL,
    p_dni                := '10796800',
    p_fecha_nacimiento   := '1944-06-19',
    p_dia_pago           := 3,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='mar' AND hora_inicio='17:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer mar 17:00 para Irma Rosa Vilas';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='jue' AND hora_inicio='17:00' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer jue 17:00 para Irma Rosa Vilas';
  END IF;

  -- ── Maria Cristina Garegnani ─────────────────────────────────────────
  SELECT triskel_save_alumna(
    p_nombre             := 'Maria',
    p_apellido           := 'Cristina Garegnani',
    p_tel                := '5492226553144',
    p_email              := NULL,
    p_dni                := '10091573',
    p_fecha_nacimiento   := '1951-11-19',
    p_dia_pago           := 10,
    p_estado             := 'activa'
  ) INTO v_id;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='mar' AND hora_inicio='10:15' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer mar 10:15 para Maria Cristina Garegnani';
  END IF;
  SELECT id INTO v_hid FROM triskel_horarios WHERE modalidad='reformer' AND dia='jue' AND hora_inicio='10:15' LIMIT 1;
  IF v_hid IS NOT NULL THEN
    INSERT INTO triskel_inscripciones(alumna_id,horario_id,precio,activa)
    VALUES(v_id,v_hid,0,true) ON CONFLICT DO NOTHING;
  ELSE RAISE WARNING 'Horario no encontrado: reformer jue 10:15 para Maria Cristina Garegnani';
  END IF;

END $$;

-- Verificar:
-- SELECT nombre, apellido, dni, email, dia_pago FROM triskel_alumnas ORDER BY nombre;