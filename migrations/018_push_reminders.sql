-- 018: Push reminders completos
-- Prerrequisitos (ejecutar UNA VEZ en SQL Editor si no están habilitadas):
--   CREATE EXTENSION IF NOT EXISTS pg_cron;
--   CREATE EXTENSION IF NOT EXISTS pg_net;

-- ── Función de recordatorio mejorada ─────────────────────────────────────────
-- Envía recordatorio en dia_pago y recordatorio de seguimiento en dia_pago+5
CREATE OR REPLACE FUNCTION triskel_send_payment_reminders()
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  v_edge_url  text    := 'https://dplzkrdgnynyyunmrawr.supabase.co/functions/v1/send-push';
  v_anon_key  text    := 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRwbHprcmRnbnlueXl1bm1yYXdyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzkwMjg2OTMsImV4cCI6MjA5NDYwNDY5M30.B-J4yJf1lnyR0isMeaCIKHeCCRd7mJe1Do-_6yxbVow';
  v_mes       text    := to_char(now() AT TIME ZONE 'America/Argentina/Buenos_Aires', 'YYYY-MM');
  v_today     integer := extract(day from now() AT TIME ZONE 'America/Argentina/Buenos_Aires')::integer;
  v_tipo      text;
  rec         record;
BEGIN
  FOR rec IN
    SELECT DISTINCT
      a.id          AS alumna_id,
      a.nombre,
      a.auth_user_id,
      a.dia_pago
    FROM triskel_alumnas a
    WHERE a.auth_user_id IS NOT NULL
      AND a.estado = 'activa'
      AND (
        -- primer recordatorio: en el dia_pago
        (a.dia_pago = v_today)
        OR
        -- segundo recordatorio: 5 días después del dia_pago
        (a.dia_pago IS NOT NULL AND a.dia_pago + 5 = v_today)
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
        WHERE av.alumna_id = a.id AND av.mes = v_mes AND av.estado = 'aprobado'
      )
  LOOP
    PERFORM net.http_post(
      url     := v_edge_url,
      headers := jsonb_build_object(
        'Content-Type',  'application/json',
        'Authorization', 'Bearer ' || v_anon_key
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

-- ── Programar el job diario (9am hora Argentina = 12:00 UTC) ─────────────────
-- Si ya existe un job anterior, lo reemplazamos
SELECT cron.unschedule('triskel-payment-reminders') WHERE EXISTS (
  SELECT 1 FROM cron.job WHERE jobname = 'triskel-payment-reminders'
);

SELECT cron.schedule(
  'triskel-payment-reminders',
  '0 12 * * *',
  'SELECT triskel_send_payment_reminders()'
);

-- Verificar: SELECT * FROM cron.job WHERE jobname='triskel-payment-reminders';
