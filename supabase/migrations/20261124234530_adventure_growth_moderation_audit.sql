-- Record owner approval/rejection changes for marketplace, business, community and event submissions.
create or replace function private.audit_marketplace_growth_moderation()
returns trigger
language plpgsql
security definer
set search_path = pg_catalog, private
as $$
begin
 if old.status is distinct from new.status and private.is_admin() then
  insert into private.admin_audit_log(actor_id,action,target_type,target_id,details)
  values(auth.uid(),'growth_submission_status_changed',tg_table_name,new.id,
    jsonb_build_object('from_status',old.status,'to_status',new.status));
 end if;
 return new;
end;
$$;
revoke all on function private.audit_marketplace_growth_moderation() from public, anon, authenticated;
drop trigger if exists marketplace_listing_moderation_audit on public.marketplace_listings;
create trigger marketplace_listing_moderation_audit after update of status on public.marketplace_listings for each row execute function private.audit_marketplace_growth_moderation();
drop trigger if exists business_profile_moderation_audit on public.business_profiles;
create trigger business_profile_moderation_audit after update of status on public.business_profiles for each row execute function private.audit_marketplace_growth_moderation();
drop trigger if exists community_space_moderation_audit on public.community_spaces;
create trigger community_space_moderation_audit after update of status on public.community_spaces for each row execute function private.audit_marketplace_growth_moderation();
drop trigger if exists adventure_event_moderation_audit on public.adventure_events;
create trigger adventure_event_moderation_audit after update of status on public.adventure_events for each row execute function private.audit_marketplace_growth_moderation();
