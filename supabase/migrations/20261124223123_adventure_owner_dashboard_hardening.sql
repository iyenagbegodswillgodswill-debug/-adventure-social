drop policy if exists "Only Adventure owner can manage rules" on public.community_rules;
drop policy if exists "Only Adventure owner can manage policy documents" on public.policy_documents;
drop policy if exists "Anyone can read visible Adventure rules" on public.community_rules;
drop policy if exists "Anyone can read visible policy documents" on public.policy_documents;
create policy "Visible rules and owner catalogue access" on public.community_rules for select to anon,authenticated using(status in ('preview','active') or private.is_admin());
create policy "Visible policies and owner catalogue access" on public.policy_documents for select to anon,authenticated using(status in ('preview','active') or private.is_admin());
create policy "Owner inserts rules" on public.community_rules for insert to authenticated with check(private.is_admin());
create policy "Owner updates rules" on public.community_rules for update to authenticated using(private.is_admin()) with check(private.is_admin());
create policy "Owner deletes rules" on public.community_rules for delete to authenticated using(private.is_admin());
create policy "Owner inserts policy documents" on public.policy_documents for insert to authenticated with check(private.is_admin());
create policy "Owner updates policy documents" on public.policy_documents for update to authenticated using(private.is_admin()) with check(private.is_admin());
create policy "Owner deletes policy documents" on public.policy_documents for delete to authenticated using(private.is_admin());

create or replace function public.admin_update_report_status(p_report_id uuid,p_status text)
returns void language plpgsql security definer set search_path=pg_catalog,private,public as $$
begin
 if not private.is_admin() then raise exception 'Owner access required' using errcode='42501'; end if;
 if p_status not in ('new','reviewing','resolved','dismissed') then raise exception 'Invalid report status'; end if;
 update public.reports set status=p_status where id=p_report_id;
 if not found then raise exception 'Report not found'; end if;
 insert into private.admin_audit_log(actor_id,action,target_type,target_id,details) values(auth.uid(),'report_status_changed','report',p_report_id,jsonb_build_object('to',p_status));
end; $$;
revoke all on function public.admin_update_report_status(uuid,text) from public,anon;
grant execute on function public.admin_update_report_status(uuid,text) to authenticated;

create or replace function private.audit_announcement_change()
returns trigger language plpgsql security definer set search_path=pg_catalog,private as $$
begin
 insert into private.admin_audit_log(actor_id,action,target_type,target_id,details)
 values(auth.uid(),'announcement_'||lower(tg_op),'announcement',case when tg_op='DELETE' then old.id else new.id end,jsonb_build_object('status',case when tg_op='DELETE' then old.status else new.status end));
 if tg_op='DELETE' then return old; end if;
 return new;
end; $$;
drop trigger if exists audit_announcement_change on public.announcements;
create trigger audit_announcement_change after insert or update or delete on public.announcements for each row execute function private.audit_announcement_change();
