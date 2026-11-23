drop policy if exists "Administrators view all profiles" on public.profiles;
drop policy if exists "Discoverable profiles visible unless either side blocked" on public.profiles;
create policy "Discoverable profiles visible unless either side blocked" on public.profiles for select to anon, authenticated using ((is_discoverable and not (select private.is_blocked_with(profiles.id))) or (select auth.uid()) = id or (select private.is_admin()));
create index if not exists admin_users_granted_by_idx on private.admin_users (granted_by);
create index if not exists admin_audit_log_actor_id_idx on private.admin_audit_log (actor_id);