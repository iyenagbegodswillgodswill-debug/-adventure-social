# Adventure

An Africa-first social platform connecting people, cultures, communities and opportunities.

**Your world. Your adventure.**

## Current preview

The mobile-first app includes:
- Adventurers directory using real profiles that have opted into discovery.
- A signed-in member Feed for text posts, with public or followers-only visibility.
- Likes and comments, with counts maintained by database triggers.
- Profile reporting, blocking and post reporting.
- Publicly visible owner announcements when published.
- Sample directory profiles only when no discoverable real profiles are available to anonymous visitors; sample follows remain local to that browser and are clearly labelled.

The Feed is private to signed-in members. Public registration remains closed.

## Member account

[account.html](./account.html) provides member sign-in, profile editing and account privacy controls. Members with an active restriction or suspension can see the recorded reason/expiry and submit an appeal; appeal decisions are displayed in their account. The appeal process does not automatically reinstate an account.

No public sign-up is available. Do not invite members until the release gates are complete.

## Owner Control Centre

[admin.html](./admin.html) is protected by Supabase Auth and database-side owner authorization. It includes:
- Overview and aggregate analytics/system checks.
- Reports & Safety with profile/post report content, status review and private case records.
- Member lookup and owner-controlled restrictions/suspensions.
- Private audit activity and advisory AI operations.
- Rules & Policies Manager with versioned rules, rule-specific graduated penalty ladders and draft policy documents.
- Appeals review with written owner decisions.
- Announcements draft, publish and archive controls.

There is exactly one owner account. No public admin registration or additional admin roles are enabled. Serious or permanent enforcement remains an owner-reviewed action; no automatic permanent bans are enabled.

## Policies and privacy

[policies.html](./policies.html) displays the current draft Community Guidelines, Terms and Privacy Policy. All policy documents and community rules remain in preview status. They are not yet effective member agreements or automatic enforcement settings. Terms and Privacy activation remains locked until legal and privacy details are completed.

## Install on a phone

Adventure includes a web app manifest and offline app-shell support.

- **iPhone/iPad:** Open the site in Safari, tap Share, then choose **Add to Home Screen**.
- **Android:** Open the site in Chrome, open the browser menu, then choose **Install app** or **Add to Home screen**.
- **Desktop:** Use the install icon in the page header when the browser offers installation.

The first visit needs an internet connection. The cached preview shell can then open offline; live accounts and server data still require a connection.

## Backend and safety

Adventure uses its own Supabase project. Public tables have Row Level Security enabled and least-privilege grants. Private owner records and case notes live in the non-exposed `private` schema. Posts, likes, comments, follows, blocks, reports and appeals are protected by database policies. Suspended members' posts and comments are hidden from other members; restricted members cannot publish, like, comment or submit reports. Owners can review reported content.

No service-role key, database password or AI provider key is stored in browser code. No paid AI provider has been enabled. No paid add-ons or services have been approved.

## Not built yet

- Image/avatar uploads and photo posts.
- Adventure Shorts/video publishing and playback.
- Communities and community membership/moderation tools.
- Private messaging and real-time notifications.
- Policy acceptance/version gates and public registration.
- Final legal/privacy details, retention and account deletion workflow.
- Full authenticated owner/member/anonymous browser tests.

The text Feed is the first main-app feature phase; these larger features will be built in controlled stages with privacy, safety and cost checks before launch.

## Development status

See [docs/PROJECT_STATUS.md](docs/PROJECT_STATUS.md), [docs/MAIN_APP_ROADMAP.md](docs/MAIN_APP_ROADMAP.md) and [docs/DATA_MODEL_AND_RLS_REVIEW.md](docs/DATA_MODEL_AND_RLS_REVIEW.md) for implementation status, database design and remaining launch checks.

Database migrations live in `supabase/migrations/`; repeatable security checks are in `supabase/tests/`.
