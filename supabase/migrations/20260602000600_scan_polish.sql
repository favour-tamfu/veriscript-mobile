-- Surface why a scan failed (e.g. Copyleaks "insufficient credits") so the app
-- can show a meaningful message instead of a misleading 0% report.
ALTER TABLE public.scan_reports
  ADD COLUMN IF NOT EXISTS error_message text;

-- Drop the temporary debug capture table (real payload shape confirmed).
DROP TABLE IF EXISTS public.copyleaks_debug;

-- Enable realtime on conversion_jobs so the converter screen receives live
-- status updates (scan_reports is already published, which is why scans update
-- on-screen but conversions didn't).
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables
    WHERE pubname = 'supabase_realtime'
      AND schemaname = 'public'
      AND tablename = 'conversion_jobs'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.conversion_jobs;
  END IF;
END $$;
