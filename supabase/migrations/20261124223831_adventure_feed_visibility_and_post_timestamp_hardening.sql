drop policy if exists "Members view permitted posts" on public.posts;
create policy "Members view permitted posts" on public.posts for select to authenticated using (
 author_id=(select auth.uid()) or (status='published' and not (select private.member_is_suspended(author_id)) and not (select private.is_blocked_with(author_id)) and
 ((visibility='public' and exists(select 1 from public.profiles p where p.id=author_id and p.is_discoverable))
 or (visibility='followers' and exists(select 1 from public.follows f where f.follower_id=(select auth.uid()) and f.followed_id=author_id)))
);
create or replace function private.set_post_updated_at()
returns trigger language plpgsql set search_path=pg_catalog as $$ begin new.updated_at=now(); return new; end; $$;
revoke all on function private.set_post_updated_at() from public,anon,authenticated;
drop trigger if exists posts_set_updated_at on public.posts;
create trigger posts_set_updated_at before update on public.posts for each row execute function private.set_post_updated_at();
