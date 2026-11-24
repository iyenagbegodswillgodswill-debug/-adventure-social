# Adventure owner administrator setup

The Admin Control Centre is implemented at `admin.html`. It is connected to the same Adventure Supabase project as the public platform, but private records and privileged actions are protected by database authorization.

## Designated owner

- **Owner email:** `allenjamesl1014@gmail.com`
- **Access model:** one owner only; no moderator accounts and no public admin registration.
- The email is prefilled on the private sign-in page. The database independently verifies the signed-in user's UUID against `private.admin_users` and the `owner` role. The email check in the page is an extra convenience check, not the security boundary.

## Current setup status

<badge>Completed</badge>

The designated owner Auth account and its single `private.admin_users` owner row are already provisioned in the Adventure project. A live database check confirms exactly one owner row. Do not repeat the one-time insert, create another owner, or add moderator/admin accounts.

To access the console, visit:

`https://iyenagbegodswillgodswill-debug.github.io/-adventure-social/admin.html`

Sign in with the existing designated owner account. Use the password already held by the owner; never store it in this repository or share it in chat.

If owner access is ever lost, recover the existing Auth account through Supabase Auth first. Do not create a second owner as a workaround.

## Security safeguards

- Only the single `owner` role is accepted by the private admin registry; the database also enforces at most one owner row.
- Owner checks run in PostgreSQL through `private.is_admin()` and `private.can_review_reports()`. Frontend visibility or a hidden URL is never treated as authorization.
- Anonymous users and ordinary signed-in members cannot read reports, the admin registry or the audit log, or change report status.
- The owner dashboard uses the same Adventure backend as the public website.
- Do not put the owner's password, service-role key, database password or other secrets in GitHub or browser code.
- Keep public registration closed until member safety, privacy and end-to-end tests are complete.
- No paid services or upgrades without explicit approval.
