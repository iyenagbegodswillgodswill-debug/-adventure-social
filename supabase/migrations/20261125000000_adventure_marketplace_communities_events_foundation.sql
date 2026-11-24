-- Adventure marketplace, business directory, community and event foundations.
-- All member submissions remain pending until owner review. No payments are collected.
create table if not exists public.marketplace_listings (
 id uuid primary key default gen_random_uuid(), seller_id uuid not null references auth.users(id) on delete cascade,
 title text not null check(char_length(btrim(title)) between 4 and 120),
 description text not null check(char_length(btrim(description)) between 10 and 3000),
 category text not null check(category in ('fashion','electronics','phones','home_furniture','beauty','vehicles','food_agriculture','services','arts_crafts','other')),
 price numeric(12,2) not null check(price>0 and price<=999999999),
 currency text not null default 'GHS' check(currency in ('GHS','NGN','KES','ZAR','UGX','TZS','RWF','XOF','XAF','USD')),
 country text not null check(char_length(btrim(country)) between 2 and 80), city text not null check(char_length(btrim(city)) between 2 and 100),
 condition text not null default 'new' check(condition in ('new','used','refurbished')),
 contact_preference text not null default 'adventure_message' check(contact_preference in ('adventure_message','phone')),
 contact_phone text, image_path text,
 status text not null default 'pending' check(status in ('pending','active','rejected','sold','removed')), moderation_note text,
 created_at timestamptz not null default now(), updated_at timestamptz not null default now(),
 constraint marketplace_phone_required check(contact_preference <> 'phone' or (contact_phone is not null and char_length(contact_phone) between 7 and 30))
);
create index if not exists marketplace_active_created_idx on public.marketplace_listings(status,created_at desc);
create index if not exists marketplace_seller_created_idx on public.marketplace_listings(seller_id,created_at desc);
alter table public.marketplace_listings enable row level security;
revoke all on public.marketplace_listings from anon,authenticated;
grant select on public.marketplace_listings to anon,authenticated;
grant insert,update,delete on public.marketplace_listings to authenticated;
create policy marketplace_read_active_or_owner on public.marketplace_listings for select to anon,authenticated using(status='active' or seller_id=auth.uid() or private.is_admin());
create policy marketplace_insert_pending_own on public.marketplace_listings for insert to authenticated with check(seller_id=auth.uid() and status='pending' and private.member_can_interact(auth.uid()));
create policy marketplace_update_own_pending_or_admin on public.marketplace_listings for update to authenticated using((seller_id=auth.uid() and status in ('pending','rejected')) or private.is_admin()) with check((seller_id=auth.uid() and status in ('pending','rejected')) or private.is_admin());
create policy marketplace_delete_own_pending_or_admin on public.marketplace_listings for delete to authenticated using((seller_id=auth.uid() and status in ('pending','rejected')) or private.is_admin());
create table if not exists public.marketplace_favorites(user_id uuid not null references auth.users(id) on delete cascade,listing_id uuid not null references public.marketplace_listings(id) on delete cascade,created_at timestamptz not null default now(),primary key(user_id,listing_id));
alter table public.marketplace_favorites enable row level security;
revoke all on public.marketplace_favorites from anon,authenticated;
grant select,insert,delete on public.marketplace_favorites to authenticated;
create policy marketplace_favorites_own_select on public.marketplace_favorites for select to authenticated using(user_id=auth.uid());
create policy marketplace_favorites_own_insert on public.marketplace_favorites for insert to authenticated with check(user_id=auth.uid() and exists(select 1 from public.marketplace_listings l where l.id=listing_id and l.status='active'));
create policy marketplace_favorites_own_delete on public.marketplace_favorites for delete to authenticated using(user_id=auth.uid());
create table if not exists public.business_profiles(
 id uuid primary key default gen_random_uuid(),owner_id uuid not null references auth.users(id) on delete cascade,
 business_name text not null check(char_length(btrim(business_name)) between 2 and 120),description text not null check(char_length(btrim(description)) between 10 and 2000),
 category text not null check(category in ('retail','fashion','food','technology','home_furniture','beauty','travel','professional_services','arts_entertainment','other')),
 country text not null check(char_length(btrim(country)) between 2 and 80),city text not null check(char_length(btrim(city)) between 2 and 100),
 website_url text,contact_email text,status text not null default 'pending' check(status in ('pending','verified','rejected','suspended')),
 created_at timestamptz not null default now(),updated_at timestamptz not null default now(),unique(owner_id)
);
alter table public.business_profiles enable row level security;
revoke all on public.business_profiles from anon,authenticated;
grant select on public.business_profiles to anon,authenticated;
grant insert,update on public.business_profiles to authenticated;
create policy business_profiles_read_published on public.business_profiles for select to anon,authenticated using(status='verified' or owner_id=auth.uid() or private.is_admin());
create policy business_profiles_insert_pending on public.business_profiles for insert to authenticated with check(owner_id=auth.uid() and status='pending' and private.member_can_interact(auth.uid()));
create policy business_profiles_update_owner_or_admin on public.business_profiles for update to authenticated using(owner_id=auth.uid() or private.is_admin()) with check((owner_id=auth.uid() and status in ('pending','rejected')) or private.is_admin());
create table if not exists public.community_spaces(
 id uuid primary key default gen_random_uuid(),created_by uuid not null references auth.users(id) on delete cascade,
 name text not null check(char_length(btrim(name)) between 3 and 80),description text not null check(char_length(btrim(description)) between 10 and 1000),
 category text not null check(category in ('culture','business','technology','education','travel','fashion','entertainment','community','other')),
 country text,visibility text not null default 'public' check(visibility in ('public','private')),
 status text not null default 'pending' check(status in ('pending','active','rejected','archived')),created_at timestamptz not null default now()
);
alter table public.community_spaces enable row level security;
revoke all on public.community_spaces from anon,authenticated;
grant select on public.community_spaces to anon,authenticated;
grant insert,update,delete on public.community_spaces to authenticated;
create policy community_spaces_read_active_or_owner on public.community_spaces for select to anon,authenticated using((status='active' and visibility='public') or created_by=auth.uid() or private.is_admin());
create policy community_spaces_create_pending on public.community_spaces for insert to authenticated with check(created_by=auth.uid() and status='pending' and private.member_can_interact(auth.uid()));
create policy community_spaces_update_owner_or_admin on public.community_spaces for update to authenticated using(created_by=auth.uid() or private.is_admin()) with check((created_by=auth.uid() and status in ('pending','rejected','archived')) or private.is_admin());
create table if not exists public.adventure_events(
 id uuid primary key default gen_random_uuid(),organizer_id uuid not null references auth.users(id) on delete cascade,
 title text not null check(char_length(btrim(title)) between 4 and 140),description text not null check(char_length(btrim(description)) between 10 and 3000),
 category text not null check(category in ('business','culture','music','education','technology','community','sports','other')),
 country text not null check(char_length(btrim(country)) between 2 and 80),city text not null check(char_length(btrim(city)) between 2 and 100),
 venue text,starts_at timestamptz not null,ends_at timestamptz,event_url text,
 status text not null default 'pending' check(status in ('pending','published','rejected','cancelled')),created_at timestamptz not null default now(),
 check(ends_at is null or ends_at>starts_at)
);
alter table public.adventure_events enable row level security;
revoke all on public.adventure_events from anon,authenticated;
grant select on public.adventure_events to anon,authenticated;
grant insert,update,delete on public.adventure_events to authenticated;
create policy adventure_events_read_published on public.adventure_events for select to anon,authenticated using(status='published' or organizer_id=auth.uid() or private.is_admin());
create policy adventure_events_create_pending on public.adventure_events for insert to authenticated with check(organizer_id=auth.uid() and status='pending' and private.member_can_interact(auth.uid()));
create policy adventure_events_update_owner_or_admin on public.adventure_events for update to authenticated using(organizer_id=auth.uid() or private.is_admin()) with check((organizer_id=auth.uid() and status in ('pending','rejected','cancelled')) or private.is_admin());
