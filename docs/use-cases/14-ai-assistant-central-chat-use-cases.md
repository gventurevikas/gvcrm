# AI Assistant and Central Chat — Use Cases

**Document ID:** GVCRM-UC-AIA  
**Requirements:** `docs/requirements/14-ai-assistant-and-central-chat.md`

---

## AIA-UC-001 — Open central chat from any screen

| Field | Value |
|-------|-------|
| **Requirement** | AIA-FR-001 |
| **Priority** | P0 |
| **Primary actor** | A-PROD / any user |

### Main flow
1. User clicks Assistant in chrome (global) or record-aware panel.
2. Chat shell opens; context chips show current record when on detail page.
3. First token streams within NFR (&lt;2s path).

---

## AIA-UC-002 — Use ChatGPT-mini as the system assistant

| Field | Value |
|-------|-------|
| **Requirement** | AIA-FR-002 |
| **Priority** | P0 |
| **Integrations** | AIA-INT-001 |

### Main flow
1. User converses in natural language.
2. Single assistant understands all entitled modules.
3. Responses grounded in authorized tools/docs — not free invention of CRM facts (AIA-SEC-008).

---

## AIA-UC-003 — Get cross-module help and next-best actions

| Field | Value |
|-------|-------|
| **Requirement** | AIA-FR-003 |
| **Priority** | P0 |
| **Primary actor** | New user / A-PROD |

### Main flow
1. User asks “How do I convert a Meta lead?” or “What should I do next on this renewal?”
2. Assistant explains steps with deep links into the correct screens.
3. Suggests next-best action based on record context and permissions.

---

## AIA-UC-004 — Execute business operations from chat

| Field | Value |
|-------|-------|
| **Requirement** | AIA-FR-004 |
| **Priority** | P0 |
| **Security** | AIA-SEC-001, AIA-SEC-002, AIA-SEC-005 |

### Main flow
1. User requests an action (create lead, update deal, log call, draft email, open case, schedule…).
2. Assistant shows **preview** of the mutation.
3. User **explicitly confirms**.
4. Tool runs **as the signed-in user**; success/failure returned.
5. Risky actions (send email, mass update, delete) require extra confirm + permissions.

### Exceptions
- **E1 Missing permission:** Refused; no privilege escalation.
- **E2 Prompt injection in email body:** Ignored for tool policy; cannot exfiltrate secrets (AIA-SEC-002/004).

---

## AIA-UC-005 — Build custom reports conversationally

| Field | Value |
|-------|-------|
| **Requirement** | AIA-FR-005 |
| **Priority** | P0 |
| **Depends on** | DAR-UC-015 |

### Main flow
1. User asks for a report (e.g. “Premium bound by producer this month, bar chart”).
2. Assistant collects missing required details (object, metrics, filters, range, grouping, chart).
3. Previews spec; user confirms.
4. DAR engine runs/saves under user security; `report_runs` source=`assistant`.
5. User opens/shares report in DAR UI.

---

## AIA-UC-006 — Manage conversation history and context

| Field | Value |
|-------|-------|
| **Requirement** | AIA-FR-006 |
| **Priority** | P0 |
| **Security** | AIA-SEC-006 |

### Main flow
1. User resumes prior thread; context chips persist.
2. Renames, searches, deletes threads per retention policy.
3. eDiscovery/admin access follows org policy.

---

## AIA-UC-007 — Use suggested prompts and onboarding chips

| Field | Value |
|-------|-------|
| **Requirement** | AIA-FR-007 |
| **Priority** | P1 |

### Main flow
1. New session shows role- and record-based starter prompts.
2. User taps chip (e.g. “Show my new Meta leads”, “Where am I on this week’s board?”).
3. Flow continues into help or tools.

---

## AIA-UC-008 — Administer assistant governance

| Field | Value |
|-------|-------|
| **Requirement** | AIA-FR-008 |
| **Priority** | P0 |
| **Primary actor** | A-ADM |
| **Security** | AIA-SEC-003, AIA-SEC-007 |

### Main flow
1. Admin enables/disables assistant per org; scopes allow-listed operations.
2. Configures model/retention/region (DPA documented).
3. Ensures sandbox assistant cannot mutate production.
4. Activates **kill switch** during incident.

---

## AIA-UC-009 — Audit and explain assistant changes

| Field | Value |
|-------|-------|
| **Requirement** | AIA-FR-009 |
| **Priority** | P0 |
| **Primary actors** | A-PROD (“what did you change?”), A-ADM (audit) |

### Main flow
1. After writes, user asks what changed; assistant summarizes tool calls.
2. Admin opens assistant audit: actor, tool, record ids, before/after, timestamp.
3. PII sent to model minimized and logged at metadata level where required.

---

## Traceability matrix

| UC | FR | Priority |
|----|-----|----------|
| AIA-UC-001…009 | AIA-FR-001…009 | as above |
