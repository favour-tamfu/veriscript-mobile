-- Processed bucket: holds converted files written by the cloudconvert-webhook
-- edge function. The webhook uploads via the service role to the path
-- `<userId>/<jobId>.<format>`, so reads are authorized by the first folder
-- segment (the owner column is null for service-role uploads).

insert into storage.buckets (id, name, public)
values ('processed', 'processed', false)
on conflict (id) do nothing;

-- Authenticated users may read only their own converted files (signed URLs).
create policy "processed_bucket_read_own"
on storage.objects
for select
to authenticated
using (
  bucket_id = 'processed'
  and (storage.foldername(name))[1] = auth.uid()::text
);
