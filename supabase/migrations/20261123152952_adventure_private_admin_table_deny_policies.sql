drop policy if exists "No direct access to admin users" on private.admin_users;
create policy "No direct access to admin users" on private.admin_users for all to public using (false) with check (false);
drop policy if exists "No direct access to admin audit log" on private.admin_audit_log;
create policy "No direct access to admin audit log" on private.admin_audit_log for all to public using (false) with check (false);