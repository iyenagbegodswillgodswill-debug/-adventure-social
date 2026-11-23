-- Keep the initial admin system limited to the roles the current dashboard fully supports.
alter table private.admin_users drop constraint if exists admin_users_role_check;
alter table private.admin_users add constraint admin_users_role_check check (role in ('owner','moderator'));
create or replace function private.is_admin()
returns boolean language sql stable security definer set search_path = pg_catalog, private
as $$ select exists (select 1 from private.admin_users a where a.user_id = auth.uid() and a.role in ('owner','moderator')); $$;
revoke all on function private.is_admin() from public, anon;
grant execute on function private.is_admin() to anon, authenticated;
