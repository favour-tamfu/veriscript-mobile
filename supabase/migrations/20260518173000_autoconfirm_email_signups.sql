update auth.users
set
  email_confirmed_at = coalesce(email_confirmed_at, timezone('utc'::text, now())),
  confirmed_at = coalesce(confirmed_at, timezone('utc'::text, now()))
where email_confirmed_at is null;

create or replace function public.handle_auth_user_autoconfirm()
returns trigger
language plpgsql
security definer
set search_path = auth, public
as $$
begin
  update auth.users
  set
    email_confirmed_at = coalesce(email_confirmed_at, timezone('utc'::text, now())),
    confirmed_at = coalesce(confirmed_at, timezone('utc'::text, now()))
  where id = new.id;

  return new;
end;
$$;

drop trigger if exists on_auth_user_autoconfirm on auth.users;
create trigger on_auth_user_autoconfirm
after insert on auth.users
for each row execute procedure public.handle_auth_user_autoconfirm();
