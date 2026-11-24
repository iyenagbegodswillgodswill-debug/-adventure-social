drop policy if exists "Conversation member can send call invites" on realtime.messages;
create policy "Conversation member can send call invites"
on realtime.messages for insert to authenticated
with check (
  realtime.messages.extension='broadcast'
  and case
    when realtime.topic() ~ '^call-inbox:[0-9a-fA-F-]{36}$'
    then exists (
      select 1 from public.direct_conversations c
      where (
        (c.participant_one=(select auth.uid()) and c.participant_two=split_part(realtime.topic(),':',2)::uuid)
        or
        (c.participant_two=(select auth.uid()) and c.participant_one=split_part(realtime.topic(),':',2)::uuid)
      )
      and not (select private.is_blocked_with(split_part(realtime.topic(),':',2)::uuid))
    )
    else false
  end
  and (select public.member_can_interact())
);