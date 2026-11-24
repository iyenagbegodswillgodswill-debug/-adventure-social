-- Adventure owner member account controls.
-- Restriction state is private and all changes are enforced and audited server-side.
create table if not exists private.member_account_controls (
  user_id uuid primary key references auth.users(id) on delete cascade,
  status text not null check (status in ('restricted','suspended')),
  reason text not null check (length(trim(reason)) between 3 and 1000),
  expires_at timestamptz,
  updated_by uuid not null references auth.users(id),
  updated_at timestamptz not null default now()
);
create index if not exists member_account_controls_expiry_idx on private.member_account_controls (expires_at) where expires_at is not null;
alter table private.member_account_controls enable row level security;
revoke all on private.member_account_controls from public, anon, authenticated, service_role;

create or replace function private.admin_list_members(p_limit integer default 200)
returns table (id uuid, username text, display_name text, country text, is_discoverable boolean, created_at timestamptz, account_status text, restriction_reason text, restriction_expires_at timestamptz)
language plpgsql stable security definer set search_path = pg_catalog, private, public
as $function$
begin
  if not private.is_admin() then raise exception 'Owner access required' using errcode = '42501'; end if;
  return query
    select p.id,p.username,p.display_name,p.country,p.is_discoverable,p.created_at,
      case when c.user_id is null or (c.expires_at is not null and c.expires_at <= now()) then 'active' else c.status end,
      case when c.expires_at is not null and c.expires_at <= now() then null else c.reason end,
      c.expires_at
    from public.profiles p left join private.member_account_controls c on c.user_id=p.id
    order by p.created_at desc limit greatest(1,least(coalesce(p_limit,200),500));
end;
$function$;
revoke all on function private.admin_list_members(integer) from public, anon;
grant execute on function private.admin_list_members(integer) to authenticated;

create or replace function public.admin_list_members(p_limit integer default 200)
returns table (id uuid, username text, display_name text, country text, is_discoverable boolean, created_at timestamptz, account_status text, restriction_reason text, restriction_expires_at timestamptz)
language sql stable security invoker set search_path = pg_catalog, private
as $function$ select * from private.admin_list_members(p_limit); $function$;
revoke all on function public.admin_list_members(integer) from public, anon;
grant execute on function public.admin_list_members(integer) to authenticated;

create or replace function private.admin_set_member_status(p_user_id uuid,p_status text,p_reason text default null,p_expires_at timestamptz default null)
returns void language plpgsql security definer set search_path = pg_catalog, private, public
as $function$
declare previous_status text;
begin
  if not private.is_admin() then raise exception 'Owner access required' using errcode = '42501'; end if;
  if p_user_id is null or p_user_id=auth.uid() then raise exception 'Invalid member account target' using errcode = '22023'; end if;
  if p_status is null or p_status not in ('active','restricted','suspended') then raise exception 'Status must be active, restricted, or suspended' using errcode = '22023'; end if;
  if not exists(select 1 from public.profiles p where p.id=p_user_id) then raise exception 'Member profile not found' using errcode = 'P0002'; end if;
  select case when c.user_id is null or (c.expires_at is not null and c.expires_at<=now()) then 'active' else c.status end
    into previous_status from (select p_user_id as user_id) target left join private.member_account_controls c on c.user_id=target.user_id;
  if p_status='active' then
    delete from private.member_account_controls where user_id=p_user_id;
  else
    if p_reason is null or length(trim(p_reason))<3 or length(p_reason)>1000 then raise exception 'A reason between 3 and 1000 characters is required' using errcode = '22023'; end if;
    if p_expires_at is not null and p_expires_at<=now() then raise exception 'Expiry must be in the future' using errcode = '22023'; end if;
    insert into private.member_account_controls(user_id,status,reason,expires_at,updated_by,updated_at)
      values(p_user_id,p_status,trim(p_reason),p_expires_at,auth.uid(),now())
      on conflict(user_id) do update set status=excluded.status,reason=excluded.reason,expires_at=excluded.expires_at,updated_by=excluded.updated_by,updated_at=now();
  end if;
  insert into private.admin_audit_log(actor_id,action,target_type,target_id,details)
    values(auth.uid(),case when p_status='active' then 'member_reinstated' else 'member_'||p_status end,'member',p_user_id,
      jsonb_build_object('from',coalesce(previous_status,'active'),'to',p_status,'reason',case when p_status='active' then null else trim(p_reason) end,'expires_at',case when p_status='active' then null else p_expires_at end));
end;
$function$;
revoke all on function private.admin_set_member_status(uuid,text,text,timestamptz) from public, anon, authenticated;
grant execute on function private.admin_set_member_status(uuid,text,text,timestamptz) to authenticated;

create or replace function public.admin_set_member_status(p_user_id uuid,p_status text,p_reason text default null,p_expires_at timestamptz default null)
returns void language sql security invoker set search_path = pg_catalog, private
as $function$ select private.admin_set_member_status(p_user_id,p_status,p_reason,p_expires_at); $function$;
revoke all on function public.admin_set_member_status(uuid,text,text,timestamptz) from public, anon;
grant execute on function public.admin_set_member_status(uuid,text,text,timestamptz) to authenticated;
