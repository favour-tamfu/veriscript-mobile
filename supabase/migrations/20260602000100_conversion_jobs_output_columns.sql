-- Converter pipeline columns the edge functions write but the schema was
-- missing:
--   * external_job_id — set by `convert-file` to the CloudConvert job id
--   * output_path     — set by `cloudconvert-webhook` to the converted file's
--                       path in the `processed` bucket; read by the app to
--                       build the signed download URL
ALTER TABLE public.conversion_jobs
  ADD COLUMN IF NOT EXISTS external_job_id TEXT,
  ADD COLUMN IF NOT EXISTS output_path     TEXT;
