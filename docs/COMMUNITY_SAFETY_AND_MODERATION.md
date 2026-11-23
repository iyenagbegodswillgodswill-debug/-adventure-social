# Adventure — Community Safety and Moderation Plan

Last updated: 2026-11-23  
Status: Safety requirements documented; first report/block controls and admin report-status workflow are implemented but await real-account end-to-end tests.

## Why this exists

Adventure is intended to help people discover one another, share cultures and build communities across Africa. A social product needs clear behaviour rules and a credible response process before it invites real members. This document defines the minimum operating standard for the first invite-only pilot.

## Member-facing community rules

Members must not use Adventure to:

- Harass, threaten, stalk, intimidate or repeatedly target another person.
- Share private personal information, intimate images or identifying details without permission.
- Impersonate another person, organisation or public service.
- Defraud, phish, run fake giveaways or solicit money through deceptive claims.
- Spam, manipulate follows or engagement, or use automated accounts to mislead people.
- Promote violence, exploitation, human trafficking or dangerous criminal activity.
- Publish sexual exploitation content or any sexual content involving minors.
- Encourage self-harm or target people with hateful or dehumanising abuse.
- Upload content they do not have the right to share.
- Evade a block, suspension or other safety restriction.

Respectful disagreement, cultural discussion and criticism are allowed. Moderation should focus on harmful conduct and clear rule violations, not simply unpopular opinions.

## Minimum safety controls before the first real member

1. [x] A visible report action on real discoverable member profiles.
2. [x] A block action that prevents profile discovery and follow interactions in both directions; existing follows are removed.
3. [x] Private report records with restricted reviewer access and moderator-only status changes.
4. [x] A private server-managed administrator role registry and owner/moderator authorization checks.
5. [ ] A way to suspend and reinstate an account while a serious report is reviewed.
6. [ ] A published contact route for urgent safety concerns and privacy requests.
7. [ ] An account deletion and data-retention procedure.
8. [ ] A process for reviewing appeals or correcting mistaken enforcement.

Do not enable registration until these controls are implemented and tested. The static preview may remain available with clearly labelled sample profiles.

## Report handling workflow

1. **Receive:** Store the reporter, reported profile, allowlisted reason, optional bounded details and server timestamp. Do not expose the report publicly.
2. **Triage:** Prioritise credible threats, exploitation, doxxing and immediate safety risks. Record who reviewed the report and when.
3. **Review:** Check the reported behaviour and available context. Avoid treating an allegation as proof by itself.
4. **Act:** Use proportionate actions: no action, warning, content removal, temporary restriction or account suspension. Escalate urgent threats through appropriate local emergency or specialist channels where warranted.
5. **Notify:** Tell affected members what action was taken when safe and appropriate, without disclosing another member's private report details.
6. **Close:** Record the outcome, reviewer and resolution time. Retain only what is necessary under a documented retention schedule.

## Moderator access and accountability

- Moderator permissions must be assigned through a trusted server-controlled process, never a user-editable profile field or client-side flag.
- Use least privilege: moderators should access only the reports and account controls required for their duties.
- Keep an audit trail for report access, decisions and account restrictions.
- Require a second review for permanent bans or other high-impact decisions where staffing allows.
- Never publish report details, reporter identity or private member data in a public directory.
- If no one is available to review reports, pause new registrations rather than pretending moderation is staffed.

## Privacy and data minimisation

- Collect only the information needed to run the account and safety workflow.
- Do not ask for government ID, exact home address, contact lists or date of birth for this MVP.
- Explain what report details are collected, who can review them and how long they are kept.
- Define retention and deletion rules before collecting real reports.
- Keep authentication secrets and privileged database keys off the client.
- Do not promise absolute confidentiality where a serious safety or legal obligation may require escalation.

## Pilot launch recommendation

Start with a small, invite-only group in Ghana. Add members gradually only when the team can respond to reports in a reasonable time. Keep public posting, direct messaging, live video and open communities out of the first pilot; each creates additional abuse and moderation risks that need separate controls.

## Readiness gate

This plan is not a substitute for legal review or a staffed moderation operation. Before launch, publish member-facing rules and privacy information, assign an accountable safety contact, implement suspension/account-deletion workflows, test authorization boundaries with real accounts and rehearse a sample report from submission through closure.
