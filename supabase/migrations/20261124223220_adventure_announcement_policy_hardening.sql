drop policy if exists "Owner manages announcements" on public.announcements;
drop policy if exists "Anyone can read published announcements" on public.announcements;
create policy "Published announcements and owner visibility" on public.announcements for select to anon,authenticated using((status='published' and (publish_at is null or publish_at<=now())) or private.is_admin());
create policy "Owner creates announcements" on public.announcements for insert to authenticated with check(private.is_admin() and created_by=(select auth.uid()));
create policy "Owner updates announcements" on public.announcements for update to authenticated using(private.is_admin()) with check(private.is_admin());
create policy "Owner deletes announcements" on public.announcements for delete to authenticated using(private.is_admin());
