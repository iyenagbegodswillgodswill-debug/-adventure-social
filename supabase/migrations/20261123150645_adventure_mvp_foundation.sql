-- Adventure MVP foundation. No Data2Coin objects are referenced.
create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text unique,
  display_name text not null default 'New Adventurer',
  bio text not null default '' check (char_length(bio) <= 280),
  country text check (country is null or char_length(country) <= 80),
  interests text[] not null default '{}',
  avatar_path text,
  is_discoverable boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint profiles_username_format check (username is null or username ~ '^[a-z0-9_]{3,24}$'),
  constraint profiles_interests_limit check (cardinality(interests) <= 10)
);
create table public.follows (
  follower_id uuid not null references public.profiles(id) on delete cascade,
  followed_id uuid not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (follower_id, followed_id),
  constraint follows_no_self_follow check (follower_id <> followed_id)
);
create index follows_followed_id_idx on public.follows(followed_id);
create table public.blocks (
  blocker_id uuid not null references public.profiles(id) on delete cascade,
  blocked_id uuid not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (blocker_id, blocked_id),
  constraint blocks_no_self_block check (blocker_id <> blocked_id)
);
create index blocks_blocked_id_idx on public.blocks(blocked_id);
create table public.reports (
  id uuid primary key default gen_random_uuid(),
  reporter_id uuid references public.profiles(id) on delete set null,
  reported_user_id uuid references public.profiles(id) on delete set null,
  reason text not null check (reason in ('harassment','impersonation','spam_or_scam','privacy_violation','hateful_content','dangerous_content','other')),
  details text not null default '' check (char_length(details) <= 1000),
  status text not null default 'new' check (status in ('new','reviewing','actioned','closed')),
  created_at timestamptz not null default now(),
  constraint reports_not_self check (reporter_id is null or reported_user_id is null or reporter_id <> reported_user_id)
);
create index profiles_discoverable_idx on public.profiles(is_discoverable, created_at desc);
create index reports_status_created_at_idx on public.reports(status, created_at);
create or replace function public.handle_new_adventure_user()
returns trigger language plpgsql security definer set search_path = ''
as $$
begin
  insert into public.profiles (id, display_name)
  values (new.id, coalesce(nullif(left(trim(new.raw_user_meta_data ->> 'display_name'), 60), ''), 'New Adventurer'));
  return new;
end;
$$;
create trigger on_adventure_auth_user_created after insert on auth.users
for each row execute function public.handle_new_adventure_user();
alter table public.profiles enable row level security;
alter table public.follows enable row level security;
alter table public.blocks enable row level security;
alter table public.reports enable row level security;
grant select on public.profiles to anon, authenticated;
grant insert, update, delete on public.profiles to authenticated;
grant select, insert, delete on public.follows to authenticated;
grant select, insert, delete on public.blocks to authenticated;
grant insert on public.reports to authenticated;
create policy "Discoverable profiles are public; owners can view themselves"
on public.profiles for select to anon, authenticated
using (is_discoverable or (select auth.uid()) = id);
create policy "Users create their own profile" on public.profiles for insert to authenticated
with check ((select auth.uid()) = id);
create policy "Users update their own profile" on public.profiles for update to authenticated
using ((select auth.uid()) = id) with check ((select auth.uid()) = id);
create policy "Users delete their own profile" on public.profiles for delete to authenticated
using ((select auth.uid()) = id);
create policy "Users view follows they participate in" on public.follows for select to authenticated
using ((select auth.uid()) = follower_id or (select auth.uid()) = followed_id);
create policy "Users follow as themselves" on public.follows for insert to authenticated
with check ((select auth.uid()) = follower_id);
create policy "Users remove their own follows" on public.follows for delete to authenticated
using ((select auth.uid()) = follower_id);
create policy "Users view blocks they created" on public.blocks for select to authenticated
using ((select auth.uid()) = blocker_id);
create policy "Users create blocks as themselves" on public.blocks for insert to authenticated
with check ((select auth.uid()) = blocker_id);
create policy "Users remove blocks they created" on public.blocks for delete to authenticated
using ((select auth.uid()) = blocker_id);
create policy "Signed-in users can submit reports as themselves" on public.reports for insert to authenticated
with check ((select auth.uid()) = reporter_id);
