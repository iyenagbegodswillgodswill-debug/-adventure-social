alter table public.reports add column reported_content_snapshot text check(reported_content_snapshot is null or char_length(reported_content_snapshot)<=2000);
create or replace function private.capture_reported_content_snapshot()
returns trigger language plpgsql security definer set search_path=pg_catalog,public as $$
begin
 if new.reported_post_id is not null then select body into new.reported_content_snapshot from public.posts where id=new.reported_post_id;
 elsif new.reported_comment_id is not null then select body into new.reported_content_snapshot from public.post_comments where id=new.reported_comment_id;
 else new.reported_content_snapshot=null; end if;
 return new;
end; $$;
revoke all on function private.capture_reported_content_snapshot() from public,anon,authenticated;
drop trigger if exists reports_capture_content_snapshot on public.reports;
create trigger reports_capture_content_snapshot before insert on public.reports for each row execute function private.capture_reported_content_snapshot();
