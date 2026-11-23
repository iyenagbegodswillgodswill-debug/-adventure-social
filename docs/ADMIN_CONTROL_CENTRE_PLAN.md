# Adventure — Admin Control Centre

Last updated: 2026-11-23
Status: First secure dashboard foundation implemented; owner provisioning and live authenticated tests remain.

## Purpose

Adventure has a dedicated private administration area, separate from member profiles and ordinary navigation. The initial console is deliberately limited to operations backed by real database controls.

## Implemented

- Private `admin.html` sign-in and owner-only access gate using Supabase Auth.
- Server-managed role registry in the non-exposed `private.admin_users` table. No client API can grant roles.
- Database-side `private.is_admin()` and `private.can_review_reports()` checks.
- Overview metrics for profile count, discoverable profiles, follows and report status.
- Member directory lookup showing only minimal profile fields.
- Private report queue with status transitions: new, reviewing, resolved and dismissed.
- Status changes automatically create records in a private audit log.
- Admin audit activity is available only through a server-checked function.
- Direct access to role and audit tables is denied; public report access remains denied.
- Public discovery helper access retained for anonymous visitors; profile discovery remains governed by the existing privacy policy.
- Security advisor returned zero security lints after the admin migrations.

## Planned / not yet implemented

1. Provision the first owner account using `docs/ADMIN_OWNER_BOOTSTRAP.md`.
2. Run live authenticated tests with an owner, ordinary member and anonymous visitor.
3. Add reasoned member suspension/reinstatement after designing the member status model and its appeal/audit flow.
4. Add report assignment, internal case notes and a documented retention policy.
5. Add content and community controls only after those member-facing features exist.
6. Add separate moderator/support roles after testing least-privilege boundaries.

## Security requirements

- The admin route is not a security boundary. Every privileged read and write is checked by backend authorization and RLS.
- Never use a client-editable profile field, email address, hidden button or hard-to-guess URL as proof of administrator status.
- Only a trusted project owner can grant or revoke roles through the private database registry.
- Reports and moderation details are inaccessible to ordinary members and public/anonymous clients.
- Report status changes are audited with actor, action, target, timestamp and old/new status.
- Service-role keys, database passwords and privileged tokens must never appear in browser JavaScript, HTML, GitHub or public documentation.
- Test authorization using anonymous, ordinary member, moderator and owner accounts. Test both allowed and denied actions.

## Launch and cost guardrails

- Keep this within the existing Adventure Supabase Free project and GitHub Pages while the required features fit their free tiers.
- Do not create another database project or enable paid services.
- Stop before any nonzero-cost upgrade, add-on or external service.
- Do not enable public member registration until the report-review workflow, accountable administrator access, suspension process, privacy information and account-deletion path are ready.
