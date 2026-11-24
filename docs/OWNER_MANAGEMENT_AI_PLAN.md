# Adventure Owner Management & AI Operations Plan

Last updated: 2026-11-24

## Product goal
Build a practical owner control centre for Adventure, supported by an AI Operations Manager that reduces routine workload while keeping the owner in control. This document distinguishes shipped functionality from planned functionality.

## Verified current state
- Owner-only Admin Control Centre is deployed in `admin.html`.
- Dashboard views: Overview, Reports & Safety, Members, Audit Activity.
- Owner-only database authorization and single-owner constraint are in place.
- Member account status controls are implemented in the database and dashboard: Active, Restricted, Suspended; reason, optional expiry and audit logging.
- Restriction enforcement currently covers profile updates, follows, blocks and report submission. Suspended profiles are excluded from public discovery.
- Public registration remains disabled.
- The latest Pages workflow for commit `312339308f868897003d61c743f4538ae2fbc66e` succeeded (run `45491662650`).
- **AI is not implemented or live.** No Edge Functions are deployed and no provider credential is configured.
- A security review remains open for private-schema USAGE grants and helper-function exposure. Do not claim the current configuration is fully hardened until this is resolved and regression-tested.
- Supabase Security Advisor currently reports leaked-password protection disabled.

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

### Phase 1 — owner member operations
- [x] Implement member directory account statuses.
- [x] Implement owner-checked restriction/suspension/reinstatement with reason, optional expiry and audit logging.
- [ ] Add member notifications, appeal workflow and automated expiry handling.
- [ ] Complete owner, ordinary-member and anonymous end-to-end tests.

### Phase 2 — verification centre
- [ ] Define categories, consent, criteria, retention and appeal rules.
- [ ] Implement private evidence submission/storage and strict access controls.
- [ ] Build application queue, review history, owner decision and member notifications.
- [ ] Test unauthorized evidence access and deletion/retention.

### Phase 3 — AI Operations Manager
- [ ] Confirm provider, data-sharing boundaries and acceptable cost with owner.
- [ ] Implement provider-neutral server-side function and secrets configuration.
- [ ] Start with report classification, duplicate suggestions, case summaries and daily owner briefings.
- [ ] Add owner review/approval and AI audit events.
- [ ] Evaluate false positives, missed severe cases, prompt injection, privacy and cost.
- [ ] Add global pause switch; recommendations only at first.

### Phase 4 — communications and analytics
- [ ] Build owner-approved announcements and delivery records.
- [ ] Add aggregate analytics and health alerts.

### Phase 5 — release readiness
- [ ] Complete security, privacy, moderation, accessibility and mobile tests.
- [ ] Keep public registration closed until the owner explicitly approves launch readiness.

## Non-negotiable guardrails
- Preserve owner-only authorization and the public registration lock.
- Make schema changes through reviewed migrations; test against Adventure only.
- Do not weaken RLS or expose private schemas/evidence to public clients.
- Do not modify Mktradehome, Data2Coin or BIGMK Furniture.
- Do not claim a phase complete until deployed and verified.
- Do not incur paid costs or send member data to an AI provider without explicit approval.
