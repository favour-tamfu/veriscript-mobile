-- usage_quotas was created before Phase 2 with the counter columns
-- (scans_used, conversions_used, ocr_used, chars_translated, period_start) but
-- WITHOUT created_at/updated_at. The increment_scans_used RPC sets updated_at,
-- so every scan failed with "column updated_at does not exist" (42703).
-- Add the timestamps, guarantee a unique user_id for the upsert RPCs, and add
-- the conversion / translation counter RPCs the app calls.
ALTER TABLE public.usage_quotas
  ADD COLUMN IF NOT EXISTS created_at timestamptz NOT NULL DEFAULT timezone('utc', now()),
  ADD COLUMN IF NOT EXISTS updated_at timestamptz NOT NULL DEFAULT timezone('utc', now());

CREATE UNIQUE INDEX IF NOT EXISTS usage_quotas_user_id_uidx
  ON public.usage_quotas (user_id);

CREATE OR REPLACE FUNCTION public.increment_conversions_used(p_user_id uuid)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  INSERT INTO public.usage_quotas (user_id, conversions_used)
  VALUES (p_user_id, 1)
  ON CONFLICT (user_id) DO UPDATE
    SET conversions_used = usage_quotas.conversions_used + 1,
        updated_at = timezone('utc', now());
END;
$$;

CREATE OR REPLACE FUNCTION public.increment_chars_translated(p_user_id uuid, p_chars int)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  INSERT INTO public.usage_quotas (user_id, chars_translated)
  VALUES (p_user_id, p_chars)
  ON CONFLICT (user_id) DO UPDATE
    SET chars_translated = usage_quotas.chars_translated + p_chars,
        updated_at = timezone('utc', now());
END;
$$;
