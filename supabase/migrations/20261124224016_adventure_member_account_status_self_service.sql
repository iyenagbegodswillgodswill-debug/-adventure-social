create or replace function private.member_account_status(p_user_id uuid default auth.uid())
returns jsonb language sql stable security definer set search_path=pg_catalog,private as $$
 select case when p_user_id is null or (p_user_id<>(select auth.uid()) and not private.is_admin()) then null
 else coalesce((select jsonb_build_object('status',c.status,'reason',c.reason,'expires_at',c.expires_at,'updated_at',c.updated_at) from private.member_account_controls c where c.user_id=p_user_id and (c.expires_at is null or c.expires_at>now())),'{}'::jsonb) end;
$$;
revoke all on function private.member_account_status(uuid) from public,anon;
grant execute on function private.member_account_status(uuid) to authenticated;
create or replace function public.member_account_status()
returns jsonb language sql stable security invoker set search_path=pg_catalog,private as $$ select private.member_account_status((select auth.uid())); $$;
revoke all on function public.member_account_status() from public,anon;
grant execute on function public.member_account_status() to authenticated;
