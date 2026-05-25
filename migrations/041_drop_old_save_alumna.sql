-- 041: Eliminar la versión anterior de triskel_save_alumna (sin p_dni)
-- La ambigüedad entre la firma vieja (10 params) y la nueva (11 params) causa error
-- "Could not choose the best candidate function"

DROP FUNCTION IF EXISTS triskel_save_alumna(text,text,text,text,text,text,integer,date,integer,text);
