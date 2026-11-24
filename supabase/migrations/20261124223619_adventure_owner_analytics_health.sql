create or replace function private.admin_platform_analytics_core()
returns jsonb language plpgsql stable security definer set search_path=pg_catalog,private,public as $$
declare result jsonb;
begin
 if not private.is_admin() then raise exception 'Owner access required' using errcode='42501'; end if;
 select jsonb_build_object(
  'members_total',(select count(*) from public.profiles),
  'members_7d',(select count(*) from public.profiles where created_at>=now()-interval '7 days'),
  'members_30d',(select count(*) from public.profiles where created_at>=now()-interval '30 days'),
  'discoverable',(select count(*) from public.profiles where is_discoverable),
  'follows_7d',(select count(*) from public.follows where created_at>=now()-interval '7 days'),
  'follows_30d',(select count(*) from public.follows where created_at>=now()-interval '30 days'),
  'reports_total',(select count(*) from public.reports),
  'reports_open',(select count(*) from public.reports where status in ('new','reviewing')),
  'appeals_pending',(select count(*) from public.member_appeals where status in ('pending','under_review')),
  'announcements_published',(select count(*) from public.announcements where status='published' and (publish_at is null or publish_at<=now())),
  'rules_preview',(select count(*) from public.community_rules where status='preview'),
  'policies_preview',(select count(*) from public.policy_documents where status='preview'),
  'owner_count',(select count(*) from private.admin_users where role='owner'),
  'public_tables_without_rls',(select count(*) from pg_class c join pg_namespace n on n.oid=c.relnamespace where n.nspname='public' and c.relkind='r' and not c.relrowsecurity),
  'ai_runs',(select count(*) from private.ai_operations_runs)
 ) into result;
 return result;
end; $$;
revoke all on function private.admin_platform_analytics_core() from public,anon;
grant execute on function private.admin_platform_analytics_core() to authenticated;
create or replace function public.admin_platform_analytics()
returns jsonb language sql stable security invoker set search_path=pg_catalog,private as $$ select private.admin_platform_analytics_core(); $$;
revoke all on function public.admin_platform_analytics() from public,anon;
grant execute on function public.admin_platform_analytics() to authenticated;
create index if not exists profiles_created_at_idx on public.profiles(created_at desc);
create index if not exists follows_created_at_idx on public.follows(created_at desc);
create index if not exists reports_created_at_idx on public.reports(created_at desc);
