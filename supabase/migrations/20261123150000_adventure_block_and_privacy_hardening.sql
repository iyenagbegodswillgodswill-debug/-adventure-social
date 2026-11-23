-- Harden profile defaults and enforce block relationships in database policies.
alter table public.profiles alter column is_discoverable set default false;
update public.profiles set is_discoverable = false where created_at = updated_at;
create schema if not exists private;
revoke all on schema private from public;
grant usage on schema private to anon, authenticated;
create or replace function private.is_blocked_with(target_user_id uuid)
returns boolean language sql stable security definer set search_path = ''
as $$
  select case when (select auth.uid()) is null then false
    else exists (select 1 from public.blocks b
      where (b.blocker_id = (select auth.uid()) and b.blocked_id = target_user_id)
         or (b.blocker_id = target_user_id and b.blocked_id = (select auth.uid())))
  end;
$$;
revoke all on function private.is_blocked_with(uuid) from public;
grant execute on function private.is_blocked_with(uuid) to anon, authenticated;
drop policy "Discoverable profiles are public; owners can view themselves" on public.profiles;
create policy "Discoverable profiles visible unless either side blocked"
on public.profiles for select to anon, authenticated
using ((is_discoverable and not (select private.is_blocked_with(id))) or (select auth.uid()) = id);
drop policy "Users follow as themselves" on public.follows;
create policy "Users follow as themselves when neither side blocked"
on public.follows for insert to authenticated
with check ((select auth.uid()) = follower_id and not (select private.is_blocked_with(followed_id)));
create or replace function private.remove_follows_after_block()
returns trigger language plpgsql security definer set search_path = ''
as $$
begin
  delete from public.follows
  where (follower_id = new.blocker_id and followed_id = new.blocked_id)
     or (follower_id = new.blocked_id and followed_id = new.blocker_id);
  return new;
end;
$$;
revoke all on function private.remove_follows_after_block() from public;
create trigger on_adventure_block_remove_follows after insert on public.blocks
for each row execute function private.remove_follows_after_block();
