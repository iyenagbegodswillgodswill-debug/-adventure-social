# Adventure — Project Status

Last updated: 2026-11-24

## Current milestone: Admin foundation and member experience

- [x] Separate public GitHub repository created.
- [x] Mobile-first Adventurers directory prototype committed.
- [x] African-inspired green/cream brand direction with restrained warm accent.
- [x] Featured sample profiles, search, interest filters and local-only demo Follow interactions.
- [x] Responsive layout, keyboard navigation, focus styles and reduced-motion support.
- [x] PWA manifest, app icon, install guidance and offline app-shell caching.
- [x] Separate Supabase project `Adventure` created on the Free plan at a quoted $0/month; project is `ACTIVE_HEALTHY`.
- [x] Initial `profiles`, `follows`, `blocks` and `reports` tables created in Adventure only.
- [x] RLS enabled; profile discovery defaults to off; profile updates restricted to approved columns.
- [x] Blocks suppress discovery/follow interactions and remove existing follows in both directions.
- [x] API grants narrowed; anonymous users have no access to follows, blocks or reports.
- [x] Signup trigger and internal helper functions isolated in a non-exposed private schema.
- [x] Five initial database migrations saved and matched to the live migration history.
- [x] Repeatable baseline security assertions passed.
- [x] Private admin role registry and audit log created in the private schema.
- [x] Database-side admin authorization checks implemented; no client-facing role-grant endpoint exists.
- [x] Admin overview RPCs and RLS policies implemented for administrator-only profile/report access.
- [x] Report status updates restricted to moderators/owners and recorded in the audit log.
- [x] Admin dashboard page created with sign-in, overview metrics, report queue, member lookup and audit activity.
- [x] Public preview footer links to the private admin sign-in page.
- [x] Member account page added with sign-in, password-reset request and profile editing for pre-provisioned Auth users.
- [x] Adventurers directory queries real profiles that explicitly opted into discovery, with a clearly labelled sample fallback when no public member profiles exist.
- [x] Signed-in members can follow and unfollow real profiles through the database; anonymous visitors are directed to member sign-in.
- [x] Signed-in members can report and block discoverable profiles; database block rules remove existing follows and hide blocked profiles.
- [x] Admin report status values are aligned with the database allowlist and legacy status constraint was removed.
- [x] Profile editor supports display name, username, country, bio, interests and explicit discoverability opt-in.
- [x] Public registration remains disabled; no unverified account creation is exposed.
- [x] Applied admin migrations saved under `supabase/migrations/` with exact live version prefixes.
- [x] Supabase Security Advisor returned zero security lints after admin implementation.
- [x] Performance Advisor no longer reports missing FK indexes or multiple permissive profile policies; remaining unused-index notices are expected on a nearly empty database.

## Admin Control Centre — remaining work

- [x] Database role checks now accept only the `owner` role; a unique partial index enforces a single owner row.
- [x] Report review, admin overview and audit activity authorization are owner-only at the database layer.
- [x] Owner-only access migration saved as `supabase/migrations/20261124204517_adventure_owner_only_admin_access.sql` and applied to the Adventure database.
- [x] Simulated non-owner authenticated access: owner checks returned false and report visibility returned zero rows.
- [x] Supabase Security Advisor returned zero security lints after owner-only hardening.
- [ ] Create and provision the first owner Auth account using `docs/ADMIN_OWNER_BOOTSTRAP.md`.
- [ ] Run authenticated owner, ordinary-member and anonymous access tests after the owner Auth account is provisioned.
- [ ] Verify report status update and audit trail end-to-end using a real test report after owner login is available.
- [ ] Add member suspension/reinstatement only after the status and appeal model is designed.

## Main Adventure experience — remaining work

- [ ] Connect public discovery to real approved/discoverable profiles.
- [ ] Provision test Auth users and verify member sign-in, profile read/write and password recovery end-to-end.
- [ ] Build controlled member registration and email verification after safety gates pass.
- [ ] Test live discovery, follow/unfollow, report submission and block behaviour with two real Auth test accounts, including privacy edge cases.
- [ ] Add report and block controls to member profiles.
- [ ] Implement avatar storage with per-user path restrictions and safe file limits.
- [ ] Publish privacy information, community rules, retention and account deletion process.
- [ ] Add feed, Shorts, communities and messaging in separately tested phases.

## Deployment status

- [x] GitHub Pages configured to publish from `main` / root.
- [x] Earlier Pages deployment succeeded (run `45202483011`, commit `1ee4812ab22a1db265d5bff31daffbee73946e08`).
- [x] Latest admin dashboard, member account, discovery, follow, report and block source build/deployment completed successfully in Pages run `45207770527` for commit `cfe65c2a5cbc728e9a801d5d5339a32e84cf90ab`.
- [ ] Verify the published site visually in a browser on desktop and mobile; the automated deployment succeeded, but direct browser verification is still outstanding.
- Expected public URL: `https://iyenagbegodswillgodswill-debug.github.io/-adventure-social/`.

## Safety and cost guardrails

Adventure is separate from Mktradehome, Data2Coin and BIGMK Furniture. The database project is isolated from those projects. It was created on the Free plan with a quoted $0 monthly project cost; this does not guarantee that future usage, storage, bandwidth or optional services can never incur charges. Do not upgrade, enable paid add-ons or accept a nonzero cost without explicit user approval.

Never put service-role keys, database passwords or other secrets in browser code or the public repository. Keep the public preview clearly labelled as a demo until authentication, privacy, moderation and release tests are complete. Do not invite real members or collect real personal information yet.


## Owner management and AI operations roadmap

- [x] Inspected the live owner dashboard and Adventure database before expanding the control centre.
- [x] Added `docs/OWNER_MANAGEMENT_AI_PLAN.md` with phased requirements, AI safety boundaries, privacy/security rules and release guardrails.
- [ ] Implement owner member operations, verification centre, AI assist-first workflows, announcements and analytics in separately reviewed and tested phases.
- [ ] Keep AI recommendations distinct from owner decisions; no autonomous identity verification, permanent bans, sensitive evidence disclosure or irreversible enforcement.
- [ ] Keep AI provider credentials server-side and do not enable paid AI services without explicit owner approval.


## Admin dashboard visual identity update — 2026-11-24

- [x] Applied the requested premium gold-and-red theme to the private owner Admin Dashboard.
- [x] Updated browser theme color, navigation/sidebar palette, primary accents and login background.
- [x] Preserved existing authentication and owner-only access logic; this commit is a visual-only change.
- [ ] Verify the deployed GitHub Pages workflow and inspect the dashboard on desktop and mobile before calling the theme rollout complete.
- [ ] Continue phased implementation from `docs/OWNER_MANAGEMENT_AI_PLAN.md`; no new management or AI capabilities are claimed complete by this visual update.


## Owner member controls — 2026-11-24

- [x] Added a private account-control table for member restrictions and suspensions; no public Data API access is granted.
- [x] Added owner-checked server functions to list member status and apply/reinstate member restrictions.
- [x] Every account status change records the previous/new status, reason and optional expiry in the private admin audit log.
- [x] Updated the Admin Dashboard member directory with Active / Restricted / Suspended controls, reason and optional expiry fields.
- [ ] Verify owner and non-owner RPC access, run database advisors, and complete a live owner-dashboard smoke test.
- [ ] Finish verification review, AI Operations Manager, announcements, analytics and final release checks. Registration remains closed.
