# Adventure — Account and Adventurer Profile Plan

Last updated: 2026-11-23
Status: Partially implemented. Auth schema and member sign-in/profile editor UI exist; public registration remains closed and live account tests are pending.

## Purpose

Turn the current Adventurers directory prototype into a safe first version where a person can create an account, own an Adventurer profile, discover other members and follow them.

This document is a build plan, not a claim that these features already work.

## Proposed first-release scope

1. Create an account and sign in.
2. Sign out and recover access.
3. Create and edit one Adventurer profile.
4. Choose a public username and display name.
5. Add an optional profile photo, short bio, country and interests.
6. Browse public profiles and search by name, username or interest.
7. Follow and unfollow members.
8. Control whether the profile is discoverable.
9. Report a profile and block an account.
10. Provide a clear route to request account deletion.

Not in the first release: direct messages, public posting, short-form video, communities, advertising, payments or creator monetisation. These need separate safety, moderation and cost planning.

## Proposed registration experience

- Landing screen explains Adventure and what a member account enables.
- Registration collects email and password, with email verification before the account becomes active.
- Do not require a phone number for the first version. Phone OTP can introduce recurring SMS costs and should be considered only after a cost and provider review.
- Ask the member to choose a unique username and display name.
- Show a short privacy explanation before publishing a profile.
- Never ask for date of birth, exact home address, government ID or contact list for this MVP.
- Provide sign-out and password-recovery flows.

## Proposed profile fields

| Field | Required? | Visibility |
|---|---|---|
| Username | Yes | Public |
| Display name | Yes | Public |
| Profile photo | No | Public if added |
| Bio | No | Public if added |
| Country | No | Public only if added |
| Interests | No | Public only if added |
| Created date | System-generated | Do not expose exact timestamp by default |

Do not collect sensitive personal details. A member should be able to remove optional profile details.

## Privacy and security requirements

- Authentication must be handled by a trusted auth provider; never store plaintext passwords.
- Enforce database row-level security. Members can update only their own profile.
- Public profile reads must expose only approved public fields.
- Private account identifiers and email addresses must never appear in public directory queries.
- Validate and constrain usernames, bio length, image type and image size.
- Restrict profile image uploads to the member's own storage path.
- Add report/block tools before opening registration to the public.
- Establish a moderation and abuse-response process before adding public posts or messaging.
- Keep secrets and service-role keys out of browser code and GitHub.
- Provide account deletion and explain what happens to content and follow records.

## Proposed data model (to review before implementation)

- `profiles`: one row per authenticated user; primary key references the auth user ID.
- `follows`: follower user ID + followed user ID, unique pair, no self-follow.
- `blocks`: blocker user ID + blocked user ID, unique pair, no self-block.
- `reports`: reporter, reported profile/content, reason, status and timestamps; access restricted to the reporting user and authorised moderators.
- Keep authentication credentials in the auth provider, not in a custom profiles table.

The exact columns, constraints, indexes, storage policies and row-level security policies must be reviewed before applying migrations.

## Backend decision gate

The existing Data2Coin backend must not be reused. Adventure needs a separate project and separate credentials.

Before creating or connecting an Adventure backend:
1. Confirm the correct Supabase organisation/account.
2. Check current free-tier limits and any usage-based charges.
3. Confirm that the user is comfortable with the selected project and its billing setup.
4. Design and review SQL schema, row-level security and storage policies.
5. Test with non-sensitive demo accounts before any public launch.

Do not put real member data into the current static demo.

## Acceptance checks before public registration

- A member can register, verify email, sign in, sign out and recover access.
- A member can create and edit only their own profile.
- A second test account cannot edit or read private fields belonging to the first.
- Public directory shows only profiles marked discoverable and only public fields.
- Follow/unfollow is stored in the database and obeys block rules.
- Reports are private and visible only to authorised reviewers.
- Account deletion and profile photo removal work.
- Tests cover unauthorised access, invalid inputs and mobile layouts.

## Decisions still to confirm

- Whether public usernames can be changed after registration.
- Whether country and interests are optional (recommended) or required.
- Whether the initial public launch is invite-only or open registration.
- Which moderation contact/process will handle reports.

## Implemented foundation

- Separate Supabase Auth and the `profiles` table are connected as the account foundation.
- `account.html` provides email/password sign-in, password-reset request and an authenticated profile editor.
- The Adventurers directory queries profiles that opted into discovery and persists follow/unfollow actions for signed-in members. It falls back to illustrative local demo profiles when no discoverable member records exist.
- The editor writes only the approved profile columns through RLS and supports display name, username, country, bio, interests and opt-in discoverability.
- Public registration is intentionally not exposed until report/block controls, moderation response, deletion and live security tests are ready.

## Current truth

The public Adventurers directory remains a labelled sample-profile preview with local-only demo follows. The member sign-in/profile editor is committed but has not been tested with real Auth users. There is no public registration, multi-account end-to-end verification, avatar upload, member report/block UI, suspension workflow or public posting. Keep the preview notice and registration closed until the full launch gates pass.
