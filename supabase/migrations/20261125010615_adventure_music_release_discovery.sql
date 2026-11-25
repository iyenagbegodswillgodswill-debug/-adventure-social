-- Adventure Music Hub: rights-confirmed release submissions and owner-reviewed discovery.
create table if not exists public.music_releases (
  id uuid primary key default gen_random_uuid(),
  submitted_by uuid not null references auth.users(id) on delete cascade,
  artist_name text not null check (char_length(btrim(artist_name)) between 2 and 100),
  release_title text not null check (char_length(btrim(release_title)) between 1 and 140),
  release_type text not null default 'single' check (release_type in ('single','ep','album','music_video')),
  genre text not null check (genre in ('afrobeats','afropop','highlife','hiplife','amapiano','afro-soul','gospel','hip-hop','rap','dancehall','r-and-b','traditional','other')),
  country text not null check (char_length(btrim(country)) between 2 and 80),
  release_date date,
  description text check (description is null or char_length(description) <= 1200),
  artwork_url text check (artwork_url is null or artwork_url ~* '^https?://[^[:space:]]+$'),
  listen_url text check (listen_url is null or listen_url ~* '^https?://[^[:space:]]+$'),
  music_video_url text check (music_video_url is null or music_video_url ~* '^https?://[^[:space:]]+$'),
  rights_confirmed boolean not null default false,
  rights_statement text not null check (char_length(btrim(rights_statement)) between 12 and 500),
  status text not null default 'pending' check (status in ('pending','approved','rejected','removed')),
  moderation_note text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint music_release_has_destination check (listen_url is not null or music_video_url is not null)
);
create index if not exists music_releases_public_date_idx on public.music_releases(status, release_date desc nulls last, created_at desc);
create index if not exists music_releases_submitter_idx on public.music_releases(submitted_by, created_at desc);
alter table public.music_releases enable row level security;
revoke all on public.music_releases from anon, authenticated;
grant select on public.music_releases to anon, authenticated;
grant insert, update on public.music_releases to authenticated;
create policy music_releases_read_public_or_owner on public.music_releases
  for select to anon, authenticated
  using (status = 'approved' or submitted_by = (select auth.uid()) or private.is_admin());
create policy music_releases_submit_rights_confirmed on public.music_releases
  for insert to authenticated
  with check (
    submitted_by = (select auth.uid())
    and status = 'pending'
    and rights_confirmed = true
    and private.member_can_interact((select auth.uid()))
  );
create policy music_releases_update_own_pending_or_admin on public.music_releases
  for update to authenticated
  using (
    (submitted_by = (select auth.uid()) and status in ('pending','rejected'))
    or private.is_admin()
  )
  with check (
    (submitted_by = (select auth.uid()) and status in ('pending','rejected') and rights_confirmed = true)
    or private.is_admin()
  );
comment on table public.music_releases is 'Rights-confirmed music release submissions. Public discovery is owner-approved only; external links are attributed destinations, not hosted music.';
