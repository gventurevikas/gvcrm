# Leads Management

**Document ID:** GVCRM-REQ-LED  
**Version:** 1.0  
**Status:** Draft for implementation  
**Module:** Leads Management  
**This document is independent.** Related modules are listed only as dependencies.

---

## 1. Purpose

Capture, score, assign, and analyze **inbound and outbound leads** from many sources so sales can respond quickly, work the right prospects first, and understand where leads are won or lost.

## 2. Scope

**In scope**

- Multi-source lead capture and manual entry into one database
- Automatic lead distribution (criteria and round-robin)
- Lead scoring with customizable rules
- Email parser for forwarded lead data
- Mobile business-card scanner
- Win-loss and lead lifecycle analytics

**Out of scope**

- Post-conversion opportunity stage management — Opportunities / Deals
- Mass email execution — Customer Communication
- Full campaign object design — Sales Performance Management (campaigns may create leads)

## 3. Users

| Persona | Typical actions |
|---------|-----------------|
| Sales development / AE | Work assigned leads, convert, recapture |
| Marketing ops | Capture forms, scoring rules, source mapping |
| Sales ops | Assignment rules, round-robin queues |
| Field rep | Scan business cards on mobile |
| Manager | Win-loss, response time, lifecycle reports |

## 4. Business objectives

- No lead left unassigned
- Fair or criteria-based routing
- Prioritization via score
- Shorter speed-to-lead
- Visibility into leakage (where and why leads are lost)

---

## 5. Functional requirements

### 5.1 Leads capture

**Source capability:** Leads Capture  
**Priority:** P0  
**ID:** LED-FR-001

The solution shall provide tools to capture leads from various sources and to manually add leads from different sources into a single database.

**User story**  
As marketing ops, I want web, import, API, and manual leads all in one lead object with a reliable source field.

**Detailed requirements**

1. Create leads manually (quick create and full layout).
2. Capture sources include at least: web forms, landing pages, CSV/XLS import, API, email parser, card scanner, campaigns, chat, and marketplace/partner apps.
3. Every lead stores `lead_source`, `source_detail`, UTM fields, and original payload (where applicable).
4. Deduplicate on email / phone / domain + name using configurable match rules (create new, update existing, or review queue).
5. Web form / embed snippet with spam protection (CAPTCHA/honeypot) and GDPR/consent fields.
6. Import wizard: column mapping, validation errors, partial success report.

**Acceptance criteria**

- Manual create and CSV import both produce Lead records in the same object.
- Duplicate email with “update existing” enriches the existing lead and logs the source touch.
- Web form submission appears as a lead within 10 seconds.
- Failed import rows are downloadable with reasons.

---

### 5.2 Automatic lead distribution

**Source capability:** Automatic Lead Distribution  
**Priority:** P0  
**ID:** LED-FR-002

The solution shall allow defining assignment rules to automatically assign sales representatives based on geography, product, department, lead score, lead source, etc., or use round-robin queues to assign leads equally.

**User story**  
As sales ops, I want US-West enterprise leads to go to Team A and everything else to round-robin SDRs.

**Detailed requirements**

1. Assignment rules engine: ordered rules with criteria (geography, product interest, department, score band, source, custom fields) → owner user or queue.
2. Round-robin queues: member list, weights optional, skip OOO/unavailable members.
3. Reassignment: manual, bulk, and rule re-run on update (configurable).
4. Unmatched leads go to a default queue/user and alert ops.
5. Full audit: which rule/queue assigned whom and why.
6. Works for new captures and optionally for updated leads.

**Acceptance criteria**

- A lead matching rule #1 is never also assigned by a lower rule.
- Round-robin of 3 active members assigns 30 leads as evenly as possible (±1).
- OOO member is skipped until they are available again.
- Assignment creates a notification for the new owner.

---

### 5.3 Lead scoring

**Source capability:** Lead Scoring  
**Priority:** P0  
**ID:** LED-FR-003

The solution shall compute and assign each lead a score based on customizable scoring rules using lead data, activities, interactions, and more.

**User story**  
As an SDR, I want high-intent leads (pricing page + demo request + title=VP) at the top of my queue.

**Detailed requirements**

1. Scoring rules: positive/negative points on demographic fields, firmographics, activities (email open/click, call, meeting, form, website events if available), recency decay optional.
2. Score is stored on the lead and updated asynchronously as events arrive.
3. Thresholds: MQL / SQL / recycle bands; crossing a threshold can trigger workflow.
4. Visible score breakdown (why this score) for transparency.
5. Recalculate all (admin job) after rule changes.

**Acceptance criteria**

- Changing a title to a high-value persona increases score per rules.
- An email click adds the configured points and updates the record.
- Score breakdown lists contributing rules.
- Threshold cross can start a workflow without a page refresh from the user.

---

### 5.4 Email parser

**Source capability:** Email Parser  
**Priority:** P1  
**ID:** LED-FR-004

The solution shall create a new lead or update an existing lead when an email with lead data is forwarded to a provided parser email address.

**User story**  
As a sales representative, I want to forward a “contact us” email to parse@company.crm and have a lead created automatically.

**Detailed requirements**

1. Org is issued one or more parser addresses (plus optional custom domain aliases).
2. Parser extracts: name, email, phone, company, title, message body, and custom mapped fields (regex / AI-assisted mapping configurable).
3. If email matches an existing lead/contact, update and log activity; else create lead.
4. Original email is stored and linked.
5. Low-confidence parses go to a review queue.
6. Abuse: only allowed sender domains can use the parser (configurable).

**Acceptance criteria**

- Forwarding a well-structured lead email creates/updates a lead with email and name populated.
- Duplicate forward updates the existing lead rather than cloning (per settings).
- Unauthorized sender is rejected and optionally notified.
- Review queue item can be accepted to create the lead.

---

### 5.5 Card scanner

**Source capability:** Card Scanner  
**Priority:** P1  
**ID:** LED-FR-005

The solution shall offer a mobile card scanner app that scans business cards and pushes new contact/lead information into the CRM automatically.

**User story**  
As a field rep at a conference, I want to snap a business card and have a lead in CRM before I leave the booth.

**Detailed requirements**

1. Mobile app (iOS/Android) or in-app camera flow: capture card image, OCR fields, user confirms/edits, submit.
2. Creates a Lead by default (setting: Lead vs Contact).
3. Stores card image as attachment.
4. Offline capture queue with sync when online.
5. Dedup warning before save if email exists.

**Acceptance criteria**

- Confirmed scan creates a CRM lead with name, company, email, phone when visible on the card.
- Image is attached to the record.
- Offline scans sync automatically when connectivity returns.
- User can correct OCR errors before submit.

---

### 5.6 Win-loss analysis

**Source capability:** Win-Loss Analysis  
**Priority:** P1  
**ID:** LED-FR-006

The solution shall display the percentage of won and lost leads, average lead life-cycle, and how fast the team responds to incoming leads, to understand where leads are lost most frequently.

**User story**  
As a sales manager, I want to see that we lose most leads at “no response after MQL” and that speed-to-lead is 4 hours so I can fix staffing.

**Detailed requirements**

1. Outcomes: converted (won as customer/opportunity per definition), lost/disqualified, recycled, still open.
2. Metrics: win %, loss %, average lifecycle duration (created → terminal status), median/average first-response time to new inbound leads.
3. Breakdown: by source, campaign, owner, team, score band, loss reason, stage-in-lead-process.
4. Funnel visualization of lead statuses.
5. Drill-down to the underlying leads (Reports module may render; data must exist here).

**Acceptance criteria**

- Win % + loss % + open % is reconcilable with lead counts for the filter.
- First-response time uses first human activity (call/email/SMS/meeting) after create.
- Loss-reason report highlights the most frequent loss bucket.
- Date range and team filters work.

---

### 5.7 Lead lifecycle operations (implied core)

**Priority:** P0  
**ID:** LED-FR-007

To make the source capabilities usable, the solution shall support a complete lead lifecycle.

**Detailed requirements**

1. Lead statuses (configurable process): e.g. New, Contacted, Nurturing, Qualified, Unqualified, Converted.
2. Convert lead → Account + Contact + optional Opportunity, mapping fields, attaching history.
3. Convert into existing account/contact when duplicates found.
4. List/kanban views, filters, tags, tasks, notes.
5. Required loss/disqualify reason when marking lost.

**Acceptance criteria**

- Conversion creates/links account and contact and optionally an opportunity in one transaction.
- Timeline history is visible on the resulting contact.
- Converted leads are read-only for core identity fields (or locked per policy) but remain searchable.

---

## 6. Data entities

| Entity | Purpose |
|--------|---------|
| Lead | Prospect identity, source, score, status, owner |
| LeadSource / Touch | Attribution events |
| AssignmentRule | Ordered matching criteria |
| RoundRobinQueue | Members, weights, last-assigned pointer |
| ScoringRule | Points definition |
| ScoreBreakdown | Per-lead rule contributions |
| ParserInbox | Parser address + mapping config |
| CardScanJob | Image, OCR result, sync status |
| LeadOutcomeSnapshot | Aggregates for win-loss |

## 7. Integrations

| ID | Integration | Purpose |
|----|-------------|---------|
| LED-INT-001 | Web forms / website / landing pages | Inbound capture |
| LED-INT-002 | Email parser mailbox | Forward-to-lead |
| LED-INT-003 | Mobile camera / OCR | Card scanner |
| LED-INT-004 | Public API / Marketplace apps | Partner lead injection |
| LED-INT-005 | Communication module | First-response timing, activities |
| LED-INT-006 | Campaigns (SPM) | Campaign member → lead |

## 8. Permissions and security

| ID | Requirement |
|----|-------------|
| LED-SEC-001 | Leads follow role, owner, queue membership, and sharing rules. |
| LED-SEC-002 | Parser addresses are unguessable; sender allow-list enforced. |
| LED-SEC-003 | Web form endpoints are rate-limited and spam-protected. |
| LED-SEC-004 | Card images are PII; encrypted storage and retention policy apply. |
| LED-SEC-005 | Assignment rule admin is a distinct permission. |

## 9. Non-functional requirements

| ID | Requirement |
|----|-------------|
| LED-NFR-001 | Inbound form → assigned owner notification P95 < 15s. |
| LED-NFR-002 | Score update P95 < 10s after qualifying activity. |
| LED-NFR-003 | Import of 10k leads completes with progress feedback; no UI timeout. |
| LED-NFR-004 | Assignment engine is deterministic and concurrent-safe (no double assign). |
| LED-NFR-005 | Win-loss dashboard P95 < 3s for 100k leads with pre-aggregation. |

## 10. Dependencies

| Module | Why |
|--------|-----|
| Accounts and Contacts | Conversion targets |
| Opportunities / Deals | Optional opportunity on convert |
| Customer Communication | Activities, email parser storage, response time |
| Documents | Card image and lead attachments |
| Dashboards and Reports | Win-loss and funnel visuals |
| Sales Performance | Campaigns feeding leads |
| Platform | Custom fields, layouts, notifications, mobile |
| Workflows | Score-threshold and assignment side effects |
| Marketplace | Lead capture apps / form apps |

## 11. Traceability

| Source capability | Requirement IDs |
|-------------------|-----------------|
| Automatic Lead Distribution | LED-FR-002 |
| Card Scanner | LED-FR-005 |
| Email Parser | LED-FR-004 |
| Leads Capture | LED-FR-001 |
| Lead Scoring | LED-FR-003 |
| Win-Loss Analysis | LED-FR-006 |
| (Lifecycle needed to operate the module) | LED-FR-007 |
