# Adventure — Project Status

Last updated: 2026-11-22

## Current milestone: Adventurers page foundation

- [x] Separate public GitHub repository created.
- [x] Initial mobile-first `index.html` committed.
- [x] Adventure brand direction: African-inspired green and cream, with restrained warm accent; not black-and-gold.
- [x] Featured profile cards, search, interest filters and demo Follow interactions.
- [x] Responsive layout for phone and desktop.
- [x] GitHub Actions Pages deployment workflow added at `.github/workflows/pages.yml`.

## Deployment status

- [ ] First GitHub Pages deployment completed and public URL verified.
- The workflow runs on pushes to `main` and can also be started manually from the repository Actions tab.
- GitHub Pages may still require the repository's Pages site to be enabled. The first workflow run will show whether GitHub permits setup through the workflow or requires a one-time repository setting change.
- Do not announce the site as live until a successful deployment and public URL check.

## Current limitations

- Profile data is illustrative demo content, not real members.
- Follow state is held only in the current browser session; it is not saved to an account.
- No authentication, database, profile editing, posts, messaging, moderation or privacy controls yet.

## Next steps

1. Check the GitHub Actions run for the Pages deployment workflow.
2. If it succeeds, verify the published URL and test on mobile.
3. If GitHub blocks deployment because Pages is not enabled, resolve that one-time repository setting.
4. Design the actual member profile and registration flow.
5. Before connecting a database, choose the Supabase organization/project and confirm any costs.
6. Add authentication, member profiles and persistent follow relationships only after the data model and privacy rules are reviewed.

## Safety and scope

This is an early prototype. Do not enter real personal information or treat demo profiles as real people. Keep this repository separate from Mktradehome, Data2Coin and BIGMK Furniture.
