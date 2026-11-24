create index if not exists posts_moderated_by_idx on public.posts(moderated_by) where moderated_by is not null;
create index if not exists post_comments_moderated_by_idx on public.post_comments(moderated_by) where moderated_by is not null;
