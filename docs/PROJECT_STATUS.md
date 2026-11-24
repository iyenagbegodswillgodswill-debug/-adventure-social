# Adventure — Project Status

Last updated: 2026-11-24

## Current milestone: Owner Control Centre hardening

### Verified foundation
- [x] Separate public GitHub repository and Adventure-only Supabase project.
- [x] Mobile-first public preview, PWA shell, account page and opt-in profile discovery.
- [x] Profiles, follows, blocks and reports with row-level security.
- [x] Private owner registry, audit log and database-enforced single-owner authorization.
- [x] Owner dashboard with Overview, Reports & Safety, Members and Audit Activity.
- [x] Public registration remains disabled.
- [x] Premium gold/red owner dashboard theme.
- [x] Private member account controls for Active / Restricted / Suspended, with reason, optional expiry and owner audit record.
- [x] Restriction enforcement on profile updates, follows, blocks and report submissions; suspended profiles are excluded from public discovery.
- [x] Owner member directory uses the owner-checked `admin_list_members` RPC and status changes use `admin_set_member_status`.
- [x] Private control table has RLS enabled and no direct anon/authenticated table access.
- [x] Exactly one owner row was confirmed.
- [x] Latest Pages workflow for commit `312339308f868897003d61c743f4538ae2fbc66e` completed successfully: run `45491662650`, including build and deploy jobs.

### Security review — still open
- [ ] Review and tighten the `private` schema USAGE grants for anon/authenticated without breaking existing RLS policy helper calls or public wrapper functions. Current inspection confirms both roles have USAGE; do not revoke until dependencies are mapped and regression-tested.
- [ ] Review exposure of private helper functions, especially `member_is_suspended`, and ensure the public discovery policy still works for anonymous visitors after any hardening.
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
- [ ] Visually inspect the live owner dashboard on desktop and mobile and complete authenticated smoke tests.
- [ ] Keep public registration closed and the site in preview until security, privacy, moderation and release checks pass.

## Safety and cost guardrails
Adventure is separate from Mktradehome, Data2Coin and BIGMK Furniture. The Supabase project is on the Free plan; future usage, storage, bandwidth or optional services may still incur costs. Do not upgrade, enable paid add-ons or accept nonzero costs without explicit approval.

Never place service-role keys, database passwords, AI provider keys or other secrets in browser code or the public repository. Never invite real members or collect real personal information until release gates are complete. Do not use facial recognition or biometric identity matching. Do not claim AI is active until a provider is configured, the server-side function is deployed and tested, and its owner controls are verified.

## Working documents
- Owner AI roadmap: `docs/OWNER_MANAGEMENT_AI_PLAN.md`
- Owner bootstrap guide: `docs/ADMIN_OWNER_BOOTSTRAP.md`
