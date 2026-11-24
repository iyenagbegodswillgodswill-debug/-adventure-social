# Adventure — Main App Roadmap

Last updated: 2026-11-24

Adventure is an Africa-first social platform connecting people, cultures, communities and opportunities. The current main app is a mobile-first web app. Public registration remains closed while the member experience, moderation, privacy and release tests are completed.

## Current foundation — implemented in source and database

- [x] Adventurers directory with discoverable real member profiles and clearly labelled sample fallback for anonymous preview visitors.
- [x] Member sign-in and profile editing; new registration remains disabled.
- [x] Follow/unfollow, block and profile reporting, plus account-page unblock management.
- [x] Text Feed for signed-in members.
- [x] Create text posts up to 2,000 characters.
- [x] Public or followers-only post visibility, enforced by RLS.
- [x] Like/unlike and comments, with database-maintained counters.
- [x] Post reporting connected to the private owner report queue, retaining a private snapshot of reported content.
- [x] Owner can reversibly hide/restore reported posts and comments with a written reason and audit log.
- [x] Restricted/suspended account interaction rules enforced by database policies.
- [x] Suspended authors' posts/comments hidden from other members.
- [x] Member account page displays own restriction reason/expiry and allows eligible members to submit an appeal.
- [x] Members can see their own appeal status and owner decision.
- [x] Published owner announcements appear on the public landing page.
- [x] Database structural checks pass for feed grants, RLS, triggers and single-owner guardrails.

## Next build phases

### Phase 2 — richer member profiles and media
- [ ] Add member profile detail pages and a safe profile-view route.
- [ ] Design avatar and image-post storage with private upload permissions, strict file type/size limits, safe delivery and deletion rules.
- [ ] Add photo posts only after Storage policies and moderation/report workflows are tested.
- [ ] Add profile and post editing controls with clear ownership rules.

### Phase 3 — Communities
- [ ] Community discovery and categories.
- [ ] Create/join/leave workflows and membership privacy.
- [ ] Community posts and owner/moderator controls with the same safety/reporting rules.
- [ ] Community rules and announcements that do not bypass platform-wide policies.

### Phase 4 — Adventure Shorts
- [ ] Decide supported video duration, file size, format and upload limits.
- [ ] Design storage, processing, playback, moderation and deletion before enabling video uploads.
- [ ] Add a vertical short-video browsing experience only after cost and bandwidth estimates are reviewed.
- [ ] No paid video service or add-on without explicit approval.

### Phase 5 — Messaging and notifications
- [x] Private one-to-one conversations with member discovery, block enforcement, spam controls and abuse reporting foundation.
- [x] Private voice-note recording, preview, upload and playback groundwork; text messages remain supported.
- [x] Optional browser speech-to-text assist with an explicit browser-processing notice; no paid AI provider is connected.
- [x] One-to-one audio/video call interface with incoming accept/decline, WebRTC signalling, mute, camera toggle and hang-up controls.
- [ ] Test actual two-member calls and verify private Realtime channel enforcement; STUN-only setup may need TURN for some networks.
- [ ] Add background/push call notifications only after consent and delivery costs are reviewed.
- [ ] Complete real two-member tests for text, voice, storage access, blocked users and mobile browser microphone support.
- [ ] Add AI-powered transcription, translation and message rewrite only after owner approval of provider, privacy boundaries and usage budget.
- [ ] Add in-app notifications for follows, comments, replies, appeals, announcements and messages.
- [ ] Add push notifications only after consent and delivery-provider costs are understood.

### Phase 6 — Discover Africa
- [ ] Build discovery categories for culture, places, events, creators and opportunities.
- [ ] Establish how listings are sourced, verified, reported and updated before publishing real-world claims.
- [ ] Add location-aware discovery only with clear user consent and privacy controls.

## Release gates

- [ ] Complete owner, ordinary-member, two-member and anonymous browser tests.
- [ ] Verify posts, comments, likes, follows, private profiles, blocks, suspensions and appeals under real authenticated sessions.
- [ ] Enable leaked-password protection and review Auth abuse controls.
- [ ] Complete Terms, Privacy, data retention, account deletion and policy acceptance/versioning.
- [ ] Test mobile layout, accessibility, slow connections, offline fallback and current deployment.
- [ ] Keep public registration closed until the owner explicitly approves launch.
- [ ] Do not enable paid services, paid AI, video infrastructure or nonzero recurring costs without explicit approval.

## Current scope limits

The Feed is text-only. Private voice messaging and one-to-one audio/video calling foundations are in place but require authenticated two-member browser testing. Calls currently rely on STUN and require both members to have Messages open; TURN and push notifications are not configured. Photo uploads, avatar uploads, Shorts/video and Communities remain future work. No AI provider is configured. The owner dashboard's AI features remain advisory-only and inactive without explicit provider approval.
 

## Africa-first expansion — initial roadmap
- [x] Create owner-reviewed marketplace listing foundation with pending/active/rejected/sold statuses and favourites data model.
- [x] Create owner-reviewed business profile foundation.
- [x] Create owner-reviewed public community and event submission foundations.
- [x] Create Marketplace, News discovery and Explore Africa pages; connect main navigation.
- [ ] Add secure listing photos, product detail views, favourites and seller contact workflow.
- [ ] Add community member join/leave, private groups, community posts and group moderation.
- [ ] Add event RSVP, organiser contact, event reporting and calendar integration.
- [ ] Add verified business profile workflow, business insights and sponsored placements only after audience and disclosure controls exist.
- [ ] Build publisher-attributed, source-linked News feed with licensed/approved feeds and region/category filters.
- [ ] Add multilingual interface and translation only with explicit privacy and cost review.
- [ ] Add country-specific currency formatting and location filters; no precise location collection without consent.
- [ ] Add transactional payments, escrow, buyer protection and delivery partners only after legal, refund, fraud and provider-cost review.
