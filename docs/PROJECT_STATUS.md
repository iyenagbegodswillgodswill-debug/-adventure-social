# Adventure — Project Status

Last updated: 2026-11-24 (Adventure text Feed foundation added)

## Current milestone: Main app Phase 1 — text Feed

### Verified foundation
- [x] Separate public GitHub repository and Adventure-only Supabase project.
- [x] Mobile-first public preview, PWA shell, account page and opt-in profile discovery.
- [x] Profiles, follows, blocks and reports with row-level security.
- [x] Private owner registry, audit log and database-enforced single-owner authorization.
- [x] Owner dashboard with Overview, Reports & Safety, Members, Audit Activity, AI Operations and Rules & Policies Manager.
- [x] Public registration remains disabled.
- [x] Premium gold/red owner dashboard theme.
- [x] Private member account controls for Active / Restricted / Suspended, with reason, optional expiry and owner audit record.
- [x] Restriction enforcement on profile updates, follows, blocks and report submissions; suspended profiles are excluded from public discovery.
- [x] Owner member directory uses the owner-checked `admin_list_members` RPC and status changes use `admin_set_member_status`.
- [x] Private control table has RLS enabled and no direct anon/authenticated table access.
- [x] Exactly one owner row was confirmed.
- [x] Main app Feed now supports text posts, public/followers visibility, likes, comments and post reporting.
- [x] Database triggers maintain like/comment counts; clients cannot directly edit counters.
- [x] Member account page supports eligible appeals and displays the member's own restriction reason/expiry.
- [x] Published owner announcements are displayed on the public landing page.
- [x] Latest Pages workflow for commit `312339308f868897003d61c743f4538ae2fbc66e` completed successfully: run `45491662650`, including build and deploy jobs.

### AI Operations Manager — foundation installed, provider activation pending
- [x] Added the private `ai_operations_runs` audit table with RLS enabled and no direct anon/authenticated access.
- [x] Deployed JWT-protected Supabase Edge Function `adventure-ai-operations` (active, version 2); verifies the signed-in user and owner access before processing.
- [x] Added the AI Operations section to the owner dashboard with briefing, report-triage and private AI run-history actions.
- [x] AI prompt treats report contents as untrusted data; outputs are recommendations only and cannot change member/report status.
- [x] Dashboard, Edge Function source and database migration are saved in GitHub.
- [ ] AI generation is not active until the owner approves an AI provider and usage budget and the server-side `OPENAI_API_KEY` secret is configured. No provider calls are made without that secret.
- [x] Database-level owner/non-owner gate checks passed for the AI audit-history RPC (owner allowed; synthetic non-owner denied).
- [ ] Live browser session tests for owner/non-owner and a successful provider-backed test remain outstanding. The provider setup response is safely surfaced in the dashboard.

### Security review — still open
- [ ] Review and tighten the `private` schema USAGE grants for anon/authenticated without breaking existing RLS policy helper calls or public wrapper functions. Current inspection confirms both roles have USAGE; do not revoke until dependencies are mapped and regression-tested.
- [x] Removed the public RPC wrapper for `member_is_suspended`; the discovery RLS policy now calls the private helper directly. Verified the public wrapper is absent and the policy expression uses the private helper.
- [ ] Finish review of private-schema USAGE and helper execution grants; anonymous discovery regression test is still outstanding.
- [ ] Enable Supabase leaked-password protection after reviewing the available Auth setting and testing sign-in/reset behaviour. Security Advisor currently reports this one warning.
- [ ] Complete authenticated owner, ordinary-member and anonymous smoke tests using dedicated test accounts.
- [ ] Verify restriction, expiry and reinstatement behaviour end-to-end with a non-owner test account. Do not test by restricting a real member.

### AI Operations Manager — installed, provider inactive
- [x] JWT-protected `adventure-ai-operations` Edge Function is deployed and ACTIVE; owner gate, advisory-only operations and private run history are in place.
- [x] Owner dashboard includes AI briefing, report-triage recommendations and AI run history.
- [ ] No AI provider credential is configured. Provider calls remain unavailable until the owner explicitly approves provider, data-sharing boundaries and any usage cost.
- [ ] Authenticated owner/non-owner browser tests and provider-backed test remain outstanding.
- [x] AI cannot execute moderation, verification, member messaging or account-status actions.

### Remaining dashboard and release work
- [x] Report case records: private owner notes, rule mapping, priority, recorded decision and resolution summary.
- [x] Report status changes now use owner-checked RPCs and write audit records.
- [x] Appeals database and owner review centre; final decisions require written reasons and do not automatically change member account status.
- [x] Owner announcements manager with draft/publish/archive controls and database audit trigger.
- [x] Member-facing appeal submission and appeal-status display are connected in the member account page.
- [x] Public announcements display is connected to the landing page.
- [ ] Verification remains intentionally deferred until consent, non-sensitive collection, private storage, retention/deletion and appeal design are approved. Do not collect identity documents or biometrics yet.
- [x] Add aggregate analytics and database governance checks; [ ] add policy acceptance/version gates before enabling registration.
- [ ] Complete authenticated owner, ordinary-member and anonymous end-to-end browser tests.
- [ ] Finalise legal Terms and Privacy details before launch.

## Deployment and release
- [x] GitHub Pages configured from `main` / root.
- [x] Latest known deployment run `45491662650` succeeded for commit `312339308f868897003d61c743f4538ae2fbc66e`.
- [ ] Verify the latest owner dashboard deployment after latest owner dashboard commit `52578dce374ecd18d98954f0e4c89ed3e10df5f4`; visually inspect desktop/mobile and complete authenticated owner/non-owner smoke tests.
- [ ] Keep public registration closed and the site in preview until security, privacy, moderation and release checks pass.

## Safety and cost guardrails
Adventure is separate from Mktradehome, Data2Coin and BIGMK Furniture. The Supabase project is on the Free plan; future usage, storage, bandwidth or optional services may still incur costs. Do not upgrade, enable paid add-ons or accept nonzero costs without explicit approval.

Never place service-role keys, database passwords, AI provider keys or other secrets in browser code or the public repository. Never invite real members or collect real personal information until release gates are complete. Do not use facial recognition or biometric identity matching. Do not claim AI is active until a provider is configured, the server-side function is deployed and tested, and its owner controls are verified.

## Working documents
- Owner AI roadmap: `docs/OWNER_MANAGEMENT_AI_PLAN.md`
- Owner bootstrap guide: `docs/ADMIN_OWNER_BOOTSTRAP.md`


## Community Rules & Terms/Policies — owner manager added
- [x] Created public `policies.html`, linked from the homepage footer.
- [x] Added a database-backed Community Guidelines catalogue with eight stable rule IDs, severity labels, examples, versions and rule-specific graduated penalty ladders.
- [x] Added versioned Terms of Service, Privacy Policy and Community Guidelines document records.
- [x] Public policy tables are read-only for members/anonymous visitors; owner-only database policies govern management.
- [x] Added Rules & Policies Manager inside the existing owner dashboard: edit rules, examples, severity, penalty ladders and policy drafts; publish/retire supported records.
- [x] Policy catalogue changes create private owner audit entries through a database trigger.
- [x] Audit trigger migration is saved in `supabase/migrations/20261124235000_adventure_policy_catalogue_audit.sql`.
- [x] Terms and Privacy activation is deliberately locked until their missing legal/privacy details are finalised.
- [x] All policy records currently have `preview` status. The page clearly states that these are drafts, not effective member contracts or automatic enforcement settings.
- [ ] Finalise and owner-approve legal Terms and Privacy details before launch, including controller/contact details, retention, deletion, lawful bases and jurisdiction.
- [ ] Add member acceptance records and require acceptance of the current policy version before member features/registration are enabled.
- [x] Add report-to-rule linking, private case notes, appeals and owner-reviewed case decisions; evidence uploads remain intentionally disabled.
- [ ] Add tested AI classification recommendations and repeat-offender review; keep all consequential enforcement owner-approved.
- [ ] Do not enable automatic penalties until rule wording, thresholds, appeal handling and false-positive safeguards are approved and tested.
- [ ] Keep public registration closed.


## Owner dashboard expansion — 2026-11-24
- [x] Added report case workflow with rule linkage, priority, private notes, resolution summary and owner-recorded decision.
- [x] Added appeal review queue and written owner decisions; review does not silently reinstate or suspend a member.
- [x] Added owner announcements manager with draft, publish and archive; announcements are public-read only when published.
- [x] Added database audit entries for report status changes, report case edits, appeal reviews and announcement changes.
- [x] Reworked exposed owner RPCs as SECURITY INVOKER wrappers calling owner-checking private SECURITY DEFINER helpers; Supabase Security Advisor no longer flags those five public RPCs.
- [x] Split catalogue SELECT and owner write policies to avoid duplicate permissive SELECT policies.
- [x] Added supporting indexes for new foreign keys.
- [x] Added aggregate 7-day/30-day activity metrics and owner-only database governance checks; no individual member content is exposed in analytics.
- [x] Verified one owner, eight rules, three policy documents, five case/appeal RPCs plus analytics RPC, RLS on new public tables, and no remaining security findings except leaked-password protection.
- [ ] Live authenticated UI smoke tests still required; a source/database check is not a substitute for signing in as owner and non-owner.
- [ ] Latest Pages workflow is still queued; verify its final deployment result before relying on the live UI.
- [ ] Latest performance advisor reports only unused-index notices in the current low-traffic database; no unindexed foreign keys remain.

- [x] Analytics migration `20261124223619_adventure_owner_analytics_health.sql` saved in GitHub and applied to Supabase.


## Main app — Phase 1 Feed foundation — 2026-11-24
- [x] Added `posts`, `post_likes` and `post_comments` with RLS and least-privilege grants.
- [x] Added public/followers visibility checks, block-aware visibility and suspension hiding.
- [x] Added database-maintained like/comment counters and timestamp updates.
- [x] Restricted members cannot publish, like, comment or report; the account page explains the recorded restriction and provides appeal access when eligible.
- [x] Added post reporting with private report-time content snapshots, so owner review retains evidence even if the original post is deleted.
- [x] Added owner-approved reversible hide/restore for reported posts and comments, with reason required and audit logging; authors can see the moderation reason on their own hidden content.
- [x] Connected the member Feed, text composer, likes, comments, reporting and delete-own-post action in `index.html`.
- [x] Connected published announcements to the landing page.
- [x] Added appeal submission/history to `account.html`.
- [x] Added `supabase/tests/adventure_social_feed_security_checks.sql`; live structural checks passed, including RLS, table grants, RPC security mode, one-owner count and counter triggers.
- [x] JavaScript syntax checks passed for `index.html`, `account.html` and `admin.html`; static UI reference checks passed.
- [ ] Real owner/member browser tests and a two-member privacy/block/follow test remain outstanding.
- [ ] Latest Pages workflow is queued; confirm successful deployment and perform mobile/desktop smoke tests.
- [ ] Photo/avatar uploads, Shorts/video, Communities, messaging and real-time notifications are not implemented yet.
- [ ] Public registration remains closed; no AI provider or paid service has been enabled.

Roadmap: `docs/MAIN_APP_ROADMAP.md`. Data model review: `docs/DATA_MODEL_AND_RLS_REVIEW.md`.
