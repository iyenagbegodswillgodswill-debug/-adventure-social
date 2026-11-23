-- Remove inherited broad API grants and explicitly grant least privilege.
revoke all privileges on table public.profiles, public.follows, public.blocks, public.reports
from anon, authenticated, public;
grant select on public.profiles to anon, authenticated;
grant update (username, display_name, bio, country, interests, avatar_path, is_discoverable)
on public.profiles to authenticated;
grant select, insert, delete on public.follows to authenticated;
grant select, insert, delete on public.blocks to authenticated;
grant insert on public.reports to authenticated;
