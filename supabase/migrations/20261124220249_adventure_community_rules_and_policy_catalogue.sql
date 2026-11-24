-- Initial, preview-only community rules and policy document catalogue.
create table public.community_rules (
 id text primary key,
 title text not null,
 category text not null,
 description text not null,
 examples text[] not null default '{}'::text[],
 severity text not null check(severity in ('low','medium','high','critical')),
 penalty_levels jsonb not null default '[]'::jsonb,
 status text not null default 'preview' check(status in ('preview','active','retired')),
 version integer not null default 1 check(version>0),
 sort_order integer not null default 0,
 updated_at timestamptz not null default now()
);
create index community_rules_status_sort_idx on public.community_rules(status,sort_order);

create table public.policy_documents (
 id text primary key,
 title text not null,
 summary text not null,
 body text not null,
 version integer not null default 1 check(version>0),
 status text not null default 'preview' check(status in ('preview','active','retired')),
 effective_at timestamptz,
 updated_at timestamptz not null default now()
);
create index policy_documents_status_idx on public.policy_documents(status);

alter table public.community_rules enable row level security;
alter table public.policy_documents enable row level security;
revoke all on public.community_rules from anon,authenticated;
revoke all on public.policy_documents from anon,authenticated;
grant select on public.community_rules to anon,authenticated;
grant select on public.policy_documents to anon,authenticated;
grant insert,update,delete on public.community_rules to authenticated;
grant insert,update,delete on public.policy_documents to authenticated;

create policy "Anyone can read visible Adventure rules" on public.community_rules for select to anon,authenticated using(status in ('preview','active'));
create policy "Only Adventure owner can manage rules" on public.community_rules for all to authenticated using(private.is_admin()) with check(private.is_admin());
create policy "Anyone can read visible policy documents" on public.policy_documents for select to anon,authenticated using(status in ('preview','active'));
create policy "Only Adventure owner can manage policy documents" on public.policy_documents for all to authenticated using(private.is_admin()) with check(private.is_admin());

insert into public.community_rules(id,title,category,description,examples,severity,penalty_levels,status,version,sort_order) values
('respect-harassment','Respect others — no harassment or bullying','Respect and safety','Do not target, threaten, intimidate, humiliate, stalk or repeatedly abuse another person. Disagreement is allowed; abuse is not.',array['Repeated unwanted insults or targeted humiliation','Threats, intimidation or stalking','Encouraging others to pile onto a person'],'high','[{"stage":1,"action":"Content warning or removal and a recorded warning","duration":"First lower-severity confirmed incident"},{"stage":2,"action":"Temporary interaction restriction","duration":"Repeated or more serious confirmed incidents"},{"stage":3,"action":"Temporary suspension; owner review for permanent removal","duration":"Severe or repeated abuse"}]'::jsonb,'preview',1,10),
('hate-discrimination','No hate or discrimination','Respect and safety','Do not attack, dehumanise, threaten or exclude people because of protected or personal characteristics.',array['Slurs or dehumanising attacks','Calls to exclude or harm a group'],'high','[{"stage":1,"action":"Remove content and issue a warning","duration":"Where harm is limited and no threat is present"},{"stage":2,"action":"Temporary restriction or suspension","duration":"Serious or repeated conduct"},{"stage":3,"action":"Owner review for permanent removal","duration":"Credible threats or extreme repeated abuse"}]'::jsonb,'preview',1,20),
('fraud-scams','No scams, fraud or deceptive offers','Trust and integrity','Do not deceive members to steal money, credentials, goods, personal data or other benefits.',array['Fake investment or giveaway offers','Phishing links or requests for passwords/verification codes','Pretending a payment was made'],'critical','[{"stage":1,"action":"Immediately limit suspicious activity and preserve evidence","duration":"Precautionary pending review"},{"stage":2,"action":"Temporary suspension after evidence review","duration":"Confirmed fraud or repeated deception"},{"stage":3,"action":"Owner review for permanent removal and appropriate reporting","duration":"Serious fraud or credible ongoing risk"}]'::jsonb,'preview',1,30),
('impersonation','Do not impersonate others','Trust and integrity','Do not pretend to be another person, organisation or official Adventure representative, or mislead people about who you are.',array['Copying another person’s identity to deceive','Fake official support or staff accounts'],'high','[{"stage":1,"action":"Remove misleading content and request correction","duration":"Unintentional or low-harm case"},{"stage":2,"action":"Restrict account features","duration":"Deliberate or repeated impersonation"},{"stage":3,"action":"Temporary suspension; owner review for permanent removal","duration":"Fraudulent or harmful impersonation"}]'::jsonb,'preview',1,40),
('sexual-misconduct','No sexual harassment or exploitation','Respect and safety','Do not sexually harass, coerce, exploit or target anyone. Any sexual exploitation or sexual content involving minors is prohibited.',array['Unwanted sexual messages or coercion','Sexual exploitation or grooming','Sexual content involving minors'],'critical','[{"stage":1,"action":"Immediate content restriction and safety review","duration":"Protective action while facts are assessed"},{"stage":2,"action":"Temporary suspension after evidence review","duration":"Confirmed harassment or exploitation"},{"stage":3,"action":"Owner review for permanent removal and appropriate reporting","duration":"Severe exploitation or child-safety concerns"}]'::jsonb,'preview',1,50),
('spam-manipulation','No spam or platform manipulation','Trust and integrity','Do not flood the platform, run deceptive engagement schemes, automate abusive activity or repeatedly send unwanted promotions.',array['Repeated unsolicited promotions','Fake accounts or engagement manipulation','Malicious links or automated flooding'],'medium','[{"stage":1,"action":"Remove spam and issue a warning","duration":"First low-impact incident"},{"stage":2,"action":"Temporary posting or interaction restriction","duration":"Repeated or disruptive incidents"},{"stage":3,"action":"Temporary suspension","duration":"Persistent abuse or coordinated manipulation"}]'::jsonb,'preview',1,60),
('privacy-violations','Respect privacy and personal information','Privacy and security','Do not publish private contact details, private messages, location or sensitive personal information without permission, or use the platform to expose or threaten someone.',array['Posting someone’s private phone number or address','Sharing private messages to intimidate','Threatening to expose personal information'],'high','[{"stage":1,"action":"Remove exposed content and notify the affected member where safe","duration":"Immediate containment"},{"stage":2,"action":"Temporary restriction or suspension","duration":"Intentional or repeated exposure"},{"stage":3,"action":"Owner review for permanent removal","duration":"Doxxing, threats or serious risk"}]'::jsonb,'preview',1,70),
('dangerous-content','No credible threats or encouragement of violence','Respect and safety','Do not make credible threats, encourage violence, coordinate harm or share instructions intended to facilitate real-world harm.',array['Credible threats against a person','Encouraging or coordinating real-world violence'],'critical','[{"stage":1,"action":"Immediate safety restriction and evidence preservation","duration":"Precautionary while assessed"},{"stage":2,"action":"Temporary suspension after review","duration":"Confirmed serious threat"},{"stage":3,"action":"Owner review for permanent removal and appropriate escalation","duration":"Credible imminent danger"}]'::jsonb,'preview',1,80)
on conflict(id) do nothing;

insert into public.policy_documents(id,title,summary,body,version,status,effective_at) values
('community-guidelines','Community Guidelines','The rules every Adventurer is expected to follow, with a penalty ladder for each rule.','These Community Guidelines are visible in preview. Penalties are proposed and will not be automatically enforced until the owner approves the final policy and enforcement configuration. Each case must be assessed on evidence, context, severity and repeat history. Members may appeal.',1,'preview',null),
('privacy-policy','Privacy Policy','Draft explanation of the personal information Adventure handles and the safeguards still to be completed.','Adventure is currently in preview. This draft explains the intended approach and is not a complete legal privacy notice.

1. Account and profile information may include your display name, username, biography, country, interests and profile image.
2. Platform activity may include follows, blocks, reports, moderation decisions and security/audit records.
3. Reports are private and are available only to authorised safety personnel.
4. Information is used to operate the platform, protect members, investigate reports, enforce rules and maintain security.
5. Adventure should collect only information needed for these purposes and should not expose private reports or account-control records publicly.
6. Before launch, Adventure must publish its data controller/contact details, lawful bases, retention periods, deletion process, hosting/processor details, international transfer information and member privacy rights.
7. Do not submit passwords, payment credentials or unnecessary sensitive information in public profile fields or reports.',1,'preview',null),
('terms-of-service','Terms of Service','Draft terms describing acceptable use, account responsibilities and platform enforcement.','Adventure is currently in preview. These draft terms are published for transparency and are not yet an effective member contract.

1. Use Adventure lawfully and respectfully.
2. Keep your account information accurate and protect your sign-in credentials.
3. You are responsible for content you submit and must have the rights and permissions needed to share it.
4. Do not misuse the platform, interfere with its security, deceive other members or violate the Community Guidelines.
5. Adventure may review reports, preserve relevant evidence, remove harmful content and apply proportionate account restrictions under the published enforcement process.
6. Members may appeal moderation decisions. Serious or permanent account removal requires owner review.
7. Do not use Adventure for emergencies; contact local emergency services when someone is in immediate danger.
8. These terms, privacy details, retention periods, contact routes and governing-law provisions must be reviewed and completed before public launch.
9. Adventure may update its terms. Members will be shown material changes and asked to accept the new version before affected member features are enabled.',1,'preview',null)
on conflict(id) do nothing;
