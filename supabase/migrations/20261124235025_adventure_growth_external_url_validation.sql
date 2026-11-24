-- Restrict externally linked business and event URLs to HTTP(S).
alter table public.business_profiles add constraint business_profiles_website_http_only check(website_url is null or website_url ~* '^https?://[^[:space:]]+$');
alter table public.adventure_events add constraint adventure_events_url_http_only check(event_url is null or event_url ~* '^https?://[^[:space:]]+$');
