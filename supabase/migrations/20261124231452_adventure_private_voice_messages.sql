alter table public.direct_messages
  add column if not exists message_type text not null default 'text',
  add column if not exists media_path text,
  add column if not exists duration_seconds integer;

alter table public.direct_messages
  add constraint direct_messages_type_check
  check (message_type in ('text','voice')) not valid;
alter table public.direct_messages
  add constraint direct_messages_voice_metadata_check
  check (
    (message_type='text' and media_path is null and duration_seconds is null)
    or
    (message_type='voice' and media_path is not null and duration_seconds between 1 and 90)
  ) not valid;

insert into storage.buckets (id,name,public,file_size_limit,allowed_mime_types)
values ('adventure-voice','adventure-voice',false,3145728,
  array['audio/webm','audio/mp4','audio/ogg','audio/wav','audio/mpeg'])
on conflict (id) do update
set public=false,file_size_limit=3145728,
    allowed_mime_types=excluded.allowed_mime_types;

create policy "Conversation members upload their own voice notes"
on storage.objects for insert to authenticated
with check (
  bucket_id='adventure-voice'
  and (storage.foldername(name))[2]=(select auth.uid())::text
  and exists (
    select 1 from public.direct_conversations c
    where c.id::text=(storage.foldername(name))[1]
      and (select auth.uid()) in (c.participant_one,c.participant_two)
      and not (select private.is_blocked_with(
        case when c.participant_one=(select auth.uid()) then c.participant_two else c.participant_one end
      ))
  )
);

create policy "Conversation members listen to shared voice notes"
on storage.objects for select to authenticated
using (
  bucket_id='adventure-voice'
  and exists (
    select 1 from public.direct_conversations c
    where c.id::text=(storage.foldername(name))[1]
      and (select auth.uid()) in (c.participant_one,c.participant_two)
  )
);

create policy "Voice note sender can delete own upload"
on storage.objects for delete to authenticated
using (
  bucket_id='adventure-voice'
  and (storage.foldername(name))[2]=(select auth.uid())::text
  and exists (
    select 1 from public.direct_conversations c
    where c.id::text=(storage.foldername(name))[1]
      and (select auth.uid()) in (c.participant_one,c.participant_two)
  )
);