-- Run with a privileged SQL connection against the Adventure project.
-- These assertions check table-level security configuration; they do not replace
-- end-to-end tests with two real authenticated accounts.
do $$
declare
  t text;
begin
  foreach t in array array['profiles','follows','blocks','reports'] loop
    if not exists (
      select 1 from pg_class c join pg_namespace n on n.oid=c.relnamespace
      where n.nspname='public' and c.relname=t and c.relrowsecurity
    ) then
      raise exception 'RLS is not enabled on public.%', t;
    end if;
  end loop;

  if has_table_privilege('anon','public.follows','select')
     or has_table_privilege('anon','public.blocks','select')
     or has_table_privilege('anon','public.reports','select')
     or has_table_privilege('anon','public.reports','insert') then
    raise exception 'Anonymous API role has an unexpected relationship/report privilege';
  end if;

  if not has_table_privilege('anon','public.profiles','select') then
    raise exception 'Anonymous profile discovery SELECT grant is missing';
  end if;

  if has_table_privilege('authenticated','public.reports','select')
     or has_table_privilege('authenticated','public.reports','update')
     or has_table_privilege('authenticated','public.reports','delete') then
    raise exception 'Authenticated users have an unexpected report privilege';
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

  if (select column_default from information_schema.columns
      where table_schema='public' and table_name='profiles'
        and column_name='is_discoverable') not like 'false%' then
    raise exception 'New profiles must default to non-discoverable';
  end if;
end;
$$;

select 'PASS: Adventure RLS, API grants, profile column restrictions and private signup trigger' as result;
