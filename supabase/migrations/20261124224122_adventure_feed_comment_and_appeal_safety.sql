drop policy if exists "Members view comments on permitted posts" on public.post_comments;
create policy "Members view comments on permitted posts" on public.post_comments for select to authenticated using (
 (select private.is_admin()) or author_id=(select auth.uid())
 or (not (select private.member_is_suspended(author_id)) and exists(select 1 from public.posts p where p.id=post_id))
);
create unique index if not exists member_appeals_one_open_per_member_idx on public.member_appeals(member_id) where status in ('pending','under_review');
