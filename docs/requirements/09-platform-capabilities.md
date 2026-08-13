# Platform Capabilities

**Document ID:** GVCRM-REQ-PLT  
**Version:** 1.0  
**Status:** Draft for implementation  
**Module:** Platform Capabilities  
**This document is independent.** Related modules are listed only as dependencies.

---

## 1. Purpose

Provide the **extensible CRM platform** on which all modules run: custom data model, layouts, views, apps, bulk editing, cases, localization, money, notes, notifications, reminders, visual cues, sandbox, and promotion of configuration to production.

This is the foundation for **Marketplace publishing**: custom apps and modules created here can later be packaged and listed (see Marketplace and App Publishing).

## 2. Scope

**In scope**

- Bulk spreadsheet-style editing
- Case management
- Color-coded icons
- Sandbox environments and configuration deployment
- Custom apps, fields, layouts, modules, views/filters
- Follow-up reminders
- Multi-language and multiple currencies
- Notes (text and audio)
- Real-time notifications

**Out of scope**

- Workflow rule engine details — Workflows and Process Automation
- Marketplace listing UX — Marketplace module (this module supplies packagable metadata)
- Central ChatGPT-mini assistant UX — AI Assistant and Central Chat (this module supplies identity, FLS, language, notifications, sandbox)

## 3. Users

| Persona | Typical actions |
|---------|-----------------|
| End user | Bulk edit, notes, reminders, notifications, cases, custom views |
| Salesforce-style admin / CRM admin | Fields, layouts, modules, apps, languages, currencies |
| Developer / partner | Custom apps, sandbox, deploy to prod, package for marketplace |
| Support agent | Cases |
| Executive / IT | Sandbox governance, deployment approvals |

## 4. Business objectives

- Fit unique business processes without forking the product
- Safe change management (sandbox → production)
- Global sales (language + currency)
- High user productivity (bulk edit, reminders, notifications, visual cues)

---

## 5. Functional requirements

### 5.1 Bulk view

**Source capability:** Bulk View  
**Priority:** P0  
**ID:** PLT-FR-001

The solution shall convert CRM lists into a spreadsheet view for editing records in bulk.

**User story**  
As a sales ops user, I want to edit 50 lead statuses in a grid like Excel and save once.

**Detailed requirements**

1. From any major object list (Leads, Contacts, Accounts, Opportunities, etc. and custom modules), switch to Bulk / Spreadsheet view.
2. Inline edit permitted fields; copy/paste from Excel; fill-down.
3. Row selection + mass update for a single field.
4. Validation runs per cell; errors highlighted; partial save with error report.
5. Respect field-level security and validation rules.
6. Optional lock/checkout for large edits to reduce conflicts.

**Acceptance criteria**

- Editing 20 cells and saving updates exactly those records.
- A validation-rule failure blocks only invalid rows (or all, per setting) with messages.
- Fields the user cannot edit are read-only in the grid.
- Undo of unsaved grid changes is available before save.

---

### 5.2 Case management

**Source capability:** Case Management  
**Priority:** P0  
**ID:** PLT-FR-002

The solution shall enable creating cases, assigning users, and tracking requests, questions, issues, or feedback from customers, vendors, and partners.

**Detailed requirements**

1. Case object: subject, description, origin, type, priority, status, requester (contact/account), related product/order, owner, SLA dates.
2. Create from UI, email-to-case, portal, API.
3. Assignment: manual, round-robin, rules (similar pattern to lead assignment).
4. Comments, internal notes, attachments, status history.
5. Customers/vendors/partners as distinct requester types.
6. Link case to account/contact/opportunity/order.

**Acceptance criteria**

- Creating and assigning a case notifies the owner.
- Status changes are audited.
- Email-to-case (if enabled) creates/updates a case from inbound mail.
- Portal requester sees only their own cases.

---

### 5.3 Color-coded icons

**Source capability:** Color Coded Icons  
**Priority:** P1  
**ID:** PLT-FR-003

The solution shall allow setting color-coded icons to check scheduled and overdue tasks in the sales pipeline view or next follow-up activity for leads, contacts, and deals in the list view.

**Detailed requirements**

1. Configurable icon/color rules: e.g. green = future follow-up, amber = due today, red = overdue, grey = none.
2. Visible on: opportunity Kanban/pipeline, lead/contact/deal list views.
3. Based on next activity date (task/call/meeting) and/or explicit next follow-up field.
4. Tooltip shows activity type and due time.
5. Admin can customize colors for accessibility.

**Acceptance criteria**

- An overdue task on a deal shows the overdue icon on Kanban and list.
- Completing the task updates the icon to the next open activity or empty state.
- Color meaning is documented in a legend.

---

### 5.4 Sandbox environment

**Source capability:** Sandbox Environment  
**Priority:** P0  
**ID:** PLT-FR-004

The solution shall enable creating new sandbox environments, cloning existing sandboxes, and refreshing sandboxes to match production configurations.

**Detailed requirements**

1. Create sandbox from production: metadata-only or metadata + sample/masked data (tiers).
2. Clone an existing sandbox.
3. Refresh sandbox from production (destructive warning + backup option).
4. Sandboxes are isolated (auth, data, integrations disabled or stubbed by default).
5. Naming, expiry, and who can access each sandbox.
6. List of sandboxes with last refresh time.

**Acceptance criteria**

- New sandbox is reachable on a distinct URL/tenant and contains production metadata.
- Refresh overwrites sandbox metadata to match production after confirmation.
- Clone copies the source sandbox configuration.
- Production credentials/webhooks are not live in sandbox unless explicitly reconnected.

---

### 5.5 Configuration deployment

**Source capability:** Configuration Deployment  
**Priority:** P0  
**ID:** PLT-FR-005

The solution shall deploy customizations and configurations from a sandbox environment to a production environment.

**Detailed requirements**

1. Change sets / deployment packages: fields, layouts, modules, apps, validation rules, workflows, dashboards (selected), email templates, etc.
2. Dependency validation before deploy.
3. Deploy to production (and between sandboxes) with preview diff, backup, and rollback window.
4. Partial success handling; deploy history and who approved.
5. Optional approval gate (Workflows) before production deploy.

**Acceptance criteria**

- A custom field created in sandbox can be deployed to production and appear on the mapped layout.
- Missing dependency blocks deploy with a clear list.
- Failed deploy does not leave production in a silently broken half-state (transactional per component group or documented repair).
- Deploy history is auditable.

---

### 5.6 Custom fields

**Source capability:** Custom Fields  
**Priority:** P0  
**ID:** PLT-FR-006

The solution shall allow creating custom fields to collect specific information from entities such as leads, contacts, or opportunities (and other objects).

**Detailed requirements**

1. Field types: text, textarea, number, currency, percent, date, datetime, boolean, picklist, multi-select, lookup/relation, email, phone, URL, formula/calculated.
2. Required, unique, default, help text, validation at field level.
3. Add to any standard or custom module the admin is allowed to extend.
4. Field-level security per profile.
5. Limit per object documented; warn before hitting limit.

**Acceptance criteria**

- New picklist on Lead appears on selected layouts and in reports.
- Formula field recalculates on dependency change.
- Profile without FLS cannot see the field in UI or API.

---

### 5.7 Custom layouts

**Source capability:** Custom Layouts  
**Priority:** P0  
**ID:** PLT-FR-007

The solution shall allow customizing page layouts of CRM records such as leads, opportunities, accounts, contacts, products, etc.

**Detailed requirements**

1. Layout editor: sections, field order, related lists, buttons, highlights panel.
2. Assign layouts by profile, record type, or app.
3. Mobile layout can differ from desktop.
4. Requiredness can be layout-specific (in addition to field-level).

**Acceptance criteria**

- Two profiles can see different layouts for the same object.
- Removing a field from layout does not delete data.
- Related lists can be reordered and shown/hidden.

---

### 5.8 Custom modules

**Source capability:** Custom Modules  
**Priority:** P0  
**ID:** PLT-FR-008

The solution shall allow adding and exporting custom modules to collect custom data sets and organize subsets of information. Packages can be generated to accommodate multiple modules of different types.

**Detailed requirements**

1. Create custom module: name, icon, singular/plural labels, fields, relationships to standard objects.
2. CRUD UI, list views, reports, API automatically generated.
3. Export module metadata; generate a package containing multiple modules and related assets (fields, layouts, workflows).
4. Import package into another org/sandbox (and into Marketplace listing).
5. Sharing model configurable (private, public read, controlled by parent, etc.).

**Acceptance criteria**

- A custom module “Properties” can lookup Account and appear in navigation.
- Export package + import into a sandbox recreates the module.
- Reports can use the custom module as a primary object.
- Package includes multiple module types when selected.

---

### 5.9 Custom apps

**Source capability:** Custom Apps  
**Priority:** P0  
**ID:** PLT-FR-009

The solution shall allow creating multiple custom apps to store data by configuring validation rules, adding standard and custom objects, calculated fields, workflow automation, and dashboards and reports to address a unique business need.

**User story**  
As an admin, I want a “Partner Payouts” app that combines custom objects, validations, workflows, and a dashboard, separate from the core Sales app.

**Detailed requirements**

1. Custom app = navigation set + objects (standard/custom) + validations + calculated fields + workflows + dashboards/reports + optional UI theme.
2. Users are assigned apps; default landing page per app.
3. Apps can be packaged for deployment and for Marketplace publish.
4. Validation rules and workflows inside the app scope still use the global engines.
5. Multiple apps coexist in one org.

**Acceptance criteria**

- Switching apps changes navigation to that app’s objects and dashboards.
- App package includes selected objects, fields, validations, workflows, and dashboards.
- User without app assignment does not see it in the app launcher.
- Calculated fields and validation rules in the app behave on record save.

---

### 5.10 Custom views and filters

**Source capability:** Custom Views and Filters  
**Priority:** P0  
**ID:** PLT-FR-010

The solution shall allow building customized views and using advanced filter options to filter CRM records.

**Detailed requirements**

1. Custom list views: columns, sort, filters (AND/OR groups), sharing (private/role/org).
2. Advanced filters: relative dates, my team, empty/not empty, related object fields.
3. Pin default view per user per object.
4. Views usable as report sources and workflow entry criteria (where applicable).

**Acceptance criteria**

- Creating “My open enterprise deals closing this month” returns the correct set.
- Sharing a view with a role does not share underlying records the viewer cannot access.
- Advanced OR filters work as specified.

---

### 5.11 Follow-up reminders

**Source capability:** Follow-up Reminders  
**Priority:** P0  
**ID:** PLT-FR-011

The solution shall allow setting reminders to follow up with prospects or generating automated email messages to be sent at a scheduled time.

**Detailed requirements**

1. Reminder on any record (lead, contact, deal, case, etc.): time, channel (in-app/email/push), note.
2. Automated follow-up email at scheduled time (uses Communication templates + consent).
3. Snooze, complete, reassign.
4. Bulk set reminders from list view.

**Acceptance criteria**

- Reminder fires at the scheduled time.
- Automated email is not sent if DNC/unsubscribed.
- Completing a reminder logs activity on the record.

---

### 5.12 Multi-language

**Source capability:** Multi-Language  
**Priority:** P0  
**ID:** PLT-FR-012

The solution shall support multiple languages and provide language packs to change the language of the CRM user interface.

**Detailed requirements**

1. User-selectable UI language from installed language packs.
2. Org default language; user override.
3. Translateable: UI chrome, picklist labels, custom field labels, email templates (separate from UI pack).
4. Admin can install/export language packs; partners can include translations in Marketplace apps.
5. RTL support for applicable packs (P1).

**Acceptance criteria**

- Switching language pack changes UI labels without changing stored data values.
- Custom field labels can have translations.
- Missing translation falls back to org default, then English.

---

### 5.13 Multiple currencies

**Source capability:** Multiple Currencies  
**Priority:** P0  
**ID:** PLT-FR-013

The solution shall allow setting a default currency, defining exchange rates versus the default currency, and generating invoices for international clients in their preferred currencies.

**Detailed requirements**

1. Org corporate currency + active currencies.
2. Dated or static exchange rates (admin-managed; optional feed later).
3. Record currency on opportunities, quotes, orders, invoices.
4. Reports can convert to corporate currency using rate at close date or current rate (selectable).
5. Invoices issued in the client’s preferred currency (Quotes/Orders module consumes this).

**Acceptance criteria**

- Opportunity in EUR shows EUR amount and corporate-currency equivalent.
- Changing exchange rate does not silently rewrite issued invoices.
- Invoice can be generated in the account’s preferred currency.
- Inactive currency cannot be selected on new records.

---

### 5.14 Notes

**Source capability:** Notes  
**Priority:** P0  
**ID:** PLT-FR-014

The solution shall allow adding text or audio notes to records (leads, contacts, accounts, deals, etc.) to summarize observations on customer and prospect interactions.

**Detailed requirements**

1. Text notes (rich text) and audio notes (record in-app or upload) on major objects and custom modules.
2. Private vs shared notes.
3. Mentions (Team Collaboration) in text notes.
4. Transcription of audio optional (P2).
5. Notes appear on timelines.

**Acceptance criteria**

- Text note saves and shows on the record timeline.
- Audio note uploads and is playable by users with access.
- Private note is only visible to author (and admins if policy allows).

---

### 5.15 Real-time notifications

**Source capability:** Real-time Notifications  
**Priority:** P0  
**ID:** PLT-FR-015

The solution shall deliver and filter real-time notifications so users can track customer interactions and act immediately.

**Detailed requirements**

1. Channels: in-app bell, desktop/push, email digest optional.
2. Events: assignments, mentions, activity logged, rotting deals, email opens (if enabled), case updates, approvals, reminders.
3. User preferences: per event type on/off and channel.
4. Filters: unread, type, object, date; mark read/unread; bulk mark.
5. Deep link to the record/action.

**Acceptance criteria**

- Assignment creates a notification within a few seconds for an online user.
- User can disable email-open notifications without disabling assignments.
- Clicking notification opens the correct record.
- Offline users receive push/email per preferences.

---

## 6. Data entities

| Entity | Purpose |
|--------|---------|
| CustomField / Layout / RecordType | Metadata |
| CustomModule / CustomApp | Extensibility |
| MetadataPackage | Export/import/deploy unit |
| SandboxEnvironment | Isolated tenant copy |
| DeploymentJob | Sandbox → prod promotion |
| ListView / FilterDefinition | Saved views |
| Case | Support/feedback tracking |
| Note | Text/audio annotation |
| Reminder | Follow-up scheduling |
| Notification / NotificationPreference | Real-time alerts |
| LanguagePack / Translation | i18n |
| Currency / ExchangeRate | Multi-currency |

## 7. Integrations

| ID | Integration | Purpose |
|----|-------------|---------|
| PLT-INT-001 | Metadata deploy API | CI and Marketplace packaging |
| PLT-INT-002 | Push notification services | Mobile/desktop alerts |
| PLT-INT-003 | FX rate source (optional) | Exchange rates |
| PLT-INT-004 | Speech-to-text (optional) | Audio note transcription |
| PLT-INT-005 | Email-to-case | Case intake |

## 8. Permissions and security

| ID | Requirement |
|----|-------------|
| PLT-SEC-001 | Metadata changes (fields, apps, deploy) are admin/dev permissions. |
| PLT-SEC-002 | Sandboxes use masked PII options for non-prod data. |
| PLT-SEC-003 | Production deploy requires authentication + optional dual control. |
| PLT-SEC-004 | Custom module sharing defaults to private. |
| PLT-SEC-005 | Notification content must not leak records via email preview beyond user access. |

## 9. Non-functional requirements

| ID | Requirement |
|----|-------------|
| PLT-NFR-001 | Bulk save of 500 cell edits P95 < 10s. |
| PLT-NFR-002 | In-app notification P95 < 3s for online users. |
| PLT-NFR-003 | Sandbox create time depends on tier; progress UI required; metadata-only target < 30 min typical. |
| PLT-NFR-004 | Metadata package import is transactional per component type with detailed logs. |
| PLT-NFR-005 | Multi-language UI switch does not require re-login. |

## 10. Dependencies

| Module | Why |
|--------|-----|
| All feature modules | Consume fields, layouts, views, notifications, currency, language |
| Workflows | Validation rules, automation inside custom apps |
| Dashboards and Reports | App dashboards, custom module reports |
| Customer Communication | Reminder emails, email-to-case |
| Opportunities | Color icons on pipeline |
| Marketplace | Package custom apps/modules for publish and install |
| Team Collaboration | Mentions in notes |
| AI Assistant and Central Chat | Assistant runs as the user; language, notifications, sandbox isolation |

## 11. Traceability

| Source capability | Requirement IDs |
|-------------------|-----------------|
| Bulk View | PLT-FR-001 |
| Case Management | PLT-FR-002 |
| Color Coded Icons | PLT-FR-003 |
| Configuration Deployment | PLT-FR-005 |
| Custom Apps | PLT-FR-009 |
| Custom Fields | PLT-FR-006 |
| Custom Layouts | PLT-FR-007 |
| Custom Modules | PLT-FR-008 |
| Custom Views and Filters | PLT-FR-010 |
| Follow-up Reminders | PLT-FR-011 |
| Multi-Language | PLT-FR-012 |
| Multiple Currencies | PLT-FR-013 |
| Notes | PLT-FR-014 |
| Real-time Notifications | PLT-FR-015 |
| Sandbox Environment | PLT-FR-004 |
