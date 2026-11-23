# Adventure owner administrator setup

The Admin Control Centre is implemented at `admin.html`, but it intentionally grants no one access by default. The first owner account must be provisioned by the project owner through the Supabase Dashboard.

## One-time owner setup

1. In the Supabase Dashboard, open the separate **Adventure** project.
2. Go to **Authentication → Users** and create the owner's account with an email address the owner controls. Use a strong unique password and verify the email as appropriate.
3. Copy that user's UUID from the Users table.
4. Open **SQL Editor** in the Adventure project and run the statement below after replacing the placeholder with the exact UUID:

```sql
insert into private.admin_users (user_id, role)
values ('REPLACE-WITH-OWNER-USER-UUID', 'owner')
on conflict (user_id) do update set role = 'owner';
```

5. Open the public site and choose **Admin access** in the footer, or visit `/admin.html`. Sign in using the email and password created in step 2.

## Important safeguards

- Do not put the owner's password, service-role key or database password in GitHub or browser code.
- Do not create a public sign-up path for administrators.
- Only the trusted Supabase project owner should run the bootstrap SQL. There is no client-facing endpoint to grant administrator roles.
- A user who signs in but is not in `private.admin_users` sees an access-denied screen; the dashboard does not load member or report data.
- Additional moderators should be added only by the trusted project owner using a reviewed SQL operation. Support accounts cannot read or resolve private reports.
- If the account is compromised, remove its row from `private.admin_users` and revoke its active sessions in Supabase Auth.

This bootstrap step is not performed yet because no Adventure owner login account has been designated in this project.
