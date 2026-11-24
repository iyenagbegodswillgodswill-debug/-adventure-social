create or replace function private.member_list_blocked_core()
returns table(blocked_id uuid,username text,display_name text)
language plpgsql stable security definer set search_path=pg_catalog,private,public as $$
begin
 if auth.uid() is null then raise exception 'Sign-in required' using errcode='42501'; end if;
 return query select b.blocked_id,p.username,p.display_name from public.blocks b
 left join public.profiles p on p.id=b.blocked_id where b.blocker_id=auth.uid() order by b.created_at desc;
end; $$;
revoke all on function private.member_list_blocked_core() from public,anon;
grant execute on function private.member_list_blocked_core() to authenticated;
create or replace function public.member_list_blocked()
returns table(blocked_id uuid,username text,display_name text)
language sql stable security invoker set search_path=pg_catalog,private as $$ select * from private.member_list_blocked_core(); $$;
revoke all on function public.member_list_blocked() from public,anon;
grant execute on function public.member_list_blocked() to authenticated;
