-- Replace the original member-report status check with the moderator workflow values.
alter table public.reports drop constraint if exists reports_status_check;
