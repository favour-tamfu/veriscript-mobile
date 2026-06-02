-- TEMPORARY: capture raw Copyleaks webhook payloads to diagnose 0% scores.
-- Dropped once the parser is confirmed against the real payload shape.
CREATE TABLE IF NOT EXISTS public.copyleaks_debug (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at timestamptz NOT NULL DEFAULT now(),
  path       text,
  body       text
);
