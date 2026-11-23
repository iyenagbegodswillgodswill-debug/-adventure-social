# Adventure — Admin Control Centre

Last updated: 2026-11-23
Status: Product and security plan; no live admin dashboard is available yet.

## Purpose

Adventure will have a dedicated, private administration area for the people trusted to operate the platform. It is separate from member profiles and ordinary navigation. The first release should be a small, reliable operations console rather than a large collection of unfinished controls.

## Planned areas

1. **Overview:** member totals, new sign-ups, profile discoverability, open reports, recent moderation actions and basic service health. Show only metrics that can be calculated accurately.
2. **Members:** search and inspect the minimum profile information needed for support; apply documented restrictions or suspension; record the reason and duration.
3. **Reports and safety:** private report queue, priority, status, reviewer assignment, case notes, resolution and timestamps. Reporter identity and report details must never be exposed to other members.
4. **Content:** review and remove reported content when posts and media are implemented. No fake controls before those features exist.
5. **Communities:** manage community settings and access when communities are implemented.
6. **Platform settings:** manage approved categories, service announcements and carefully scoped feature settings.
7. **Administrators and audit log:** view administrator roles and a tamper-resistant history of privileged actions.

## Security requirements

- The admin route is not a security boundary. Every privileged read and write must be checked by the backend.
- Never use a client-editable profile field, email address, hidden button or hard-to-guess URL as proof of administrator status.
- Create a private server-managed administrator-role registry. Only a trusted server-side process may grant or revoke roles. Do not expose role-management permissions to normal clients.
- Require an authenticated session and server-side role verification for every admin operation. Deny by default.
- Use least privilege: begin with one owner administrator; add moderator/support roles only when needed, with narrower permissions.
- Keep reports and moderation notes inaccessible to ordinary members and public/anonymous clients.
- Record actor, action, target, timestamp, reason and outcome for sensitive operations. Do not allow admins to edit or delete audit history through the app.
- Require a reason for suspensions and content removals. Use temporary, reversible actions where appropriate. Permanent bans and other high-impact actions should require a second review when a second trusted administrator exists.
- Protect administrator sign-in with strong authentication and session controls. Do not build password or secret storage ourselves.
- Never place service-role keys, database passwords or privileged tokens in browser JavaScript, HTML, GitHub Pages or public documentation.
- Test authorization using an anonymous visitor, an ordinary member, a moderator (when introduced) and the owner administrator. Test both allowed and denied actions.

## Build sequence

1. Define the private role registry and server-side authorization checks.
2. Implement a minimal owner-only dashboard shell that reveals no sensitive data until authorization succeeds.
3. Add read-only overview metrics and member lookup with field minimisation.
4. Build the private report queue and audited moderation actions.
5. Add additional roles and approval workflow only when there is a real operational need.
6. Complete negative authorization tests and re-run Supabase security advisors before enabling the console for real operations.

## Launch and cost guardrails

- Keep this within the existing Adventure Supabase Free project and GitHub Pages while the required features fit their free tiers.
- Do not create another database project or enable paid services for the admin console.
- Stop before any nonzero-cost upgrade, add-on or external service.
- Do not enable public member registration until the report-review workflow, accountable administrator access, suspension process, privacy information and account-deletion path are ready.
- The dashboard is an operational tool, not a promise that every future feature can be moderated automatically.
