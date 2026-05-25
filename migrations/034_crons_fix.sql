-- 034: Fix crons de recordatorio de pago + agregar cron de cumpleaños
--
-- ANTES DE EJECUTAR: reemplazá PEGAR_SERVICE_ROLE_KEY_AQUI con tu service_role key.
-- La encontrás en: Supabase Dashboard → Settings → API → "service_role" (la key larga).

-- ── 1. Función de recordatorio de pago (versión definitiva) ──────────────────
CREATE OR REPLACE FUNCTION triskel_send_payment_reminders()
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  v_edge_url  text    := 'https://dplzkrdgnynyyunmrawr.supabase.co/functions/v1/send-push';
  v_key       text    := 'PEGAR_SERVICE_ROLE_KEY_AQUI';
  v_mes       text    := to_char(now() AT TIME ZONE 'America/Argentina/Buenos_Aires', 'YYYY-MM');
  v_today     integer := extract(day from now() AT TIME ZONE 'America/Argentina/Buenos_Aires')::integer;
  rec         record;
BEGIN
  FOR rec IN
    SELECT DISTINCT a.nombre, a.auth_user_id, a.dia_pago
    FROM triskel_alumnas a
    WHERE a.auth_user_id IS NOT NULL
      AND a.estado = 'activa'
      AND (
        a.dia_pago = v_today
        OR (a.dia_pago IS NOT NULL AND a.dia_pago + 5 = v_today)
      )
      AND EXISTS (
        SELECT 1 FROM triskel_inscripciones i
        WHERE i.alumna_id = a.id AND i.activa = true
      )
      AND NOT EXISTS (
        SELECT 1 FROM triskel_pagos p
        WHERE p.alumna_id = a.id AND p.mes = v_mes AND p.pagado = true
      )
      AND NOT EXISTS (
        SELECT 1 FROM triskel_avisos_pago av
        WHERE av.alumna_id = a.id AND av.mes = v_mes
          AND av.estado IN ('aprobado', 'pendiente')
      )
  LOOP
    PERFORM net.http_post(
      url     := v_edge_url,
      headers := jsonb_build_object(
        'Content-Type',  'application/json',
        'Authorization', 'Bearer ' || v_key
      ),
      body    := jsonb_build_object(
        'tipo',           'recordatorio_pago',
        'target_user_id', rec.auth_user_id::text,
        'nombre',         rec.nombre,
        'mes',            v_mes
      )
    );
  END LOOP;
END;
$$;

-- ── 2. Función de cumpleaños ──────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION triskel_send_birthday_reminders()
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  v_edge_url  text := 'https://dplzkrdgnynyyunmrawr.supabase.co/functions/v1/send-push';
  v_key       text := 'PEGAR_SERVICE_ROLE_KEY_AQUI';
  v_today     date := (now() AT TIME ZONE 'America/Argentina/Buenos_Aires')::date;
  rec         record;
BEGIN
  FOR rec IN
    SELECT a.nombre
    FROM triskel_alumnas a
    WHERE a.fecha_nacimiento IS NOT NULL
      AND a.estado = 'activa'
      AND extract(month from a.fecha_nacimiento) = extract(month from v_today)
      AND extract(day   from a.fecha_nacimiento) = extract(day   from v_today)
  LOOP
    PERFORM net.http_post(
      url     := v_edge_url,
      headers := jsonb_build_object(
        'Content-Type',  'application/json',
        'Authorization', 'Bearer ' || v_key
      ),
      body    := jsonb_build_object(
        'tipo',        'cumpleanos',
        'target_tipo', 'teacher',
        'nombre',      rec.nombre
      )
    );
  END LOOP;
END;
$$;

-- ── 3. Reprogramar crons ──────────────────────────────────────────────────────
DO $$ BEGIN
  PERFORM cron.unschedule('triskel-payment-reminders');
EXCEPTION WHEN OTHERS THEN NULL;
END $$;

SELECT cron.schedule(
  'triskel-payment-reminders',
  '0 12 * * *',
  'SELECT triskel_send_payment_reminders()'
);

DO $$ BEGIN
  PERFORM cron.unschedule('triskel-cumpleanos');
EXCEPTION WHEN OTHERS THEN NULL;
END $$;

SELECT cron.schedule(
  'triskel-cumpleanos',
  '0 11 * * *',
  'SELECT triskel_send_birthday_reminders()'
);

-- Verificar: SELECT jobname, schedule FROM cron.job WHERE jobname LIKE 'triskel-%';
