# Adventure Visual Redesign Plan

Status: In progress — Phase 1 brand assets and scoped Home styling have been committed. Full-page visual and device testing remain outstanding.
Approved direction: unique Adventure identity inspired by the supplied reference; deep black and charcoal foundation, warm gold primary identity, subtle red details.

## 1. Goals

- Make Adventure feel like a polished, premium, mobile-first African social platform.
- Use the reference as inspiration, not as a template to copy.
- Establish a coherent visual language across member pages and the owner dashboard.
- Preserve all existing functionality, data flows, access controls, routes, and accessibility.
- Improve layout, hierarchy, spacing, typography, media presentation, and responsive behaviour.

## 2. Brand and design tokens

- App background: deep black.
- Main surfaces: layered charcoal and near-black.
- Primary brand highlight: warm gold.
- Secondary accent: restrained red, reserved for small emphasis, alerts, and selected details.
- Text: high-contrast white with soft grey secondary text.
- Borders: subtle charcoal; gold used sparingly for active or premium emphasis.
- Buttons: gold for primary actions; neutral dark surfaces for secondary actions; clear destructive styling.
- Cards: consistent corner radii, spacing, image treatment, and restrained shadows.
- Motion: subtle transitions, with reduced-motion preferences respected.

The existing six personal accent choices (red, blue, green, purple, orange, pink) must not be removed. Gold becomes the fixed platform identity; the selected personal accent remains an optional user preference and must be applied consistently without overriding critical status colours or reducing contrast. The Settings page must continue to expose the existing choices.

## 3. Screen-by-screen scope

1. Home/feed: refined header and navigation, featured creators, discovery/recommendation areas, subscriptions, feed cards, and post actions.
2. Explore: clear discovery categories, people, communities, events, marketplace, music, and news sections.
3. Member profiles: profile hero, avatar, identity details, follow controls, content tabs, saved/purchased content where already supported.
4. Messages: conversation list, thread, composer, voice messages, and call controls.
5. Shorts: immersive vertical viewing and creator entry points while retaining existing creation handlers and media permissions.
6. Music Hub and Studio: artist discovery, release submission, official media links, and the existing audio workspace.
7. Marketplace and Events: listing/event cards, filters, details, and existing contact/submission actions.
8. Settings, notifications, support, and policies: consistent controls and readable long-form content.
9. Owner dashboard: matching premium design while preserving owner-only access, moderation review, audit records, member controls, and safety workflows.

## 4. Technical approach

- First audit each page's HTML, inline styles, scripts, navigation, forms, event handlers, and Supabase calls.
- Establish a small set of shared design tokens and reusable CSS patterns in the existing shared theme assets.
- Avoid broad global selectors that can accidentally restyle form controls, dialogs, media players, notices, or status messages.
- Apply styles page by page, beginning with Home, then Explore and Profile, then Messages, then content/business pages, then Settings/support, and finally the owner dashboard.
- Keep visual changes separate from backend, database, authentication, storage, and business-logic changes.
- Do not rename IDs, form names, data attributes, function names, routes, storage keys, Supabase table/column names, RPCs, or Edge Function names as part of a styling pass.
- Do not replace working controls with decorative mockups or placeholder buttons.
- Preserve the service-worker app shell and update its cache version only when actual assets change.
- Preserve existing PWA installation behaviour, page routes, and navigation destinations.
- Keep all changes in the Adventure repository; do not mix with other projects.

## 5. Functionality protection checklist

Before editing each page, record its existing:
- Navigation links and active states.
- Buttons, click handlers, form submissions, and validation.
- Authentication/session checks and redirect behaviour.
- Supabase queries, RPCs, storage buckets, and realtime subscriptions.
- Media upload, recording, playback, and permission behaviour.
- Accessibility labels, keyboard focus, and reduced-motion behaviour.

After styling each page, compare against that baseline. A visual change is not complete if any existing action stops working.

## 6. Testing and release gates

- Run existing GitHub Actions script checks after each coherent batch.
- Inspect diffs to confirm only intended presentation changes and no accidental logic removal.
- Test desktop and narrow mobile layouts, including safe-area spacing and bottom navigation.
- Verify text contrast, keyboard focus, form states, loading/empty/error states, and long content.
- Check sign-in/session-dependent pages without changing account or security rules.
- Test representative interactions for posts, follows, comments, messaging, voice messages, calls, media, submissions, settings, and owner actions where test accounts/environment permit.
- Check PWA cache update behaviour after asset changes.
- Deploy in small batches; verify each deployed batch before proceeding.
- Clearly report automated checks separately from manual browser/device tests. Never claim a flow passed if it was not actually exercised.

## 7. Rollout phases

- Phase 0 — baseline inventory and functionality map; no visual changes.
- Phase 1 — shared design tokens, typography, buttons, cards, navigation primitives.
- Phase 2 — Home, Explore, and member profile.
- Phase 3 — Messages and Shorts.
- Phase 4 — Music Hub, Studio, Marketplace, Events, and News.
- Phase 5 — Settings, notifications, support, and policies.
- Phase 6 — owner dashboard visual alignment and permission-sensitive regression checks.
- Phase 7 — full responsive review, accessibility review, regression testing, and release.

## 8. Explicit non-goals for this redesign

- No database/schema changes.
- No authentication or RLS policy changes.
- No changes to owner identity or privileges.
- No changes to registration availability.
- No automatic moderation or AI provider activation.
- No paid services, new subscriptions, or monetisation activation.
- No feature removals or fake functionality.
- No claims of complete testing without evidence.

## 9. Completion definition

The visual redesign is complete only when all in-scope pages use the approved design system, existing six accent preferences remain available, responsive and accessibility checks are complete, and the existing functionality checklist has been re-verified. Any untested flow must remain explicitly marked as untested.
