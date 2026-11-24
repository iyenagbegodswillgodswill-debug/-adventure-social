-- SECURITY INVOKER public RPC wrappers call owner-checking SECURITY DEFINER helpers in the private schema.
-- This keeps exposed RPC entrypoints from themselves being SECURITY DEFINER.
create or replace function private.admin_save_report_case_core(p_report_id uuid,p_rule_id text default null,p_priority text default 'normal',p_decision text default null,p_owner_notes text default '',p_resolution_summary text default '')
returns void language plpgsql security definer set search_path=pg_catalog,private,public as $$
begin
 if not private.is_admin() then raise exception 'Owner access required' using errcode='42501'; end if;
 if p_priority not in ('low','normal','high','urgent') then raise exception 'Invalid priority'; end if;
 if p_decision is not null and p_decision not in ('no_action','content_removed','warning','restricted','suspended','referred') then raise exception 'Invalid decision'; end if;
 if length(coalesce(p_owner_notes,''))>5000 or length(coalesce(p_resolution_summary,''))>1500 then raise exception 'Case text is too long'; end if;
 if p_rule_id is not null and not exists(select 1 from public.community_rules where id=p_rule_id) then raise exception 'Unknown community rule'; end if;
 if not exists(select 1 from public.reports where id=p_report_id) then raise exception 'Report not found'; end if;
 insert into private.report_case_records(report_id,rule_id,priority,decision,owner_notes,resolution_summary,reviewed_by,reviewed_at,updated_at)
 values(p_report_id,p_rule_id,p_priority,p_decision,coalesce(p_owner_notes,''),coalesce(p_resolution_summary,''),auth.uid(),case when p_decision is null then null else now() end,now())
 on conflict(report_id) do update set rule_id=excluded.rule_id,priority=excluded.priority,decision=excluded.decision,owner_notes=excluded.owner_notes,resolution_summary=excluded.resolution_summary,reviewed_by=excluded.reviewed_by,reviewed_at=excluded.reviewed_at,updated_at=now();
 insert into private.admin_audit_log(actor_id,action,target_type,target_id,details) values(auth.uid(),'report_case_updated','report',p_report_id,jsonb_build_object('rule_id',p_rule_id,'priority',p_priority,'decision',p_decision));
end; $$;
create or replace function private.admin_list_report_cases_core(p_limit integer default 100)
returns table(report_id uuid,rule_id text,priority text,decision text,owner_notes text,resolution_summary text,reviewed_at timestamptz)
language plpgsql stable security definer set search_path=pg_catalog,private as $$
begin
 if not private.is_admin() then raise exception 'Owner access required' using errcode='42501'; end if;
 return query select c.report_id,c.rule_id,c.priority,c.decision,c.owner_notes,c.resolution_summary,c.reviewed_at from private.report_case_records c order by c.updated_at desc limit greatest(1,least(coalesce(p_limit,100),300));
end; $$;
create or replace function private.admin_review_appeal_core(p_appeal_id uuid,p_status text,p_decision text)
returns void language plpgsql security definer set search_path=pg_catalog,private,public as $$
begin
 if not private.is_admin() then raise exception 'Owner access required' using errcode='42501'; end if;
 if p_status not in ('under_review','approved','rejected') then raise exception 'Invalid appeal status'; end if;
 if p_status in ('approved','rejected') and length(trim(coalesce(p_decision,'')))<5 then raise exception 'A clear owner decision is required'; end if;
 update public.member_appeals set status=p_status,owner_decision=coalesce(p_decision,''),reviewed_by=auth.uid(),reviewed_at=case when p_status in ('approved','rejected') then now() else null end,updated_at=now() where id=p_appeal_id;
 if not found then raise exception 'Appeal not found'; end if;
 insert into private.admin_audit_log(actor_id,action,target_type,target_id,details) values(auth.uid(),'appeal_reviewed','appeal',p_appeal_id,jsonb_build_object('status',p_status));
end; $$;
create or replace function private.admin_list_appeals_core(p_limit integer default 100)
returns table(id uuid,member_id uuid,reason text,status text,owner_decision text,created_at timestamptz,updated_at timestamptz)
language plpgsql stable security definer set search_path=pg_catalog,private,public as $$
begin
 if not private.is_admin() then raise exception 'Owner access required' using errcode='42501'; end if;
 return query select a.id,a.member_id,a.reason,a.status,a.owner_decision,a.created_at,a.updated_at from public.member_appeals a order by a.created_at desc limit greatest(1,least(coalesce(p_limit,100),300));
end; $$;
create or replace function private.admin_update_report_status_core(p_report_id uuid,p_status text)
returns void language plpgsql security definer set search_path=pg_catalog,private,public as $$
begin
 if not private.is_admin() then raise exception 'Owner access required' using errcode='42501'; end if;
 if p_status not in ('new','reviewing','resolved','dismissed') then raise exception 'Invalid report status'; end if;
 update public.reports set status=p_status where id=p_report_id;
 if not found then raise exception 'Report not found'; end if;
 insert into private.admin_audit_log(actor_id,action,target_type,target_id,details) values(auth.uid(),'report_status_changed','report',p_report_id,jsonb_build_object('to',p_status));
end; $$;
revoke all on function private.admin_save_report_case_core(uuid,text,text,text,text,text) from public,anon;
revoke all on function private.admin_list_report_cases_core(integer) from public,anon;
revoke all on function private.admin_review_appeal_core(uuid,text,text) from public,anon;
revoke all on function private.admin_list_appeals_core(integer) from public,anon;
revoke all on function private.admin_update_report_status_core(uuid,text) from public,anon;
grant execute on function private.admin_save_report_case_core(uuid,text,text,text,text,text) to authenticated;
grant execute on function private.admin_list_report_cases_core(integer) to authenticated;
grant execute on function private.admin_review_appeal_core(uuid,text,text) to authenticated;
grant execute on function private.admin_list_appeals_core(integer) to authenticated;
grant execute on function private.admin_update_report_status_core(uuid,text) to authenticated;
create or replace function public.admin_save_report_case(p_report_id uuid,p_rule_id text default null,p_priority text default 'normal',p_decision text default null,p_owner_notes text default '',p_resolution_summary text default '')
returns void language sql security invoker set search_path=pg_catalog,private as $$ select private.admin_save_report_case_core(p_report_id,p_rule_id,p_priority,p_decision,p_owner_notes,p_resolution_summary); $$;
create or replace function public.admin_list_report_cases(p_limit integer default 100)
returns table(report_id uuid,rule_id text,priority text,decision text,owner_notes text,resolution_summary text,reviewed_at timestamptz)
language sql stable security invoker set search_path=pg_catalog,private as $$ select * from private.admin_list_report_cases_core(p_limit); $$;
create or replace function public.admin_review_appeal(p_appeal_id uuid,p_status text,p_decision text)
returns void language sql security invoker set search_path=pg_catalog,private as $$ select private.admin_review_appeal_core(p_appeal_id,p_status,p_decision); $$;
create or replace function public.admin_list_appeals(p_limit integer default 100)
returns table(id uuid,member_id uuid,reason text,status text,owner_decision text,created_at timestamptz,updated_at timestamptz)
language sql stable security invoker set search_path=pg_catalog,private as $$ select * from private.admin_list_appeals_core(p_limit); $$;
create or replace function public.admin_update_report_status(p_report_id uuid,p_status text)
returns void language sql security invoker set search_path=pg_catalog,private as $$ select private.admin_update_report_status_core(p_report_id,p_status); $$;
grant execute on function public.admin_save_report_case(uuid,text,text,text,text,text) to authenticated;
grant execute on function public.admin_list_report_cases(integer) to authenticated;
grant execute on function public.admin_review_appeal(uuid,text,text) to authenticated;
grant execute on function public.admin_list_appeals(integer) to authenticated;
grant execute on function public.admin_update_report_status(uuid,text) to authenticated;
create index if not exists report_case_records_reviewed_by_idx on private.report_case_records(reviewed_by);
create index if not exists member_appeals_reviewed_by_idx on public.member_appeals(reviewed_by);
create index if not exists announcements_created_by_idx on public.announcements(created_by);
create index if not exists announcements_updated_by_idx on public.announcements(updated_by);
