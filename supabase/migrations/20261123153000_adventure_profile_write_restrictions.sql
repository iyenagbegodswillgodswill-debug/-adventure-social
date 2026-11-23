-- Restrict profile mutations to editable fields and keep timestamps server-controlled.
revoke insert, delete, update on public.profiles from authenticated;
grant select on public.profiles to anon, authenticated;
grant update (username, display_name, bio, country, interests, avatar_path, is_discoverable)
on public.profiles to authenticated;
drop policy if exists "Users create their own profile" on public.profiles;
drop policy if exists "Users delete their own profile" on public.profiles;
create or replace function private.set_profile_updated_at()
returns trigger language plpgsql set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;
revoke all on function private.set_profile_updated_at() from public;
create trigger on_adventure_profile_updated before update on public.profiles
for each row execute function private.set_profile_updated_at();
revoke all on function public.handle_new_adventure_user() from public;
