create table if not exists public.support_tickets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  subject text not null check (char_length(btrim(subject)) between 5 and 160),
  category text not null check (category in ('account','safety','bug','marketplace','messages_calls','payments_future','other')),
  description text not null check (char_length(btrim(description)) between 10 and 4000),
  status text not null default 'open' check (status in ('open','in_progress','waiting_on_member','resolved','closed')),
  priority text not null default 'normal' check (priority in ('low','normal','high','urgent')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  resolved_at timestamptz
);
create index if not exists support_tickets_user_updated_idx on public.support_tickets(user_id, updated_at desc);
create index if not exists support_tickets_status_updated_idx on public.support_tickets(status, updated_at desc);
create table if not exists public.support_ticket_messages (
  id uuid primary key default gen_random_uuid(),
  ticket_id uuid not null references public.support_tickets(id) on delete cascade,
  sender_id uuid not null references auth.users(id) on delete cascade,
  body text not null check (char_length(btrim(body)) between 1 and 4000),
  created_at timestamptz not null default now()
);
create index if not exists support_ticket_messages_ticket_created_idx on public.support_ticket_messages(ticket_id, created_at);
alter table public.support_tickets enable row level security;
alter table public.support_ticket_messages enable row level security;
grant select, insert, update on public.support_tickets to authenticated;
grant select, insert on public.support_ticket_messages to authenticated;
create policy "Members read own tickets and owner reads all" on public.support_tickets for select to authenticated using (user_id = (select auth.uid()) or (select private.is_admin()));
create policy "Active members create own support tickets" on public.support_tickets for insert to authenticated with check (user_id = (select auth.uid()) and (select private.member_can_interact((select auth.uid()))));
create policy "Owner updates support ticket status" on public.support_tickets for update to authenticated using ((select private.is_admin())) with check ((select private.is_admin()));
create policy "Ticket participants read support messages" on public.support_ticket_messages for select to authenticated using (exists (select 1 from public.support_tickets t where t.id = ticket_id and (t.user_id = (select auth.uid()) or (select private.is_admin()))));
create policy "Ticket participants send support messages" on public.support_ticket_messages for insert to authenticated with check (sender_id = (select auth.uid()) and exists (select 1 from public.support_tickets t where t.id = ticket_id and t.status not in ('resolved','closed') and (t.user_id = (select auth.uid()) or (select private.is_admin()))));
create or replace function private.touch_support_ticket() returns trigger language plpgsql security definer set search_path = '' as $$
begin
 update public.support_tickets set updated_at=now(), status=case
  when new.sender_id <> user_id and status='open' then 'in_progress'
  when new.sender_id = user_id and status='waiting_on_member' then 'in_progress'
  else status end where id=new.ticket_id;
 return new;
end; $$;
revoke all on function private.touch_support_ticket() from public, anon, authenticated;
create trigger support_message_touch_ticket after insert on public.support_ticket_messages for each row execute function private.touch_support_ticket();
comment on table public.support_tickets is 'Private Adventure customer support cases; readable only by ticket owner and designated platform owner.';
comment on table public.support_ticket_messages is 'Private messages attached to Adventure support tickets.';
