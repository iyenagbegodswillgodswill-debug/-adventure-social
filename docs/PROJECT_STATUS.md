# Adventure — Project Status

Last updated: 2026-11-24 (Owner Rules & Policies Manager added)

## Current milestone: Owner Control Centre hardening

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
- [x] Latest Pages workflow for commit `312339308f868897003d61c743f4538ae2fbc66e` completed successfully: run `45491662650`, including build and deploy jobs.

### AI Operations Manager — foundation installed, provider activation pending
- [x] Added the private `ai_operations_runs` audit table with RLS enabled and no direct anon/authenticated access.
- [x] Deployed JWT-protected Supabase Edge Function `adventure-ai-operations` (active, version 2); verifies the signed-in user and owner access before processing.
- [x] Added the AI Operations section to the owner dashboard with briefing, report-triage and private AI run-history actions.
- [x] AI prompt treats report contents as untrusted data; outputs are recommendations only and cannot change member/report status.
- [x] Dashboard, Edge Function source and database migration are saved in GitHub.
- [ ] AI generation is not active until the owner approves an AI provider and usage budget and the server-side `OPENAI_API_KEY` secret is configured. No provider calls are made without that secret.
- [x] Database-level owner/non-owner gate checks passed for the AI audit-history RPC (owner allowed; synthetic non-owner denied).\n- [ ] Live browser session tests for owner/non-owner and a successful provider-backed test remain outstanding. The provider setup response is safely surfaced in the dashboard.

### Security review — still open
- [ ] Review and tighten the `private` schema USAGE grants for anon/authenticated without breaking existing RLS policy helper calls or public wrapper functions. Current inspection confirms both roles have USAGE; do not revoke until dependencies are mapped and regression-tested.
- [x] Removed the public RPC wrapper for `member_is_suspended`; the discovery RLS policy now calls the private helper directly. Verified the public wrapper is absent and the policy expression uses the private helper.\n- [ ] Finish review of private-schema USAGE and helper execution grants; anonymous discovery regression test is still outstanding.
- [ ] Enable Supabase leaked-password protection after reviewing the available Auth setting and testing sign-in/reset behaviour. Security Advisor currently reports this one warning.
- [ ] Complete authenticated owner, ordinary-member and anonymous smoke tests using dedicated test accounts.
- [ ] Verify restriction, expiry and reinstatement behaviour end-to-end with a non-owner test account. Do not test by restricting a real member.

### AI Operations Manager — not live yet
- [ ] No AI Edge Function is deployed; Supabase currently reports zero Edge Functions.
- [ ] No AI provider or API credential has been configured.
- [ ] Build a provider-neutral, server-side AI service only after selecting a provider and receiving explicit approval for any API key, data sharing and possible usage cost.
- [ ] Start with report classification, duplicate suggestions, case summaries and owner briefings; recommendations only.
- [ ] Add AI audit records, owner review/approval, privacy minimisation, prompt-injection safeguards, evaluation and a global pause switch.
- [ ] Keep bans, verification decisions, evidence disclosure, bulk messaging and other consequential actions owner-approved.

### Remaining product work
- [ ] Verification centre with consent, private evidence storage, retention/deletion and appeal safeguards.
- [ ] Announcements with owner preview/approval and delivery records.
- [ ] Aggregate analytics and service-health monitoring.
- [ ] Member registration and email verification only after safety gates pass.
- [ ] Avatar storage with per-user path restrictions and safe file limits.
- [ ] Publish privacy information, community rules, retention and account deletion process.
- [ ] Build feed, Shorts, communities and messaging in separately tested phases.

## Deployment and release
- [x] GitHub Pages configured from `main` / root.
- [x] Latest known deployment run `45491662650` succeeded for commit `312339308f868897003d61c743f4538ae2fbc66e`.
- [ ] Verify the latest owner dashboard deployment after the Rules & Policies Manager commits; visually inspect desktop/mobile and complete authenticated owner/non-owner smoke tests.
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
- [x] Public policy tables are read-only for members/anonymous visitors; owner-only database policies govern management.\n- [x] Added Rules & Policies Manager inside the existing owner dashboard: edit rules, examples, severity, penalty ladders and policy drafts; publish/retire supported records.\n- [x] Policy catalogue changes create private owner audit entries through a database trigger.\n- [x] Audit trigger migration is saved in `supabase/migrations/20261124235000_adventure_policy_catalogue_audit.sql`.\n- [x] Terms and Privacy activation is deliberately locked until their missing legal/privacy details are finalised.
- [x] All policy records currently have `preview` status. The page clearly states that these are drafts, not effective member contracts or automatic enforcement settings.
- [ ] Finalise and owner-approve legal Terms and Privacy details before launch, including controller/contact details, retention, deletion, lawful bases and jurisdiction.
- [ ] Add member acceptance records and require acceptance of the current policy version before member features/registration are enabled.\n- [ ] Add report-to-rule linking, evidence handling, appeals and reviewed enforcement.
- [ ] Add rule-linked evidence review, AI classification recommendations, proportionate reversible enforcement, appeals, repeat-offender handling and audit history.
- [ ] Do not enable automatic penalties until rule wording, thresholds, appeal handling and false-positive safeguards are approved and tested.
- [ ] Keep public registration closed.
