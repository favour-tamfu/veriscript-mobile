-- Add external_job_id to conversion_jobs for CloudConvert webhook matching
ALTER TABLE public.conversion_jobs ADD COLUMN IF NOT EXISTS external_job_id TEXT;
