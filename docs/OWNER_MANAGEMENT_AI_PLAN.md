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

## Implemented AI foundation (2026-11-24)\n- Private `ai_operations_runs` audit table with RLS, owner-only read policy, and no anon access. Owner-only history RPC is verified against owner and synthetic non-owner claims.\n- Deployed `adventure-ai-operations` Edge Function, JWT verification enabled, owner verification before data access.\n- Dashboard AI Operations section with briefing, report-triage controls and private AI run history.\n- Initial scope sends only report IDs, reason, details, status and timestamps (limited to 100 recent reports); report text is treated as untrusted input.\n- AI output is advisory only. No automated bans, report resolution, verification decisions, member messaging or other consequential actions.\n- Provider activation requires explicit owner approval of OpenAI, API key setup and a usage budget.\n\n## Implemented Rules & Policies Manager (2026-11-24)\n- Owner-only dashboard editor for the eight rule records and three policy documents.\n- Edit rule descriptions, examples, severity and per-rule penalty ladder; update document title, summary and body.\n- Explicit preview/active/retired states; Terms and Privacy cannot be activated until legal/privacy details are completed.\n- Content changes increment record versions. Database trigger writes owner-only audit entries.\n- No automatic member penalties are enabled.\n\n## Target owner workspace
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
- [x] Add Rules & Policies Manager with owner-only editing, publication safeguards and audit trail.\n- [ ] Add member notifications, appeal workflow and automated expiry handling.\n- [ ] Add policy acceptance records and version gates before opening registration.
- [ ] Complete owner, ordinary-member and anonymous end-to-end tests.

### Phase 2 — reports, appeals and verification centre\n- [ ] Link reports to specific community rule IDs and evidence metadata.\n- [ ] Add private case notes, escalation, appeal submissions and owner decisions.\n- [ ] Add proportionate reversible enforcement recommendations; no automatic permanent bans.\n\n### Phase 3 — verification centre
- [ ] Define categories, consent, criteria, retention and appeal rules.
- [ ] Implement private evidence submission/storage and strict access controls.
- [ ] Build application queue, review history, owner decision and member notifications.
- [ ] Test unauthorized evidence access and deletion/retention.

### Phase 4 — AI Operations Manager
- [ ] Confirm provider, data-sharing boundaries and acceptable cost with owner.
- [ ] Implement provider-neutral server-side function and secrets configuration.
- [ ] Start with report classification, duplicate suggestions, case summaries and daily owner briefings.
- [ ] Add owner review/approval and AI audit events.
- [ ] Evaluate false positives, missed severe cases, prompt injection, privacy and cost.
- [ ] Add global pause switch; recommendations only at first.

### Phase 5 — communications and analytics
- [ ] Build owner-approved announcements and delivery records.
- [ ] Add aggregate analytics and health alerts.

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
