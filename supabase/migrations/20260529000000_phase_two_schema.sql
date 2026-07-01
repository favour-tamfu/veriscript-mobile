-- Phase 2: add missing columns, create scan_reports / usage_quotas tables,
-- add increment_scans_used RPC.

-- documents: add type and storage_path columns the app expects
ALTER TABLE public.documents
  ADD COLUMN IF NOT EXISTS type TEXT,
  ADD COLUMN IF NOT EXISTS storage_path TEXT;

-- conversion_jobs: add from_format / to_format; relax the NOT NULL on
-- source_filename so the app can insert without it
ALTER TABLE public.conversion_jobs
  ADD COLUMN IF NOT EXISTS from_format TEXT,
  ADD COLUMN IF NOT EXISTS to_format   TEXT,
  ALTER COLUMN source_filename DROP NOT NULL;

-- scan_reports
CREATE TABLE IF NOT EXISTS public.scan_reports (
  id               uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  document_id      uuid        REFERENCES public.documents(id) ON DELETE CASCADE,
  user_id          uuid        NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  status           text        NOT NULL DEFAULT 'pending',
  similarity_pct   numeric,
  sources          text,
  report_pdf_url   text,
  external_scan_id text,
  created_at       timestamptz NOT NULL DEFAULT timezone('utc', now())
);

ALTER TABLE public.scan_reports ENABLE ROW LEVEL SECURITY;

CREATE POLICY "scan_reports_manage_own"
  ON public.scan_reports FOR ALL TO authenticated
  USING  (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE INDEX IF NOT EXISTS idx_scan_reports_document
  ON public.scan_reports(document_id);

CREATE INDEX IF NOT EXISTS idx_scan_reports_external_id
  ON public.scan_reports(external_scan_id);

-- usage_quotas
CREATE TABLE IF NOT EXISTS public.usage_quotas (
  id         uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    uuid        NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
  scans_used int         NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT timezone('utc', now()),
  updated_at timestamptz NOT NULL DEFAULT timezone('utc', now())
);

ALTER TABLE public.usage_quotas ENABLE ROW LEVEL SECURITY;

CREATE POLICY "usage_quotas_read_own"
  ON public.usage_quotas FOR SELECT TO authenticated
  USING (auth.uid() = user_id);

-- Auto-create a usage_quotas row when a new user is created
CREATE OR REPLACE FUNCTION public.handle_new_user_quota()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
  INSERT INTO public.usage_quotas (user_id)
  VALUES (NEW.id)
  ON CONFLICT (user_id) DO NOTHING;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_created_quota ON auth.users;
CREATE TRIGGER on_auth_user_created_quota
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user_quota();

-- Upsert scans_used counter (used by increment_scans_used RPC)
CREATE OR REPLACE FUNCTION public.increment_scans_used(p_user_id uuid)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  INSERT INTO public.usage_quotas (user_id, scans_used)
  VALUES (p_user_id, 1)
  ON CONFLICT (user_id) DO UPDATE
    SET scans_used = usage_quotas.scans_used + 1,
        updated_at = timezone('utc', now());
END;
$$;
