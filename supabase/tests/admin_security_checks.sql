-- Adventure Admin Control Centre security assertions
-- Run against the Adventure project after applying all admin migrations.
do $$
begin
  if not exists (select 1 from pg_class c join pg_namespace n on n.oid=c.relnamespace where n.nspname='private' and c.relname='admin_users' and c.relrowsecurity) then
    raise exception 'FAIL: private.admin_users must have RLS enabled';
  end if;
  if not exists (select 1 from pg_class c join pg_namespace n on n.oid=c.relnamespace where n.nspname='private' and c.relname='admin_audit_log' and c.relrowsecurity) then
    raise exception 'FAIL: private.admin_audit_log must have RLS enabled';
  end if;
  if has_table_privilege('anon','private.admin_users','select') or has_table_privilege('authenticated','private.admin_users','select') then
    raise exception 'FAIL: clients must not read private.admin_users directly';
  end if;
  if has_table_privilege('anon','private.admin_audit_log','select') or has_table_privilege('authenticated','private.admin_audit_log','select') then
    raise exception 'FAIL: clients must not read private.admin_audit_log directly';
  end if;
  if has_function_privilege('anon','public.admin_overview()','execute') or has_function_privilege('anon','public.admin_recent_activity(integer)','execute') then
    raise exception 'FAIL: anonymous users must not call admin RPCs';
  end if;
  if not has_function_privilege('authenticated','public.admin_overview()','execute') or not has_function_privilege('authenticated','public.admin_recent_activity(integer)','execute') then
    raise exception 'FAIL: authenticated clients need the guarded admin RPC entry points';
  end if;
  if has_table_privilege('anon','public.reports','select') then
    raise exception 'FAIL: anonymous users must not read reports';
  end if;
  if not has_table_privilege('authenticated','public.reports','select') then
    raise exception 'FAIL: authenticated report access must be available for RLS-gated moderators';
  end if;
  if has_column_privilege('authenticated','public.reports','details','update') or has_column_privilege('authenticated','public.reports','reason','update') then
    raise exception 'FAIL: admin client must not edit report content';
  end if;
  if not has_column_privilege('authenticated','public.reports','status','update') then
    raise exception 'FAIL: moderators need status-only update permission';
  end if;
  if not exists (select 1 from pg_constraint where conrelid='public.reports'::regclass and conname='reports_status_allowed') then
    raise exception 'FAIL: report status allowlist must be present';
  end if;
  if exists (select 1 from pg_constraint where conrelid='public.reports'::regclass and conname='reports_status_check') then
    raise exception 'FAIL: obsolete report status constraint remains';
  end if;
  if not has_schema_privilege('anon','private','usage') or not has_function_privilege('anon','private.is_admin()','execute') then
    raise exception 'FAIL: anonymous discovery helper execution must remain available';
  end if;
  raise notice 'PASS: admin tables private, RPCs guarded, reports protected, status-only moderation and discovery helper grants intact';
end;
$$;
