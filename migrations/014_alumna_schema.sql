-- 014: alumna schema - auth link, photo, payment notices, push subscriptions

ALTER TABLE triskel_alumnas
  ADD COLUMN IF NOT EXISTS auth_user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS foto_url text;

CREATE INDEX IF NOT EXISTS idx_alumnas_auth_user ON triskel_alumnas(auth_user_id);

-- Payment notices: alumna reports payment, teacher approves
CREATE TABLE IF NOT EXISTS triskel_avisos_pago (
  id          serial PRIMARY KEY,
  alumna_id   integer NOT NULL REFERENCES triskel_alumnas(id) ON DELETE CASCADE,
  mes         text NOT NULL,                   -- 'YYYY-MM'
  monto_declarado numeric,
  nota        text,
  estado      text NOT NULL DEFAULT 'pendiente', -- 'pendiente' | 'aprobado' | 'rechazado'
  created_at  timestamptz DEFAULT now(),
  updated_at  timestamptz DEFAULT now(),
  UNIQUE(alumna_id, mes)
);

CREATE INDEX IF NOT EXISTS idx_avisos_estado ON triskel_avisos_pago(estado);
CREATE INDEX IF NOT EXISTS idx_avisos_alumna ON triskel_avisos_pago(alumna_id);

-- Web Push subscriptions (browser PushSubscription JSON)
CREATE TABLE IF NOT EXISTS triskel_push_subscriptions (
  id          serial PRIMARY KEY,
  user_id     uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  subscription jsonb NOT NULL,
  tipo        text NOT NULL DEFAULT 'alumna',   -- 'alumna' | 'teacher'
  updated_at  timestamptz DEFAULT now(),
  UNIQUE(user_id)
);

CREATE INDEX IF NOT EXISTS idx_push_tipo ON triskel_push_subscriptions(tipo);
