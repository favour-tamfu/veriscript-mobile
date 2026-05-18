create extension if not exists "pgcrypto";

create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  full_name text,
  preferred_locale text not null default 'en',
  plan text not null default 'free',
  created_at timestamptz not null default timezone('utc'::text, now()),
  updated_at timestamptz not null default timezone('utc'::text, now())
);

create table if not exists public.documents (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  name text not null,
  kind text not null,
  source_path text,
  target_format text,
  status text not null default 'pending',
  details text,
  remote_url text,
  created_at timestamptz not null default timezone('utc'::text, now()),
  updated_at timestamptz not null default timezone('utc'::text, now())
);

create table if not exists public.conversion_jobs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  document_id uuid references public.documents (id) on delete set null,
  source_filename text not null,
  source_object_path text,
  target_format text not null,
  status text not null default 'queued',
  error_message text,
  created_at timestamptz not null default timezone('utc'::text, now()),
  updated_at timestamptz not null default timezone('utc'::text, now())
);

create or replace function public.handle_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = timezone('utc'::text, now());
  return new;
end;
$$;

drop trigger if exists profiles_set_updated_at on public.profiles;
create trigger profiles_set_updated_at
before update on public.profiles
for each row execute function public.handle_updated_at();

drop trigger if exists documents_set_updated_at on public.documents;
create trigger documents_set_updated_at
before update on public.documents
for each row execute function public.handle_updated_at();

drop trigger if exists conversion_jobs_set_updated_at on public.conversion_jobs;
create trigger conversion_jobs_set_updated_at
before update on public.conversion_jobs
for each row execute function public.handle_updated_at();

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id)
  values (new.id)
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute procedure public.handle_new_user();

alter table public.profiles enable row level security;
alter table public.documents enable row level security;
alter table public.conversion_jobs enable row level security;

create policy "profiles_select_own"
on public.profiles
for select
to authenticated
using (auth.uid() = id);

create policy "profiles_update_own"
on public.profiles
for update
to authenticated
using (auth.uid() = id)
with check (auth.uid() = id);

create policy "documents_manage_own"
on public.documents
for all
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

create policy "conversion_jobs_manage_own"
on public.conversion_jobs
for all
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

insert into storage.buckets (id, name, public)
values ('documents', 'documents', false)
on conflict (id) do nothing;

create policy "documents_bucket_read_own"
on storage.objects
for select
to authenticated
using (bucket_id = 'documents' and owner = auth.uid());

create policy "documents_bucket_insert_own"
on storage.objects
for insert
to authenticated
with check (bucket_id = 'documents' and owner = auth.uid());

create policy "documents_bucket_update_own"
on storage.objects
for update
to authenticated
using (bucket_id = 'documents' and owner = auth.uid())
with check (bucket_id = 'documents' and owner = auth.uid());

create policy "documents_bucket_delete_own"
on storage.objects
for delete
to authenticated
using (bucket_id = 'documents' and owner = auth.uid());
