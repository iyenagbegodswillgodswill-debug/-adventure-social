create table if not exists private.ai_operations_runs (
  id uuid primary key default gen_random_uuid(),
  actor_id uuid references auth.users(id) on delete set null,
  operation text not null check (operation in ('daily_briefing','report_triage')),
  status text not null check (status in ('completed','failed')),
  model text,
  input_summary jsonb not null default '{}'::jsonb,
  output jsonb,
  error_code text,
  created_at timestamptz not null default now()
);
alter table private.ai_operations_runs enable row level security;
revoke all on private.ai_operations_runs from anon, authenticated, public;
create index if not exists ai_operations_runs_created_at_idx on private.ai_operations_runs(created_at desc);
create or replace function private.ai_operations_is_owner()
returns boolean language sql stable security definer set search_path = ''
as $$
  select exists (
    select 1 from private.admin_users a
    where a.user_id = (select auth.uid()) and a.role = 'owner'
  );
$$;
revoke all on function private.ai_operations_is_owner() from public, anon;
grant execute on function private.ai_operations_is_owner() to authenticated;

grant select on private.ai_operations_runs to authenticated;
create policy ai_operations_owner_read on private.ai_operations_runs for select to authenticated
using (private.ai_operations_is_owner());
create or replace function private.admin_ai_operations_recent(p_limit integer default 10)
returns table(id uuid, operation text, status text, model text, output jsonb, created_at timestamptz)
language plpgsql security definer set search_path = ''
as $$
begin
  if not private.ai_operations_is_owner() then raise exception 'owner access required' using errcode = '42501'; end if;
  return query select r.id,r.operation,r.status,r.model,r.output,r.created_at from private.ai_operations_runs r order by r.created_at desc limit greatest(1,least(coalesce(p_limit,10),50));
end;
$$;
revoke all on function private.admin_ai_operations_recent(integer) from public, anon;
grant execute on function private.admin_ai_operations_recent(integer) to authenticated;
create or replace function public.admin_ai_operations_recent(p_limit integer default 10)
returns table(id uuid, operation text, status text, model text, output jsonb, created_at timestamptz)
language sql stable security invoker set search_path = ''
as $$ select * from private.admin_ai_operations_recent(p_limit); $$;
revoke all on function public.admin_ai_operations_recent(integer) from public, anon;
grant execute on function public.admin_ai_operations_recent(integer) to authenticated;
