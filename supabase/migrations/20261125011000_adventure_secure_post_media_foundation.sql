alter table public.posts
 add column if not exists media_type text,
 add column if not exists media_path text,
 add column if not exists media_mime text,
 add column if not exists media_size_bytes bigint,
 add column if not exists duration_seconds integer;
alter table public.posts drop constraint if exists posts_media_metadata_check;
alter table public.posts add constraint posts_media_metadata_check check (
 (media_type is null and media_path is null and media_mime is null and media_size_bytes is null and duration_seconds is null)
 or (media_type in ('image','video') and media_path is not null and media_mime is not null
  and media_size_bytes between 1 and 26214400
  and ((media_type='image' and media_mime in ('image/jpeg','image/png','image/webp') and duration_seconds is null)
    or (media_type='video' and media_mime in ('video/mp4','video/webm') and duration_seconds between 1 and 60)))
);
insert into storage.buckets(id,name,public,file_size_limit,allowed_mime_types)
values('adventure-post-media','adventure-post-media',false,26214400,array['image/jpeg','image/png','image/webp','video/mp4','video/webm'])
on conflict(id) do update set public=false,file_size_limit=26214400,allowed_mime_types=excluded.allowed_mime_types;
create policy "Authors upload media for own posts" on storage.objects for insert to authenticated with check (
 bucket_id='adventure-post-media' and (storage.foldername(name))[1]=(select auth.uid())::text
 and exists(select 1 from public.posts p where p.id::text=(storage.foldername(name))[2] and p.author_id=(select auth.uid()) and p.media_path=name and p.media_type in ('image','video') and (select private.member_can_interact((select auth.uid()))))
);
create policy "Members read visible post media they can access" on storage.objects for select to authenticated using (
 bucket_id='adventure-post-media' and exists(select 1 from public.posts p where p.id::text=(storage.foldername(name))[2] and p.media_path=name and p.status='published' and p.moderation_status='visible' and not (select private.member_is_suspended(p.author_id)) and (
 p.author_id=(select auth.uid()) or (select private.is_admin()) or (
 not (select private.is_blocked_with(p.author_id)) and (
 (p.visibility='public' and exists(select 1 from public.profiles pr where pr.id=p.author_id and pr.is_discoverable))
 or (p.visibility='followers' and exists(select 1 from public.follows f where f.follower_id=(select auth.uid()) and f.followed_id=p.author_id))
 ))))
);
create policy "Authors and owner delete post media" on storage.objects for delete to authenticated using (
 bucket_id='adventure-post-media' and ((storage.foldername(name))[1]=(select auth.uid())::text or (select private.is_admin()))
);
create index if not exists posts_media_type_created_idx on public.posts(media_type,created_at desc) where media_type is not null;
comment on column public.posts.media_path is 'Private Storage object path; files are served only after Storage RLS authorization.';
comment on column public.posts.duration_seconds is 'Short-video duration, limited to 60 seconds by database constraint.';