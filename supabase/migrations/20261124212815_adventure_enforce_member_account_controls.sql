-- Enforce owner-applied member restrictions on existing member actions.
create or replace function private.member_can_interact(p_user_id uuid default auth.uid())
returns boolean language sql stable security definer set search_path = pg_catalog, private
as $function$
  select p_user_id is not null and not exists (
    select 1 from private.member_account_controls c
    where c.user_id=p_user_id and (c.expires_at is null or c.expires_at>now())
  );
$function$;
revoke all on function private.member_can_interact(uuid) from public, anon;
grant execute on function private.member_can_interact(uuid) to authenticated;

create or replace function private.member_is_suspended(p_user_id uuid)
returns boolean language sql stable security definer set search_path = pg_catalog, private
as $function$
  select exists (
    select 1 from private.member_account_controls c
    where c.user_id=p_user_id and c.status='suspended'
      and (c.expires_at is null or c.expires_at>now())
  );
$function$;
revoke all on function private.member_is_suspended(uuid) from public, anon;
grant execute on function private.member_is_suspended(uuid) to anon, authenticated;

drop policy if exists "Users update their own profile" on public.profiles;
create policy "Active members update their own profile" on public.profiles for update to authenticated
using ((select auth.uid())=id and (select private.member_can_interact((select auth.uid()))))
with check ((select auth.uid())=id and (select private.member_can_interact((select auth.uid()))));

drop policy if exists "Users follow as themselves when neither side blocked" on public.follows;
create policy "Active members follow as themselves when neither side blocked" on public.follows for insert to authenticated
with check ((select auth.uid())=follower_id and (select private.member_can_interact((select auth.uid()))) and not (select private.is_blocked_with(follows.followed_id)));

drop policy if exists "Users create blocks as themselves" on public.blocks;
create policy "Active members create blocks as themselves" on public.blocks for insert to authenticated
with check ((select auth.uid())=blocker_id and (select private.member_can_interact((select auth.uid()))));

drop policy if exists "Signed-in users can submit reports as themselves" on public.reports;
create policy "Active members can submit reports as themselves" on public.reports for insert to authenticated
with check ((select auth.uid())=reporter_id and (select private.member_can_interact((select auth.uid()))));

drop policy if exists "Discoverable profiles visible unless either side blocked" on public.profiles;
create policy "Discoverable active profiles visible unless either side blocked" on public.profiles for select to anon, authenticated
using ((is_discoverable and not (select private.member_is_suspended(profiles.id)) and not (select private.is_blocked_with(profiles.id))) or (select auth.uid())=id or (select private.is_admin()));

create index if not exists member_account_controls_updated_by_idx on private.member_account_controls(updated_by);
drop policy if exists "No direct access to member account controls" on private.member_account_controls;
create policy "No direct access to member account controls" on private.member_account_controls for all to public using (false) with check (false);
