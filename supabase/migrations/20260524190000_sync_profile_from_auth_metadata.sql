create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (
    id,
    full_name
  )
  values (
    new.id,
    coalesce(
      new.raw_user_meta_data ->> 'full_name',
      new.raw_user_meta_data ->> 'display_name'
    )
  )
  on conflict (id) do update
  set full_name = coalesce(
    public.profiles.full_name,
    excluded.full_name
  );

  return new;
end;
$$;

insert into public.profiles (
  id,
  full_name
)
select
  users.id,
  coalesce(
    users.raw_user_meta_data ->> 'full_name',
    users.raw_user_meta_data ->> 'display_name'
  )
from auth.users as users
on conflict (id) do update
set full_name = coalesce(
  public.profiles.full_name,
  excluded.full_name
);
