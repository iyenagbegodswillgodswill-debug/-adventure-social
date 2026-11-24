-- Members may insert only author/content/target columns. Server-managed counters,
-- status, IDs, timestamps and report evidence snapshots must use defaults/triggers.
revoke insert on public.posts from authenticated;
grant insert(author_id,body,visibility) on public.posts to authenticated;
revoke insert on public.post_likes from authenticated;
grant insert(post_id,user_id) on public.post_likes to authenticated;
revoke insert on public.post_comments from authenticated;
grant insert(post_id,author_id,body) on public.post_comments to authenticated;
revoke insert on public.reports from authenticated;
grant insert(reporter_id,reported_user_id,reported_post_id,reported_comment_id,reason,details) on public.reports to authenticated;
revoke insert,update on public.member_appeals from authenticated;
grant insert(member_id,reason) on public.member_appeals to authenticated;
