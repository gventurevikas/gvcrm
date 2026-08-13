# Accounts and Contacts Management

**Document ID:** GVCRM-REQ-ACM  
**Version:** 1.0  
**Status:** Draft for implementation  
**Source:** CRM Requirement sheet — Accounts and Contacts Management  
**This document is independent.** Related modules are listed only as dependencies.

---

## 1. Purpose

Provide a single system of record for **companies (accounts)** and **people (contacts)**, including hierarchy, relationship visualization, geography, and appointment booking. Sales, support, and success teams must see a unified 360° view of every account and contact without leaving the record.

## 2. Scope

**In scope**

- Account create / update / archive and 360° account view
- Account hierarchy (parent / child)
- Contact create / update / archive and 360° contact view
- Interactive organization charts
- Contact map and geo-filtering
- Individual appointment scheduling pages
- Group appointment scheduling URLs

**Out of scope (owned by other modules)**

- Email / SMS / call execution — Customer Communication
- Opportunity stage movement — Opportunities / Deals
- Document repository — Documents Management
- Lead capture before conversion — Leads Management

## 3. Users

| Persona | Typical actions |
|---------|-----------------|
| Sales representative | Create accounts/contacts, book meetings, view 360° history |
| Account manager | Maintain hierarchy, identify upsell via child accounts |
| Sales operations | Define required fields, sharing rules, scheduling policies |
| Customer / prospect (external) | Pick a meeting slot from a shared scheduling link |
| Admin | Configure map providers, org-chart rules, scheduling branding |

## 4. Business objectives

- One trusted profile per company and per person
- Faster meeting booking without back-and-forth email
- Visibility of parent/child commercial relationships for cross-sell and upsell
- Clear internal reporting lines and buying-committee relationships

---

## 5. Functional requirements

### 5.1 Account management

**Source capability:** Account Management  
**Priority:** P0  
**ID:** ACM-FR-001

The solution shall allow creating accounts to store profile information of companies or business units, and shall offer a unified view of account details plus associated records.

**User story**  
As a sales representative, I want to open one account page and see all related people, deals, tickets, notes, billing, and communication so I do not hunt across modules.

**Detailed requirements**

1. Users can create, edit, clone, merge, and archive accounts.
2. Standard account fields shall include at least: name, legal name, type (customer / prospect / partner / vendor / other), industry, website, phone, billing/shipping addresses, annual revenue, employee count, owner, parent account, tax IDs, billing information, status, and description.
3. Custom fields defined in Platform Capabilities must appear on the account layout.
4. The account 360° view shall show associated: contacts, opportunities, tickets/cases, notes, billing information, communication history, documents, quotes/orders/contracts, activities, and products in use.
5. Duplicate detection shall warn when name + domain or tax ID already exists.
6. Account owner and sharing rules control who can view or edit.

**Acceptance criteria**

- Creating an account with required fields succeeds and appears in search and list views within 3 seconds under normal load.
- Opening an account shows all associated record types listed above (empty states if none).
- Merging two accounts moves child records to the surviving account and writes an audit entry.
- Archived accounts are hidden from default lists but remain searchable with an “include archived” filter.

---

### 5.2 Account hierarchy

**Source capability:** Account Hierarchy  
**Priority:** P0  
**ID:** ACM-FR-002

The solution shall support hierarchy by linking related accounts to a parent account, and shall enable viewing child account information from the parent account page to identify cross-selling and upselling opportunities.

**User story**  
As an account manager, I want to see all child business units under a parent so I can spot products sold in one unit that another unit does not yet have.

**Detailed requirements**

1. An account may have zero or one parent account and many child accounts.
2. Hierarchy depth shall support at least 10 levels.
3. Cycles are forbidden (A cannot be parent of B if B is ancestor of A).
4. Parent account page shall display a tree or indented list of children with key metrics: open opportunities, closed-won revenue (period selectable), active contacts, open tickets.
5. Users can navigate from parent → child and child → parent without losing context.
6. Roll-up optional metrics (configurable): total open pipeline, total won revenue, contact count.

**Acceptance criteria**

- Linking account B as child of A updates both records immediately.
- Attempting a cyclic parent assignment is blocked with a clear error.
- Parent page shows each child’s name, owner, open pipeline, and last activity date.
- Changing parent is audited (old parent, new parent, actor, timestamp).

---

### 5.3 Contact management

**Source capability:** Contact Management  
**Priority:** P0  
**ID:** ACM-FR-003

The solution shall allow creating contacts to store profile information of individuals and shall offer a unified view of contact details and associated accounts, opportunities, tickets, surveys, notes, activity history, communication history, engagement history, social data, and more.

**User story**  
As a sales representative, I want a full history of every person I talk to so I can personalize outreach and avoid duplicate conversations.

**Detailed requirements**

1. Users can create, edit, clone, merge, and archive contacts.
2. A contact may be linked to one primary account and optionally additional accounts (buying roles).
3. Standard fields shall include at least: first/last name, email(s), phone(s), mobile, title, department, role, reports-to contact, mailing address, timezone, preferred language, owner, lead source, social handles, do-not-contact flags.
4. Contact 360° view shall include: accounts, opportunities, tickets, surveys, notes, activity history, communication history, engagement history, social data, documents, and appointments.
5. Email and phone uniqueness warnings (configurable: warn vs block).
6. Conversion from lead shall create or update a contact without losing history (see Leads Management).

**Acceptance criteria**

- Contact with valid email/phone saves and appears on the related account.
- 360° view shows each associated object type.
- Merge keeps the selected master field values and all activities.
- Do-not-contact flag prevents outbound email/SMS from CRM (enforced in Communication module).

---

### 5.4 Organization charts

**Source capability:** Organization Charts  
**Priority:** P1  
**ID:** ACM-FR-004

The solution shall provide interactive org charts to keep track of contacts and visualize relationships among contacts.

**User story**  
As an account manager, I want to see who reports to whom and who influences the deal so I can map the buying committee.

**Detailed requirements**

1. Org chart is built from contact `reports-to` relationships and optional influence/relationship types (decision maker, champion, blocker, influencer, end user).
2. Chart is interactive: zoom, pan, click node to open contact, drag to re-parent (permissioned).
3. Chart can be scoped to an account or to a selected set of contacts.
4. Missing `reports-to` contacts still appear as unlinked nodes with a prompt to link.
5. Export org chart as PNG/PDF.

**Acceptance criteria**

- Opening org chart for an account with 20 contacts renders within 2 seconds.
- Changing reports-to on the chart updates the contact record.
- Relationship type badges are visible on nodes.
- Users without edit permission can view but cannot drag-reparent.

---

### 5.5 Contacts map

**Source capability:** Contacts Map  
**Priority:** P1  
**ID:** ACM-FR-005

The solution shall integrate map services such as Google Maps, Badger Maps, etc. to help locate contacts and filter them by city, state, and country.

**User story**  
As a field representative, I want to see nearby contacts on a map and filter by city/state/country before a trip.

**Detailed requirements**

1. Map view plots contacts (and optionally accounts) that have geocodable addresses.
2. Filters: city, state/region, country, owner, account, tags, last activity date.
3. Clicking a pin opens a mini-card (name, account, phone, next activity) with link to full record.
4. Admin can configure map provider (Google Maps, Badger Maps, or other supported provider) and API credentials.
5. Addresses are geocoded on save; failed geocodes are flagged for cleanup.
6. Clustering for dense pin areas.

**Acceptance criteria**

- Filtering to a country shows only contacts in that country.
- A newly saved contact with a valid address appears on the map after geocoding completes.
- If map provider credentials are missing, UI shows a configuration message instead of a blank map.
- Location data is stored only for permitted records (respect sharing).

---

### 5.6 Appointment scheduling (individual)

**Source capability:** Appointment Scheduling  
**Priority:** P0  
**ID:** ACM-FR-006

The solution shall allow creating a custom scheduling page and including calendar links in individual emails so customers can pick a date and time.

**User story**  
As a sales representative, I want to send my booking link in an email so the prospect chooses a slot that is already free on my calendar.

**Detailed requirements**

1. Each user can publish a branded personal scheduling page (URL slug, photo, bio, meeting types, durations, buffers, working hours, timezone).
2. Availability is read from the user’s connected calendar(s).
3. Invitee picks date/time; CRM creates an appointment activity linked to the contact/lead/account and sends calendar invites to both parties.
4. Scheduling link can be inserted into emails (Communication module) and copied to clipboard.
5. Meeting types may require intake questions (name, email, company, custom fields).
6. Cancellation / reschedule links are included in confirmation.

**Acceptance criteria**

- Prospect using a valid link only sees free slots in the host timezone converted to invitee timezone.
- Confirmed booking creates a CRM activity and calendar events for host and invitee.
- Double-booking the same slot is prevented.
- Custom branding (logo, color) from the user’s or org settings appears on the page.

---

### 5.7 Group appointment scheduling

**Source capability:** Group Appointment Scheduling  
**Priority:** P1  
**ID:** ACM-FR-007

The solution shall allow publishing a single scheduling URL that shares calendars of several users. Once the group URL is sent to a contact, they can set up a meeting with any of the users.

**User story**  
As a sales team lead, I want one shared booking link so a prospect can meet the first available AE on my team.

**Detailed requirements**

1. Admins or team leads create a group scheduling page bound to a set of users or a user group.
2. Invitee sees combined availability; assignment rule options: any available, round-robin, least recently booked, or invitee chooses a specific host.
3. Booking creates the appointment against the assigned host and links the contact.
4. Group URL can be rotated or disabled without deleting history.
5. Hosts can opt out temporarily (OOO) without changing the group definition.

**Acceptance criteria**

- Group link shows a slot only if at least one eligible host is free.
- Round-robin distributes consecutive bookings across eligible hosts.
- Assigned host receives the invite and the activity appears on their CRM calendar.
- Disabled group URL returns a friendly “scheduling unavailable” page.

---

## 6. Data entities

| Entity | Key attributes | Relationships |
|--------|----------------|---------------|
| Account | identity, commercial profile, billing, status, owner | parent Account, child Accounts, Contacts, Opportunities, Cases, Documents, Orders |
| Contact | identity, channels, role, timezone, DNC flags, owner | Account(s), reports-to Contact, Activities, Opportunities, Documents |
| AccountContactRole | role, primary flag | Account ↔ Contact |
| Appointment / Meeting | type, start/end, timezone, location/video URL, status | Contact/Lead/Account, Host User(s) |
| SchedulingPage | slug, branding, meeting types, hours, buffers | User or UserGroup |
| GeoCoordinate | lat/long, geocode status, provider | Account or Contact address |

## 7. Integrations

| ID | Integration | Purpose |
|----|-------------|---------|
| ACM-INT-001 | Google Maps / Badger Maps (or equivalent) | Contact/account map and geocoding |
| ACM-INT-002 | Google Calendar / Microsoft Outlook Calendar | Availability and meeting write-back |
| ACM-INT-003 | Video meeting providers (Meet / Teams / Zoom) | Optional conference link on booking |
| ACM-INT-004 | Email (Communication module) | Insert scheduling links into outbound mail |

## 8. Permissions and security

| ID | Requirement |
|----|-------------|
| ACM-SEC-001 | Account and contact access follows role + record-owner + sharing rules. |
| ACM-SEC-002 | External scheduling pages expose only free/busy, never calendar event titles or internal notes. |
| ACM-SEC-003 | Map views never reveal records the user cannot already read. |
| ACM-SEC-004 | PII fields (email, phone, address) are audit-logged on view export and on merge. |
| ACM-SEC-005 | Group scheduling URLs are unguessable tokens; old tokens can be revoked. |

## 9. Non-functional requirements

| ID | Requirement |
|----|-------------|
| ACM-NFR-001 | Account/contact record page P95 load < 2s for 360° summary (lazy-load heavy widgets). |
| ACM-NFR-002 | Search by name, email, phone, domain returns in < 1s for up to 1M contacts. |
| ACM-NFR-003 | Hierarchy and org chart remain usable up to 500 nodes per view (pagination/virtualization beyond that). |
| ACM-NFR-004 | All create/update/merge/archive actions are fully auditable. |
| ACM-NFR-005 | Multi-language labels and multi-currency billing fields follow Platform Capabilities. |

## 10. Dependencies

| Module | Why |
|--------|-----|
| Customer Communication | Emails, calls, SMS, and scheduling-link insertion |
| Leads Management | Lead → contact/account conversion |
| Opportunities / Deals | Related deals on 360° view |
| Documents Management | Attachments on account/contact |
| Platform Capabilities | Custom fields, layouts, notes, notifications, multi-currency |
| Team Collaboration | Tags, mentions, user groups for group scheduling |
| Workflows and Process Automation | Assignment and validation on account/contact save |

## 11. Traceability

| Source capability | Requirement IDs |
|-------------------|-----------------|
| Account Hierarchy | ACM-FR-002 |
| Account Management | ACM-FR-001 |
| Appointment Scheduling | ACM-FR-006 |
| Contact Management | ACM-FR-003 |
| Contacts Map | ACM-FR-005 |
| Group Appointment Scheduling | ACM-FR-007 |
| Organization Charts | ACM-FR-004 |
