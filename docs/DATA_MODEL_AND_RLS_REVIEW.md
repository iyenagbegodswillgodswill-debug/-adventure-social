# Adventure — Data Model and RLS Review

Last updated: 2026-11-23  
Status: Design proposal only. No database has been created or changed.

## Scope

This proposal supports the first real Adventure release: verified accounts, public Adventurer profiles, discoverability, follows, blocks and private reports. It deliberately excludes posts, messaging, video, communities, payments and monetisation.

Adventure must use its own backend project and credentials. Do not connect this design to Data2Coin or Mktradehome.

## Proposed tables

All tables below belong in the exposed `public` schema only if required by the client API. Enable RLS on every exposed table.

### 1. `profiles`

One profile per authenticated account.

| Column | Suggested type | Notes |
|---|---|---|
| `id` | `uuid` | Primary key; references `auth.users(id)`, cascade on account deletion |
| `username` | `text` | Required, unique; normalized lowercase value |
| `display_name` | `text` | Required, bounded length |
| `bio` | `text` | Nullable, bounded length |
| `country_code` | `text` | Nullable ISO country code; no exact address |
| `interests` | `text[]` | Optional, bounded number and length of values |
| `avatar_path` | `text` | Nullable storage object path, not an arbitrary public URL |
| `is_discoverable` | `boolean` | Defaults true only after the member explicitly publishes their profile |
| `created_at` | `timestamptz` | Server-generated |
| `updated_at` | `timestamptz` | Server-maintained |

Keep email, auth provider identifiers, roles and credentials out of public profile queries. The auth provider owns credentials. Do not use user-editable auth metadata for authorization decisions.

### 2. `follows`

| Column | Suggested type | Notes |
|---|---|---|
| `follower_id` | `uuid` | References `profiles.id` |
| `followed_id` | `uuid` | References `profiles.id` |
| `created_at` | `timestamptz` | Server-generated |

Use the pair (`follower_id`, `followed_id`) as the primary key. Add a check preventing self-follow. Add an index beginning with `followed_id` for follower-list lookups. Follow insertion must be rejected if either side has blocked the other.

### 3. `blocks`

| Column | Suggested type | Notes |
|---|---|---|
| `blocker_id` | `uuid` | References `profiles.id` |
| `blocked_id` | `uuid` | References `profiles.id` |
| `created_at` | `timestamptz` | Server-generated |

Use the pair as the primary key and prevent self-block. A block must suppress profile discovery and follow relationships between the two accounts. Decide and test whether existing follow rows are deleted transactionally when a block is created.

### 4. `reports`

| Column | Suggested type | Notes |
|---|---|---|
| `id` | `uuid` | Primary key |
| `reporter_id` | `uuid` | References `profiles.id` |
| `reported_profile_id` | `uuid` | References `profiles.id` |
| `reason_code` | `text` | Allowlisted values, not arbitrary status instructions |
| `details` | `text` | Optional, length-limited |
| `status` | `text` | Server-controlled; e.g. new, reviewing, resolved, dismissed |
| `created_at` | `timestamptz` | Server-generated |
| `reviewed_at` | `timestamptz` | Nullable, moderator-controlled |

Reports are private safety records. A reporter may submit and view their own report status; ordinary members must never read reports filed by other people or change moderation status. Moderator authorization must come from trusted server-controlled roles, not user-editable metadata. Do not expose report details in public profile queries.

## RLS policy intent

These are requirements to implement and test, not executable policies yet.

- `profiles`: public/anonymous directory reads only for discoverable profiles and approved public columns. Authenticated members may insert their own profile and update only their own row. Updates must enforce ownership in both `USING` and `WITH CHECK`; members cannot change their profile ID or grant themselves moderator privileges.
- `follows`: authenticated members may create/delete only rows where they are the follower. Reads should reveal only the follow data needed by the product, respect blocks, and never reveal private account identifiers.
- `blocks`: authenticated members may create/delete/read only rows where they are the blocker. Blocked users cannot inspect who blocked them through this table.
- `reports`: authenticated members may insert a report as themselves and read only reports they submitted. No member-facing update/delete policy for moderation fields. Moderators need a separate trusted authorization path and narrowly scoped policies.
- Enable RLS on all exposed tables. Grants determine whether a role can reach a table; RLS determines which rows it can access. Review both.
- Use explicit `TO anon` / `TO authenticated` policy roles and ownership predicates such as `(select auth.uid()) = owner_id`. Do not treat `TO authenticated` alone as sufficient authorization.
- Do not create public `SECURITY DEFINER` functions as a shortcut around RLS. Prefer invoker permissions. If a privileged function is proven necessary, isolate it in a non-exposed schema, validate the caller, restrict EXECUTE grants and review it separately.

## Profile image storage

Use a dedicated private bucket initially unless public avatars are an explicit product decision. If public avatar URLs are needed, publish only approved avatar objects, not a general user-upload bucket.

- Restrict uploads to the authenticated member's own folder, e.g. `<auth.uid()>/...`.
- Enforce file size and image MIME/type limits; do not trust the filename extension.
- Define select, insert, update and delete storage policies separately.
- If using upsert, test the required INSERT, SELECT and UPDATE permissions together.
- Remove orphaned image objects on replacement and account deletion.
- Never store service-role or secret keys in browser code.

## Constraints, indexes and validation

- Normalize usernames before uniqueness checks; enforce uniqueness in the database, not only in the UI.
- Add database constraints for non-empty usernames/display names, reasonable length bounds, valid country-code shape, allowed report reason/status values and no self-follow/self-block.
- Index foreign-key columns used for joins and ownership filters; include indexes for profile discoverability/username lookup and both directions of the follow graph.
- Paginate directory and relationship queries. Avoid fetching every profile or follow row at once.
- Use server-generated timestamps and prevent clients from setting moderation fields.
- Keep public directory responses narrow: never select `*` when private columns may be added later.

## Required security tests before launch

1. Anonymous visitor can see only discoverable public profile fields.
2. Anonymous visitor cannot read email, auth IDs beyond what the product requires, blocks, reports or private profile data.
3. Member A cannot update Member B's profile or change ownership by altering submitted IDs.
4. Member A cannot create a follow row as Member B.
5. Self-follow and self-block fail at the database layer.
6. Blocks prevent discovery/follow interactions in both directions as designed.
7. Member A cannot read Member B's reports or change report status.
8. A normal member cannot grant themselves moderator privileges.
9. A user cannot upload, replace or delete another member's avatar.
10. Account deletion removes or safely anonymizes dependent profile, follow, block, report and storage data according to the published retention policy.
11. All tests are repeated with anonymous and authenticated sessions, including direct API calls that bypass the UI.

## Decisions before implementation

- Confirm a separate Adventure Supabase project and its owner/account.
- Review current free-tier limits, usage charges and backup/retention options before provisioning.
- Decide whether public avatars use a public or private bucket.
- Confirm username change policy and whether usernames can ever be recycled.
- Define who handles reports and how moderator access is granted and audited.
- Define report retention and account-deletion behaviour.
- Choose invite-only launch as the safer initial default, then reassess after moderation is operational.

## Implementation gate

Do not run migrations, create storage buckets, enable signups or collect real member data until the backend project is confirmed, this model is reviewed, RLS/storage policies are implemented, and the security tests pass.
