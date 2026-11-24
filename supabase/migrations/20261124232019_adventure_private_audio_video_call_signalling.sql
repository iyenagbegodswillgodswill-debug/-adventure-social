create policy "Call inbox recipient can receive broadcasts"
on realtime.messages for select to authenticated
using (
  realtime.messages.extension='broadcast'
  and case
    when realtime.topic() ~ '^call-inbox:[0-9a-fA-F-]{36}$'
    then split_part(realtime.topic(),':',2)::uuid=(select auth.uid())
    else false
  end
  and (select public.member_can_interact())
);

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

create policy "Conversation members can receive call signalling"
on realtime.messages for select to authenticated
using (
  realtime.messages.extension='broadcast'
  and case
    when realtime.topic() ~ '^call-room:[0-9a-fA-F-]{36}$'
    then exists (
      select 1 from public.direct_conversations c
      where c.id=split_part(realtime.topic(),':',2)::uuid
        and (select auth.uid()) in (c.participant_one,c.participant_two)
        and not (select private.is_blocked_with(
          case when c.participant_one=(select auth.uid()) then c.participant_two else c.participant_one end
        ))
    )
    else false
  end
  and (select public.member_can_interact())
);

create policy "Conversation members can send call signalling"
on realtime.messages for insert to authenticated
with check (
  realtime.messages.extension='broadcast'
  and case
    when realtime.topic() ~ '^call-room:[0-9a-fA-F-]{36}$'
    then exists (
      select 1 from public.direct_conversations c
      where c.id=split_part(realtime.topic(),':',2)::uuid
        and (select auth.uid()) in (c.participant_one,c.participant_two)
        and not (select private.is_blocked_with(
          case when c.participant_one=(select auth.uid()) then c.participant_two else c.participant_one end
        ))
    )
    else false
  end
  and (select public.member_can_interact())
);