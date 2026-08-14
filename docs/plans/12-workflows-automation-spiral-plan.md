# Workflows & Process Automation (WPA) — Spiral Plan

**Document ID:** GVCRM-PLAN-WPA  
**Requirement:** `docs/requirements/12-workflows-and-process-automation.md`  
**Database:** `docs/database/13-wpa-workflows.md` (`gvcrm_wpa`)  
**Program wave:** S3  
**Packages:** `@gvcrm/mod-automation`, `gvcrm-wpa-api`

---

## 1. Purpose

Automate CRM processes: visual sales process editor, workflow rules (immediate + time-based), validation rules, approval chains, templates, and governance (limits, kill switch, impact analysis).

---

## 2. Priority slices

| Priority | Capabilities |
|----------|--------------|
| **P0** | Sales process editor, workflow rules, validation, approvals |
| **P1** | Predefined templates, automation governance |
| **P2** | Advanced impact simulation UX |

---

## 3. Spiral cycles

| Cycle | Focus |
|-------|-------|
| **WPA-S1** | Validation rules engine (UI/API/bulk) |
| **WPA-S2** | Workflow rules immediate actions |
| **WPA-S3** | Time-based durable queue |
| **WPA-S4** | Approval processes (discount, contract, document, T&E) |
| **WPA-S5** | Visual sales process editor aligned to ODM pipelines |
| **WPA-S6** | Templates + governance/kill switch (P1) |

---

## 4. Cycle WPA-S1 — Validation

### Objectives
- Multi-criteria validation on create/update
- Same rules on API and bulk; rare bypass audited

### Risks
| Risk | Mitigation |
|------|------------|
| Rules only on UI | Shared server evaluator |

### Evaluation
- [ ] Invalid stage change blocked on API and UI

---

## 5. Cycle WPA-S2 — Immediate workflows

### Objectives
- Trigger on field/stage; actions: update, notify, create task, webhook
- Idempotent action execution

### Evaluation
- [ ] Stage entry creates task once under retry

---

## 6. Cycle WPA-S3 — Time-based

### Objectives
- Durable delayed jobs; wake worker; timezone aware

### Risks
| Risk | Mitigation |
|------|------------|
| Lost jobs on crash | Durable store + lease |

### Evaluation
- [ ] Time-based email action fires after delay; survives restart

---

## 7. Cycle WPA-S4 — Approvals

### Objectives
- Multi-step approval chains; QOC discount integration
- Approve/reject with comments; lock record fields while pending

### Evaluation
- [ ] Over-threshold discount cannot save without approval

---

## 8. Cycle WPA-S5 — Sales process editor

### Objectives
- Drag-drop stages, entry/exit actions; publish to ODM pipeline

### Evaluation
- [ ] Published process matches Kanban stages

---

## 9. Cycle WPA-S6 — Governance

### Objectives
- Templates library; org automation limits; kill switch; impact analysis

### Evaluation
- [ ] Kill switch stops new workflow executions within SLA

---

## 10. Cross-cutting SDLC checklist

| Stage | WPA activity |
|-------|--------------|
| Requirements | WPA-FR P0 set |
| Design | Rule DSL; job lease protocol |
| Build | Engine + designer UI |
| Test | Exactly-once/idempotent suites |
| Deploy | Worker fleet |
| Ops | Automation log dashboards |

---

## 11. Dependencies

| Needs | Provides |
|-------|----------|
| ODM/LED/QOC/DOC/CCM Facades; PLT notifications | Guard rails for commercial + process quality |

---

## 12. Exit criteria (module MVP)

Validation + immediate/time-based workflows + approvals + sales process editor; actions idempotent; kill switch available.
