create index if not exists adventure_events_organizer_id_idx on public.adventure_events(organizer_id);
create index if not exists community_spaces_created_by_idx on public.community_spaces(created_by);
create index if not exists marketplace_favorites_listing_id_idx on public.marketplace_favorites(listing_id);
create index if not exists member_notifications_actor_id_idx on public.member_notifications(actor_id);
create index if not exists support_ticket_messages_sender_id_idx on public.support_ticket_messages(sender_id);