-- Add external_scan_id to scan_reports for Copyleaks webhook matching
ALTER TABLE public.scan_reports
ADD COLUMN IF NOT EXISTS external_scan_id TEXT;

CREATE INDEX IF NOT EXISTS idx_scan_reports_external_id
ON public.scan_reports(external_scan_id);
