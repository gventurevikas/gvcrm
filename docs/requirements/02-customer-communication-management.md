# Customer Communication Management

**Document ID:** GVCRM-REQ-CCM  
**Version:** 1.0  
**Status:** Draft for implementation  
**Module:** Customer Communication Management  
**This document is independent.** Related modules are listed only as dependencies.

---

## 1. Purpose

Give sales and support teams a single place to **call, email, and SMS** prospects and customers, with templates, scheduling, tracking, and automatic association to the correct CRM records.

## 2. Scope

**In scope**

- Call reminders, scheduling, and tagging
- Native in-app email send/receive
- Gmail and Outlook client integration
- Automatic email-to-record association
- Email templates, canned responses, scheduling, status tracking, and mass email
- SMS send, templates, timezone-aware scheduling, and analytics

**Out of scope**

- Campaign strategy and multi-channel campaign objects — Sales Performance Management
- Report visualization of email/call KPIs beyond operational views — Dashboards and Reports
- Appointment booking pages — Accounts and Contacts Management

## 3. Users

| Persona | Typical actions |
|---------|-----------------|
| Sales representative | Call, email, SMS, use templates, see open/click status |
| Support / success agent | Canned responses, associate threads to contacts |
| Sales manager | View team call schedules and missed-call alerts |
| Marketing ops | Maintain templates and mass-email compliance |
| Admin | Connect email/SMS providers, domains, and tracking |

## 4. Business objectives

- Faster, consistent outreach from CRM or the user’s existing inbox
- No orphan emails: every message lands on the right contact/lead
- Measurable email and SMS performance
- Fewer missed calls through reminders and shared schedules

---

## 5. Functional requirements

### 5.1 Call reminders

**Source capability:** Call Reminders  
**Priority:** P0  
**ID:** CCM-FR-001

The solution shall allow setting reminders for upcoming calls and shall send alerts for missed ones.

**User story**  
As a sales representative, I want a reminder before a scheduled call and an alert if I miss it so nothing drops.

**Detailed requirements**

1. Users can set reminder offsets (e.g. 5 / 15 / 30 / 60 minutes, custom) on a call activity.
2. Reminders are delivered via in-app notification, email, and optionally push/desktop.
3. A call marked missed (no connect, no wrap-up within configurable SLA) triggers a missed-call alert to the owner and optional manager.
4. Reminder preferences are per user; org defaults exist.
5. Snooze and complete actions dismiss the reminder and log the outcome.

**Acceptance criteria**

- Reminder fires within ±30 seconds of the configured time.
- Missed-call alert is created when status = Missed or wrap-up SLA expires.
- Dismissing a reminder does not delete the call activity.
- Users can see upcoming call reminders on homepage widgets.

---

### 5.2 Call scheduling

**Source capability:** Call Scheduling  
**Priority:** P0  
**ID:** CCM-FR-002

The solution shall allow scheduling phone calls at a later date and offer an at-a-glance view of one’s own and teammates’ call schedules.

**User story**  
As a sales manager, I want to see my team’s call calendar so I can coach coverage and avoid collisions.

**Detailed requirements**

1. Users schedule calls with date/time, duration, timezone, related record, purpose, and optional script/notes.
2. Personal calendar view: day/week/month of own calls.
3. Team calendar view: selected teammates or user group, with privacy (show busy vs show title based on permission).
4. Conflicts with existing calls/meetings are warned.
5. Reschedule and cancel update all viewers in real time.

**Acceptance criteria**

- Scheduled call appears on owner and team calendars immediately.
- Filtering the team view by user group shows only those users.
- Unauthorized users cannot see call titles marked private.
- Timezone of the related contact is displayed next to the slot.

---

### 5.3 Call tagging

**Source capability:** Call Tagging  
**Priority:** P1  
**ID:** CCM-FR-003

The solution shall allow assigning each call a custom tag to sort calls into categories or identify call types.

**User story**  
As a sales ops analyst, I want to tag calls as demo, discovery, follow-up, or support so reporting is accurate.

**Detailed requirements**

1. Multiple tags per call; tags may be selected from a controlled vocabulary and/or free text (admin-configurable).
2. Tagging is available before, during, and after the call (including wrap-up).
3. Lists, filters, and reports can filter by call tag.
4. Admins can rename/merge tags without losing historical association.

**Acceptance criteria**

- A call can be saved with 0..n tags.
- Filter “tag = Discovery” returns only matching calls.
- Merging tags updates historical call records.

---

### 5.4 Canned responses

**Source capability:** Canned Responses  
**Priority:** P0  
**ID:** CCM-FR-004

The solution shall provide pre-determined email responses to commonly asked questions so agents can reply to prospects quickly.

**User story**  
As a support agent, I want to insert a approved reply snippet so I answer faster without going off-brand.

**Detailed requirements**

1. Library of canned responses with title, category, body (rich text), language, and merge fields.
2. Insert into email composer via shortcut / search.
3. Permissions: personal, team, or org-wide canned responses.
4. Usage count is tracked for hygiene (unused snippets can be retired).

**Acceptance criteria**

- Inserting a snippet populates merge fields from the open contact/lead.
- Team snippets are visible only to that team.
- Edits to org snippets require the configured permission.

---

### 5.5 Direct email communication

**Source capability:** Direct Email Communication  
**Priority:** P0  
**ID:** CCM-FR-005

The solution shall provide a standard email configuration to send and receive emails directly from the solution itself.

**User story**  
As a sales representative, I want to send and receive mail inside CRM without switching to another app.

**Detailed requirements**

1. Org or user can connect a sending domain / mailbox (SMTP/IMAP or provider API).
2. In-app inbox: inbound, sent, drafts, scheduled, bounced.
3. Composer supports To/Cc/Bcc, attachments, templates, tracking, and related-record picker.
4. Inbound mail is fetched continuously or via push (provider webhooks).
5. Bounce and complaint handling updates deliverability status on the contact.

**Acceptance criteria**

- User can send an email from CRM and see it in Sent within seconds.
- Inbound email to the connected mailbox appears in CRM inbox.
- Failed send shows a retryable error, not a silent drop.

---

### 5.6 Email association with CRM records

**Source capability:** Email Association with CRM Records  
**Priority:** P0  
**ID:** CCM-FR-006

The solution shall automatically associate all incoming and outgoing emails with the respective contact record and allow instantly replying, sharing quotes, adding follow-ups, and making notes.

**User story**  
As an account manager, I want every email with a customer to appear on their contact timeline automatically.

**Detailed requirements**

1. Match inbound/outbound by email address to Contact, Lead, or Account (shared mailbox rules configurable).
2. Unmatched mail goes to an “unassociated” queue for manual linking.
3. From a thread user can: reply/reply-all/forward, attach/share a quote, create a follow-up task, add a note.
4. Association is visible on contact, related account, and related opportunity timelines.
5. Users can relink a mis-associated email.

**Acceptance criteria**

- Outbound mail to a known contact email is on that contact’s timeline without manual linking.
- Reply from timeline continues the same thread ID.
- Sharing a quote from the thread creates a document/quote association.
- Relink moves the email and writes an audit event.

---

### 5.7 Email client integration

**Source capability:** Email Client Integration  
**Priority:** P0  
**ID:** CCM-FR-007

The solution shall integrate popular email clients such as Gmail and Outlook so users can send and receive emails directly from the email client itself, with CRM context.

**User story**  
As a sales representative who lives in Gmail, I want CRM sidebar context and logging without leaving my inbox.

**Detailed requirements**

1. Official integrations/add-ins for Gmail and Microsoft Outlook (web at minimum; desktop where feasible).
2. From the client, user can log email to CRM, create/update contact or lead, view related deals, and insert templates.
3. OAuth connection; tokens stored encrypted; disconnect is supported.
4. Optional auto-log of sent/received mail for connected users (with allow-list / exclude internal domains).

**Acceptance criteria**

- Connecting Gmail/Outlook via OAuth succeeds and shows connected status in CRM.
- Logging an email from the add-in creates the CRM email activity on the matched record.
- Disconnect revokes tokens and stops sync.
- Internal domain exclusion prevents logging all-staff mail by default.

---

### 5.8 Email scheduling

**Source capability:** Email Scheduling  
**Priority:** P1  
**ID:** CCM-FR-008

The solution shall allow scheduling emails for a specified date and time, choosing from pre-selected times or a custom time, and editing scheduled emails before delivery.

**User story**  
As a sales representative, I want to write now and send tomorrow at 09:00 in the prospect’s timezone.

**Detailed requirements**

1. Composer action: Send later — presets (morning, afternoon, next business day) and custom datetime.
2. Timezone source: user, contact, or explicit selection.
3. Scheduled items remain editable or cancellable until send starts.
4. If the related contact is deleted or marked DNC before send, the job is blocked and the user notified.

**Acceptance criteria**

- Scheduled email appears in a Scheduled folder with countdown.
- Edit before send updates body and recipients.
- Cancel prevents delivery.
- Send occurs within ±1 minute of the scheduled time under normal load.

---

### 5.9 Email status

**Source capability:** Email Status  
**Priority:** P1  
**ID:** CCM-FR-009

The solution shall provide real-time notifications when a prospect opens a sent email and shall allow setting follow-up reminders.

**User story**  
As a sales representative, I want to know when a prospect opens my proposal email so I can follow up immediately.

**Detailed requirements**

1. Optional open and click tracking (pixel + wrapped links), respectful of org privacy settings.
2. Real-time in-app/push notification: first open, subsequent opens (configurable), link clicks.
3. Status on the email activity: queued, sent, delivered, opened, clicked, bounced, unsubscribed, failed.
4. One-click “remind me to follow up” (time offset or when opened).

**Acceptance criteria**

- First open updates status to Opened and can trigger a notification.
- User can disable tracking per email or globally.
- Bounce updates contact email quality flag.
- Follow-up reminder creates a task/activity linked to the email.

---

### 5.10 Email templates

**Source capability:** Email Templates  
**Priority:** P0  
**ID:** CCM-FR-010

The solution shall offer pre-built email templates or allow creating a template from scratch to send mass emails to leads/contacts as a campaign or to trigger a workflow rule.

**User story**  
As marketing ops, I want reusable branded templates that workflows and campaigns can both use.

**Detailed requirements**

1. Template types: sales, support, marketing/mass, system/workflow.
2. Visual editor + HTML source; merge fields from lead/contact/account/opportunity/user.
3. Pre-built starter templates shipped with the product.
4. Versioning, preview with sample data, test send.
5. Templates are selectable from composer, mass email, campaigns, and workflow actions.

**Acceptance criteria**

- Creating a template and using it in composer inserts merge values correctly.
- Workflow can send a selected template when conditions match.
- Invalid merge fields are highlighted at save time.
- Only permitted roles can publish org-wide templates.

---

### 5.11 Mass email

**Source capability:** Mass Email  
**Priority:** P1  
**ID:** CCM-FR-011

The solution shall allow sending individual and personalized emails to campaign members and to recipients on contact and lead lists.

**User story**  
As a sales representative, I want to email a filtered list of leads with each person’s name and company personalized, not as a single blast To-line.

**Detailed requirements**

1. Recipients from: list view selection, saved list, campaign members.
2. Each recipient receives an individual message (not exposing other addresses).
3. Personalization via templates/merge fields.
4. Compliance: unsubscribe link, suppression lists, DNC, bounce, frequency caps.
5. Throttling and daily send limits per org/user/domain.
6. Progress, errors, and per-recipient status.

**Acceptance criteria**

- Sending to 100 contacts creates 100 individual messages with unique merge data.
- Unsubscribed and DNC records are skipped and reported.
- User sees a confirmation of estimated recipients before send.
- Partial failure does not block successful recipients.

---

### 5.12 SMS interaction

**Source capability:** SMS Interaction  
**Priority:** P1  
**ID:** CCM-FR-012

The solution shall allow reaching prospects and customers through SMS and sending personalized texts using data stored in the CRM.

**User story**  
As a sales representative, I want to text a contact from their record using their name and next appointment time.

**Detailed requirements**

1. SMS composer on lead/contact with merge fields.
2. Inbound SMS is captured, associated to the record, and notified to the owner.
3. Consent / opt-in status is stored and enforced.
4. Conversation thread view on the record.
5. Character count and multi-segment warning.

**Acceptance criteria**

- Outbound SMS appears on the timeline with delivery status.
- Inbound reply threads to the same conversation.
- Sending to an opted-out number is blocked with an explanation.

---

### 5.13 SMS scheduling

**Source capability:** SMS Scheduling  
**Priority:** P1  
**ID:** CCM-FR-013

The solution shall allow scheduling text messages according to the timezone of customers and prospects.

**User story**  
As a sales representative, I want SMS to go out at 10:00 in the contact’s local timezone, not mine.

**Detailed requirements**

1. Schedule SMS using contact timezone (fallback: account, then user).
2. Quiet hours: org-configurable window during which scheduled SMS is deferred.
3. Edit/cancel before send.

**Acceptance criteria**

- A contact in IST receives a message scheduled for 10:00 IST even if the sender is in another zone.
- Quiet-hours deferral is visible on the scheduled item.
- Cancel prevents delivery.

---

### 5.14 SMS templates

**Source capability:** SMS Templates  
**Priority:** P1  
**ID:** CCM-FR-014

The solution shall allow creating text message templates and saving them for later use.

**Detailed requirements**

1. Create/edit/archive SMS templates with name, body, merge fields, language, category.
2. Insert from SMS composer and from workflow/campaign actions.
3. Personal vs team vs org scope.

**Acceptance criteria**

- Saved template can be reused on another contact with new merge values.
- Character estimate updates as merge fields resolve in preview.

---

### 5.15 SMS analytics

**Source capability:** SMS Analytics  
**Priority:** P2  
**ID:** CCM-FR-015

The solution shall provide insights into text-message performance, including which templates received higher responses from the target customer base.

**User story**  
As a sales ops manager, I want to see which SMS templates get the most replies so we standardize on winners.

**Detailed requirements**

1. Metrics: sent, delivered, failed, opted-out, inbound replies, reply rate, by template, user, team, date range.
2. Template leaderboard by reply rate and conversion to next activity/opportunity (where attributable).
3. Export and embed as a dashboard widget (Dashboards module consumes this data).

**Acceptance criteria**

- Selecting a date range and team updates metrics without page reload.
- Template A vs B reply rates are comparable when both have sends in range.
- Failed sends are excluded from reply-rate denominator or shown separately (documented).

---

## 6. Data entities

| Entity | Purpose |
|--------|---------|
| MailboxConnection | User/org email OAuth or SMTP/IMAP config |
| EmailMessage | Inbound/outbound email, headers, body, status, tracking |
| EmailThread | Conversation grouping |
| EmailTemplate / CannedResponse | Reusable email content |
| MassEmailJob | Batch personalized send |
| CallActivity | Scheduled/completed/missed calls, tags, outcome |
| SmsMessage | Inbound/outbound SMS, status |
| SmsTemplate | Reusable SMS content |
| CommunicationConsent | Email/SMS/call opt-in/out per channel |
| TrackingEvent | Open, click, bounce, complaint, SMS delivery |

## 7. Integrations

| ID | Integration | Purpose |
|----|-------------|---------|
| CCM-INT-001 | Gmail / Google Workspace | Client add-in + optional sync |
| CCM-INT-002 | Microsoft Outlook / Exchange / Graph | Client add-in + optional sync |
| CCM-INT-003 | Telephony / softphone / CPaaS | Click-to-call, call logging, recording optional |
| CCM-INT-004 | SMS gateway (Twilio or equivalent) | Send/receive SMS, delivery receipts |
| CCM-INT-005 | Calendar (via Accounts module) | Call vs meeting conflict awareness |

## 8. Permissions and security

| ID | Requirement |
|----|-------------|
| CCM-SEC-001 | Users can only email/SMS/call records they are allowed to read, unless a shared queue is assigned. |
| CCM-SEC-002 | OAuth tokens and SMTP secrets are encrypted at rest; never exposed in UI or logs. |
| CCM-SEC-003 | Tracking pixels and link wrapping are optional and disclosed in org settings. |
| CCM-SEC-004 | Mass email requires a dedicated permission; marketing vs transactional templates are separated. |
| CCM-SEC-005 | Consent and unsubscribe are honored globally across composer, mass send, and workflows. |
| CCM-SEC-006 | Call recordings (if enabled) follow retention and access policies. |

## 9. Non-functional requirements

| ID | Requirement |
|----|-------------|
| CCM-NFR-001 | Inbound email association P95 < 30s from provider receipt. |
| CCM-NFR-002 | Open/click events appear in UI within 10s of receipt. |
| CCM-NFR-003 | Mass email throughput respects provider limits; jobs are resumable. |
| CCM-NFR-004 | SMS delivery status updates via webhooks without polling-only design. |
| CCM-NFR-005 | All outbound content is stored for audit and compliance export. |

## 10. Dependencies

| Module | Why |
|--------|-----|
| Accounts and Contacts | Recipients, timezones, DNC, scheduling links in email |
| Leads Management | Lead email/SMS before conversion |
| Opportunities / Deals | Log communication on deals; share quotes from threads |
| Quotes, Orders, and Contracts | Share quotes from email |
| Dashboards and Reports | Email reports, call analytics, activity reports |
| Platform Capabilities | Notifications, notes, custom fields on activities |
| Workflows and Process Automation | Send email/SMS as workflow actions |
| Sales Performance Management | Campaign member sends |
| Marketplace | Email/SMS/telephony connector apps |

## 11. Traceability

| Source capability | Requirement IDs |
|-------------------|-----------------|
| Call Reminders | CCM-FR-001 |
| Call Scheduling | CCM-FR-002 |
| Call Tagging | CCM-FR-003 |
| Canned Responses | CCM-FR-004 |
| Direct Email Communication | CCM-FR-005 |
| Email Association with CRM Records | CCM-FR-006 |
| Email Client Integration | CCM-FR-007 |
| Email Scheduling | CCM-FR-008 |
| Email Status | CCM-FR-009 |
| Email Templates | CCM-FR-010 |
| Mass Email | CCM-FR-011 |
| SMS Analytics | CCM-FR-015 |
| SMS Interaction | CCM-FR-012 |
| SMS Scheduling | CCM-FR-013 |
| SMS Templates | CCM-FR-014 |
