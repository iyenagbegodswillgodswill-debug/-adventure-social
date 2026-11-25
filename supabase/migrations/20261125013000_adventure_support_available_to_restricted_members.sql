drop policy if exists "Active members create own support tickets" on public.support_tickets;
create policy "Authenticated members can create own support tickets" on public.support_tickets
for insert to authenticated
with check (user_id = (select auth.uid()));