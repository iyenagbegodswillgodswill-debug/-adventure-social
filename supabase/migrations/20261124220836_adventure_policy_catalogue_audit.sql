-- Audit owner changes to the Adventure community rules and policy catalogue.
create or replace function private.audit_policy_catalogue_change()
returns trigger
language plpgsql
security definer
set search_path = pg_catalog, public, private
as $$
declare
  v_actor uuid := auth.uid();
  v_id text;
  v_kind text := tg_table_name;
begin
  if v_actor is null or not exists (
    select 1 from private.admin_users a
    where a.user_id = v_actor and a.role = 'owner'
  ) then
    raise exception 'owner access required';
  end if;
  v_id := coalesce(to_jsonb(new)->>'id', to_jsonb(old)->>'id');
  insert into private.admin_audit_log(actor_id, action, target_type, target_id, details)
  values (
    v_actor,
    case when tg_op = 'INSERT' then 'policy_catalogue_created'
         when tg_op = 'DELETE' then 'policy_catalogue_deleted'
         else 'policy_catalogue_updated' end,
    v_kind,
    null,
    jsonb_build_object(
      'record_id', v_id,
      'operation', tg_op,
      'old_status', case when tg_op in ('UPDATE','DELETE') then to_jsonb(old)->>'status' else null end,
      'new_status', case when tg_op in ('INSERT','UPDATE') then to_jsonb(new)->>'status' else null end,
      'version', case when tg_op <> 'DELETE' then to_jsonb(new)->>'version' else null end
    )
  );
  if tg_op = 'DELETE' then return old; end if;
  return new;
end;
$$;

revoke all on function private.audit_policy_catalogue_change() from public, anon, authenticated;

drop trigger if exists audit_community_rules_change on public.community_rules;
create trigger audit_community_rules_change
after insert or update or delete on public.community_rules
for each row execute function private.audit_policy_catalogue_change();

drop trigger if exists audit_policy_documents_change on public.policy_documents;
create trigger audit_policy_documents_change
after insert or update or delete on public.policy_documents
for each row execute function private.audit_policy_catalogue_change();