-- 016: pg_cron daily payment reminders
-- Prerequisites:
--   1. pg_cron extension enabled in Supabase (Dashboard > Database > Extensions)
--   2. pg_net extension enabled
--   3. Edge Function 'send-push' deployed
--   4. Replace EDGE_FUNCTION_URL with your actual project URL

-- Enable extensions (run manually in Supabase if not already done)
-- CREATE EXTENSION IF NOT EXISTS pg_cron;
-- CREATE EXTENSION IF NOT EXISTS pg_net;

-- Helper function: find alumnas whose payment is due today and send reminders
CREATE OR REPLACE FUNCTION triskel_send_payment_reminders()
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  v_edge_url text := 'https://dplzkrdgnynyyunmrawr.supabase.co/functions/v1/send-push';
  v_service_key text := current_setting('app.supabase_service_key', true);
  v_mes text := to_char(now(), 'YYYY-MM');
  v_today integer := extract(day from now())::integer;
  rec record;
BEGIN
  -- Find alumnas with dia_pago = today who haven't paid this month
  FOR rec IN
    SELECT DISTINCT
      a.id as alumna_id,
      a.nombre,
      a.apellido,
      a.auth_user_id,
      a.dia_pago
    FROM triskel_alumnas a
    WHERE a.dia_pago = v_today
      AND a.auth_user_id IS NOT NULL
      AND EXISTS (
        SELECT 1 FROM triskel_inscripciones i WHERE i.alumna_id=a.id AND i.activa=true
      )
      AND NOT EXISTS (
        SELECT 1 FROM triskel_pagos p
        WHERE p.alumna_id=a.id AND p.mes=v_mes AND p.pagado=true
      )
      AND NOT EXISTS (
        SELECT 1 FROM triskel_avisos_pago av
        WHERE av.alumna_id=a.id AND av.mes=v_mes AND av.estado='aprobado'
      )
  LOOP
    -- Call Edge Function to send push notification to this alumna
    PERFORM net.http_post(
      url := v_edge_url,
      headers := jsonb_build_object(
        'Content-Type', 'application/json',
        'Authorization', 'Bearer ' || v_service_key
      ),
      body := jsonb_build_object(
        'tipo', 'recordatorio_pago',
        'target_user_id', rec.auth_user_id,
        'nombre', rec.nombre,
        'mes', v_mes
      )
    );
  END LOOP;
END;
$$;

-- Schedule: runs daily at 9:00 AM UTC (adjust timezone as needed)
-- Note: run this after enabling pg_cron extension
-- SELECT cron.schedule(
--   'triskel-payment-reminders',
--   '0 12 * * *',   -- 9am Argentina time (UTC-3) = 12:00 UTC
--   'SELECT triskel_send_payment_reminders()'
-- );

-- To check scheduled jobs: SELECT * FROM cron.job;
-- To unschedule: SELECT cron.unschedule('triskel-payment-reminders');
