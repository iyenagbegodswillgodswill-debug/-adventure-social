# Adventure Owner Management & AI Operations Plan

Last updated: 2026-11-24

## Product goal

Build a practical owner control centre for Adventure, supported by an AI Operations Manager that reduces routine workload while keeping the owner in control of consequential decisions.

This is a phased implementation plan, not a claim that the features below already exist.

## Current verified baseline

- The owner-only Admin Control Centre is deployed in the repository as `admin.html`.
- Current dashboard views: Overview, Reports & Safety, Members, Audit Activity.
- Current database tables include `public.profiles`, `public.follows`, `public.blocks`, `public.reports`, `private.admin_users`, and `private.admin_audit_log`.
- The database has one owner row and enforces owner-only privileged access.
- Public registration remains disabled.
- No verification workflow, account suspension workflow, announcement centre, or AI operations service is currently implemented.
- Current profile/member tooling is read-only apart from report status changes. Do not present unimplemented controls as functional.

## Target owner workspace

1. **Overview & platform health**
   - Member totals, new members, discoverability, report queue, verification queue, recent activity, service health.
   - Clear warnings when data is stale or an integration is unavailable.

2. **Member management**
   - Search and inspect member profiles, account status, reports, blocks and moderation history.
   - Add controlled suspend, restrict, reinstate and appeal workflows only after status rules, member notifications, expiry, audit logging and appeal safeguards are designed.
   - Never silently delete member data as a moderation shortcut.

3. **Verification centre**
   - Member-submitted applications, category, reason, evidence checklist, review status and decision history.
   - Distinguish basic email/account verification from optional profile authenticity badges (for example public figure, creator, or organization), with clear published criteria.
   - Private evidence storage with least-privilege access, short retention, explicit consent, and deletion after the review/appeal retention period.
   - AI may check application completeness and flag inconsistencies for human review. AI must not autonomously decide identity authenticity or approve sensitive verification.

4. **Reports & safety**
   - Keep existing report queue and audit trail.
   - Add severity, duplicate grouping, evidence/context, case notes, escalation and appeal support in tested increments.
   - AI may classify and prioritize reports, explain uncertainty, and draft recommendations. The owner makes decisions on serious or irreversible enforcement.

5. **Announcements & member communications**
   - Draft, preview, target, schedule and send platform notices.
   - Require owner confirmation before broad sends; maintain delivery and failure records.

6. **Analytics**
   - Member growth, active usage, discovery/follow trends, report rates, verification turnaround and retention indicators.
   - Aggregate by default; avoid unnecessary exposure of individual member data.

7. **Audit & governance**
   - Record who/what initiated each privileged action, when, target, reason, outcome and whether AI suggested or performed it.
   - Provide owner-visible AI activity log, model/provider status, automation settings, and pause switch.

## AI Operations Manager: operating boundaries

### Permitted automation after testing
- Routine platform health checks and aggregate summaries.
- Report categorization, duplicate suggestions and urgency recommendations.
- Verification application completeness checks (not identity approval).
- Spam/scam pattern alerts with supporting signals and confidence/uncertainty.
- Drafting member notices and owner briefings.
- Low-risk housekeeping that is reversible, logged and explicitly enabled.

### Always require owner approval
- Permanent bans or irreversible account actions.
- Verification approval/rejection.
- Removal of disputed content in serious cases.
- Bulk member messaging.
- Access to or disclosure of private evidence.
- Changes to privacy, security, billing, retention or platform-wide settings.

### Security and privacy requirements
- AI provider credentials stay server-side in secrets, never in browser JavaScript or GitHub.
- Use least-privilege service access and server-side authorization; never trust client-supplied role or AI output.
- Treat member content and uploaded evidence as untrusted input, not instructions.
- Send an AI provider only the minimum data needed; redact identifiers where possible.
- Log AI recommendations and actions, retain an explanation and allow the owner to pause automation.
- No automated facial recognition, biometric matching, or claims that AI can prove a person's identity.
- No paid AI provider, plan upgrade or metered service without the owner's explicit approval.

## Delivery phases

### Phase 0 — foundation and design
- [x] Inspect current dashboard and database baseline.
- [x] Record this roadmap in the repository.
- [ ] Define moderation/account states, verification categories and retention/appeal rules before schema changes.
- [ ] Create a separate test plan and backup/rollback approach.

### Phase 1 — owner member operations
- [ ] Improve member directory with safe profile detail view and filters.
- [ ] Design and implement reversible restriction/suspension and reinstatement with reason, expiry, notification, appeal and audit records.
- [ ] Test owner, ordinary member and anonymous access.

### Phase 2 — verification centre
- [ ] Publish verification criteria and member consent flow.
- [ ] Implement private evidence submission/storage and strict access/retention rules.
- [ ] Build application queue, review history, owner decision and member notification.
- [ ] Test unauthorized evidence access and deletion/retention behaviour.

### Phase 3 — AI Operations Manager (assist-first)
- [ ] Define server-side AI service boundary and provider-neutral interface.
- [ ] Start with report classification, duplicate suggestions, case summaries and daily owner briefings.
- [ ] Add owner review/approve controls and AI audit events.
- [ ] Evaluate false positives, missed severe cases, prompt-injection resistance, privacy and cost before any automation.
- [ ] Add a global pause switch. Begin with recommendations only; enable narrow reversible automation only after evaluation.

### Phase 4 — communications and analytics
- [ ] Build owner-approved announcements and notification delivery records.
- [ ] Add aggregate analytics and health alerts.

### Phase 5 — release readiness
- [ ] Complete end-to-end security, privacy, moderation, accessibility and mobile tests.
- [ ] Keep public registration closed until the owner explicitly approves launch readiness.

## Non-negotiable project guardrails

- Preserve the existing owner-only authorization and public registration lock.
- Make schema changes through reviewed migrations; test against Adventure only.
- Do not weaken RLS or expose private schemas/evidence to public clients.
- Do not modify Mktradehome, Data2Coin or BIGMK Furniture.
- Do not claim a phase is complete until deployed and verified.
- Do not incur paid costs without explicit owner approval.
