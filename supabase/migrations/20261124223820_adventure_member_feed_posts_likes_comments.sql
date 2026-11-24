create table public.posts (
 id uuid primary key default gen_random_uuid(), author_id uuid not null references public.profiles(id) on delete cascade,
 body text not null check(char_length(trim(body)) between 1 and 2000),
 visibility text not null default 'public' check(visibility in ('public','followers')),
 status text not null default 'published' check(status in ('published','hidden')),
 likes_count integer not null default 0 check(likes_count>=0), comments_count integer not null default 0 check(comments_count>=0),
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create index posts_author_created_idx on public.posts(author_id,created_at desc);
create index posts_visibility_created_idx on public.posts(visibility,status,created_at desc);
alter table public.posts enable row level security;
revoke all on public.posts from anon,authenticated;
grant select,insert,delete on public.posts to authenticated;
grant update(body,visibility,status) on public.posts to authenticated;
create policy "Members view permitted posts" on public.posts for select to authenticated using (
 author_id=(select auth.uid()) or (status='published' and not (select private.is_blocked_with(author_id)) and
 ((visibility='public' and exists(select 1 from public.profiles p where p.id=author_id and p.is_discoverable and not (select private.member_is_suspended(p.id))))
 or (visibility='followers' and exists(select 1 from public.follows f where f.follower_id=(select auth.uid()) and f.followed_id=author_id))))
);
create policy "Active members publish their own posts" on public.posts for insert to authenticated with check(author_id=(select auth.uid()) and (select private.member_can_interact((select auth.uid()))));
create policy "Active members edit their own posts" on public.posts for update to authenticated using(author_id=(select auth.uid()) and (select private.member_can_interact((select auth.uid())))) with check(author_id=(select auth.uid()) and (select private.member_can_interact((select auth.uid()))));
create policy "Authors delete their own posts" on public.posts for delete to authenticated using(author_id=(select auth.uid()));

create table public.post_likes (
 post_id uuid not null references public.posts(id) on delete cascade,
 user_id uuid not null references public.profiles(id) on delete cascade,
 created_at timestamptz not null default now(), primary key(post_id,user_id)
);
create index post_likes_user_idx on public.post_likes(user_id,post_id);
alter table public.post_likes enable row level security;
revoke all on public.post_likes from anon,authenticated;
grant select,insert,delete on public.post_likes to authenticated;
create policy "Members see only their own post likes" on public.post_likes for select to authenticated using(user_id=(select auth.uid()));
create policy "Active members like visible posts" on public.post_likes for insert to authenticated with check(user_id=(select auth.uid()) and (select private.member_can_interact((select auth.uid()))) and exists(select 1 from public.posts p where p.id=post_id and p.status='published'));
create policy "Members remove their own likes" on public.post_likes for delete to authenticated using(user_id=(select auth.uid()));

create table public.post_comments (
 id uuid primary key default gen_random_uuid(), post_id uuid not null references public.posts(id) on delete cascade,
 author_id uuid not null references public.profiles(id) on delete cascade,
 body text not null check(char_length(trim(body)) between 1 and 1000), created_at timestamptz not null default now()
);
create index post_comments_post_created_idx on public.post_comments(post_id,created_at);
create index post_comments_author_created_idx on public.post_comments(author_id,created_at desc);
alter table public.post_comments enable row level security;
revoke all on public.post_comments from anon,authenticated;
grant select,insert,delete on public.post_comments to authenticated;
create policy "Members view comments on permitted posts" on public.post_comments for select to authenticated using(exists(select 1 from public.posts p where p.id=post_id));
create policy "Active members comment on permitted posts" on public.post_comments for insert to authenticated with check(author_id=(select auth.uid()) and (select private.member_can_interact((select auth.uid()))) and exists(select 1 from public.posts p where p.id=post_id and p.status='published'));
create policy "Members delete their own comments" on public.post_comments for delete to authenticated using(author_id=(select auth.uid()));

create or replace function private.adjust_post_counter()
returns trigger language plpgsql security definer set search_path=pg_catalog,public as $$
declare target_post uuid; delta integer;
begin
 target_post=case when tg_op='DELETE' then old.post_id else new.post_id end;
 delta=case when tg_op='INSERT' then 1 else -1 end;
 if tg_table_name='post_likes' then update public.posts set likes_count=greatest(0,likes_count+delta) where id=target_post;
 else update public.posts set comments_count=greatest(0,comments_count+delta) where id=target_post; end if;
 if tg_op='DELETE' then return old; end if; return new;
end; $$;
revoke all on function private.adjust_post_counter() from public,anon,authenticated;
create trigger post_likes_counter after insert or delete on public.post_likes for each row execute function private.adjust_post_counter();
create trigger post_comments_counter after insert or delete on public.post_comments for each row execute function private.adjust_post_counter();

alter table public.reports add column reported_post_id uuid references public.posts(id) on delete set null;
alter table public.reports add column reported_comment_id uuid references public.post_comments(id) on delete set null;
alter table public.reports add constraint reports_single_content_target check(reported_post_id is null or reported_comment_id is null);
drop policy if exists "Active members can submit reports as themselves" on public.reports;
drop policy if exists "Signed-in users can submit reports as themselves" on public.reports;
create policy "Active members can submit valid reports" on public.reports for insert to authenticated with check(
 reporter_id=(select auth.uid()) and (select private.member_can_interact((select auth.uid()))) and (
 (reported_post_id is null and reported_comment_id is null and reported_user_id is not null)
 or (reported_post_id is not null and reported_comment_id is null and exists(select 1 from public.posts p where p.id=reported_post_id and p.author_id=reported_user_id))
 or (reported_comment_id is not null and reported_post_id is null and exists(select 1 from public.post_comments c where c.id=reported_comment_id and c.author_id=reported_user_id))
));
create index reports_reported_post_idx on public.reports(reported_post_id) where reported_post_id is not null;
create index reports_reported_comment_idx on public.reports(reported_comment_id) where reported_comment_id is not null;
