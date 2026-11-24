-- Adventure social feed and account-safety structural checks.
-- Run with a privileged SQL connection. These checks do not replace real-user RLS tests.
do $$
declare t text;
begin
 foreach t in array array['profiles','follows','blocks','reports','posts','post_likes','post_comments','member_appeals','announcements','community_rules','policy_documents'] loop
  if not exists(select 1 from pg_class c join pg_namespace n on n.oid=c.relnamespace where n.nspname='public' and c.relname=t and c.relrowsecurity) then
   raise exception 'RLS is not enabled on public.%',t;
  end if;
 end loop;

 if (select count(*) from private.admin_users where role='owner')<>1 then
  raise exception 'Adventure must have exactly one owner account';
 end if;

 if has_table_privilege('anon','public.posts','select') or has_table_privilege('anon','public.posts','insert')
  or has_table_privilege('anon','public.post_likes','select') or has_table_privilege('anon','public.post_comments','select')
  or has_table_privilege('anon','public.member_appeals','select') or has_table_privilege('anon','public.member_appeals','insert') then
  raise exception 'Anonymous API role has unexpected access to member content or appeals';
 end if;

 if not has_column_privilege('authenticated','public.posts','body','update')
  or has_column_privilege('authenticated','public.posts','likes_count','update')
  or has_column_privilege('authenticated','public.posts','comments_count','update')
  or has_table_privilege('authenticated','public.post_likes','update')
  or has_table_privilege('authenticated','public.post_comments','update') then
  raise exception 'Post counters or reaction/comment rows have unsafe direct update grants';
 end if;

 if has_table_privilege('authenticated','public.posts','insert')
  or has_column_privilege('authenticated','public.posts','likes_count','insert')
  or has_column_privilege('authenticated','public.posts','comments_count','insert')
  or has_column_privilege('authenticated','public.posts','status','insert')
  or has_column_privilege('authenticated','public.post_likes','created_at','insert')
  or has_column_privilege('authenticated','public.post_comments','created_at','insert')
  or has_column_privilege('authenticated','public.reports','status','insert')
  or has_column_privilege('authenticated','public.reports','reported_content_snapshot','insert')
  or has_column_privilege('authenticated','public.member_appeals','status','insert')
  or has_table_privilege('authenticated','public.member_appeals','update') then
  raise exception 'Members have insert/update access to server-managed fields';
 end if;

 if has_function_privilege('authenticated','private.adjust_post_counter()','execute')
  or has_function_privilege('anon','private.adjust_post_counter()','execute')
  or has_function_privilege('authenticated','private.capture_reported_content_snapshot()','execute') then
  raise exception 'Post counter trigger function is directly executable';
 end if;

 if not has_function_privilege('authenticated','public.member_can_interact()','execute')
  or not has_function_privilege('authenticated','public.member_can_appeal()','execute')
  or not has_function_privilege('authenticated','public.member_account_status()','execute') then
  raise exception 'Member self-service status functions are not available to authenticated users';
 end if;

 if exists(select 1 from pg_proc p join pg_namespace n on n.oid=p.pronamespace
  where n.nspname='public' and p.proname in ('member_can_interact','member_can_appeal','member_account_status','admin_save_report_case','admin_list_report_cases','admin_review_appeal','admin_list_appeals','admin_update_report_status','admin_platform_analytics') and p.prosecdef) then
  raise exception 'An exposed public RPC is unexpectedly SECURITY DEFINER';
 end if;

 if exists(select 1 from pg_class c join pg_namespace n on n.oid=c.relnamespace where n.nspname='public' and c.relkind='r' and not c.relrowsecurity) then
  raise exception 'A public table is missing RLS';
 end if;

 if not exists(select 1 from pg_trigger where tgname='post_likes_counter' and not tgisinternal)
  or not exists(select 1 from pg_trigger where tgname='post_comments_counter' and not tgisinternal)
  or not exists(select 1 from pg_trigger where tgname='reports_capture_content_snapshot' and not tgisinternal) then
  raise exception 'Post counter triggers are missing';
 end if;
end $$;

select 'PASS: Adventure feed grants, RLS, owner count, trigger safety and self-service RPC checks' as result;
