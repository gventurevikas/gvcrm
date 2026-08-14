# Opportunities / Deals — Use Cases

**Document ID:** GVCRM-UC-ODM  
**Requirements:** `docs/requirements/06-opportunities-deals-management.md`

---

## ODM-UC-001 — Manage opportunities

| Field | Value |
|-------|-------|
| **Requirement** | ODM-FR-001 |
| **Priority** | P0 |
| **Primary actor** | A-AE / A-PROD |

### Main flow
1. User creates opportunity (or from lead convert) with account, amount, close date, pipeline/stage.
2. Filters/lists deals by owner, stage, LOB.
3. Updates stage; history recorded; optional WPA validation.
4. Closes won/lost with reason when required.

### Business rules
- Access via owner, roles, teams, sharing (ODM-SEC-001).
- Amount/probability may be FLS-restricted (ODM-SEC-003).

---

## ODM-UC-002 — Configure multiple sales pipelines

| Field | Value |
|-------|-------|
| **Requirement** | ODM-FR-002 |
| **Priority** | P0 |
| **Primary actor** | A-OPS |
| **Security** | ODM-SEC-002 |

### Main flow
1. Ops creates pipelines (e.g. new business, cross-sell, renewal).
2. Defines stages, order, defaults.
3. Optionally imports pipeline definition (no external credentials — ODM-SEC-005).
4. Assigns which users/teams use which pipeline.

---

## ODM-UC-003 — Work deals on Kanban board

| Field | Value |
|-------|-------|
| **Requirement** | ODM-FR-003 |
| **Priority** | P0 |

### Main flow
1. User opens pipeline Kanban; columns = stages; sees totals/swimlanes.
2. Drag-drops card to new stage (&lt;500ms update target).
3. Board loads &lt;2s with ~200 cards.

### Exceptions
- **E1 Validation blocks stage:** Card snaps back; error shown.

---

## ODM-UC-004 — Apply opportunity win probability

| Field | Value |
|-------|-------|
| **Requirement** | ODM-FR-004 |
| **Priority** | P0 |

### Main flow
1. Stage default probability applied on stage change.
2. Rep overrides probability if permitted.
3. Weighted pipeline feeds SPM forecast / DAR reports.

---

## ODM-UC-005 — Detect and act on rotting opportunities

| Field | Value |
|-------|-------|
| **Requirement** | ODM-FR-005 |
| **Priority** | P0 (High) |
| **Primary actors** | A-SYS, A-AE, A-MGR |

### Main flow
1. Ops configures rotting criteria (days in stage, no activity).
2. Incremental job flags stuck deals.
3. Kanban highlights rotting cards; managers get lists/alerts.
4. Owner takes action (activity, stage move, or close).

### Business rules
- Rotting evaluation must be incremental (NFR), not full-table thrash.

---

## ODM-UC-006 — Manage deal activity timeline

| Field | Value |
|-------|-------|
| **Requirement** | ODM-FR-006 |
| **Priority** | P0 |
| **Integrations** | ODM-INT-002, ODM-INT-007 |

### Main flow
1. User logs call/email/task/note on opportunity (or CCM auto-associates).
2. Timeline updates; followers receive real-time notifications.
3. Manager reviews activity health on deal.

---

## ODM-UC-007 — Design and run sales journeys

| Field | Value |
|-------|-------|
| **Requirement** | ODM-FR-007 |
| **Priority** | P1 |
| **Primary actor** | A-OPS |
| **Security** | ODM-SEC-004 (publish ≠ edit) |

### Main flow
1. Ops designs journey (wait, email, create task, field update) visually.
2. Publishes journey; enrolls opportunities by criteria.
3. Actions execute idempotently; enrollment history visible.

### Exceptions
- **E1 Action fails:** Retry/DLQ; ops alerted.

---

## Traceability matrix

| UC | FR | Priority |
|----|-----|----------|
| ODM-UC-001…007 | ODM-FR-001…007 | as above |
