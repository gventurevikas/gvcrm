# Customer Communication — Use Cases

**Document ID:** GVCRM-UC-CCM  
**Requirements:** `docs/requirements/02-customer-communication-management.md`

---

## CCM-UC-001 — Set and receive call reminders

| Field | Value |
|-------|-------|
| **Requirement** | CCM-FR-001 |
| **Priority** | P0 |
| **Primary actor** | A-AE / A-PROD |

### Main flow
1. User schedules or logs a call with reminder time.
2. At due time, system sends in-app / push / email reminder (PLT notifications).
3. If call marked missed, user receives missed-call alert.
4. User completes or snoozes reminder.

### Business rules
- Reminder only if user can read the related record (CCM-SEC-001).

---

## CCM-UC-002 — Schedule calls on personal and team calendars

| Field | Value |
|-------|-------|
| **Requirement** | CCM-FR-002 |
| **Priority** | P0 |
| **Primary actor** | A-AE, A-MGR |

### Main flow
1. User creates call appointment with contact/lead.
2. System checks conflicts with CRM + calendar (CCM-INT-005 / ACM).
3. Call appears on personal calendar; manager views team call calendar.
4. User completes call; disposition logged.

---

## CCM-UC-003 — Tag calls for reporting

| Field | Value |
|-------|-------|
| **Requirement** | CCM-FR-003 |
| **Priority** | P1 |
| **Primary actor** | A-AE, A-OPS |

### Main flow
1. After/during call log, user selects tags (demo, discovery, renewal, etc.).
2. Tags available for DAR call analytics filters.

---

## CCM-UC-004 — Insert canned responses

| Field | Value |
|-------|-------|
| **Requirement** | CCM-FR-004 |
| **Priority** | P0 |
| **Primary actor** | A-SUP / A-AE |

### Main flow
1. In email composer, user opens canned responses.
2. Selects snippet; merge fields resolve from record.
3. User edits and sends.

---

## CCM-UC-005 — Send and receive email inside CRM

| Field | Value |
|-------|-------|
| **Requirement** | CCM-FR-005 |
| **Priority** | P0 |
| **Primary actor** | A-AE |

### Preconditions
- Mailbox connected (OAuth/SMTP); secrets encrypted (CCM-SEC-002).

### Main flow
1. User composes email from record or inbox.
2. System checks consent/unsubscribe (CCM-SEC-005).
3. Sends; stores message/thread; handles bounces.
4. Inbound mail arrives in CRM inbox.

### Exceptions
- **E1 No consent / DNC:** Send blocked with reason.
- **E2 Bounce:** Status updated; optional task created.

---

## CCM-UC-006 — Auto-associate email with CRM records

| Field | Value |
|-------|-------|
| **Requirement** | CCM-FR-006 |
| **Priority** | P0 |
| **Primary actor** | A-AE |

### Main flow
1. Email sent/received matching contact/lead email.
2. Within association SLA (&lt;30s), thread linked to record(s).
3. User replies, attaches quote PDF, or adds note from thread UI.

### Alternate
- **A1 Ambiguous match:** User picks correct record.

---

## CCM-UC-007 — Work from Gmail or Outlook with CRM context

| Field | Value |
|-------|-------|
| **Requirement** | CCM-FR-007 |
| **Priority** | P0 |
| **Integrations** | CCM-INT-001, CCM-INT-002 |

### Main flow
1. User installs add-in; authenticates to GVCRM.
2. Opens email in Gmail/Outlook; sidebar shows matching CRM records.
3. User logs email to CRM / creates lead / opens deal without leaving client.

---

## CCM-UC-008 — Schedule email for later send

| Field | Value |
|-------|-------|
| **Requirement** | CCM-FR-008 |
| **Priority** | P1 |

### Main flow
1. User writes email; chooses **Send later** in contact timezone.
2. Before send time, user edits or cancels.
3. Worker sends at scheduled time; association proceeds as CCM-UC-006.

---

## CCM-UC-009 — Track email open and click status

| Field | Value |
|-------|-------|
| **Requirement** | CCM-FR-009 |
| **Priority** | P1 |

### Main flow
1. User sends tracked email (disclosure per CCM-SEC-003).
2. Open/click events arrive (&lt;10s target).
3. User notified; may set follow-up reminder.

---

## CCM-UC-010 — Manage and use email templates

| Field | Value |
|-------|-------|
| **Requirement** | CCM-FR-010 |
| **Priority** | P0 |
| **Primary actor** | A-MKT / A-AE |

### Main flow
1. Marketing creates branded template with merge fields.
2. Rep selects template in composer, mass send, campaign, or workflow.
3. Preview shows merged content; send proceeds with consent checks.

---

## CCM-UC-011 — Send mass email to a list

| Field | Value |
|-------|-------|
| **Requirement** | CCM-FR-011 |
| **Priority** | P1 |
| **Primary actor** | A-MKT |
| **Security** | CCM-SEC-004 |

### Main flow
1. User with mass-email permission selects list/campaign members.
2. System skips unsubscribed/DNC/invalid; throttles send.
3. Each recipient gets individual personalized message.
4. Results report: sent, skipped, bounced.

---

## CCM-UC-012 — SMS conversation on a record

| Field | Value |
|-------|-------|
| **Requirement** | CCM-FR-012 |
| **Priority** | P1 |
| **Integrations** | CCM-INT-004 |

### Main flow
1. User opens SMS on contact/lead with SMS opt-in.
2. Sends message; inbound replies thread on record.
3. Without opt-in, send blocked.

---

## CCM-UC-013 — Schedule SMS with quiet hours

| Field | Value |
|-------|-------|
| **Requirement** | CCM-FR-013 |
| **Priority** | P1 |

### Main flow
1. User schedules SMS in contact timezone.
2. If quiet hours, system defers to next allowed window.
3. Message sends; thread updated.

---

## CCM-UC-014 — Use SMS templates

| Field | Value |
|-------|-------|
| **Requirement** | CCM-FR-014 |
| **Priority** | P1 |

### Main flow
1. User creates/selects SMS template with merge fields.
2. Inserts into composer; sends or schedules.

---

## CCM-UC-015 — Review SMS analytics

| Field | Value |
|-------|-------|
| **Requirement** | CCM-FR-015 |
| **Priority** | P2 |
| **Primary actor** | A-MKT / A-MGR |

### Main flow
1. User opens SMS analytics.
2. Views sent, replies, reply rate by template/user/period.
3. Optionally exports or pins to dashboard via DAR.

---

## Traceability matrix

| UC | FR | Priority |
|----|-----|----------|
| CCM-UC-001…015 | CCM-FR-001…015 | P0–P2 as above |
