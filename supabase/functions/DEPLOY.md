# Deploy Edge Functions

Run these commands from the project root after adding your API keys to Supabase secrets:

```bash
supabase functions deploy scan-document
supabase functions deploy copyleaks-webhook
supabase functions deploy translate-text
supabase functions deploy export-report-pdf
supabase functions deploy convert-file
supabase functions deploy cloudconvert-webhook
```

Verify deployment:
```bash
supabase functions list
```

Test scan-document locally first:
```bash
supabase functions serve scan-document --env-file .env.local
```

## Required secrets

```bash
supabase secrets set COPYLEAKS_KEY=your_key
supabase secrets set CLOUDCONVERT_KEY=your_key
supabase secrets set GOOGLE_TRANSLATE_KEY=your_key
supabase secrets set SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
```

Verify: `supabase secrets list` — all 4 keys must appear.
