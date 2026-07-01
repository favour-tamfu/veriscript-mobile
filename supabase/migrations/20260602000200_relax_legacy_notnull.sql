-- Phase 2 moved the app onto documents.type / documents.storage_path and
-- conversion_jobs.to_format, but the legacy NOT NULL columns the app no longer
-- populates (documents.kind, conversion_jobs.target_format) were left in place.
-- That made every document/job insert fail before the conversion or scan
-- pipeline could even start. Relax them, matching what phase 2 already did for
-- conversion_jobs.source_filename.
ALTER TABLE public.documents
  ALTER COLUMN kind DROP NOT NULL;

ALTER TABLE public.conversion_jobs
  ALTER COLUMN target_format DROP NOT NULL;
