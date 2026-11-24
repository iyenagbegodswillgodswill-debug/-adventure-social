-- Adventure owner-only administrator access.
-- The private registry accepts only the designated owner role, with at most one owner.
alter table private.admin_users drop constraint if exists admin_users_role_check;
alter table private.admin_users add constraint admin_users_role_check check (role = 'owner');
create unique index if not exists admin_users_single_owner_idx
  on private.admin_users (role) where role = 'owner';

create or replace function private.is_admin()
returns boolean
language sql
stable
security definer
set search_path to 'pg_catalog', 'private'
as $function$
  select exists (
    select 1 from private.admin_users a
    where a.user_id = auth.uid()
      and a.role = 'owner'
  );
$function$;

create or replace function private.can_review_reports()
returns boolean
language sql
stable
security definer
set search_path to 'pg_catalog', 'private'
as $function$
  select exists (
    select 1 from private.admin_users a
    where a.user_id = auth.uid()
      and a.role = 'owner'
  );
$function$;

revoke all on function private.admin_overview() from public, anon;
grant execute on function private.admin_overview() to authenticated;
revoke all on function private.admin_recent_activity(integer) from public, anon;
grant execute on function private.admin_recent_activity(integer) to authenticated;
revoke all on function public.admin_overview() from public, anon;
grant execute on function public.admin_overview() to authenticated;
revoke all on function public.admin_recent_activity(integer) from public, anon;
grant execute on function public.admin_recent_activity(integer) to authenticated;
