# Adventure — Release Readiness Checklist

Last updated: 2026-11-23  
Status: Working checklist. The current site is an early static preview, not a public social network.

## A. Prototype and deployment

- [x] Source code stored in the dedicated Adventure GitHub repository.
- [x] GitHub Pages configured from `main` / root.
- [x] Latest planning commit deployed successfully by GitHub Actions.
- [ ] Open the published URL on desktop and phone.
- [ ] Check small-screen layout, navigation overflow, text size and touch targets.
- [ ] Test search, interest filters, Follow/Unfollow and browser refresh.
- [ ] Confirm preview notice is visible and demo interactions are clearly described.
- [ ] Confirm planned navigation items do not pretend to work.

## B. Account and profile MVP

- [ ] Separate Adventure backend project created and billing/free-tier limits reviewed.
- [ ] Email verification, sign-in, sign-out and password recovery tested.
- [ ] Profile creation/editing and username uniqueness tested.
- [ ] Discoverability preference works.
- [ ] Public directory returns only approved public profile fields.
- [ ] Profile image upload, replacement and deletion are secured.
- [ ] No email, private identifiers, secrets or service-role keys exposed to the browser.

## C. Security and privacy

- [ ] RLS enabled on every exposed table.
- [ ] Ownership policies use both row visibility and update checks.
- [ ] Anonymous and cross-account API tests pass.
- [ ] Follow and block rules are enforced by the database.
- [ ] Reports are private and moderation status is protected.
- [ ] Moderator privileges use trusted server-controlled authorization.
- [ ] Account deletion and data retention behaviour are documented and tested.
- [ ] Backups and recovery procedure are understood.
- [ ] Privacy notice explains what data is collected, why, visibility and deletion.
- [ ] Terms/community rules and a contact route for safety reports are ready.

## D. Moderation and launch controls

- [ ] A named owner/process is ready to review reports.
- [ ] Report reasons and escalation process are defined.
- [ ] Blocked accounts cannot continue unwanted interactions.
- [ ] Abuse, spam, impersonation and harmful-content response is documented.
- [ ] Initial launch is invite-only unless moderation capacity supports open registration.
- [ ] No public posting, messaging, Shorts or communities until their moderation controls are built and tested.

## E. Performance, accessibility and data use

- [ ] Test on a lower-end phone and a slower mobile connection.
- [ ] Avoid autoplaying video and unnecessary large assets.
- [ ] Images have sensible dimensions and loading behaviour.
- [ ] Keyboard navigation, labels, focus states and contrast are checked.
- [ ] Directory uses pagination and bounded search results.
- [ ] No unnecessary third-party trackers or analytics collect personal data.

## F. Launch decision

A successful GitHub Pages build is not a launch approval. Adventure is ready for real members only after sections B, C and D are complete, critical tests pass, and the owner explicitly approves the release.

## Current release decision

**Not ready for public registration.** Continue with the static preview and backend design review. Do not collect real member information yet.
