alter table public.posts add column moderation_status text not null default 'visible' check(moderation_status in ('visible','hidden'));
alter table public.posts add column moderation_reason text;
alter table public.posts add column moderated_by uuid references auth.users(id);
alter table public.posts add column moderated_at timestamptz;
alter table public.post_comments add column moderation_status text not null default 'visible' check(moderation_status in ('visible','hidden'));
alter table public.post_comments add column moderation_reason text;
alter table public.post_comments add column moderated_by uuid references auth.users(id);
alter table public.post_comments add column moderated_at timestamptz;
drop policy if exists "Members and owner view permitted posts" on public.posts;
create policy "Members and owner view permitted posts" on public.posts for select to authenticated using (
 (select private.is_admin()) or author_id=(select auth.uid()) or
 (status='published' and moderation_status='visible' and not (select private.member_is_suspended(author_id)) and not (select private.is_blocked_with(author_id)) and
 ((visibility='public' and exists(select 1 from public.profiles p where p.id=author_id and p.is_discoverable))
 or (visibility='followers' and exists(select 1 from public.follows f where f.follower_id=(select auth.uid()) and f.followed_id=author_id)))
);
drop policy if exists "Members view comments on permitted posts" on public.post_comments;
create policy "Members view comments on permitted posts" on public.post_comments for select to authenticated using (
 (select private.is_admin()) or author_id=(select auth.uid())
 or (moderation_status='visible' and not (select private.member_is_suspended(author_id)) and exists(select 1 from public.posts p where p.id=post_id))
);
create or replace function private.admin_moderate_reported_content_core(p_report_id uuid,p_action text,p_reason text)
returns void language plpgsql security definer set search_path=pg_catalog,private,public as $$
declare post_target uuid; comment_target uuid;
begin
 if not private.is_admin() then raise exception 'Owner access required' using errcode='42501'; end if;
 if p_action not in ('hide','restore') then raise exception 'Invalid moderation action'; end if;
 if length(trim(coalesce(p_reason,'')))<5 or length(p_reason)>1000 then raise exception 'A clear moderation reason is required'; end if;
 select reported_post_id,reported_comment_id into post_target,comment_target from public.reports where id=p_report_id for update;
 if not found then raise exception 'Report not found'; end if;
 if post_target is not null then
  update public.posts set moderation_status=case when p_action='hide' then 'hidden' else 'visible' end,moderation_reason=p_reason,moderated_by=auth.uid(),moderated_at=now() where id=post_target;
 elsif comment_target is not null then
  update public.post_comments set moderation_status=case when p_action='hide' then 'hidden' else 'visible' end,moderation_reason=p_reason,moderated_by=auth.uid(),moderated_at=now() where id=comment_target;
 else raise exception 'The original reported content is no longer available for moderation'; end if;
 insert into private.admin_audit_log(actor_id,action,target_type,target_id,details)
 values(auth.uid(),'reported_content_'||p_action,case when post_target is not null then 'post' else 'comment' end,coalesce(post_target,comment_target),jsonb_build_object('report_id',p_report_id,'reason',p_reason));
end; $$;
revoke all on function private.admin_moderate_reported_content_core(uuid,text,text) from public,anon;
grant execute on function private.admin_moderate_reported_content_core(uuid,text,text) to authenticated;
create or replace function public.admin_moderate_reported_content(p_report_id uuid,p_action text,p_reason text)
returns void language sql security invoker set search_path=pg_catalog,private as $$ select private.admin_moderate_reported_content_core(p_report_id,p_action,p_reason); $$;
revoke all on function public.admin_moderate_reported_content(uuid,text,text) from public,anon;
grant execute on function public.admin_moderate_reported_content(uuid,text,text) to authenticated;
