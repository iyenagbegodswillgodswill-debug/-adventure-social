# Adventure

An Africa-first social platform connecting people, cultures, communities and opportunities.

**Your world. Your adventure.**

## Preview

The mobile-first Adventurers directory now loads real profiles that have opted into discovery and stores follow/unfollow actions for signed-in members. If no discoverable member profiles exist yet, it clearly falls back to illustrative sample profiles and local-only demo follows.

## Admin Control Centre

A private administrator console is available in the source at [admin.html](./admin.html). It includes an overview of member and follow counts, a private report queue, member directory lookup, report status updates and a recent audit log. Every private view is gated by Supabase Auth and database-side administrator authorization; a hidden URL alone is never treated as security.

The first owner account is not provisioned yet. Follow [docs/ADMIN_OWNER_BOOTSTRAP.md](docs/ADMIN_OWNER_BOOTSTRAP.md) to create and approve the owner account from the Adventure Supabase Dashboard. No public admin registration is provided.

## Member account

A member sign-in and profile settings page is available at [account.html](./account.html). Signed-in members can edit their display name, username, country, bio, interests and discovery privacy setting. Public registration remains closed while safety controls and real-account testing are completed. An Auth user must be provisioned before sign-in can be tested.

## Install on a phone

Adventure includes a web app manifest and offline app-shell support.

- **iPhone/iPad:** Open the site in Safari, tap Share, then choose **Add to Home Screen**.
- **Android:** Open the site in Chrome, open the browser menu, then choose **Install app** or **Add to Home screen**.
- **Desktop:** Use the install icon in the page header when the browser offers installation.

The first visit needs an internet connection. The cached preview shell can then open offline; live accounts and server data will still require a connection.

## Backend and safety

The separate Adventure Supabase project contains the initial profiles, follows, blocks and reports schema. RLS and least-privilege API grants are enabled. Administrator roles and audit records live in a non-exposed private schema. Registration is not yet connected to the public website; profile editing, avatar uploads, member-facing report/block flows and account suspension are still under development. Do not invite members or enter real personal information yet.

Database migrations live in `supabase/migrations/`; repeatable configuration checks are in `supabase/tests/security_checks.sql`.

## Development status

See [docs/PROJECT_STATUS.md](docs/PROJECT_STATUS.md) for the current milestone, deployment state and limitations. See [docs/DATA_MODEL_AND_RLS_REVIEW.md](docs/DATA_MODEL_AND_RLS_REVIEW.md) for the implemented schema and remaining security work.
