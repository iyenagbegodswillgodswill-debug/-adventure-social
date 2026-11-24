# Adventure owner administrator setup

The Admin Control Centre is implemented at `admin.html`. It is connected to the same Adventure Supabase project as the public platform, but private records and privileged actions are protected by database authorization.

## Designated owner

- **Owner email:** `allenjamesl1014@gmail.com`
- **Access model:** one owner only; no moderator accounts and no public admin registration.
- The email is prefilled on the private sign-in page. The database independently verifies the signed-in user's UUID against `private.admin_users` and the `owner` role. The email check in the page is an extra convenience check, not the security boundary.

## One-time owner setup

1. Open the **Adventure** Supabase project.
2. Go to **Authentication → Users**.
3. Create an Auth user using `allenjamesl1014@gmail.com`, set a strong unique password, and complete email verification if required.
4. Copy that user's UUID from the Auth Users list.
5. Open **SQL Editor** in the Adventure project and run this statement, replacing the placeholder with the exact UUID:

```sql
insert into private.admin_users (user_id, role)
values ('REPLACE-WITH-OWNER-USER-UUID', 'owner')
on conflict (user_id) do update set role = 'owner';
```

6. Visit `https://iyenagbegodswillgodswill-debug.github.io/-adventure-social/admin.html` and sign in with the owner email and the password you created.

## Current setup status

The owner Auth account has **not** been created yet. A database lookup confirmed that `allenjamesl1014@gmail.com` is not currently present in this project's Auth users. I cannot create the Auth identity through the connected project tools, and I will not invent a password or write credentials into the repository.

If the Supabase Dashboard says you do not have access to the Adventure project, first make sure you are signed into the Supabase account that owns the Adventure organization/project. Do not create a different project or invite another admin as a workaround.

## Security safeguards

- Only the single `owner` role is accepted by the private admin registry; the database also enforces at most one owner row.
- Owner checks run in PostgreSQL through `private.is_admin()` and `private.can_review_reports()`. Frontend visibility or a hidden URL is never treated as authorization.
- Anonymous users and ordinary signed-in members cannot read reports, the admin registry or the audit log, or change report status.
- The owner dashboard uses the same Adventure backend as the public website.
- Do not put the owner's password, service-role key, database password or other secrets in GitHub or browser code.
- Keep public registration closed until member safety, privacy and end-to-end tests are complete.
- No paid services or upgrades without explicit approval.
