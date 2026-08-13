# Opportunities / Deals Management

**Document ID:** GVCRM-REQ-ODM  
**Version:** 1.0  
**Status:** Draft for implementation  
**Module:** Opportunities / Deals Management  
**This document is independent.** Related modules are listed only as dependencies.

---

## 1. Purpose

Manage the **sales pipeline**: create and progress opportunities/deals through stages, support multiple pipelines, visualize work on a Kanban board, attach activities, automate journeys, estimate win probability, and highlight rotting/stuck deals.

## 2. Scope

**In scope**

- Opportunity create, filter, stage flow, lead conversion into opportunity
- Multiple sales pipelines (create, customize, import)
- Kanban / pipeline view
- Stage win-probability
- Opportunity rotting / stuck-deal highlighting (**source priority: High → P0**)
- Activity tracking on the opportunity with real-time updates
- Drag-and-drop journey designer with automated rules and workflows

**Out of scope**

- Quote/order/contract documents — Quotes, Orders, and Contracts
- Product catalog maintenance — Products Management
- Approval of discounts — Workflows (triggered from deals)

## 3. Users

| Persona | Typical actions |
|---------|-----------------|
| Sales representative | Create deals, move stages, log activities |
| Sales manager | Pipeline inspection, rotting deals, forecast inputs |
| Sales ops | Pipeline definitions, probabilities, rotting criteria |
| RevOps | Import pipelines, journey automation |

## 4. Business objectives

- Clear stage-based selling across one or many motions (e.g. new logo vs renewal)
- Early warning on neglected deals
- Activity history always attached to the deal
- Repeatable automated journeys without engineering

---

## 5. Functional requirements

### 5.1 Opportunity management

**Source capability:** Opportunity Management  
**Priority:** P0  
**ID:** ODM-FR-001

The solution shall allow creating new opportunities, sorting and filtering them using various fields, managing flow across stages, and converting leads into opportunities.

**User story**  
As a sales representative, I want to convert a qualified lead into a deal and move it through stages until close.

**Detailed requirements**

1. CRUD for opportunities with standard fields: name, account, primary contact, pipeline, stage, amount, currency, close date, owner, type, source, description, next step, probability (auto from stage, overridable).
2. Sort/filter/list views on any permitted field; saved views.
3. Stage transitions with optional required fields / lost reasons / won details.
4. Convert from Lead (see Leads) creating or linking Account, Contact, Opportunity.
5. Products/line items can be associated (Products module).
6. Close won/lost is terminal; reopen requires permission.

**Acceptance criteria**

- Creating an opportunity linked to an account shows on the account 360° view.
- Stage change updates probability to the stage default unless overridden.
- Lead conversion can create an opportunity in one transaction.
- List filters (owner = me, close date this quarter, amount > X) work together.

---

### 5.2 Multiple sales pipelines

**Source capability:** Multiple Sales Pipeline  
**Priority:** P0  
**ID:** ODM-FR-002

The solution shall allow creating multiple sales pipelines, customizing settings and views, and importing sales pipelines from other CRM systems.

**User story**  
As sales ops, I want a New Business pipeline and a Renewal pipeline with different stages.

**Detailed requirements**

1. Multiple pipelines per org, each with ordered stages, probabilities, forecast categories, and required fields per stage.
2. Customize list/kanban views per pipeline.
3. Assign default pipeline by opportunity type, team, or record type.
4. Import pipeline definitions (stages + probabilities) from common CRMs via file or connector (Salesforce/HubSpot-style CSV/API mapping).
5. Deactivate pipeline without deleting historical deals; new creates blocked.

**Acceptance criteria**

- Two pipelines can exist with different stage names simultaneously.
- An opportunity belongs to exactly one pipeline at a time; changing pipeline remaps stages via a mapping UI.
- Import creates stages and probabilities from a valid mapping file.
- Inactive pipeline is hidden from create form.

---

### 5.3 Sales pipeline / Kanban view

**Source capability:** Sales Pipeline / Kanban View of Opportunities  
**Priority:** P0  
**ID:** ODM-FR-003

The solution shall organize opportunities on a Kanban board and offer visibility of opportunities across all stages in a single view.

**User story**  
As a sales manager, I want to see all open deals by stage on one board and drag a card to the next stage.

**Detailed requirements**

1. Kanban columns = pipeline stages; cards show key fields (name, amount, close date, owner, rotting indicator, next activity).
2. Drag-and-drop stage change with the same validation as detail-page stage change.
3. Swimlanes optional (owner, forecast category, priority).
4. Column totals: count and sum amount (converted to org currency).
5. Filters: owner, team, close date, amount, product, tags.
6. Click card → peek panel or full record.
7. Color-coded icons for overdue next activity (Platform capability consumed here).

**Acceptance criteria**

- All open opportunities in the selected pipeline appear in the correct stage column.
- Dragging to Won/Lost prompts for required close fields.
- Totals match list-view aggregates for the same filter.
- Board remains usable with hundreds of cards (virtualization / work-in-view limits + “load more”).

---

### 5.4 Opportunity probability

**Source capability:** Opportunity Probability  
**Priority:** P0  
**ID:** ODM-FR-004

The solution shall assign a win-probability percentage to different stages of the opportunity.

**Detailed requirements**

1. Each stage has a default win probability (0–100).
2. Opportunity probability defaults from stage; users with permission may override.
3. Forecast and weighted pipeline use probability × amount (Sales Performance consumes this).
4. History of probability changes is audited.
5. Closed-won = 100%, closed-lost = 0% (not overridable).

**Acceptance criteria**

- Moving to a stage with 40% sets probability to 40% if not overridden.
- Override persists until stage change policy: “keep override” vs “reset to stage default” (configurable).
- Weighted amount on reports equals amount × probability / 100.

---

### 5.5 Opportunity rotting

**Source capability:** Opportunity Rotting  
**Source priority:** High  
**Priority:** P0  
**ID:** ODM-FR-005

The solution shall highlight opportunities when configurable criteria are met, drawing attention to opportunities that have been unattended or stuck at a stage beyond a specific period.

**User story**  
As a sales manager, I want deals with no activity for 14 days or 20+ days in Proposal to glow red on the board.

**Detailed requirements**

1. Configurable rotting rules per pipeline/stage: no activity for N days; time-in-stage > N; close date in the past; missing next step; score/amount thresholds optional.
2. Visual highlight on Kanban, list, and detail (badge + color).
3. Notification to owner and optional manager when a deal becomes rotting.
4. Rotting clears automatically when criteria no longer match (e.g. new activity logged).
5. Report: rotting deals by owner/stage.
6. Multiple severity levels (watch / rotting / critical) if multiple rules match.

**Acceptance criteria**

- A deal with no activity for longer than the rule threshold shows the rotting indicator within the evaluation window (≤ 15 minutes or on page load, whichever is specified; batch + on-read acceptable if documented).
- Logging a call clears the “no activity” rotting state.
- Time-in-stage rule does not apply to Won/Lost.
- Managers can open a list of all rotting deals for their team.

---

### 5.6 Activity management

**Source capability:** Activity Management  
**Priority:** P0  
**ID:** ODM-FR-006

The solution shall track all customer communications and activities associated with an opportunity and notify updates in real time. Examples: emails, phone calls, appointments, tasks, notes.

**User story**  
As an AE, I want every email, call, meeting, task, and note on the deal timeline, and I want to be notified when a teammate logs something.

**Detailed requirements**

1. Opportunity timeline aggregates: emails, calls, appointments, tasks, notes, SMS, stage changes, file attachments, quotes.
2. Create task/call/meeting/note from the opportunity.
3. Real-time notifications to followers/owner when activities are added or updated (filterable).
4. Users can follow/unfollow an opportunity.
5. Activity completion updates rotting evaluation.

**Acceptance criteria**

- Sending an email related to the opportunity’s contact can be associated to the opportunity (manual or auto-match rules).
- A new task on the deal appears on the timeline without refresh (websocket/push or short poll).
- Followers receive a notification on new activity per their notification preferences.
- Timeline is reverse-chronological with type filters.

---

### 5.7 Journey designer

**Source capability:** Journey Designer  
**Priority:** P1  
**ID:** ODM-FR-007

The solution shall provide a drag-and-drop interface to create sales journeys with automated business rules and integrated workflows that perform optimally across various devices.

**User story**  
As revops, I want a visual journey: when a deal enters Proposal, create a task, send a template email, and wait 3 days before reminding the owner.

**Detailed requirements**

1. Visual drag-and-drop canvas: entry criteria (pipeline/stage/field/activity), wait steps, conditions, actions.
2. Actions: create task, assign owner, send email/SMS (Communication), update fields, create notification, invoke workflow rule, create quote stub, add playbook.
3. Journeys run on server; UI is responsive on desktop and tablet; read-only status on mobile.
4. Test/debug with sample opportunity; version publish/pause.
5. Enrollment: automatic on criteria and/or manual.
6. An opportunity can be in one journey of a given type at a time unless designed otherwise; exit criteria required.

**Acceptance criteria**

- Publishing a journey enrolls matching new opportunities.
- Wait step fires the next action after the configured delay (±1 minute).
- Pausing a journey stops new enrollments; in-flight behavior is documented (finish current wait vs exit).
- Canvas is usable on tablet (no overlapping unusable controls).

---

## 6. Data entities

| Entity | Purpose |
|--------|---------|
| Pipeline | Named sales process |
| PipelineStage | Order, probability, forecast category, required fields |
| Opportunity | Deal header |
| OpportunityLineItem | Products/quantities/prices |
| OpportunityHistory | Stage, amount, probability changes |
| RottingRule / RottingState | Highlight configuration and current flags |
| Journey / JourneyVersion | Visual automation definition |
| JourneyEnrollment | Opportunity progress through a journey |
| OpportunityFollower | Notification subscription |

## 7. Integrations

| ID | Integration | Purpose |
|----|-------------|---------|
| ODM-INT-001 | Leads module | Conversion |
| ODM-INT-002 | Communication | Timeline activities |
| ODM-INT-003 | Products | Line items |
| ODM-INT-004 | Quotes/Orders/Contracts | Commercial downstream |
| ODM-INT-005 | Workflows | Approvals and validation on stage change |
| ODM-INT-006 | External CRM import | Pipeline import |
| ODM-INT-007 | Real-time channel (websocket) | Activity notifications |

## 8. Permissions and security

| ID | Requirement |
|----|-------------|
| ODM-SEC-001 | Opportunity access via owner, roles, teams, account team, sharing rules. |
| ODM-SEC-002 | Pipeline and rotting-rule configuration is ops/admin permission. |
| ODM-SEC-003 | Amount and probability field-level security for sensitive deals. |
| ODM-SEC-004 | Journey publish is separated from journey edit. |
| ODM-SEC-005 | Import of pipelines does not import external user credentials. |

## 9. Non-functional requirements

| ID | Requirement |
|----|-------------|
| ODM-NFR-001 | Kanban load P95 < 2s for 200 visible cards. |
| ODM-NFR-002 | Stage change P95 < 500ms plus any synchronous validation. |
| ODM-NFR-003 | Timeline new-item visibility < 3s for online followers. |
| ODM-NFR-004 | Rotting evaluation job is incremental, not full-table scan every minute. |
| ODM-NFR-005 | Journey engine is horizontally scalable and exactly-once per step (idempotent actions). |

## 10. Dependencies

| Module | Why |
|--------|-----|
| Accounts and Contacts | Account/contact on deal |
| Leads | Conversion |
| Products | Line items, amount rollup |
| Customer Communication | Emails/calls/SMS/appointments |
| Documents | Playbooks and attachments |
| Quotes, Orders, and Contracts | Quote from opportunity |
| Dashboards and Reports | Deal reports |
| Sales Performance | Forecast uses probability and amount |
| Platform | Color icons, custom fields, notifications, notes |
| Workflows | Stage validation, discount approval |
| Team Collaboration | Tags, mentions on notes |

## 11. Traceability

| Source capability | Requirement IDs |
|-------------------|-----------------|
| Activity Management | ODM-FR-006 |
| Journey Designer | ODM-FR-007 |
| Multiple Sales Pipeline | ODM-FR-002 |
| Opportunity Management | ODM-FR-001 |
| Opportunity Probability | ODM-FR-004 |
| Opportunity Rotting (High) | ODM-FR-005 |
| Sales Pipeline / Kanban View | ODM-FR-003 |
