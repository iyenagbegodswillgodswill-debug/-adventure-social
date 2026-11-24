-- Private in-app notifications for follows, post reactions/comments and direct messages.
create table if not exists public.member_notifications(
 id uuid primary key default gen_random_uuid(),recipient_id uuid not null references auth.users(id) on delete cascade,
 actor_id uuid references public.profiles(id) on delete set null,
 kind text not null check(kind in ('follow','post_like','post_comment','direct_message')),
 entity_id uuid,is_read boolean not null default false,created_at timestamptz not null default now()
);
create index if not exists member_notifications_inbox_idx on public.member_notifications(recipient_id,created_at desc);
alter table public.member_notifications enable row level security;
revoke all on public.member_notifications from anon,authenticated;
grant select on public.member_notifications to authenticated;
grant update(is_read) on public.member_notifications to authenticated;
create policy member_notifications_read_own on public.member_notifications for select to authenticated using(recipient_id=auth.uid());
create policy member_notifications_mark_own_read on public.member_notifications for update to authenticated using(recipient_id=auth.uid()) with check(recipient_id=auth.uid());
create or replace function private.create_social_notification()
returns trigger language plpgsql security definer set search_path=pg_catalog,public,private as $$
declare v_recipient uuid; v_actor uuid; v_kind text; v_entity uuid;
begin
 if tg_table_name='follows' then
  v_recipient:=new.followed_id; v_actor:=new.follower_id; v_kind:='follow'; v_entity:=null;
 elsif tg_table_name='post_likes' then
  select p.author_id into v_recipient from public.posts p where p.id=new.post_id;
  v_actor:=new.user_id; v_kind:='post_like'; v_entity:=new.post_id;
 elsif tg_table_name='post_comments' then
  select p.author_id into v_recipient from public.posts p where p.id=new.post_id;
  v_actor:=new.author_id; v_kind:='post_comment'; v_entity:=new.post_id;
 elsif tg_table_name='direct_messages' then
  select case when c.participant_one=new.sender_id then c.participant_two else c.participant_one end into v_recipient
  from public.direct_conversations c where c.id=new.conversation_id;
  v_actor:=new.sender_id; v_kind:='direct_message'; v_entity:=new.conversation_id;
 else return new; end if;
 if v_recipient is not null and v_actor is not null and v_recipient<>v_actor then
  insert into public.member_notifications(recipient_id,actor_id,kind,entity_id) values(v_recipient,v_actor,v_kind,v_entity);
 end if;
 return new;
end; $$;
revoke all on function private.create_social_notification() from public,anon,authenticated;
create trigger notify_new_follow after insert on public.follows for each row execute function private.create_social_notification();
create trigger notify_post_like after insert on public.post_likes for each row execute function private.create_social_notification();
create trigger notify_post_comment after insert on public.post_comments for each row execute function private.create_social_notification();
create trigger notify_direct_message after insert on public.direct_messages for each row execute function private.create_social_notification();
