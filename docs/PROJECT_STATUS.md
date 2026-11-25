# Adventure — Project Status

Last updated: 2026-11-25 (member comfort and navigation pass)

## Current milestone: Main app Phase 1 — text Feed + private messaging foundation

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
- [x] Member account page supports eligible appeals, displays the member's own restriction reason/expiry, and lists/unblocks accounts the member has blocked.
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
- [x] Verified one owner, eight rules, three policy documents, case, appeal, moderation and analytics RPCs, RLS on new public tables, and no remaining security findings except leaked-password protection.
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
- [x] Added owner moderation RPC as a SECURITY INVOKER wrapper; non-owner access was tested and denied.
- [x] Connected the member Feed, text composer, likes, comments, reporting and delete-own-post action in `index.html`.
- [x] Connected published announcements to the landing page.
- [x] Added appeal submission/history to `account.html`.
- [x] Added `supabase/tests/adventure_social_feed_security_checks.sql`; live structural checks passed, including RLS, table grants, RPC security mode, one-owner count, counter triggers, report snapshots and self-service block listing.
- [x] Reconciled all 35 repository migration filenames with the live Supabase migration history; removed duplicate files that could have reintroduced the public suspension helper.
- [x] Updated PWA service worker to cache the new member account/policy pages and use cache v2.
- [x] Added indexes for the two content-moderation actor foreign keys; the performance advisor now reports zero unindexed foreign keys.
- [x] JavaScript syntax checks passed for `index.html`, `account.html` and `admin.html`; static UI reference checks passed.
- [ ] Real owner/member browser tests and a two-member privacy/block/follow test remain outstanding.
- [ ] Complete real owner/member browser tests and mobile/desktop smoke tests against the current Pages deployment.
- [x] Private one-to-one text and voice messaging foundation; audio/video calling UI and private WebRTC signalling added, pending two-member call tests.
- [ ] Photo/avatar uploads, Shorts/video, Communities and push notifications remain future work.
- [ ] Public registration remains closed; no AI provider or paid service has been enabled.

Roadmap: `docs/MAIN_APP_ROADMAP.md`. Data model review: `docs/DATA_MODEL_AND_RLS_REVIEW.md`.


### Private voice messaging — foundation added (2026-11-24)
- [x] Added `message_type`, private media path and duration metadata to direct messages; existing text messages remain compatible.
- [x] Created private `adventure-voice` Storage bucket with a 3 MB upload limit and audio-only MIME allowlist.
- [x] Storage upload/listen/delete policies scope files to conversation participants and the sender's own upload path.
- [x] Messages page adds microphone recording, local playback preview, discard, voice-note send/playback and optional browser speech-to-text.
- [x] Voice-to-text is optional and asks before using the browser speech-recognition service; no AI provider key or paid AI calls were added.
- [ ] Test real two-member voice upload/playback, blocked-member access, browser microphone permissions and speech-to-text on supported browsers before calling this production-ready.
- [ ] Full AI-powered transcription, translation or message rewrite remains inactive until the owner approves an AI provider, data-sharing scope and any usage budget.

- [x] Voice-message migration is aligned with the live migration history.
- [x] Voice schema, private bucket, 3 Storage policies and message metadata verified in the live database; Messages JavaScript syntax and static DOM selectors pass.
- [x] Voice messaging Pages deployment workflow `45508580168` completed successfully.


### Private audio/video calls — foundation added (2026-11-24)
- [x] Added one-to-one audio and video call controls to the Messages conversation header.
- [x] Added incoming-call screen with accept/decline, outgoing-call timeout, mute, camera toggle and hang-up controls.
- [x] Added WebRTC peer connection and Supabase private Realtime broadcast signalling for offers, answers, ICE candidates and call state.
- [x] Added four Realtime RLS policies scoped to the conversation participants, active member status and block checks; call invitation policy is separately hardened against blocked members.
- [x] Call signalling policies and migration history are present in the live Supabase database; messages.html JavaScript syntax and static selector checks pass.
- [ ] Confirm Supabase Realtime Allow public access is disabled so private-channel RLS is enforced.
- [ ] Test actual two-member incoming/outgoing calls, microphone/camera permissions, decline, busy, disconnect and blocked-member denial on mobile and desktop.
- [ ] Current WebRTC configuration uses STUN only. A TURN relay may be needed for restrictive mobile/Wi-Fi networks; do not add a paid relay without owner approval.
- [ ] Calls require both members to have Adventure Messages open; background/push incoming-call notifications are not implemented.


## Africa-first expansion — marketplace, business, communities and events (2026-11-25)
- [x] Added Marketplace listings and favourites tables with RLS; new listings are private/pending until owner approval.
- [x] Added business profile submissions; public profiles require owner approval and use a verified status.
- [x] Added community-space submissions; public community spaces require owner approval.
- [x] Added event submissions; events are not public until owner approval.
- [x] Added an owner-only review queue for pending products, businesses, communities and events.
- [x] Added a Marketplace preview page with listing submission, category/country filters and safety notices. In-app payments, escrow and delivery are not enabled.
- [x] Added News discovery page linking to external publisher coverage and topic searches; it does not fabricate headlines or republish article text.
- [x] Added Explore Africa page for community, business and event discovery/submission.
- [x] Connected News, Marketplace and Explore Africa from the main navigation.
- [x] Saved migration `20261124234514_adventure_marketplace_communities_events_foundation.sql` and applied it to the Adventure Supabase project.
- [x] Added database audit triggers for owner approval/rejection of products, business profiles, communities and events; audit migration `20261124234931_adventure_growth_moderation_audit.sql` applied.
- [ ] Add moderated image uploads for marketplace listings and business profiles; image_path is metadata only until secure storage upload and delivery are implemented.
- [ ] Add seller listing management, favourites UI, product detail pages, and a safe member-to-seller conversation handoff.
- [ ] Add community membership, posts, moderators and private-community access checks.
- [ ] Add event RSVP and event reporting.
- [ ] Build a sourced, refreshable news feed using publisher-approved RSS/API sources and attribution; current page opens external coverage instead of embedding live headlines.
- [ ] Browser QA for owner approval, member submission and anonymous public browsing remains required.
- [ ] Registration remains closed. No payments, paid APIs, paid AI, paid storage or paid services were enabled.

- [x] Restricted business and event external links to HTTP(S) URLs at database level; migration `20261124235025_adventure_growth_external_url_validation.sql` applied.

- [x] Updated PWA shell cache to v4 to include News, Marketplace and Explore Africa; repaired an existing malformed service-worker entry and confirmed JavaScript syntax.

## In-app notifications — 2026-11-24
- [x] Added private per-member notification inbox for new follows, post likes, post comments and direct messages.
- [x] Notifications are generated by database triggers; members can only read their own notifications and update only their own read flag.
- [x] Added Notifications page and connected the homepage notification icon; post activity links open the Feed and message alerts open Messages.
- [x] Added Notifications page to the PWA shell cache.
- [x] Applied migration `20261124235214_adventure_member_in_app_notifications.sql` and saved it in GitHub.
- [ ] Test notifications using two authenticated member accounts, including self-actions, blocks, unread counts and read state.
- [ ] Add reply notifications, notification preferences and optional push notifications after consent and cost review.


## In-app African News reader — 2026-11-25
- [x] Replaced Google News topic links and external search redirects with an in-app headline feed, filters, search, and story reader.
- [x] Deployed public read-only Edge Function `adventure-news-feed` (JWT verification disabled intentionally because headlines are public; GET/OPTIONS only; no database writes or secrets).
- [x] Feed aggregates publisher RSS headlines and short descriptions from BBC News Africa, Africanews, Premium Times, The Guardian Africa and France 24 Africa; deduplicates and sorts by publication date.
- [x] Feed response uses a short in-memory cache and HTTP cache headers to reduce upstream requests.
- [x] Story cards open an in-app reading panel with publisher attribution and the RSS summary; opening the original publisher is an explicit optional action.
- [x] News page uses the Adventure Edge Function through the project's publishable key; no paid news API or AI provider is used.
- [x] Saved Edge Function source at `supabase/functions/adventure-news-feed/index.ts`.
- [x] Updated service worker cache to v6.
- [ ] Verify live feed response and real mobile/desktop browsing after Pages deployment; external RSS providers may occasionally be unavailable or change feed formats.
- [ ] Expand country-specific reporting and editorial review as the news section grows. Do not republish full copyrighted articles or imply publisher endorsement.


## Unified Adventure Feed — 2026-11-25
- [x] Expanded the main member Feed to mix community posts with publisher-attributed African news, active Marketplace listings and published events in one chronological scroll.
- [x] Added Feed type filters: Everything, People, News, Marketplace and Events; existing Latest, Following and My posts controls remain.
- [x] News items display in-feed with publisher and summary; a member can expand source details and deliberately choose the original report.
- [x] Marketplace cards link to the in-app Marketplace; event cards link to Explore Africa.
- [x] Feed pulls public content through existing RLS and the public news Edge Function; no new public write access or admin role added.
- [x] Updated service worker cache to v8.
- [ ] Photo and video post uploads/player are not yet implemented. Current social post schema and composer are text-only; build secure media storage, moderation-aware media visibility, upload limits and feed playback before advertising video support.
- [ ] Add richer in-app article reading where publisher licensing permits; current feed shows headline/short RSS summary and source link.
- [ ] Verify mixed feed against signed-in member accounts, mobile layouts, and live RSS provider responses after Pages deployment.


## Customer Support Centre — 2026-11-25
- [x] Added private support tickets and threaded member/support replies in Supabase with row-level security.
- [x] Members can create and read only their own tickets; the designated owner can review all tickets and reply from the private owner dashboard.
- [x] Added ticket categories, status tracking and timestamps; member conversations remain private.
- [x] Added Adventure Support page, navigation link and PWA app-shell caching.
- [x] Public registration remains closed; support ticket creation requires an authenticated, eligible member.
- [ ] Test member-to-owner ticket lifecycle with two real accounts, including closed-ticket behavior and unauthorized cross-member access.
- [ ] Add response-time targets, support macros, knowledge-base search and operational escalation after initial testing.
- [ ] Do not promise 24/7 support or guaranteed response times until staffing is established.

## Next product build stages
- [ ] Secure photo/video uploads and in-feed playback, including moderation-aware access and private staging.
- [ ] Short-video recording studio with camera capture, editing, accessible captions, safe filter processing and draft publishing.
- [ ] Creator Hub, community membership and moderation, event RSVP, seller management and product detail/contact flows.
- [ ] Verify news feed reliability and improve country coverage with attributed sources.
- [ ] Full owner/member/mobile browser QA and release checklist before public launch.

### Adventure photo and Shorts media foundation — 2026-11-25
- [x] Added optional photo/video metadata to posts without changing existing text-only posts.
- [x] Created private `adventure-post-media` Storage bucket, 25 MB maximum object size and JPEG/PNG/WebP/MP4/WebM allowlist.
- [x] Storage RLS checks post ownership for uploads and post visibility/moderation/block/follower access for downloads; authors and owner can delete objects.
- [x] Feed composer supports photo/video file selection, photo filters baked into JPEG output, file-size/type checks and 60-second video duration validation.
- [x] Added an in-app Shorts camera recorder using MediaRecorder and canvas filter rendering; camera video filters are baked into recorded clips. Video posts play inline with user-controlled controls and no autoplay.
- [x] Added Photos and Short videos Feed filters. Existing text-only posts remain supported.
- [ ] Verify real phone camera/microphone capture, iOS Safari MP4 recording, Android WebM recording, media uploads, signed playback URLs, follower visibility and moderation-hidden media.
- [ ] Add trim/crop, captions, drafts, accessibility review, media reporting and orphaned-object cleanup before public release.
- [ ] Confirm actual Storage usage and Free-plan quotas; do not upgrade or enable paid services without explicit approval.

- [x] Added covering indexes for Adventure events, communities, marketplace favourites, notification actors and support-message sender foreign keys; migration `20261125012000_adventure_growth_support_foreign_key_indexes.sql` applied.


## Adventure Voice & Music Studio — first creator workspace
- [x] Added `music.html`, a mobile-friendly browser studio with microphone vocal recording, audio-file import, a 16-step kick/snare/hi-hat beat maker, multi-track playback, per-track volume/mute/remove controls, master volume and low-pass warmth control.
- [x] Added local project save/load using IndexedDB on the current device and stereo WAV mix export using browser audio rendering.
- [x] Added Music Studio to the main Adventure navigation and PWA app-shell cache v11.
- [ ] Verify microphone recording, audio decoding, IndexedDB save/restore and WAV export on current iOS Safari, Android Chrome and desktop browsers.
- [ ] Current projects are stored only in the current browser/device; cloud project sync and private cross-device backups are not implemented yet.
- [ ] This is a starter production workspace, not yet a full commercial DAW: advanced pitch correction/Auto-Tune, MIDI instruments, piano roll, detailed timeline editing, vocal comping, professional mastering, collaboration and cloud storage remain future stages.
- [ ] Add artist profiles, rights/permission records, owner-reviewed release submissions and an in-app Music discovery catalogue before public releases.
- [ ] Keep all studio work private by default; public registration stays closed; no paid services, audio APIs or AI provider have been enabled.


## Adventure Music Hub — rights-aware African release discovery
- [x] Added `music_releases` with artist/release metadata, genre, country, release date, rights statement, rights-confirmation gate and pending/approved/rejected/removed moderation states.
- [x] Enabled RLS: only approved releases are public; submitters can see their own submissions; owner can review; submissions require an eligible signed-in member and explicit rights confirmation.
- [x] Added Music Hub page with search, genre/country filters, release cards and official external listening/music-video destinations.
- [x] Kept music audio on artist/rightsholder-authorised destinations; Adventure does not scrape, copy or host commercial songs in this phase.
- [x] Added owner review queue for pending Music Hub submissions.
- [x] Preserved the existing browser-based creator workspace as `studio.html`; `music.html` is now the discovery hub.
- [x] Added both pages to main navigation and PWA cache v12.
- [ ] Verify anonymous public browsing, member submission, owner approval/rejection and official link safety with real sessions.
- [ ] Add licensed/artist-authorised audio previews, artist profiles, charts, Music Shorts integration and release notifications after rights and storage workflows are designed.
- [ ] Keep public registration closed; no paid audio service, streaming provider or AI provider was enabled.


## Feed and Music usability correction — 2026-11-25
- [x] Added an Adventure Feed filter for approved Music Hub video submissions.
- [x] Feed now loads approved music-video links alongside news, marketplace listings and events.
- [x] If the member-post query fails, the Feed still attempts to show public discovery items instead of returning early with an empty screen.
- [x] Music Hub now has a dedicated Music Videos section with embedded YouTube/Vimeo player support for approved official links; other official destinations remain external links.
- [ ] No approved music releases or music-video submissions were present when this change was made, so the new video sections will show an honest empty-state message until rights-confirmed content is submitted and owner-approved.
- [ ] Verify the deployed News Edge Function returns current headlines and fix upstream feed/parser/deployment issues if it returns no items. A web fetch attempt could not access the function endpoint, so live headline availability is not yet confirmed.
- [ ] Add audio post support so artists can export a vocal/song from Music Studio and publish it to the Feed. Current post media schema and composer support photos/videos only; do not describe audio publishing as complete.
- [ ] Simplify global navigation and first-time-user guidance in a separate UI pass without removing existing features.


## Member comfort and navigation pass — 2026-11-25
- [x] Simplified the main navigation to Home, Feed, Explore, Music, Messages and a More menu for News, Marketplace, Music Studio, Notifications, Help and Account.
- [x] Removed an outdated notification click message that incorrectly said notifications were not available.
- [x] Added consistent navigation to the Music Hub, Music Studio, Messages, Support and Account pages.
- [x] Bumped the PWA app-shell cache to v13 so returning visitors can receive the updated navigation.
- [ ] Verify navigation, dropdown usability, keyboard access and small-screen layouts on real mobile browsers.
- [ ] Verify all core features using real owner/member accounts; deployment and source checks alone do not establish end-to-end correctness.

- [x] Replaced the generic empty Feed message with clear, section-specific guidance and useful next steps for Music Videos, News, Marketplace, Events and new member posts.


## Icon-first navigation — 2026-11-25
- [x] Replaced text-heavy page navigation with a consistent icon-first bottom navigation on Home, Feed, Explore, Music and Messages.
- [x] Added an icon grid under More for News, Marketplace, Music Studio, Notifications, Help and Account.
- [x] Added accessible labels for navigation controls and a safe-area-aware mobile bottom bar.
- [x] Refreshed the PWA cache to v14.
- [ ] Verify all icon destinations, active states, dropdown behavior, keyboard access and mobile layouts on real devices before public launch.
