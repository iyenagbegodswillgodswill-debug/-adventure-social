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
