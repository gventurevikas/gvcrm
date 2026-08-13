# AI Assistant and Central Chat

**Document ID:** GVCRM-REQ-AIA  
**Version:** 1.0  
**Status:** Draft for implementation  
**Module:** AI Assistant and Central Chat  
**This document is independent.** Related modules are listed only as dependencies.

---

## 1. Purpose

Provide a **single central chat** in GVCRM where users can ask questions **and run business operations** across every module. **ChatGPT-mini** is the system-wide assistant: it helps users understand the CRM, gather the details it needs, create **custom reports**, and execute permitted actions (create/update records, communicate, schedule, quote, and more) without leaving the conversation.

The assistant is not a separate product. It is the conversational front door to the whole platform.

## 2. Scope

**In scope**

- Always-available central chat (global shell + record-aware side chat)
- ChatGPT-mini as the default overall-system assistant
- Cross-module help, how-to, and “what should I do next?”
- Natural-language **business operations** (create, update, search, assign, communicate, schedule, quote, approve-request, and similar)
- Conversational **custom report** creation from required details (object, metrics, filters, grouping, date range, visualization)
- Multi-turn clarification when details are missing
- Preview + confirm for write actions; full audit of assistant-initiated operations
- Conversation history, suggested prompts, and admin controls (enable, scopes, retention)

**Out of scope**

- Human-to-human private chat and feeds — Team Collaboration
- Drag-and-drop report canvas UI — Dashboards and Reports (this module calls that engine)
- Training or fine-tuning a proprietary LLM in MVP (uses ChatGPT-mini / equivalent hosted model)
- Autonomous agents that run unattended overnight without a user session (that is Workflows)

## 3. Users

| Persona | Typical actions in central chat |
|---------|----------------------------------|
| Remote producer / sales representative | “Show my new Meta leads…”, “Log a call…”, “Where am I on this week’s leaderboard?”, “Email this contact a follow-up” |
| Agency principal / sales manager | “Premium bound by producer this month”, “Assign these LinkedIn leads round-robin”, “Show at-risk renewals” |
| Sales ops / analyst | “Build a custom report: deals by stage and product, last 90 days” |
| Support / success | “Open a case for Acme”, “Summarize this account” |
| Admin | Configure assistant, scopes, model, retention; ask “how do I deploy sandbox to prod?” |
| New user | “How do I convert a lead?” — guided help across modules |

## 4. Business objectives

- One place to **operate the CRM**, not only ask about it
- Faster custom reporting without learning the report builder first
- Consistent help across all modules from one assistant
- Safe actions: same permissions as the user, with confirmation and audit
- Low-latency, cost-efficient assistance via **ChatGPT-mini** as the default model

---

## 5. Functional requirements

### 5.1 Central chat shell

**Priority:** P0  
**ID:** AIA-FR-001

The solution shall provide a central chat available from every screen so users can run business operations and get help without changing modules.

**User story**  
As a sales representative, I want a chat button always on screen so I can create a task or ask about a deal while I am already on the account page.

**Detailed requirements**

1. Global entry: header/sidebar launcher (keyboard shortcut, e.g. `Ctrl/Cmd + J`) opens the central chat from any module.
2. Layout: conversation pane, composer, suggested prompts, optional record/context chips.
3. Modes: **global** (no record) and **record-aware** (open lead/contact/account/deal/quote/case/etc. is attached as context).
4. Chat can be docked (side panel) or expanded (full page / overlay) and remembers last state per user.
5. Mobile: full-screen chat with the same capabilities (subset of visualizations OK).
6. Unread / in-progress indicator if a long report or action is still running.
7. Distinct from Team Collaboration private chat (different icon, label: “GVCRM Assistant”).

**Acceptance criteria**

- Chat launcher is visible on homepage, list views, and record pages.
- Opening chat from a deal attaches that deal as context (visible chip; user can remove it).
- Shortcut opens/closes chat without losing composer draft.
- Private human chat and Assistant chat are not mixed in one thread.

---

### 5.2 ChatGPT-mini system assistant

**Priority:** P0  
**ID:** AIA-FR-002

The overall system assistant shall be **ChatGPT-mini** (OpenAI GPT-4o-mini / ChatGPT mini class, or org-configured equivalent). It shall help across **all GVCRM modules**.

**User story**  
As any user, I want one assistant that understands leads, deals, quotes, reports, and settings so I do not switch bots per module.

**Detailed requirements**

1. Default model: **ChatGPT-mini** (product name in UI: “GVCRM Assistant, powered by ChatGPT-mini”).
2. Admin may switch to another approved model later; ChatGPT-mini remains the documented default.
3. System prompt / tool catalog covers every in-scope module: Accounts, Contacts, Communication, Dashboards & Reports, Documents, Leads, Opportunities, Products, Quotes/Orders/Contracts, Platform, Sales Performance, Collaboration, Workflows, Marketplace.
4. Assistant can explain *how* a feature works and *do* the corresponding permitted action.
5. Responses stream token-by-token; user can stop generation.
6. Language follows the user’s UI language pack (Platform multi-language).
7. If the model is unavailable, chat shows a clear fallback (search + help links), not a blank error.

**Acceptance criteria**

- UI identifies ChatGPT-mini (or configured model) in assistant settings/about.
- Asking “How do I convert a lead?” returns accurate steps for the Leads module.
- Asking “Create a follow-up task on this deal for Friday” (with deal context) proposes a task action.
- Streaming starts within the NFR latency budget; Stop cancels the request.

---

### 5.3 Cross-module help

**Priority:** P0  
**ID:** AIA-FR-003

The assistant shall help users complete work across modules: concepts, navigation, next best action, and playbook-style guidance.

**Detailed requirements**

1. Help intents: what a field/module is, how to do a process, why a validation failed, what a rotting deal means, how marketplace install works.
2. Ground answers in GVCRM product behaviour (requirements + in-app help), not generic internet CRM advice when they conflict.
3. Next-best-action suggestions based on context (e.g. deal with no next step → propose task + email).
4. Deep links: answers include buttons/links to the right screen or record.
5. Optional: cite which module/capability the answer relates to.

**Acceptance criteria**

- “Where do I set exchange rates?” deep-links to Platform currency settings (if the user can access them).
- “This quote failed validation” explains the blocking rule in plain language when the error is in context.
- Help answers do not invent features that are not in GVCRM.

---

### 5.4 Business operations from chat

**Priority:** P0  
**ID:** AIA-FR-004

Users shall perform business operations from the central chat. The assistant plans the operation, collects missing fields, previews the change, and executes only after confirmation (unless the user has enabled trusted quick-actions for low-risk ops).

**User story**  
As a sales representative, I want to type “Add lead Jane Doe, Acme, jane@acme.com, source = webinar and assign to me” and have the lead created without opening the lead form.

**Supported operation classes (minimum)**

| Class | Examples |
|-------|----------|
| Search / retrieve | Find account Acme; list my overdue tasks; show this contact’s last 5 emails |
| Create | Lead, contact, account, opportunity, task, note, case, quote (from deal), reminder |
| Update | Stage, owner, amount, close date, tags, custom fields the user can edit |
| Communicate | Draft/send email or SMS (Communication module + consent); log a call |
| Schedule | Book meeting / suggest scheduling link (Accounts scheduling) |
| Commercial | Create quote from opportunity; request discount approval |
| Documents | Attach/share link, find playbook |
| Collaborate | Post a note with @mention; add tag |
| Reporting | Build/run custom report (AIA-FR-005) |
| Admin (permissioned) | Explain sandbox deploy; cannot silently change production metadata without extra confirm |

**Detailed requirements**

1. Tool/function calling into GVCRM APIs with the **current user’s identity and permissions** (never a superuser).
2. Missing required details → assistant asks clarifying questions (one batch where possible) before executing.
3. Preview card: object, fields to write, related records, warnings (duplicates, DNC, validation).
4. Confirm / Edit / Cancel. Destructive actions (delete, mass update, send mass email) always require explicit confirm.
5. Optional “trusted quick actions” (admin + user toggle) for low-risk creates (e.g. note, task) without extra click.
6. After success: confirmation + link to the record + suggested next step.
7. Partial failure: report what succeeded and what did not; no silent half-state.
8. Bulk ops from chat (e.g. “close lost these 3 deals with reason X”) require list preview and confirm; respect max batch size.

**Acceptance criteria**

- Creating a lead via chat produces the same Lead record as the UI form, with audit “created via Assistant”.
- User without create-lead permission is refused with a clear explanation.
- Send-email from chat honours DNC/unsubscribe.
- Duplicate email warning appears on the preview before confirm.
- Cancelling preview creates nothing.

---

### 5.5 Custom reports from required details

**Priority:** P0  
**ID:** AIA-FR-005

The assistant shall create **custom reports** conversationally. It shall collect the **required details**, then build and run a report using the Dashboards and Reports engine (same security, KPIs, and chart types).

**User story**  
As a sales manager, I want to say “I need won revenue by salesperson and product for this quarter as a bar chart” and get a saved report I can open, share, or pin to a dashboard.

**Required details the assistant must gather (ask if missing)**

| Detail | Why |
|--------|-----|
| Primary object / subject | Leads, deals, activities, invoices, etc. |
| Metrics / columns | Amount, count, win rate, etc. |
| Filters | Owner, team, date range, stage, product, tags, custom fields |
| Grouping / breakdown | By AE, stage, product, month |
| Time grain / period | This quarter, last 30 days, custom |
| Visualization | Table, bar, funnel, pie, etc. (DAR chart types) |
| Name + save location | Personal vs shared folder |
| Audience | Just me / team (does not grant extra data access) |

**Detailed requirements**

1. If the user omits details, assistant asks only for what is still required (not a long form dump).
2. Show a **report spec preview** (plain language + structured definition) before run.
3. Run uses DAR query engine and **viewer’s record/field security**.
4. Result appears in chat: summary insight + chart/table thumbnail + “Open in Reports” + Save + Add to dashboard + Export (CSV/XLS/PDF via DAR).
5. Saved report is a first-class DAR report (editable later in drag-and-drop builder).
6. Follow-ups: “Break that down by month”, “Exclude lost”, “Share with West team” update the same thread spec.
7. Ambiguous metrics (“performance”) → assistant proposes 2–3 KPI interpretations and lets the user pick.
8. Large results: summarize + offer drill-down rather than dumping thousands of rows into chat.

**Acceptance criteria**

- “Deals closed this month by stage” with no other info still runs after assistant confirms object=Opportunity, period=this month, grouping=stage, metric=count and/or amount.
- Saved report opens in DAR builder with the same columns/filters.
- A user who cannot see Amount never sees Amount in the chat report.
- Totals in chat match the same report run in DAR for the same user.
- “Export CSV” uses DAR-FR-013 sharing/export rules.

---

### 5.6 Context, memory, and conversation history

**Priority:** P0  
**ID:** AIA-FR-006

**Detailed requirements**

1. Context sources: current user, role, timezone, open record(s), recent module, attached files/records in the thread.
2. Thread history is kept per user; user can rename, pin, search, and delete threads.
3. Org retention policy (e.g. 30/90/365 days) configurable; export for compliance.
4. Assistant may use short-term thread memory; it must not persist customer PII to the model provider beyond the configured retention and vendor DPA.
5. “Forget this record / new topic” clears context chips without deleting the whole thread unless asked.
6. Resume a previous thread with full operation and report history.

**Acceptance criteria**

- Returning to a thread shows prior messages, previews, and created record links.
- Deleting a thread removes it from the user’s history per retention rules.
- Switching from Deal A to Deal B updates the context chip; subsequent “update amount” targets Deal B.

---

### 5.7 Suggested prompts and onboarding

**Priority:** P1  
**ID:** AIA-FR-007

**Detailed requirements**

1. Role-based starter prompts (AE vs manager vs admin).
2. Contextual suggestions on a record page (e.g. on a rotting deal: “Draft a follow-up email”, “Why is this rotting?”, “Create a recovery task”).
3. After each successful operation, 1–3 next-step chips.
4. First-run coachmark: what the assistant can and cannot do.

**Acceptance criteria**

- A new AE sees prompts such as “Create a lead”, “What’s on my calendar today?”, “Build my activity report”.
- On an opportunity record, at least one suggestion is deal-specific.

---

### 5.8 Admin configuration and governance

**Priority:** P0  
**ID:** AIA-FR-008

**Detailed requirements**

1. Org settings: enable/disable assistant; default model **ChatGPT-mini**; optional alternate approved models.
2. Feature flags: help-only vs help+operations; report creation; outbound email/SMS from chat; mass actions.
3. Operation allow-list per profile (e.g. SDRs can create leads/tasks but cannot send mass email via chat).
4. API keys / model credentials stored encrypted; never shown in chat.
5. Usage dashboard: conversations, tokens, operations executed, errors (feeds DAR API/usage style widgets).
6. Kill switch disables assistant globally within seconds.
7. Sandbox: assistant uses sandbox data only; cannot target production from a sandbox session.

**Acceptance criteria**

- Disabling operations mode leaves Q&A/help working if help is still enabled.
- A profile without “send email via assistant” never sees Send on an email preview.
- Kill switch makes the launcher show “Assistant temporarily unavailable”.
- ChatGPT-mini (or configured model) API secret is not exposed in UI, logs, or model output.

---

### 5.9 Audit and explainability

**Priority:** P0  
**ID:** AIA-FR-009

**Detailed requirements**

1. Every executed operation writes a standard audit event: actor, assistant thread id, tool name, record ids, before/after summary, timestamp.
2. User can ask “what did you change?” and get the list for this thread.
3. Admins can filter audit by user, object, date, thread.
4. Assistant must not hide that a write happened behind a vague chat reply.

**Acceptance criteria**

- Lead created via chat appears in audit with source = Assistant.
- “Undo” for the last create (where technically safe) is offered or explained if not possible.
- Admin audit search finds the thread id from the record’s system information.

---

## 6. Data entities

| Entity | Purpose |
|--------|---------|
| AssistantThread | Conversation container, owner, title, status |
| AssistantMessage | User / assistant / system / tool messages |
| AssistantContextChip | Attached record, file, or module context |
| AssistantToolCall | Planned/executed GVCRM operation |
| ReportSpecDraft | Conversational custom-report definition before save |
| AssistantOrgSetting | Model, flags, allow-lists, retention |
| AssistantUsageSnapshot | Token and operation telemetry |
| AssistantAuditEvent | Immutable log of writes |

## 7. Integrations

| ID | Integration | Purpose |
|----|-------------|---------|
| AIA-INT-001 | ChatGPT-mini (OpenAI-compatible API) | Default reasoning / NL understanding |
| AIA-INT-002 | GVCRM object APIs (all modules) | Execute business operations as the user |
| AIA-INT-003 | Dashboards and Reports query + save API | Custom reports from chat |
| AIA-INT-004 | Communication send APIs | Email/SMS drafts and sends |
| AIA-INT-005 | Workflow / approval APIs | Submit approval, explain validation |
| AIA-INT-006 | Documents search | Find collateral / attach files |
| AIA-INT-007 | Platform notifications | Long-running report/action completion |
| AIA-INT-008 | Audit store | Operation traceability |

## 8. Permissions and security

| ID | Requirement |
|----|-------------|
| AIA-SEC-001 | Assistant never bypasses role, sharing, or field-level security. It can only do what the user can do in the UI. |
| AIA-SEC-002 | Prompt injection from record fields or emails must not escalate privileges or exfiltrate other records. |
| AIA-SEC-003 | PII sent to ChatGPT-mini is minimized (ids + needed fields); vendor DPA and region options documented. |
| AIA-SEC-004 | Users cannot ask the assistant to reveal another user’s data, secrets, API keys, or other tenants. |
| AIA-SEC-005 | Mass email, delete, and metadata deploy from chat require extra confirmation and dedicated permissions. |
| AIA-SEC-006 | Conversation content follows org retention and eDiscovery export rules. |
| AIA-SEC-007 | Sandbox assistant cannot mutate production. |
| AIA-SEC-008 | Model responses that include record data must match authorized query results, not hallucinated CRM facts for operational decisions. When unsure, assistant searches first. |

## 9. Non-functional requirements

| ID | Requirement |
|----|-------------|
| AIA-NFR-001 | First streamed token P95 < 2s for help questions (excluding cold start). |
| AIA-NFR-002 | Simple operation preview (single-record create/update) P95 < 3s after user submit. |
| AIA-NFR-003 | Custom report run in chat follows DAR-NFR-002; chat shows progress if async. |
| AIA-NFR-004 | Chat shell open P95 < 300ms (cached thread list). |
| AIA-NFR-005 | Tool execution is idempotent where possible (client-generated operation id). |
| AIA-NFR-006 | Assistant remains usable if one module API is down (degrade that tool, keep others). |

## 10. Dependencies

| Module | Why |
|--------|-----|
| All CRM modules | Operations, search, and help targets |
| Dashboards and Reports | Custom report engine, charts, export, share, save |
| Customer Communication | Email/SMS/call from chat; consent |
| Leads / Accounts / Contacts / Opportunities | Core CRUD and conversion |
| Quotes, Orders, and Contracts | Quote and commercial actions |
| Documents | Find/attach/share |
| Platform | Identity, FLS, language, notifications, sandbox |
| Workflows | Validation errors, approvals |
| Sales Performance | Goals/forecast questions and reports |
| Team Collaboration | Tags, mentions — not human private chat |
| Marketplace | Help on install; optional assistant extensions |
| US Insurance Agency and Remote Sales | LOB/household/renewal prompts; remote producer workspace |
| Sales Performance | Leaderboard rank questions; campaign ROI |

## 11. Suggested delivery phases

| Phase | Deliver |
|-------|---------|
| **MVP (P0)** | Central chat shell, ChatGPT-mini help + single-record operations (create/update/search) with preview/confirm, conversational custom reports (save + open in DAR), audit, org kill switch |
| **v1 (P1)** | Suggested prompts, trusted quick-actions, email/SMS send from chat, dashboard pin from chat, usage dashboard, role allow-lists |
| **Later (P2)** | Multi-step agents with user-approved plans, marketplace assistant skills, voice input |

## 12. Traceability

| Capability | Requirement IDs |
|------------|-----------------|
| Central chat for all business operations | AIA-FR-001, AIA-FR-004 |
| ChatGPT-mini overall-system assistant | AIA-FR-002, AIA-FR-003 |
| Custom reports from required details | AIA-FR-005 |
| Context, history, prompts | AIA-FR-006, AIA-FR-007 |
| Governance, audit, security | AIA-FR-008, AIA-FR-009 |
