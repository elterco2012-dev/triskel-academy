-- 032: Soporte multi-dispositivo para push subscriptions
-- Problema: UNIQUE(user_id) permite solo 1 dispositivo por usuario.
-- Solución: unicidad por (user_id, endpoint) para que cada dispositivo tenga su fila.

-- 1. Quitar la constraint vieja
ALTER TABLE triskel_push_subscriptions
  DROP CONSTRAINT IF EXISTS triskel_push_subscriptions_user_id_key;

-- 2. Crear índice único por (user_id, endpoint del dispositivo)
CREATE UNIQUE INDEX IF NOT EXISTS idx_push_user_endpoint
  ON triskel_push_subscriptions(user_id, (subscription->>'endpoint'));

-- 3. Actualizar la función para hacer upsert por dispositivo (no por usuario)
CREATE OR REPLACE FUNCTION triskel_save_push_subscription(p_subscription jsonb, p_tipo text DEFAULT 'alumna')
RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE v_uid uuid := auth.uid();
BEGIN
  IF v_uid IS NULL THEN RETURN jsonb_build_object('ok',false,'msg','not authenticated'); END IF;
  IF triskel_is_alumna() THEN
    p_tipo := 'alumna';
  END IF;
  INSERT INTO triskel_push_subscriptions(user_id, subscription, tipo, updated_at)
  VALUES(v_uid, p_subscription, p_tipo, now())
  ON CONFLICT(user_id, (subscription->>'endpoint')) DO UPDATE
    SET subscription=EXCLUDED.subscription, tipo=EXCLUDED.tipo, updated_at=now();
  RETURN jsonb_build_object('ok',true);
END;
$$;
GRANT EXECUTE ON FUNCTION triskel_save_push_subscription(jsonb, text) TO authenticated;
