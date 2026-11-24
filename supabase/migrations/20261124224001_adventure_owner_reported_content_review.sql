drop policy if exists "Members view permitted posts" on public.posts;
create policy "Members and owner view permitted posts" on public.posts for select to authenticated using (
 (select private.is_admin()) or author_id=(select auth.uid()) or
 (status='published' and not (select private.member_is_suspended(author_id)) and not (select private.is_blocked_with(author_id)) and
 ((visibility='public' and exists(select 1 from public.profiles p where p.id=author_id and p.is_discoverable))
 or (visibility='followers' and exists(select 1 from public.follows f where f.follower_id=(select auth.uid()) and f.followed_id=author_id)))
);
