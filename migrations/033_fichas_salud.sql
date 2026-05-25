-- 033: Tabla y RPCs de fichas de salud de alumnas
-- Las funciones triskel_get_mi_ficha_salud y triskel_save_mi_ficha_salud
-- son usadas por alumna.html pero nunca se crearon como migración.

-- ── 1. Tabla ─────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS triskel_fichas_salud (
  id                       serial PRIMARY KEY,
  alumna_id                bigint NOT NULL REFERENCES triskel_alumnas(id) ON DELETE CASCADE,
  -- Datos personales
  dni                      text,
  celular_familiar         text,
  grupo_sanguineo          text,
  -- Objetivos
  objetivos                text,
  nivel_actividad_previo   text,
  como_llego               text,
  -- Hábitos
  cafe_por_dia             text,
  trabaja                  boolean,
  trabajo_de_pie           boolean,
  hs_sentada               text,
  camina_frecuencia        text,
  toma_alcohol             boolean,
  hs_sueno                 numeric,
  hace_dieta               boolean,
  -- Cuerpo y lesiones
  problemas_posturales     text,
  cirugias_lesiones        text,
  embarazo_postparto       text,
  dolor_cronico            text,
  -- Actividad y salud
  actividad_fisica         boolean,
  actividad_frecuencia     text,
  fumadora                 boolean,
  colesterol_alto          boolean,
  convulsiones             boolean,
  diabetes                 boolean,
  alergia_medicamento      text,
  toma_medicamento         text,
  afecciones_cardiacas     text,
  afecciones_respiratorias text,
  -- Información adicional
  datos_importantes        text,
  antecedentes_familiares  text,
  -- Timestamps
  created_at               timestamptz DEFAULT now(),
  updated_at               timestamptz DEFAULT now(),
  UNIQUE(alumna_id)
);

ALTER TABLE triskel_fichas_salud ENABLE ROW LEVEL SECURITY;

-- Alumna solo puede ver/editar su propia ficha
CREATE POLICY "own_ficha" ON triskel_fichas_salud
  FOR ALL TO authenticated
  USING (
    alumna_id = (
      SELECT id FROM triskel_alumnas WHERE auth_user_id = auth.uid() LIMIT 1
    )
  )
  WITH CHECK (
    alumna_id = (
      SELECT id FROM triskel_alumnas WHERE auth_user_id = auth.uid() LIMIT 1
    )
  );

-- ── 2. GET: devuelve la ficha de la alumna autenticada (null si no existe) ───
CREATE OR REPLACE FUNCTION triskel_get_mi_ficha_salud()
RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  v_alumna_id bigint;
  v_result    jsonb;
BEGIN
  SELECT id INTO v_alumna_id
  FROM triskel_alumnas
  WHERE auth_user_id = auth.uid()
  LIMIT 1;

  IF v_alumna_id IS NULL THEN RETURN NULL; END IF;

  SELECT row_to_json(f)::jsonb INTO v_result
  FROM triskel_fichas_salud f
  WHERE f.alumna_id = v_alumna_id;

  RETURN v_result; -- NULL si no tiene ficha todavía
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_get_mi_ficha_salud() TO authenticated;

-- ── 3. SAVE: upsert de la ficha de la alumna autenticada ─────────────────────
CREATE OR REPLACE FUNCTION triskel_save_mi_ficha_salud(
  p_dni                      text    DEFAULT NULL,
  p_celular_familiar         text    DEFAULT NULL,
  p_grupo_sanguineo          text    DEFAULT NULL,
  p_objetivos                text    DEFAULT NULL,
  p_nivel_actividad_previo   text    DEFAULT NULL,
  p_como_llego               text    DEFAULT NULL,
  p_cafe_por_dia             text    DEFAULT NULL,
  p_trabaja                  boolean DEFAULT NULL,
  p_trabajo_de_pie           boolean DEFAULT NULL,
  p_hs_sentada               text    DEFAULT NULL,
  p_camina_frecuencia        text    DEFAULT NULL,
  p_toma_alcohol             boolean DEFAULT NULL,
  p_hs_sueno                 numeric DEFAULT NULL,
  p_hace_dieta               boolean DEFAULT NULL,
  p_problemas_posturales     text    DEFAULT NULL,
  p_cirugias_lesiones        text    DEFAULT NULL,
  p_embarazo_postparto       text    DEFAULT NULL,
  p_dolor_cronico            text    DEFAULT NULL,
  p_actividad_fisica         boolean DEFAULT NULL,
  p_actividad_frecuencia     text    DEFAULT NULL,
  p_fumadora                 boolean DEFAULT NULL,
  p_colesterol_alto          boolean DEFAULT NULL,
  p_convulsiones             boolean DEFAULT NULL,
  p_diabetes                 boolean DEFAULT NULL,
  p_alergia_medicamento      text    DEFAULT NULL,
  p_toma_medicamento         text    DEFAULT NULL,
  p_afecciones_cardiacas     text    DEFAULT NULL,
  p_afecciones_respiratorias text    DEFAULT NULL,
  p_datos_importantes        text    DEFAULT NULL,
  p_antecedentes_familiares  text    DEFAULT NULL
)
RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  v_alumna_id bigint;
BEGIN
  SELECT id INTO v_alumna_id
  FROM triskel_alumnas
  WHERE auth_user_id = auth.uid()
  LIMIT 1;

  IF v_alumna_id IS NULL THEN
    RETURN jsonb_build_object('ok', false, 'msg', 'alumna no encontrada');
  END IF;

  INSERT INTO triskel_fichas_salud (
    alumna_id, dni, celular_familiar, grupo_sanguineo,
    objetivos, nivel_actividad_previo, como_llego,
    cafe_por_dia, trabaja, trabajo_de_pie, hs_sentada, camina_frecuencia,
    toma_alcohol, hs_sueno, hace_dieta,
    problemas_posturales, cirugias_lesiones, embarazo_postparto, dolor_cronico,
    actividad_fisica, actividad_frecuencia, fumadora, colesterol_alto,
    convulsiones, diabetes, alergia_medicamento, toma_medicamento,
    afecciones_cardiacas, afecciones_respiratorias,
    datos_importantes, antecedentes_familiares,
    updated_at
  ) VALUES (
    v_alumna_id, p_dni, p_celular_familiar, p_grupo_sanguineo,
    p_objetivos, p_nivel_actividad_previo, p_como_llego,
    p_cafe_por_dia, p_trabaja, p_trabajo_de_pie, p_hs_sentada, p_camina_frecuencia,
    p_toma_alcohol, p_hs_sueno, p_hace_dieta,
    p_problemas_posturales, p_cirugias_lesiones, p_embarazo_postparto, p_dolor_cronico,
    p_actividad_fisica, p_actividad_frecuencia, p_fumadora, p_colesterol_alto,
    p_convulsiones, p_diabetes, p_alergia_medicamento, p_toma_medicamento,
    p_afecciones_cardiacas, p_afecciones_respiratorias,
    p_datos_importantes, p_antecedentes_familiares,
    now()
  )
  ON CONFLICT (alumna_id) DO UPDATE SET
    dni                      = EXCLUDED.dni,
    celular_familiar         = EXCLUDED.celular_familiar,
    grupo_sanguineo          = EXCLUDED.grupo_sanguineo,
    objetivos                = EXCLUDED.objetivos,
    nivel_actividad_previo   = EXCLUDED.nivel_actividad_previo,
    como_llego               = EXCLUDED.como_llego,
    cafe_por_dia             = EXCLUDED.cafe_por_dia,
    trabaja                  = EXCLUDED.trabaja,
    trabajo_de_pie           = EXCLUDED.trabajo_de_pie,
    hs_sentada               = EXCLUDED.hs_sentada,
    camina_frecuencia        = EXCLUDED.camina_frecuencia,
    toma_alcohol             = EXCLUDED.toma_alcohol,
    hs_sueno                 = EXCLUDED.hs_sueno,
    hace_dieta               = EXCLUDED.hace_dieta,
    problemas_posturales     = EXCLUDED.problemas_posturales,
    cirugias_lesiones        = EXCLUDED.cirugias_lesiones,
    embarazo_postparto       = EXCLUDED.embarazo_postparto,
    dolor_cronico            = EXCLUDED.dolor_cronico,
    actividad_fisica         = EXCLUDED.actividad_fisica,
    actividad_frecuencia     = EXCLUDED.actividad_frecuencia,
    fumadora                 = EXCLUDED.fumadora,
    colesterol_alto          = EXCLUDED.colesterol_alto,
    convulsiones             = EXCLUDED.convulsiones,
    diabetes                 = EXCLUDED.diabetes,
    alergia_medicamento      = EXCLUDED.alergia_medicamento,
    toma_medicamento         = EXCLUDED.toma_medicamento,
    afecciones_cardiacas     = EXCLUDED.afecciones_cardiacas,
    afecciones_respiratorias = EXCLUDED.afecciones_respiratorias,
    datos_importantes        = EXCLUDED.datos_importantes,
    antecedentes_familiares  = EXCLUDED.antecedentes_familiares,
    updated_at               = now();

  RETURN jsonb_build_object('ok', true);
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_save_mi_ficha_salud(
  text,text,text,text,text,text,text,boolean,boolean,text,text,
  boolean,numeric,boolean,text,text,text,text,boolean,text,
  boolean,boolean,boolean,boolean,text,text,text,text,text,text
) TO authenticated;

NOTIFY pgrst, 'reload schema';
