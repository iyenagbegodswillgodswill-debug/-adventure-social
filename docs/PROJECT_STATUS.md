# Adventure — Project Status

Last updated: 2026-11-23

## Current milestone: Safe foundation and backend setup

- [x] Separate public GitHub repository created.
- [x] Mobile-first Adventurers directory prototype committed.
- [x] African-inspired green/cream brand direction with restrained warm accent.
- [x] Featured profile cards, search, interest filters and demo Follow interactions.
- [x] Responsive layout for phone and desktop.
- [x] GitHub Pages configured to publish from `main` / root.
- [x] Early-preview notice clarifies that profiles are illustrative and Follow state is local to the current browser.
- [x] Keyboard skip navigation, visible focus styles, reduced-motion support and improved filter accessibility added.
- [x] PWA manifest, app icon, install guidance and offline app-shell caching added.
- [x] Account/profile MVP plan documented in `docs/ACCOUNT_AND_PROFILE_PLAN.md`.
- [x] Community rules, report handling and moderator accountability proposed in `docs/COMMUNITY_SAFETY_AND_MODERATION.md`.
- [x] Separate Supabase project `Adventure` created in the existing Free organisation at quoted $0/month; project is `ACTIVE_HEALTHY`.
- [x] Initial `profiles`, `follows`, `blocks` and `reports` tables created in Adventure only.
- [x] RLS enabled on all four tables; profile discovery defaults to off.
- [x] Profile updates restricted to approved columns; IDs and timestamps remain server-controlled.
- [x] Blocks suppress discovery/follow interactions and remove existing follows in both directions.
- [x] API grants explicitly audited and narrowed; anonymous users have no grants on follows, blocks or reports.
- [x] Signup trigger moved to a non-exposed private schema with restricted execute permissions.
- [x] Versioned SQL migrations saved under `supabase/migrations/`.
- [x] Supabase security advisor re-check returned no security lints.
- [x] Supabase performance advisor reported only unused-index notices on the empty new database; no missing foreign-key indexes remain.

## Deployment status

- [x] GitHub Pages source enabled from `main` / root.
- [x] Previous published version completed successfully in GitHub Pages build/deployment (run `45199119487`).
- [x] Latest documentation/backend-status commit `dd7dfba4c67fb287dda1bdcdf7e566095e6d04a8` completed successfully in GitHub Pages build/deployment (run `45201992767`).
- [ ] Confirm the newest PWA frontend commit finishes the branch-based Pages build.
- [ ] Verify the published URL in a browser on desktop and mobile.
- Expected public URL: `https://iyenagbegodswillgodswill-debug.github.io/-adventure-social/`.
- [x] Removed the duplicate custom Pages workflow; branch-based GitHub Pages publishing is the single intended deployment path.

## Current limitations

- Profile data is illustrative demo content, not real members.
- Follow state on the website is still local browser demo state, not connected to the database.
- Main navigation items other than Adventurers and notifications are placeholders and labelled as planned.
- No real authentication UI or verified signup flow is connected to the website.
- Profile editing, avatar storage, real follows, posts, messaging and moderation tools are not implemented.
- Reports can be submitted only through a future authenticated flow; there is no moderator read/review workflow yet.
- No real members should be invited and no real personal data should be collected until the launch gates below pass.

## Next steps

1. Connect the website to the separate Adventure project using only its public/publishable client key; never place service-role or secret keys in browser code.
2. Configure and test email verification, password recovery and signup abuse controls before exposing registration.
3. Build account screens and profile editing, then connect discovery and follow actions to the secured tables.
4. Implement avatar storage with per-user path restrictions and safe file limits.
5. Implement trusted moderator authorization, private report review, suspension and audit trail.
6. Run anonymous and two-account security tests, then re-run Supabase advisors.
7. Verify the public site on desktop and mobile.
8. Start with a small invite-only pilot only after safety controls and an accountable report reviewer are operational.
9. Add posts, messaging, Shorts and communities only as later, separately tested milestones.

## Safety and scope

Adventure is separate from Mktradehome, Data2Coin and BIGMK Furniture. The new database project is isolated from those projects. The project was created on the Free plan with a quoted $0 monthly project cost; this is not a guarantee that future usage, storage, bandwidth or optional paid services can never incur charges. Do not upgrade, enable paid add-ons or accept a nonzero cost without the user's explicit approval.

Never put service-role keys, database passwords or other secrets in browser code or the public repository. Keep the public preview clearly labelled as a demo until authentication, privacy, moderation and release tests are complete.
