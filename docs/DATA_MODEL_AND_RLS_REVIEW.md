# Adventure — Data Model and RLS Review

Last updated: 2026-11-23
Status: Initial member data model and private admin authorization foundation implemented. Live multi-account authorization tests remain outstanding.

## Project separation

- Supabase project: `Adventure`
- Project ref: `fhjhbkbyglchiiunwohy`
- Region: `eu-west-1`
- Organisation plan at creation: Free
- Quoted project cost: $0/month
- No Data2Coin or Mktradehome tables, credentials or data are used.

## Member tables

### `profiles`
One row per authenticated account, linked to `auth.users(id)`. Contains username, display name, short bio, country, interests, avatar object path, discoverability and timestamps. Email and credentials are not copied into the public profile. Username is nullable during initial account creation and, when set, must be lowercase letters, numbers or underscores (3–24 characters). Bio is limited to 280 characters and interests to 10 entries.

New profiles default to **not discoverable**. A signup trigger creates a minimal profile with a safe default display name. Profile updates are restricted to approved columns; IDs and timestamps are server-controlled.

### `follows`
Stores follower/followed account pairs with a composite primary key and a no-self-follow constraint. Authenticated users can create and remove only their own outgoing follows. Follow insertion is rejected when either account has blocked the other.

### `blocks`
Stores blocker/blocked pairs with a composite primary key and a no-self-block constraint. Members can inspect and manage only blocks they created. A database trigger removes follows in both directions when a block is created. Profile discovery and follow creation check blocks in both directions.

### `reports`
Stores a private report record with reporter, reported account, allowlisted reason, bounded details, status and timestamp. Authenticated members can submit reports as themselves. Members cannot read, update or delete report records. Owners and moderators can read reports and update only the allowlisted status values: `new`, `reviewing`, `resolved`, `dismissed`.

## Admin-only tables and functions

### `private.admin_users`
Server-managed role registry keyed by Auth user UUID. Supported roles are `owner` and `moderator` only. Additional support roles are deferred until a separate least-privilege view is designed. The table is in the non-exposed `private` schema, has RLS enabled, has no client table grants and has explicit deny policies. No public RPC or client action can grant administrator status. The first owner is provisioned by the trusted project owner through the Supabase SQL Editor; see `docs/ADMIN_OWNER_BOOTSTRAP.md`.

### `private.admin_audit_log`
Private append-only audit records for privileged changes. Direct client table access is denied. Report status changes are written by a database trigger with actor, action, target, timestamp and old/new status.

### Guarded functions
- `private.is_admin()` checks server-managed role membership.
- `private.can_review_reports()` restricts report review to owner/moderator.
- `public.admin_overview()` and `public.admin_recent_activity()` are authenticated RPC entry points that call private functions which re-check administrator status server-side.
- Anonymous callers cannot execute admin RPCs. The public discovery policy retains access to the narrowly scoped private helper functions it needs; those helpers do not expose the role registry or audit records.

## Security implemented

- RLS is enabled on all four public member tables and both private admin tables.
- API table grants were explicitly narrowed; anonymous users have no access to follows, blocks or reports.
- Authenticated ordinary members cannot read report records; report reads and status updates require moderator/owner authorization.
- Admin clients can update only report status, not report reason, details or identities.
- Profile discovery defaults to off and checks both privacy choice and block relationships.
- Profile updates are limited to approved columns.
- Signup and internal security-definer functions are isolated in the non-exposed `private` schema with restricted execute grants.
- Supabase Security Advisor returned zero security lints after the admin migrations.
- Repeatable admin privilege assertions are saved in `supabase/tests/admin_security_checks.sql` and passed against the live database.
- No service-role key or database password is stored in the repository or browser code.

## Migration source of truth

All applied database changes are committed under `supabase/migrations/` with filenames matching the live migration history. Apply future schema changes through reviewed migrations; do not make untracked dashboard edits.

## Still required before launch

1. Provision the first owner Auth account and role using `docs/ADMIN_OWNER_BOOTSTRAP.md`.
2. Test policies with a real anonymous visitor, owner and two separate authenticated member accounts.
3. Verify non-discoverable profiles are invisible to other members and anonymous visitors while owners can view their own profiles.
4. Verify blocks suppress discovery and prevent new follows in both directions and remove existing follows.
5. Verify ordinary members cannot read reports or invoke admin RPCs, and moderators can update only report status.
6. Configure and test email verification, password recovery, signup limits and abuse protection.
7. Define profile image bucket visibility, file type/size limits and per-user storage policies before creating the bucket.
8. Publish privacy information, retention rules, account deletion and member-facing community rules.
9. Implement suspension/reinstatement and a staffed report-response process before public registration.
10. Run Supabase security and performance advisors after meaningful changes.

## Not implemented

Public member signup/login UI, member profile editing, avatar uploads, member-facing report/block controls, suspension workflow, posts, comments, messaging, video and communities are not yet connected to the website. The public site remains a labelled sample-profile preview. Do not invite real members or collect real personal information yet.
