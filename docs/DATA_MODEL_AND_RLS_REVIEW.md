# Adventure — Data Model and RLS Review

Last updated: 2026-11-23  
Status: Initial database foundation implemented in the separate Adventure Supabase project. Full security testing and application integration remain outstanding.

## Project separation

- Supabase project: `Adventure`
- Project ref: `fhjhbkbyglchiiunwohy`
- Region: `eu-west-1`
- Organisation plan at creation: Free
- Quoted project cost: $0/month
- No Data2Coin or Mktradehome tables, credentials or data are used.

## Implemented tables

### `profiles`
One row per authenticated account, linked to `auth.users(id)`. Contains username, display name, short bio, country, interests, avatar object path, discoverability and timestamps. Email and credentials are not copied into the public profile. Username is nullable during initial account creation and, when set, must be lowercase letters, numbers or underscores (3–24 characters). Bio is limited to 280 characters and interests to 10 entries.

New profiles default to **not discoverable**. A member must explicitly opt in before their profile appears in public discovery. A signup trigger creates a minimal profile with a safe default display name. Profile updates are restricted to editable columns; IDs and timestamps are server-controlled.

### `follows`
Stores follower/followed account pairs with a composite primary key and a no-self-follow constraint. Authenticated users can create and remove only their own outgoing follows. Follow insertion is rejected when either account has blocked the other.

### `blocks`
Stores blocker/blocked pairs with a composite primary key and a no-self-block constraint. Members can inspect and manage only blocks they created. A database trigger removes follows in both directions when a block is created. Profile discovery and follow creation check blocks in both directions.

### `reports`
Stores a private report record with reporter, reported account, allowlisted reason, bounded details, status and timestamp. Authenticated members can submit reports as themselves. There is deliberately no member-facing read, update or delete permission yet; a moderator review interface and trusted moderator authorization must be implemented before reports can be operationally handled.

## Security implemented

- RLS is enabled on all four public tables.
- API table grants were explicitly revoked and re-granted with least privilege after a permissions audit.
- Anonymous users can only select discoverable profiles; they have no grants on follows, blocks or reports.
- Authenticated users can select profiles subject to discoverability and block checks.
- Profile update grants are limited to username, display name, bio, country, interests, avatar path and discoverability.
- Reports allow authenticated insert only; no client-side report reads or moderation updates.
- Signup and block-related security-definer functions are isolated in the non-exposed `private` schema with restricted execute grants.
- No service-role key or database password is stored in the repository or browser code.

## Migration source of truth

The SQL migrations are committed under `supabase/migrations/`. Apply future database changes through reviewed, versioned migrations; do not make untracked dashboard edits.

## Still required before launch

1. Test policies with real anonymous and two separate authenticated test accounts.
2. Verify that non-discoverable profiles are invisible to other members and anonymous users, while owners can still view their own profile.
3. Verify blocks suppress discovery and prevent new follows in both directions and remove existing follows.
4. Verify users cannot alter another member's profile, forge a follow, or read/modify reports.
5. Implement trusted moderator roles, report review, suspension and audit logging before enabling real reports.
6. Configure and test email verification, password recovery, signup limits and abuse protection.
7. Define profile image bucket visibility, file type/size limits and per-user storage policies before creating the bucket.
8. Publish privacy information, retention rules, account deletion and member-facing community rules.
9. Run Supabase security and performance advisors again after meaningful changes.

## Not implemented

Authentication UI, signup availability controls, member profile editing, avatar uploads, public follow counts, moderation dashboard, posts, comments, messaging, video and communities are not yet connected to the website. Do not invite real members or collect real personal information yet.
