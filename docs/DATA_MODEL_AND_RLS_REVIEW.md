# Adventure — Data Model and RLS Review

Last updated: 2026-11-24  
Status: Member directory, profile editor, text Feed, reactions, comments, reporting, appeals and owner controls are implemented in the database and client source. Real multi-account browser authorization tests remain outstanding.

## Project separation

- Supabase project: Adventure
- Project ref: `fhjhbkbyglchiiunwohy`
- Region: `eu-west-1`
- No Data2Coin or Mktradehome tables, credentials or data are used.
- Public registration remains closed.

## Member tables

### `profiles`
One row per authenticated account, linked to `auth.users(id)`. Contains username, display name, short bio, country, interests, avatar object path, discoverability and timestamps. Email and credentials are not copied into the public profile. Username is nullable during initial account creation and, when set, must be lowercase letters, numbers or underscores (3–24 characters). Bio is limited to 280 characters and interests to 10 entries.

New profiles default to **not discoverable**. A signup trigger creates a minimal profile with a safe default display name. Profile updates are restricted to approved columns and IDs/timestamps are server-controlled. Public discovery respects discoverability, suspension and block relationships; a private profile can be seen by members it follows/accepts through the current follow relationship, unless either side has blocked the other.

### `follows` and `blocks`
Follows store follower/followed account pairs with a composite primary key and no-self-follow constraint. Members can create and remove only their own outgoing follows. Follow insertion is rejected when either account has blocked the other.

Blocks store blocker/blocked pairs with a composite primary key and no-self-block constraint. Members can inspect and manage only blocks they created. A database trigger removes follows in both directions when a block is created. Discovery, post visibility and follow creation check block relationships in both directions.

### `posts`
Stores member-authored text posts (1–2,000 characters), author, visibility (`public` or `followers`), publication state and server-maintained like/comment counts. Public posts are visible to signed-in members only when the author has enabled discovery. Followers-only posts are visible to the author's followers. Authors can edit their own post content/visibility while their account is allowed to interact, and can delete their own posts. Owners can inspect posts referenced by reports.

Suspended authors' posts are hidden from other members. Restricted or suspended accounts cannot create or edit posts. No photo/video upload is enabled yet.

### `post_likes`
One row per post/member pair. Members can read their own like rows, add a like to a visible published post and remove only their own like. They cannot directly edit the server-maintained count. A private-schema trigger updates `posts.likes_count`.

### `post_comments`
Stores comments (1–1,000 characters) on visible posts. Members can read comments only when they can read the parent post, add comments only while their account can interact, and delete only their own comments. Suspended authors' comments are hidden from other members. A private-schema trigger updates `posts.comments_count`.

### `reports`
Stores a private report record with reporter, reported member, optional reported post/comment target, allowlisted reason, bounded details, status and timestamp. Authenticated active members can submit a report as themselves. Members cannot read, update or delete report records. Only the owner can review the report queue and case evidence; status changes use owner-checked RPCs and audit records.

### `member_appeals`
Members can read only their own appeals and submit an appeal only while they have an active restriction or suspension. A partial unique index allows one open appeal per member. Owner review requires a written decision for approval/rejection; an appeal outcome does not automatically change account status. The member account page displays the member's own restriction reason/expiry and appeal history.

### `announcements`
Owner-managed title/body records. Drafts and archived announcements are owner-only; anonymous and authenticated visitors can read only published announcements whose publish time has arrived. Create/update/delete actions are audit logged.

### `community_rules` and `policy_documents`
The rules catalogue contains eight stable rule IDs, rule-specific graduated penalty ladders, severity, examples and version information. Terms, Privacy and Community Guidelines are versioned documents. All are currently in `preview` status. Terms and Privacy activation is locked until legal/privacy details are completed. No automatic penalties are enabled.

## Private owner data and functions

### `private.admin_users`
Server-managed role registry. Exactly one owner account is provisioned; the role constraint prevents additional moderator/admin roles. The table is in the non-exposed `private` schema, has RLS enabled, no client table grants and explicit deny policies. No public RPC or client action can grant owner status.

### `private.admin_audit_log`
Private audit records for privileged changes. Direct client table access is denied. Report status, report case edits, appeal decisions, announcement changes and policy catalogue changes are audit logged.

### `private.report_case_records`
Private owner-only report case notes, rule mapping, priority, recorded decision, resolution summary and review metadata. Direct client table access is denied; owner-only RPCs expose the necessary case workflow.

### `private.ai_operations_runs`
Private history for the owner-only advisory AI operations. The deployed Edge Function is JWT protected and owner gated. It can produce advisory briefings and report-triage suggestions, but cannot change account status or apply moderation actions. No AI provider key is configured and no paid AI usage is enabled.

### Guarded functions
- `private.is_admin()` checks the single owner role.
- `private.member_can_interact()` blocks write actions for restricted/suspended accounts.
- `private.member_is_suspended()` and `private.is_blocked_with()` support visibility enforcement.
- `public.member_can_interact()`, `public.member_can_appeal()` and `public.member_account_status()` are SECURITY INVOKER self-service wrappers; account status returns only the caller's own restriction data.
- Owner report, appeal, announcement, policy and analytics RPCs use SECURITY INVOKER public wrappers calling owner-checked private helpers.

## Security implemented

- RLS is enabled on every public table; the database check currently reports zero public tables without RLS.
- Anonymous users have no access to member posts, likes, comments or appeals. Published announcements and opted-in discoverable profiles are public-readable.
- Authenticated users cannot directly update post counters, likes or comments.
- Private report notes, admin roles, audit records and AI operation history remain in the private schema.
- Account restrictions are enforced in the database for profile edits, follows, blocks, reports, posts, likes and comments.
- Suspended accounts' content is hidden from other members; blocked relationships suppress discovery and post visibility.
- Public owner RPCs are SECURITY INVOKER, not SECURITY DEFINER.
- No service-role key, database password or AI provider key is stored in the repository or browser code.
- Supabase Security Advisor currently reports one remaining warning: leaked-password protection is disabled. Other security lints returned no findings in the latest check.
- Repeatable checks are in `supabase/tests/security_checks.sql`, `supabase/tests/admin_security_checks.sql` and `supabase/tests/adventure_social_feed_security_checks.sql`.

## Migration source of truth

Applied database changes are committed under `supabase/migrations/` with filenames matching the live migration history. Apply future schema changes through reviewed migrations; do not make untracked dashboard edits.

## Still required before launch

1. Complete authenticated end-to-end tests with the owner, at least two separate members and an anonymous visitor.
2. Verify private profile, follower-only post, block, suspension and appeal policies through real sessions.
3. Enable leaked-password protection after reviewing the Auth setting.
4. Configure/test email verification, password recovery, rate limits and abuse protection.
5. Define avatar/photo/video storage visibility, file type/size limits, upload controls and deletion policies before creating public media buckets.
6. Finalise Terms and Privacy details, including controller/contact, lawful basis, retention, deletion and jurisdiction.
7. Add member policy acceptance/version records and enforce them before registration opens.
8. Define account deletion and data retention workflows.
9. Build staffed moderation response procedures and member notifications.
10. Run Supabase security/performance advisors after meaningful changes and review unused-index notices after real traffic begins.

## Not implemented yet

Public member registration, avatar/photo uploads, photo posts, Adventure Shorts/video, communities, private messaging, real-time notifications, policy acceptance/version gates and account deletion. The current Feed supports text posts only. The public site remains in preview; do not invite members or collect real personal information until release gates are complete.
