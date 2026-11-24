-- Public, read-only wrapper for profile discovery suspension checks.
create or replace function public.member_is_suspended(p_user_id uuid)
returns boolean language sql stable security invoker set search_path = pg_catalog, private
as $function$ select private.member_is_suspended(p_user_id); $function$;
revoke all on function public.member_is_suspended(uuid) from public;
grant execute on function public.member_is_suspended(uuid) to anon, authenticated;

drop policy if exists "Discoverable active profiles visible unless either side blocked" on public.profiles;
create policy "Discoverable active profiles visible unless either side blocked" on public.profiles for select to anon, authenticated
using ((is_discoverable and not (select public.member_is_suspended(profiles.id)) and not (select private.is_blocked_with(profiles.id))) or (select auth.uid())=id or (select private.is_admin()));
