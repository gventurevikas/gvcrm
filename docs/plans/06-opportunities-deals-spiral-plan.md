# Opportunities / Deals (ODM) — Spiral Plan

**Document ID:** GVCRM-PLAN-ODM  
**Requirement:** `docs/requirements/06-opportunities-deals-management.md`  
**Database:** `docs/database/07-odm-opportunities.md` (`gvcrm_odm`)  
**Program wave:** S2  
**Packages:** `@gvcrm/mod-opportunities`, `gvcrm-odm-api`

---

## 1. Purpose

Multi-pipeline deal management with Kanban, win probability, **rotting alerts (P0/High)**, activity timeline, and journey automation.

---

## 2. Priority slices

| Priority | Capabilities |
|----------|--------------|
| **P0** | Opportunity CRUD, pipelines, Kanban, probability, rotting, activity timeline |
| **P1** | Journey designer |
| **P2** | Advanced journey analytics |

---

## 3. Spiral cycles

| Cycle | Focus |
|-------|-------|
| **ODM-S1** | Pipelines, stages, opportunity CRUD, history |
| **ODM-S2** | Kanban UI + totals/swimlanes (&lt;2s @200 cards) |
| **ODM-S3** | Probability + rotting job (incremental) |
| **ODM-S4** | Activity timeline + followers |
| **ODM-S5** | Line items (PRD snapshots) + INS pipeline codes |
| **ODM-S6** | Journey designer (P1) |

---

## 4. Cycle ODM-S1 — Core deal

### Objectives
- Pipelines/stages seed (incl. insurance codes when INS entitled)
- Opportunity CRUD; stage changes &lt;500ms; stage history
- Link account/contact/lead ULIDs

### Risks
| Risk | Mitigation |
|------|------------|
| Invalid stage jumps | WPA validation integration when ready |

### Evaluation
- [ ] Create/move opportunity; history recorded

---

## 5. Cycle ODM-S2 — Kanban

### Objectives
- Board by pipeline; drag-drop; column totals; swimlanes
- Performance NFR

### Evaluation
- [ ] 200-card board &lt;2s in staging

---

## 6. Cycle ODM-S3 — Probability & rotting

### Objectives
- Stage default probability; override with FLS
- Rotting rules + alerts (High → treat as P0)
- Incremental evaluation job

### Risks
| Risk | Mitigation |
|------|------------|
| Full-table rotting scans | Incremental watermark / indexed last_activity |

### Evaluation
- [ ] Stale deal flags and notifies owner

---

## 7. Cycle ODM-S4 — Timeline

### Objectives
- Real-time-ish activity timeline from CCM/TCL/DOC Facades
- Followers

### Evaluation
- [ ] Logged call appears on timeline without page refresh (poll/WS)

---

## 8. Cycle ODM-S5 — Commerce & INS hooks

### Objectives
- Line items with product price snapshots
- Pipelines: new_business / cross_sell / renewal

### Evaluation
- [ ] Renewal opp links INS policy id

---

## 9. Cycle ODM-S6 — Journeys

### Objectives
- Drag-drop journey designer; enrollments; idempotent actions

### Evaluation
- [ ] Journey action fires once on stage entry

---

## 10. Cross-cutting SDLC checklist

| Stage | ODM activity |
|-------|--------------|
| Requirements | ODM-FR including rotting High |
| Design | Pipeline model; rotting algorithm |
| Build | API + Kanban module |
| Test | Perf, race on stage update, FLS on amount |
| Deploy | Entitle `odm` |
| Ops | Rotting job metrics |

---

## 11. Dependencies

| Needs | Provides |
|-------|----------|
| ACM, LED convert, PRD (line items), WPA optional | QOC quotes, SPM forecast, DAR deal reports, INS renewals |

---

## 12. Exit criteria (module MVP)

Multi-pipeline Kanban + probability + rotting + timeline + convert-from-lead path complete.
