create table if not exists private.report_case_records (
 report_id uuid primary key references public.reports(id) on delete cascade,
 rule_id text references public.community_rules(id) on delete set null,
 priority text not null default 'normal' check(priority in ('low','normal','high','urgent')),
 decision text check(decision in ('no_action','content_removed','warning','restricted','suspended','referred')),
 owner_notes text not null default '' check(char_length(owner_notes)<=5000),
 resolution_summary text not null default '' check(char_length(resolution_summary)<=1500),
 reviewed_by uuid references auth.users(id), reviewed_at timestamptz, updated_at timestamptz not null default now()
);
alter table private.report_case_records enable row level security;
create policy "No direct access to report case records" on private.report_case_records for all using(false) with check(false);

create table if not exists public.member_appeals (
 id uuid primary key default gen_random_uuid(), member_id uuid not null references auth.users(id) on delete cascade,
 reason text not null check(char_length(trim(reason)) between 10 and 2000),
 status text not null default 'pending' check(status in ('pending','under_review','approved','rejected')),
 owner_decision text not null default '' check(char_length(owner_decision)<=2000),
 reviewed_by uuid references auth.users(id), reviewed_at timestamptz,
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
alter table public.member_appeals enable row level security;
revoke all on public.member_appeals from anon;
grant select,insert,update on public.member_appeals to authenticated;
create policy "Members view own appeals" on public.member_appeals for select to authenticated using((select auth.uid())=member_id);
create policy "Members submit own appeals" on public.member_appeals for insert to authenticated with check((select auth.uid())=member_id and status='pending' and owner_decision='' and reviewed_by is null and reviewed_at is null);
create policy "Owner reviews appeals" on public.member_appeals for update to authenticated using(private.is_admin()) with check(private.is_admin());

create table if not exists public.announcements (
 id uuid primary key default gen_random_uuid(),
 title text not null check(char_length(trim(title)) between 3 and 160),
 body text not null check(char_length(trim(body)) between 3 and 5000),
 status text not null default 'draft' check(status in ('draft','published','archived')),
 publish_at timestamptz, created_by uuid references auth.users(id), updated_by uuid references auth.users(id),
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
alter table public.announcements enable row level security;
revoke all on public.announcements from anon,authenticated;
grant select on public.announcements to anon,authenticated;
grant insert,update,delete on public.announcements to authenticated;
create policy "Anyone can read published announcements" on public.announcements for select to anon,authenticated using(status='published' and (publish_at is null or publish_at<=now()));
create policy "Owner manages announcements" on public.announcements for all to authenticated using(private.is_admin()) with check(private.is_admin());

create or replace function public.admin_save_report_case(p_report_id uuid,p_rule_id text default null,p_priority text default 'normal',p_decision text default null,p_owner_notes text default '',p_resolution_summary text default '')
returns void language plpgsql security definer set search_path=pg_catalog,private,public as $$
begin
 if not private.is_admin() then raise exception 'Owner access required' using errcode='42501'; end if;
 if p_priority not in ('low','normal','high','urgent') then raise exception 'Invalid priority'; end if;
 if p_decision is not null and p_decision not in ('no_action','content_removed','warning','restricted','suspended','referred') then raise exception 'Invalid decision'; end if;
 if p_rule_id is not null and not exists(select 1 from public.community_rules where id=p_rule_id) then raise exception 'Unknown community rule'; end if;
 if not exists(select 1 from public.reports where id=p_report_id) then raise exception 'Report not found'; end if;
 insert into private.report_case_records(report_id,rule_id,priority,decision,owner_notes,resolution_summary,reviewed_by,reviewed_at,updated_at)
 values(p_report_id,p_rule_id,p_priority,p_decision,coalesce(p_owner_notes,''),coalesce(p_resolution_summary,''),auth.uid(),case when p_decision is null then null else now() end,now())
 on conflict(report_id) do update set rule_id=excluded.rule_id,priority=excluded.priority,decision=excluded.decision,owner_notes=excluded.owner_notes,resolution_summary=excluded.resolution_summary,reviewed_by=excluded.reviewed_by,reviewed_at=excluded.reviewed_at,updated_at=now();
 insert into private.admin_audit_log(actor_id,action,target_type,target_id,details) values(auth.uid(),'report_case_updated','report',p_report_id,jsonb_build_object('rule_id',p_rule_id,'priority',p_priority,'decision',p_decision));
end; $$;
revoke all on function public.admin_save_report_case(uuid,text,text,text,text,text) from public,anon;
grant execute on function public.admin_save_report_case(uuid,text,text,text,text,text) to authenticated;

create or replace function public.admin_list_report_cases(p_limit integer default 100)
returns table(report_id uuid,rule_id text,priority text,decision text,owner_notes text,resolution_summary text,reviewed_at timestamptz)
language plpgsql stable security definer set search_path=pg_catalog,private as $$
begin
 if not private.is_admin() then raise exception 'Owner access required' using errcode='42501'; end if;
 return query select c.report_id,c.rule_id,c.priority,c.decision,c.owner_notes,c.resolution_summary,c.reviewed_at from private.report_case_records c order by c.updated_at desc limit greatest(1,least(coalesce(p_limit,100),300));
end; $$;
revoke all on function public.admin_list_report_cases(integer) from public,anon;
grant execute on function public.admin_list_report_cases(integer) to authenticated;

create or replace function public.admin_review_appeal(p_appeal_id uuid,p_status text,p_decision text)
returns void language plpgsql security definer set search_path=pg_catalog,private,public as $$
begin
 if not private.is_admin() then raise exception 'Owner access required' using errcode='42501'; end if;
 if p_status not in ('under_review','approved','rejected') then raise exception 'Invalid appeal status'; end if;
 if p_status in ('approved','rejected') and length(trim(coalesce(p_decision,'')))<5 then raise exception 'A clear owner decision is required'; end if;
 update public.member_appeals set status=p_status,owner_decision=coalesce(p_decision,''),reviewed_by=auth.uid(),reviewed_at=case when p_status in ('approved','rejected') then now() else null end,updated_at=now() where id=p_appeal_id;
 if not found then raise exception 'Appeal not found'; end if;
 insert into private.admin_audit_log(actor_id,action,target_type,target_id,details) values(auth.uid(),'appeal_reviewed','appeal',p_appeal_id,jsonb_build_object('status',p_status));
end; $$;
revoke all on function public.admin_review_appeal(uuid,text,text) from public,anon;
grant execute on function public.admin_review_appeal(uuid,text,text) to authenticated;

create or replace function public.admin_list_appeals(p_limit integer default 100)
returns table(id uuid,member_id uuid,reason text,status text,owner_decision text,created_at timestamptz,updated_at timestamptz)
language plpgsql stable security definer set search_path=pg_catalog,private,public as $$
begin
 if not private.is_admin() then raise exception 'Owner access required' using errcode='42501'; end if;
 return query select a.id,a.member_id,a.reason,a.status,a.owner_decision,a.created_at,a.updated_at from public.member_appeals a order by a.created_at desc limit greatest(1,least(coalesce(p_limit,100),300));
end; $$;
revoke all on function public.admin_list_appeals(integer) from public,anon;
grant execute on function public.admin_list_appeals(integer) to authenticated;

create index if not exists member_appeals_member_created_idx on public.member_appeals(member_id,created_at desc);
create index if not exists member_appeals_status_created_idx on public.member_appeals(status,created_at desc);
create index if not exists report_case_records_rule_idx on private.report_case_records(rule_id);
