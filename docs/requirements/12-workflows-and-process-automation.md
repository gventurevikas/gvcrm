# Workflows and Process Automation

**Document ID:** GVCRM-REQ-WPA  
**Version:** 1.0  
**Status:** Draft for implementation  
**Module:** Workflows and Process Automation  
**This document is independent.** Related modules are listed only as dependencies.

---

## 1. Purpose

Automate **how work moves** through GVCRM: visual sales processes, workflow rules, validation, approval chains, and predefined templates — so teams follow consistent processes without manual policing.

## 2. Scope

**In scope**

- Approval rules (discounts, T&E, contracts, documents, etc.)
- Predefined workflow templates (instant or scheduled sales actions)
- Visual drag-and-drop sales process editor
- Validation rules with multi-criteria checks and error messages
- Custom workflow rules that run without user interaction when conditions are met

**Out of scope**

- Opportunity journey designer details — Opportunities module (may invoke this engine)
- Custom app packaging — Platform / Marketplace
- Report scheduling — Dashboards (not a sales workflow)

## 3. Users

| Persona | Typical actions |
|---------|-----------------|
| Sales ops / revops | Design processes, workflows, validations, approvals |
| Sales representative | Submit approvals, see validation errors, benefit from automation |
| Approver (manager, finance, legal) | Approve/reject requests |
| Admin | Templates, deployment from sandbox |
| Auditor | Approval and automation history |

## 4. Business objectives

- Enforce data quality at entry time
- Standardize sales stages and required actions
- Route business requests (discount, contract, document) to the right approvers
- Reduce repetitive follow-ups via unattended automation

---

## 5. Functional requirements

### 5.1 Sales process editor

**Source capability:** Sales Process Editor  
**Priority:** P0  
**ID:** WPA-FR-001

The solution shall provide a visual drag-and-drop editor to design multiple sales processes, set sequence, edit stages and properties, and specify conditions and actions to be met.

**User story**  
As sales ops, I want to design the New Business process visually: stages in order, entry conditions, and actions that fire on stage entry.

**Detailed requirements**

1. Canvas editor: multiple named sales processes; drag to reorder stages; edit stage properties (name, probability hint, forecast category, required fields, exit criteria).
2. Conditions: who can enter a stage, when a record qualifies, record types/pipelines mapping.
3. Actions on stage enter/exit: create task, send email, assign, notify, invoke workflow, request approval.
4. Publish / draft / version history; assign process to pipeline or record type.
5. Test mode with a sample record.
6. Works with Opportunities primarily; reusable pattern for Leads and custom modules (P1).

**Acceptance criteria**

- Publishing a process with 6 stages updates the pipeline stage order used in Kanban.
- Required-field property blocks stage change until fields are filled.
- Action “create task on enter Proposal” creates the task when a deal enters that stage.
- Draft edits do not affect production until publish.

---

### 5.2 Workflow rules

**Source capability:** Workflow Rules  
**Priority:** P0  
**ID:** WPA-FR-002

The solution shall allow custom workflows that automate processes requiring no user interaction, triggering actions when predefined conditions are met.

**User story**  
As sales ops, I want: if lead score ≥ 80 and country = US, assign to Enterprise Queue and send the owner an email — with no one clicking a button.

**Detailed requirements**

1. Workflow definition: object, trigger (created, updated, created-or-updated, scheduled/time-based, event), entry conditions (AND/OR, formulas).
2. Immediate actions and time-based actions (e.g. 3 days after no activity).
3. Actions: update fields, assign owner/queue, send email/SMS, create task/record, notify, add tag, call webhook, enroll in journey, submit for approval.
4. Evaluation order / exclusive vs additive flags to prevent conflicting rules.
5. Recursion guards (max depth, “run once per record” option).
6. Activate/deactivate; debug log per record.
7. Deploy via sandbox configuration deployment.

**Acceptance criteria**

- A matching create event runs immediate actions without a UI session.
- Time-based action fires after the delay (±1 minute) if conditions still hold (or per “don’t recheck” setting).
- Deactivated rule does not fire.
- Debug log shows why a record did or did not match.

---

### 5.3 Predefined workflow templates

**Source capability:** Predefined Workflow Templates  
**Priority:** P1  
**ID:** WPA-FR-003

The solution shall provide templates to set common sales actions instantly or schedule them at a later date.

**User story**  
As an admin standing up a new org, I want to install “New lead welcome + owner task in 1 day” instead of building it from scratch.

**Detailed requirements**

1. Catalog of predefined templates: new lead assignment + welcome email, deal stage follow-ups, quote expiration reminder, case SLA nudge, contract renewal reminder, etc.
2. Template parameters: which email template, delay, owner queue, conditions.
3. Apply instantly (activate now) or schedule activation date.
4. Templates can be cloned and customized after apply.
5. Marketplace apps may contribute additional templates (see MKT).

**Acceptance criteria**

- Applying a template creates an active or scheduled workflow with documented actions.
- Scheduling activation for Monday 09:00 starts the rule then, not before.
- Cloning allows editing without changing the original catalog template.

---

### 5.4 Validation rules

**Source capability:** Validation Rules  
**Priority:** P0  
**ID:** WPA-FR-004

The solution shall set validation rules with condition checks across multiple criteria to prevent inaccurate data from entering the CRM, including an error message when the user inputs an invalid value.

**User story**  
As sales ops, I want to block Closed-Won without amount > 0 and primary contact populated, with a clear error.

**Detailed requirements**

1. Validation rule: object, formula/criteria across multiple fields and related records, active flag, error message, error location (top or field).
2. Runs on UI save, bulk edit, import, and API (unless a bypass permission is explicitly granted and audited).
3. Multiple rules per object; all applicable errors can surface together.
4. Optional filter: only certain record types/profiles.
5. Sandbox test + deploy to production.

**Acceptance criteria**

- Saving a record that fails criteria shows the configured error message and does not persist.
- API insert of invalid data returns 4xx with the same logical message.
- Bulk view highlights failing rows.
- Inactive rule does not block saves.

---

### 5.5 Approval rules

**Source capability:** Approval Rules  
**Priority:** P0  
**ID:** WPA-FR-005

The solution shall set up and automate approval processes for business requests, including deal discount approvals, travel and expense reports, contract review, document approvals, etc.

**User story**  
As deal desk, I want discounts > 20% to require manager then finance approval before the quote can be sent.

**Detailed requirements**

1. Approval process per object/request type: entry criteria, steps (serial and/or parallel), approver determination (manager hierarchy, user, role, group, named approver field).
2. Built-in request types / examples: deal discount, T&E, contract review, document approval; extensible to custom modules.
3. Submit / recall / approve / reject / reassign; comments required on reject (configurable).
4. Record lock or field lock while pending (configurable).
5. Notifications at each step; escalation if SLA breached.
6. After-final actions: update fields, send email, unlock, create audit, continue workflow.
7. Approval history related list forever (immutable).
8. Delegate approver / out-of-office routing.

**Acceptance criteria**

- A quote with discount > threshold cannot be marked Sent until approval is Approved.
- Two-step serial approval requires step 1 before step 2.
- Parallel step completes when all (or first, if configured) approvers respond.
- Reject unlocks or keeps lock per config and notifies submitter with comments.
- T&E, contract, and document objects can each have their own process.

---

### 5.6 Automation governance (implied platform need)

**Priority:** P1  
**ID:** WPA-FR-006

To operate safely, the solution shall provide monitoring and limits for automation.

**Detailed requirements**

1. Per-org daily limits for workflow executions, emails sent by automation, approval submits.
2. Failure alerts to admin when actions error (e.g. email provider down).
3. “Automation paused” kill switch.
4. Impact analysis: which rules touch object X / field Y.

**Acceptance criteria**

- Approaching limit warns admins.
- Kill switch stops new workflow and time-based executions immediately.
- Impact analysis lists active rules referencing a field before it is deleted.

---

## 6. Data entities

| Entity | Purpose |
|--------|---------|
| SalesProcess / ProcessStage | Visual process definition |
| WorkflowRule / WorkflowAction / TimeBasedJob | Unattended automation |
| WorkflowTemplate | Catalog starter |
| ValidationRule | Data quality gate |
| ApprovalProcess / ApprovalStep / ApprovalRequest | Human-in-the-loop |
| AutomationLog | Debug and audit |
| AutomationLimitSnapshot | Usage vs caps |

## 7. Integrations

| ID | Integration | Purpose |
|----|-------------|---------|
| WPA-INT-001 | All CRM objects | Triggers and updates |
| WPA-INT-002 | Communication | Automated email/SMS |
| WPA-INT-003 | Platform notifications | Approvals and failures |
| WPA-INT-004 | Documents | Document approval |
| WPA-INT-005 | Quotes/Deals | Discount approval |
| WPA-INT-006 | Webhooks / Marketplace apps | External actions |
| WPA-INT-007 | Sandbox deploy | Promote automation metadata |

## 8. Permissions and security

| ID | Requirement |
|----|-------------|
| WPA-SEC-001 | Designing/activating automation is admin/ops permission. |
| WPA-SEC-002 | Approval actions are only available to designated approvers (or delegates). |
| WPA-SEC-003 | Workflows cannot grant record access beyond the running user’s or a documented “automation user” with audited elevated rights. |
| WPA-SEC-004 | Validation bypass permission is rare and fully audited. |
| WPA-SEC-005 | Webhook secrets for workflow callouts are encrypted. |

## 9. Non-functional requirements

| ID | Requirement |
|----|-------------|
| WPA-NFR-001 | Immediate workflow actions P95 < 2s added to user save path, or async within 5s if marked asynchronous. |
| WPA-NFR-002 | Time-based queue is durable across deploys; no lost jobs. |
| WPA-NFR-003 | Approval submit P95 < 1s to create request + notify. |
| WPA-NFR-004 | Exactly-once (or idempotent) action execution on retries. |
| WPA-NFR-005 | Editor canvas usable with 20+ stages without UI freeze. |

## 10. Dependencies

| Module | Why |
|--------|-----|
| Opportunities / Deals | Sales process, discount approval, rotting side effects |
| Leads | Assignment and nurture automation |
| Quotes, Orders, Contracts | Quote send gates, contract approval |
| Documents | Document approval, playbook publish |
| Customer Communication | Email/SMS actions |
| Platform | Custom objects/apps, sandbox deploy, notifications |
| Team Collaboration | Tags, @notify actions |
| Sales Performance | Campaign member status updates |
| Marketplace | Workflow templates and connector actions from apps |

## 11. Traceability

| Source capability | Requirement IDs |
|-------------------|-----------------|
| Approval Rules | WPA-FR-005 |
| Predefined Workflow Templates | WPA-FR-003 |
| Sales Process Editor | WPA-FR-001 |
| Validation Rules | WPA-FR-004 |
| Workflow Rules | WPA-FR-002 |
| (Governance needed to operate automation) | WPA-FR-006 |
