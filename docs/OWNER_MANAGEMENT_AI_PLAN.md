# Adventure Owner Management & AI Operations Plan

Last updated: 2026-11-24

## Product goal
Build a practical owner control centre for Adventure, supported by an AI Operations Manager that reduces routine workload while keeping the owner in control. This document distinguishes shipped functionality from planned functionality.

## Verified current state
- Owner-only Admin Control Centre is deployed in `admin.html`.
- Dashboard views: Overview, Reports & Safety, Members, Audit Activity, AI Operations and Rules & Policies Manager.
- Owner-only database authorization and single-owner constraint are in place.
- Member account status controls are implemented in the database and dashboard: Active, Restricted, Suspended; reason, optional expiry and audit logging.
- Restriction enforcement currently covers profile updates, follows, blocks and report submission. Suspended profiles are excluded from public discovery.
- Public registration remains disabled.
- The latest Pages workflow for commit `312339308f868897003d61c743f4538ae2fbc66e` succeeded (run `45491662650`).
- **AI Operations foundation is installed but provider-backed generation is not active.** The owner dashboard now includes briefing and report-triage actions; a JWT-protected Supabase Edge Function verifies the signed-in owner and a private audit table records outputs. The function is deployed, but no `OPENAI_API_KEY` secret is configured, so it safely returns an inactive/setup-needed state without making provider calls.
- The public `member_is_suspended` RPC wrapper was removed; profile discovery RLS now calls the private helper directly. Private-schema USAGE and helper execution grants still need a full dependency review and anonymous discovery regression test.
- Supabase Security Advisor currently reports leaked-password protection disabled.

## Implemented AI foundation (2026-11-24)
- Private `ai_operations_runs` audit table with RLS, owner-only read policy, and no anon access. Owner-only history RPC is verified against owner and synthetic non-owner claims.
- Deployed `adventure-ai-operations` Edge Function, JWT verification enabled, owner verification before data access.
- Dashboard AI Operations section with briefing, report-triage controls and private AI run history.
- Initial scope sends only report IDs, reason, details, status and timestamps (limited to 100 recent reports); report text is treated as untrusted input.
- AI output is advisory only. No automated bans, report resolution, verification decisions, member messaging or other consequential actions.
- Provider activation requires explicit owner approval of OpenAI, API key setup and a usage budget.

## Implemented Rules & Policies Manager (2026-11-24)
- Owner-only dashboard editor for the eight rule records and three policy documents.
- Edit rule descriptions, examples, severity and per-rule penalty ladder; update document title, summary and body.
- Explicit preview/active/retired states; Terms and Privacy cannot be activated until legal/privacy details are completed.
- Content changes increment record versions. Database trigger writes owner-only audit entries.
- No automatic member penalties are enabled.

## Target owner workspace
1. **Overview & platform health:** member totals, new members, discovery, report queue, verification queue, activity and service health; visibly flag stale/unavailable data.
2. **Member management:** profile detail, account status, reports, blocks, moderation history, expiry, notification and appeal support. Never silently delete member data as moderation.
3. **Verification centre:** consent-based applications, clear categories and criteria, private evidence storage, strict access, short retention, deletion and appeals. AI can check completeness but cannot decide identity authenticity.
4. **Reports & safety:** severity, duplicate grouping, context, case notes, escalation and appeal. AI can classify, prioritize and recommend; the owner decides serious or irreversible enforcement.
5. **Announcements:** draft, preview, target, schedule and send, with owner confirmation and delivery/failure records.
6. **Analytics:** aggregate growth, activity, discovery/follow trends, report rates and verification turnaround; avoid unnecessary individual-level exposure.
7. **Audit & governance:** who/what initiated an action, when, target, reason, outcome and whether AI suggested or performed it; provider status, automation settings and pause switch.

## AI Operations Manager boundaries

### Permitted after testing
- Aggregate platform health checks and summaries.
- Report categorization, duplicate suggestions, urgency recommendations and case summaries.
- Verification application completeness checks only.
- Spam/scam pattern alerts with supporting signals and uncertainty.
- Drafting member notices and owner briefings.
- Narrow, reversible housekeeping only after explicit enablement and evaluation.

### Always require owner approval
- Permanent bans or irreversible account actions.
- Verification approval/rejection.
- Removal of disputed content in serious cases.
- Bulk member messaging.
- Access to or disclosure of private evidence.
- Privacy, security, billing, retention or platform-wide settings.

### Security and privacy requirements
- Provider credentials remain server-side secrets, never in browser JavaScript or GitHub.
- Use least privilege and server-side authorization; never trust client-supplied roles or model output.
- Treat member content and evidence as untrusted input, not instructions.
- Send only minimum necessary data; redact identifiers where possible.
- Log recommendations and actions, retain explanations, and provide a global pause switch.
- No facial recognition, biometric matching or AI claims of proving identity.
- No paid provider, plan upgrade or metered service without explicit owner approval.

## Delivery phases

### Phase 0 — foundation
- [x] Inspect dashboard and database baseline.
- [x] Record phased roadmap and safety boundaries.
- [ ] Complete security grant/helper review, test plan and rollback plan.

### Phase 1 — owner member operations and governance
- [x] Implement member directory account statuses.
- [x] Implement owner-checked restriction/suspension/reinstatement with reason, optional expiry and audit logging.
- [x] Add Rules & Policies Manager with owner-only editing, publication safeguards and audit trail.
- [ ] Add member notifications and automated expiry handling.
- [ ] Add policy acceptance records and version gates before opening registration.
- [ ] Complete owner, ordinary-member and anonymous end-to-end tests.

### Phase 2 — reports and appeals (owner workflow implemented; member connection pending)
- [x] Link report cases to community rule IDs and priority. Evidence uploads are deliberately not supported yet; no sensitive evidence is collected.
- [x] Add private case notes, resolution summary, owner-recorded decisions and audit history.
- [x] Add appeal database and owner review/decision workflow with written reasons.
- [x] Route report status changes through owner-checked audit-logged RPCs.
- [x] Connect member appeal submission and appeal-status display in the member account page.
- [ ] Add member notices and proportionate reversible enforcement only after end-to-end review. No automatic permanent bans.

### Phase 3 — verification centre (deferred for privacy design)
- [ ] Define categories, consent, criteria, retention and appeal rules before collecting verification data.
- [ ] Do not collect identity documents, biometric data or sensitive evidence until private storage, access controls and deletion/retention are designed and tested.
- [ ] Build application queue, review history, owner decision and member notifications after the privacy design is approved.
- [ ] Test unauthorized evidence access and deletion/retention.

### Phase 4 — AI Operations Manager
- [x] Deploy owner-gated JWT-protected server-side operations function and private run history.
- [x] Add advisory daily briefing and report-triage operations; no member/account changes are permitted.
- [x] Keep reports as untrusted input and log operation outcomes privately.
- [ ] Confirm provider, data-sharing boundaries and acceptable cost with owner before configuring a provider key.
- [ ] Evaluate false positives, missed severe cases, prompt injection, privacy and cost before any broader use.
- [ ] Keep owner approval and a global pause switch; recommendations only.

### Phase 5 — communications and analytics
- [x] Add owner announcements manager with draft, publish and archive controls and database audit trail.
- [x] Connect public announcement display in the landing page.
- [x] Add aggregate 7-day/30-day activity metrics and database governance checks.
- [ ] Add additional health alerts and deployment monitoring.

### Phase 6 — release readiness
- [ ] Complete security, privacy, moderation, accessibility and mobile tests.
- [ ] Keep public registration closed until the owner explicitly approves launch readiness.

## Non-negotiable guardrails
- Preserve owner-only authorization and the public registration lock.
- Make schema changes through reviewed migrations; test against Adventure only.
- Do not weaken RLS or expose private schemas/evidence to public clients.
- Do not modify Mktradehome, Data2Coin or BIGMK Furniture.
- Do not claim a phase complete until deployed and verified.
- Do not incur paid costs or send member data to an AI provider without explicit approval.


## Dashboard delivery update — 2026-11-24
The owner dashboard now includes the report case workflow, appeals review queue and announcements manager. Report and appeal operations use owner-checked private helpers behind SECURITY INVOKER public RPCs. Case notes stay in the private schema; appeal members can only read their own records; published announcements are public-read while drafts remain owner-only. Report status, case changes, appeal decisions and announcement changes are audit logged.

The five exposed owner RPCs were changed to SECURITY INVOKER wrappers after the Supabase Security Advisor flagged public SECURITY DEFINER entrypoints. A fresh security check no longer reports those functions. The remaining Security Advisor warning is leaked-password protection being disabled; this setting still needs an owner-side Auth configuration review.

Member appeal submission/status, public announcements display and aggregate analytics are now connected. Remaining dashboard/release connections are policy acceptance/version gates, complete legal/privacy details, the verification privacy design and authenticated end-to-end testing. Verification is deliberately deferred until consent, evidence handling, retention and deletion safeguards are designed. No paid AI provider has been enabled, and registration remains closed.


The owner dashboard now includes aggregate analytics and database governance checks. Analytics are limited to counts and activity totals; no private member content is surfaced.


## Main app progress — 2026-11-24
The first main-app feature phase is implemented: a signed-in text Feed with public/followers visibility, likes, comments, post reporting and account-restriction-aware controls. Like/comment counters are maintained by database triggers; clients cannot update them directly. Members with an active restriction can see their own reason/expiry and submit an appeal, while the owner reviews appeals in the dashboard. Published announcements now appear on the landing page.

Remaining main-app phases are tracked in `docs/MAIN_APP_ROADMAP.md`: richer profiles/media, Communities, Adventure Shorts, messaging/notifications and Discover Africa. Keep registration closed until real authenticated browser tests, privacy/legal completion and release gates pass.
