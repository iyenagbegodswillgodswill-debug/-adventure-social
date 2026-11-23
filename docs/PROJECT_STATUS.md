# Adventure — Project Status

Last updated: 2026-11-23

## Current milestone: Safe foundation and account/profile design

- [x] Separate public GitHub repository created.
- [x] Mobile-first Adventurers directory prototype committed.
- [x] African-inspired green/cream brand direction with restrained warm accent.
- [x] Featured profile cards, search, interest filters and demo Follow interactions.
- [x] Responsive layout for phone and desktop.
- [x] GitHub Actions Pages deployment workflow configured.
- [x] Early-preview notice clarifies that profiles are illustrative and Follow state is local to the current browser.
- [x] Account/profile MVP plan documented in `docs/ACCOUNT_AND_PROFILE_PLAN.md`.
- [x] Proposed database model, RLS intent, storage safeguards and security tests documented in `docs/DATA_MODEL_AND_RLS_REVIEW.md`.
- [x] Release readiness gates documented in `docs/RELEASE_READINESS_CHECKLIST.md`.
- [x] Community rules, report handling and moderator accountability proposed in `docs/COMMUNITY_SAFETY_AND_MODERATION.md`.

## Deployment status

- [x] GitHub Pages source enabled from `main` / root.
- [x] Commit `0329813fe3150d23d38fe96250514283a9a7ee4b` completed successfully in the project workflow (run `45198140505`) and GitHub Pages build/deployment (run `45198140138`).
- [ ] Verify the published URL in a browser on desktop and mobile.
- Expected public URL: `https://iyenagbegodswillgodswill-debug.github.io/-adventure-social/`.
- The community-safety documentation commit is newer than the last confirmed successful deployment; check Actions before claiming it is live.

## Current limitations

- Profile data is illustrative demo content, not real members.
- Follow state is saved in local browser storage on the current device only; it is not linked to an account or synced across devices.
- Main navigation items other than Adventurers and notifications are placeholders and labelled as planned.
- No real account or personal information is collected by this prototype.
- No authentication, database, profile editing, real follows, posts, messaging, moderation or privacy controls are implemented.
- The data model, RLS design and community-safety plan are proposals only. No Adventure database, migration, bucket, auth provider or moderation workflow has been created or changed.

## Next steps

1. Verify the current public URL and test the page on desktop and mobile.
2. Review the account/profile, data model, release-readiness and community-safety documents.
3. Confirm the separate Adventure backend account/project and review current costs/free-tier limits before provisioning.
4. Implement authentication, profiles, follows, blocks, reports and storage policies only after schema review.
5. Run anonymous, cross-account and moderator-authorization security tests before enabling registration.
6. Start with a small invite-only pilot only after safety controls and an accountable report reviewer are operational.
7. Add posts, messaging, Shorts and communities only as later, separately tested milestones.

## Safety and scope

This is an early static prototype, not a public social network. Do not enter real personal information or treat demo profiles as real people. Keep Adventure separate from Mktradehome, Data2Coin and BIGMK Furniture. Never put service-role keys or other secrets in browser code or the public repository.
