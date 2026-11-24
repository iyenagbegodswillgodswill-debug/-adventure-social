-- Keep suspension status as an internal RLS helper, not a public RPC endpoint.
drop policy if exists "Discoverable active profiles visible unless either side blocked" on public.profiles;
create policy "Discoverable active profiles visible unless either side blocked"
on public.profiles for select to anon, authenticated
using (
  (is_discoverable
    and not (select private.member_is_suspended(profiles.id))
    and not (select private.is_blocked_with(profiles.id)))
  or (select auth.uid()) = id
  or (select private.is_admin())
);
drop function if exists public.member_is_suspended(uuid);
