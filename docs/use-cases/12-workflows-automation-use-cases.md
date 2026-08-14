# Workflows and Process Automation — Use Cases

**Document ID:** GVCRM-UC-WPA  
**Requirements:** `docs/requirements/12-workflows-and-process-automation.md`

---

## WPA-UC-001 — Design and publish a sales process

| Field | Value |
|-------|-------|
| **Requirement** | WPA-FR-001 |
| **Priority** | P0 |
| **Primary actor** | A-OPS |
| **Security** | WPA-SEC-001 |

### Main flow
1. Ops opens visual sales process editor.
2. Defines stages, required fields, entry/exit actions.
3. Publishes; ODM pipeline/Kanban aligns to process.
4. Reps experience required-field enforcement on stage moves.

---

## WPA-UC-002 — Configure workflow rules

| Field | Value |
|-------|-------|
| **Requirement** | WPA-FR-002 |
| **Priority** | P0 |
| **Primary actor** | A-OPS |
| **Security** | WPA-SEC-003, WPA-SEC-005 |

### Main flow
1. Ops creates rule on object (on create/update or time-based).
2. Sets criteria and actions (field update, assign, email/SMS via CCM, task, webhook).
3. Activates rule; executions are idempotent / exactly-once where specified.
4. Automation log shows history.

### Exceptions
- **E1 Action failure:** Retry; alert; do not silently skip compliance checks.

---

## WPA-UC-003 — Install predefined workflow templates

| Field | Value |
|-------|-------|
| **Requirement** | WPA-FR-003 |
| **Priority** | P1 |

### Main flow
1. Ops browses templates (welcome lead, quote expiry, renewals…).
2. Installs into org; customizes; activates.
3. Optionally packages via sandbox deploy / Marketplace.

---

## WPA-UC-004 — Enforce validation rules

| Field | Value |
|-------|-------|
| **Requirement** | WPA-FR-004 |
| **Priority** | P0 |
| **Security** | WPA-SEC-004 |

### Main flow
1. Ops defines multi-criteria validation (e.g. LOB required on INS opps).
2. User/API/bulk save evaluates same rules.
3. Invalid save blocked with clear errors.
4. Rare bypasses fully audited.

---

## WPA-UC-005 — Submit and process approvals

| Field | Value |
|-------|-------|
| **Requirement** | WPA-FR-005 |
| **Priority** | P0 |
| **Primary actors** | A-AE (submitter), A-MGR/A-FIN/A-LEG (approver) |
| **Security** | WPA-SEC-002 |

### Main flow
1. Trigger (discount, T&E, contract, document) creates approval request.
2. Approver notified; reviews; approves or rejects with comments.
3. Multi-step chain continues until final.
4. On approve, originating transaction proceeds; on reject, locked fields remain.

### Alternate
- **A1 Delegate approver** while primary OOO.

---

## WPA-UC-006 — Govern automation (limits, kill switch, impact)

| Field | Value |
|-------|-------|
| **Requirement** | WPA-FR-006 |
| **Priority** | P1 |
| **Primary actor** | A-ADM / A-OPS |

### Main flow
1. Admin monitors automation volume vs org limits.
2. Runs impact analysis before changing a busy rule.
3. Activates **kill switch** to stop new executions in incident.
4. Reviews automation logs for audit.

---

## Traceability matrix

| UC | FR | Priority |
|----|-----|----------|
| WPA-UC-001…006 | WPA-FR-001…006 | as above |
