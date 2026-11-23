# Adventure

An Africa-first social platform connecting people, cultures, communities and opportunities.

**Your world. Your adventure.**

## Preview

The current public preview is a mobile-first Adventurers directory with sample profiles, search, interest filters and local-only demo Follow interactions. Sample profiles are illustrative, not real members.

## Install on a phone

Adventure includes a web app manifest and offline app-shell support.

- **iPhone/iPad:** Open the site in Safari, tap Share, then choose **Add to Home Screen**.
- **Android:** Open the site in Chrome, open the browser menu, then choose **Install app** or **Add to Home screen**.
- **Desktop:** Use the install icon in the page header when the browser offers installation.

The first visit needs an internet connection. The cached preview shell can then open offline; live accounts and server data will still require a connection when those features are released.

## Backend and safety

The separate Adventure Supabase project contains the initial profiles, follows, blocks and reports schema. RLS and least-privilege API grants are enabled. Registration is not yet connected to the website; profile editing, avatar uploads and moderation tooling are still under development. Do not enter real personal information or invite members yet.

Database migrations live in `supabase/migrations/`; repeatable configuration checks are in `supabase/tests/security_checks.sql`.

## Development status

See [docs/PROJECT_STATUS.md](docs/PROJECT_STATUS.md) for the current milestone, deployment state and limitations. See [docs/DATA_MODEL_AND_RLS_REVIEW.md](docs/DATA_MODEL_AND_RLS_REVIEW.md) for the implemented schema and remaining security work.
