# Document Translation — Setup

`translate-document` does **layout-preserving** translation of PDF / Word / PowerPoint /
Excel / text files using Google Cloud Translation **Advanced (v3)**. Unlike the
text translator (`translate-text`, which uses a simple v2 API key), the document
API requires a **service account**, not an API key.

## What you need to do once

### 1. Enable the API
In the Google Cloud Console for your project:
- Enable **Cloud Translation API**.
- Make sure billing is enabled (document translation is billed **per page**).

### 2. Create a service account
- IAM & Admin → Service Accounts → **Create service account**.
- Grant it the role **Cloud Translation API User** (`roles/cloudtranslate.user`).
- Create a **JSON key** for it and download the file.

### 3. Add the JSON as a Supabase secret
The function reads the whole JSON from `GOOGLE_SERVICE_ACCOUNT_JSON`:

```bash
supabase secrets set GOOGLE_SERVICE_ACCOUNT_JSON="$(cat path/to/service-account.json)"
```

(Optional) override the region — document translation is **not** available in
`global`; it defaults to `us-central1`:

```bash
supabase secrets set GOOGLE_TRANSLATE_LOCATION=us-central1
```

### 4. Deploy
```bash
supabase functions deploy translate-document
```

`verify_jwt` stays **on** (the app calls it with the signed-in user's JWT), so no
`config.toml` entry is needed.

## How it flows
1. App uploads the source file to the `documents` storage bucket.
2. App calls `translate-document` with `{ storagePath, fileName, sourceLang, targetLang, userId }`.
3. Function downloads the bytes, calls Google v3 `translateDocument` (or
   `translateText` for `.txt`), and uploads the translated file to the
   `processed` bucket.
4. App downloads it with a signed URL — same pattern as the File Converter.

## Notes / follow-ups
- **Cost**: every document translation is billed per page by Google. This first
  version does **not** meter document translations against the free
  `chars_translated` quota — consider gating document translation to Plus users
  or adding a `doc_translations_used` counter if free-tier cost is a concern.
- Inline request size limit is ~20 MB; the app caps uploads at 10 MB.
- Supported inputs: `pdf`, `docx`, `pptx`, `xlsx`, `txt`. Scanned/image-only PDFs
  translate only the text layer Google can extract.
