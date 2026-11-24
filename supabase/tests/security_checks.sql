-- Run with a privileged SQL connection against the Adventure project.
-- Structural checks only; real owner/member/anonymous browser tests are still required.
do $$
declare t text;
begin
 foreach t in array array['profiles','follows','blocks','reports','posts','post_likes','post_comments','member_appeals','announcements','community_rules','policy_documents'] loop
  if not exists(select 1 from pg_class c join pg_namespace n on n.oid=c.relnamespace where n.nspname='public' and c.relname=t and c.relrowsecurity) then
   raise exception 'RLS is not enabled on public.%',t;
  end if;
 end loop;

 if has_table_privilege('anon','public.follows','select')
  or has_table_privilege('anon','public.blocks','select')
  or has_table_privilege('anon','public.reports','select')
  or has_table_privilege('anon','public.posts','select')
  or has_table_privilege('anon','public.post_likes','select')
  or has_table_privilege('anon','public.post_comments','select')
  or has_table_privilege('anon','public.member_appeals','select') then
  raise exception 'Anonymous API role has unexpected access to member-only data';
 end if;

 if not has_table_privilege('anon','public.profiles','select')
  or not has_table_privilege('anon','public.announcements','select') then
  raise exception 'Anonymous profile/announcement read grants are missing';
 end if;

 if not has_table_privilege('authenticated','public.reports','select')
  or has_table_privilege('authenticated','public.reports','update')
  or has_table_privilege('authenticated','public.reports','delete')
  or not has_column_privilege('authenticated','public.reports','status','update') then
  raise exception 'Report access must remain RLS-gated and status-only for the owner workflow';
 end if;

 if not has_column_privilege('authenticated','public.profiles','username','update')
  or has_column_privilege('authenticated','public.profiles','id','update')
  or has_column_privilege('authenticated','public.profiles','updated_at','update') then
  raise exception 'Profile column-level update grants are not restricted as expected';
 end if;

 if has_function_privilege('anon','private.handle_new_adventure_user()','execute')
  or has_function_privilege('authenticated','private.handle_new_adventure_user()','execute') then
  raise exception 'Signup trigger function is directly executable by API roles';
 end if;

 if not has_schema_privilege('anon','private','usage') or not has_function_privilege('anon','private.is_admin()','execute') then
  raise exception 'Narrow discovery/authorization helper access is missing';
 end if;

 if (select column_default from information_schema.columns where table_schema='public' and table_name='profiles' and column_name='is_discoverable') not like 'false%' then
  raise exception 'New profiles must default to non-discoverable';
 end if;

 if (select count(*) from private.admin_users where role='owner')<>1 then
  raise exception 'Adventure must have exactly one owner';
 end if;

 if exists(select 1 from pg_class c join pg_namespace n on n.oid=c.relnamespace where n.nspname='public' and c.relkind='r' and not c.relrowsecurity) then
  raise exception 'A public table is missing RLS';
 end if;
end $$;

select 'PASS: Adventure RLS, API grants, profile restrictions, private signup trigger and single-owner checks' as result;
