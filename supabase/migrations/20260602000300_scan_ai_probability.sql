-- AI content detection: store the Copyleaks AI probability (0-100) next to the
-- plagiarism similarity. Populated by copyleaks-webhook when the scan was
-- submitted with aiGeneratedText.detect = true.
ALTER TABLE public.scan_reports
  ADD COLUMN IF NOT EXISTS ai_probability numeric;
