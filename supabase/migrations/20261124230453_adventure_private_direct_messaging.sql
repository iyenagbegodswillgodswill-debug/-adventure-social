create table public.direct_conversations (
  id uuid primary key default gen_random_uuid(),
  participant_one uuid not null references public.profiles(id) on delete cascade,
  participant_two uuid not null references public.profiles(id) on delete cascade,
  created_by uuid not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  last_message_at timestamptz not null default now(),
  constraint direct_conversations_distinct_members check (participant_one <> participant_two),
  constraint direct_conversations_ordered_members check (participant_one < participant_two),
  constraint direct_conversations_pair_unique unique (participant_one, participant_two)
);
create index direct_conversations_one_recent_idx on public.direct_conversations(participant_one,last_message_at desc);
create index direct_conversations_two_recent_idx on public.direct_conversations(participant_two,last_message_at desc);
alter table public.direct_conversations enable row level security;
revoke all on public.direct_conversations from anon, authenticated;
grant select on public.direct_conversations to authenticated;
create policy "Members read only their direct conversations"
on public.direct_conversations for select to authenticated
using ((select auth.uid()) in (participant_one, participant_two));

create table public.direct_messages (
  id uuid primary key default gen_random_uuid(),
  conversation_id uuid not null references public.direct_conversations(id) on delete cascade,
  sender_id uuid not null references public.profiles(id) on delete cascade,
  body text not null check (char_length(trim(body)) between 1 and 2000),
  created_at timestamptz not null default now()
);
create index direct_messages_conversation_created_idx on public.direct_messages(conversation_id,created_at desc);
create index direct_messages_sender_created_idx on public.direct_messages(sender_id,created_at desc);
alter table public.direct_messages enable row level security;
revoke all on public.direct_messages from anon, authenticated;
grant select, insert on public.direct_messages to authenticated;
create policy "Members read messages in their conversations"
on public.direct_messages for select to authenticated
using (exists (
  select 1 from public.direct_conversations c
  where c.id=conversation_id and (select auth.uid()) in (c.participant_one,c.participant_two)
));
create policy "Active members send messages in their conversations"
on public.direct_messages for insert to authenticated
with check (
  sender_id=(select auth.uid())
  and (select private.member_can_interact((select auth.uid())))
  and exists (
    select 1 from public.direct_conversations c
    where c.id=conversation_id
      and (select auth.uid()) in (c.participant_one,c.participant_two)
      and not (select private.is_blocked_with(case when c.participant_one=(select auth.uid()) then c.participant_two else c.participant_one end))
  )
);

create or replace function private.start_direct_conversation_core(p_other_user uuid)
returns uuid
language plpgsql
security definer
set search_path=pg_catalog,public,private
as $$
declare
  v_user uuid := auth.uid();
  v_one uuid;
  v_two uuid;
  v_conversation uuid;
begin
  if v_user is null then raise exception 'Sign-in required' using errcode='42501'; end if;
  if p_other_user is null or p_other_user=v_user then raise exception 'Choose another Adventurer' using errcode='22023'; end if;
  if not private.member_can_interact(v_user) then raise exception 'Your account cannot send messages right now' using errcode='42501'; end if;
  if private.is_blocked_with(p_other_user) then raise exception 'Messaging is unavailable between these accounts' using errcode='42501'; end if;
  if not exists (
    select 1 from public.profiles p
    where p.id=p_other_user and p.is_discoverable=true
      and not private.member_is_suspended(p.id)
  ) then raise exception 'This profile is not available for new conversations' using errcode='P0002'; end if;

  if v_user < p_other_user then v_one:=v_user; v_two:=p_other_user;
  else v_one:=p_other_user; v_two:=v_user; end if;

  insert into public.direct_conversations(participant_one,participant_two,created_by)
  values(v_one,v_two,v_user)
  on conflict(participant_one,participant_two) do update
    set last_message_at=public.direct_conversations.last_message_at
  returning id into v_conversation;
  return v_conversation;
end;
$$;
revoke all on function private.start_direct_conversation_core(uuid) from public,anon,authenticated;
grant execute on function private.start_direct_conversation_core(uuid) to authenticated;

create or replace function public.start_direct_conversation(p_other_user uuid)
returns uuid
language sql
security invoker
set search_path=pg_catalog,private
as $$ select private.start_direct_conversation_core(p_other_user); $$;
revoke all on function public.start_direct_conversation(uuid) from public,anon;
grant execute on function public.start_direct_conversation(uuid) to authenticated;

create or replace function private.guard_direct_message()
returns trigger
language plpgsql
security definer
set search_path=pg_catalog,public,private
as $$
declare v_other uuid; v_recent integer;
begin
  if new.sender_id is distinct from auth.uid() then
    raise exception 'Messages must be sent as the signed-in member' using errcode='42501';
  end if;
  if not private.member_can_interact(new.sender_id) then
    raise exception 'Your account cannot send messages right now' using errcode='42501';
  end if;
  select case when c.participant_one=new.sender_id then c.participant_two else c.participant_one end
    into v_other
  from public.direct_conversations c
  where c.id=new.conversation_id and new.sender_id in (c.participant_one,c.participant_two);
  if v_other is null or private.is_blocked_with(v_other) or private.member_is_suspended(v_other) then
    raise exception 'Messaging is unavailable for this conversation' using errcode='42501';
  end if;
  if char_length(trim(new.body)) not between 1 and 2000 then
    raise exception 'Message must be between 1 and 2000 characters' using errcode='22023';
  end if;
  perform pg_advisory_xact_lock(hashtextextended(new.sender_id::text,0));
  select count(*) into v_recent from public.direct_messages
  where sender_id=new.sender_id and created_at>now()-interval '1 minute';
  if v_recent>=20 then raise exception 'Please slow down before sending another message' using errcode='54000'; end if;
  new.body:=trim(new.body);
  return new;
end;
$$;
revoke all on function private.guard_direct_message() from public,anon,authenticated;
create trigger direct_messages_guard before insert on public.direct_messages
for each row execute function private.guard_direct_message();

create or replace function private.touch_direct_conversation()
returns trigger
language plpgsql
security definer
set search_path=pg_catalog,public
as $$
begin
  update public.direct_conversations set last_message_at=new.created_at where id=new.conversation_id;
  return new;
end;
$$;
revoke all on function private.touch_direct_conversation() from public,anon,authenticated;
create trigger direct_messages_touch_conversation after insert on public.direct_messages
for each row execute function private.touch_direct_conversation();

do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname='supabase_realtime' and schemaname='public' and tablename='direct_messages'
  ) then
    alter publication supabase_realtime add table public.direct_messages;
  end if;
end $$;
