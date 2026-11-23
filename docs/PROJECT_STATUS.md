# Adventure — Project Status

Last updated: 2026-11-23

## Current milestone: Adventurers page foundation

- [x] Separate public GitHub repository created.
- [x] Initial mobile-first `index.html` committed.
- [x] Adventure brand direction: African-inspired green and cream, with restrained warm accent; not black-and-gold.
- [x] Featured profile cards, search, interest filters and demo Follow interactions.
- [x] Responsive layout for phone and desktop.
- [x] GitHub Actions Pages deployment workflow added at `.github/workflows/pages.yml`.

## Deployment status

- [x] GitHub Pages source enabled from `main` / root.
- [x] First GitHub Pages deployment completed successfully (run `45195713110`, all three jobs successful).
- [ ] Verify the public URL in a browser on desktop and mobile.
- The workflow runs on pushes to `main` and can also be started manually from the repository Actions tab.
- Expected public URL: `https://iyenagbegodswillgodswill-debug.github.io/-adventure-social/`.

## Current limitations

- Profile data is illustrative demo content, not real members.
- Follow state is saved in local browser storage on the current device only; it is not linked to an account or synced across devices.
- Main navigation items other than Adventurers and notifications are placeholders; the interface now labels these as planned rather than pretending the pages exist.
- No real account or personal information is collected by this prototype.
- No authentication, database, profile editing, posts, messaging, moderation or privacy controls yet.

## Next steps

1. Verify the public URL and test the page on desktop and mobile.
2. Design the real member profile and registration flow.
3. Define the first release scope for posts, follows and discovery.
4. Before connecting a database, choose the Supabase organization/project and confirm any costs.
5. Review the data model, authentication, privacy rules and moderation before storing real member information.

## Safety and scope

This is an early prototype. Do not enter real personal information or treat demo profiles as real people. Keep this repository separate from Mktradehome, Data2Coin and BIGMK Furniture.
