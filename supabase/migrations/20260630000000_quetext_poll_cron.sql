-- Enable pg_net (HTTP calls from SQL) and pg_cron (scheduled jobs).
-- Both are available on all Supabase projects; this just activates them.
CREATE EXTENSION IF NOT EXISTS pg_net  WITH SCHEMA extensions;
CREATE EXTENSION IF NOT EXISTS pg_cron WITH SCHEMA cron;

-- Grant cron usage to the postgres role (required by Supabase's pg_cron setup).
GRANT USAGE ON SCHEMA cron TO postgres;

-- ── Quetext-poll cron job ────────────────────────────────────────────────────
-- Calls the quetext-poll edge function every minute.
-- The service_role_key is read from Supabase Vault secret named
-- 'service_role_key'. Create it in:
--   Supabase Dashboard → Vault → New secret  (name: service_role_key)

-- Remove any previous version of this job (idempotent).
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM cron.job WHERE jobname = 'quetext-poll') THEN
    PERFORM cron.unschedule('quetext-poll');
  END IF;
END $$;

-- Schedule quetext-poll to run every minute.
SELECT cron.schedule(
  'quetext-poll',
  '* * * * *',
  $$
  SELECT
    net.http_post(
      url     := 'https://wzplvgcqopecyhaikqwn.supabase.co/functions/v1/quetext-poll',
      headers := jsonb_build_object(
        'Content-Type',  'application/json',
        'Authorization', 'Bearer ' || (
          SELECT decrypted_secret
          FROM vault.decrypted_secrets
          WHERE name = 'service_role_key'
          LIMIT 1
        )
      ),
      body    := '{}'::jsonb
    )
  $$
);
