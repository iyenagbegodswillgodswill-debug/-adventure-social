drop policy if exists "Discoverable active profiles visible unless either side blocked" on public.profiles;
create policy "Discoverable profiles and followed private profiles are visible unless blocked" on public.profiles for select to anon,authenticated using (
 (is_discoverable and not (select private.member_is_suspended(profiles.id)) and not (select private.is_blocked_with(profiles.id)))
 or (select auth.uid())=id or (select private.is_admin())
 or (exists(select 1 from public.follows f where f.follower_id=(select auth.uid()) and f.followed_id=profiles.id) and not (select private.member_is_suspended(profiles.id)) and not (select private.is_blocked_with(profiles.id)))
);
create or replace function private.member_can_appeal(p_user_id uuid default auth.uid())
returns boolean language sql stable security definer set search_path=pg_catalog,private as $$
 select p_user_id is not null and exists(select 1 from private.member_account_controls c where c.user_id=p_user_id and c.status in ('restricted','suspended') and (c.expires_at is null or c.expires_at>now()));
$$;
revoke all on function private.member_can_appeal(uuid) from public,anon;
grant execute on function private.member_can_appeal(uuid) to authenticated;
create or replace function public.member_can_appeal()
returns boolean language sql stable security invoker set search_path=pg_catalog,private as $$ select private.member_can_appeal((select auth.uid())); $$;
create or replace function public.member_can_interact()
returns boolean language sql stable security invoker set search_path=pg_catalog,private as $$ select private.member_can_interact((select auth.uid())); $$;
revoke all on function public.member_can_appeal() from public,anon;
revoke all on function public.member_can_interact() from public,anon;
grant execute on function public.member_can_appeal() to authenticated;
grant execute on function public.member_can_interact() to authenticated;
drop policy if exists "Members submit own appeals" on public.member_appeals;
create policy "Restricted members submit own appeals" on public.member_appeals for insert to authenticated with check((select auth.uid())=member_id and (select private.member_can_appeal((select auth.uid()))) and status='pending' and owner_decision='' and reviewed_by is null and reviewed_at is null);
