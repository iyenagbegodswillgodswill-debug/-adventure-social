drop trigger if exists on_adventure_auth_user_created on auth.users;
drop function if exists public.handle_new_adventure_user();
create or replace function private.handle_new_adventure_user()
returns trigger language plpgsql security definer set search_path = ''
as $$
begin
  insert into public.profiles (id, display_name)
  values (new.id, coalesce(nullif(left(trim(new.raw_user_meta_data ->> 'display_name'), 60), ''), 'New Adventurer'));
  return new;
end;
$$;
revoke all on function private.handle_new_adventure_user() from public, anon, authenticated;
create trigger on_adventure_auth_user_created after insert on auth.users
for each row execute function private.handle_new_adventure_user();
create index reports_reporter_id_idx on public.reports(reporter_id);
create index reports_reported_user_id_idx on public.reports(reported_user_id);
