# Dashboards & Reports (DAR) — Spiral Plan

**Document ID:** GVCRM-PLAN-DAR  
**Requirement:** `docs/requirements/03-dashboards-and-reports.md`  
**Database:** `docs/database/04-dar-dashboards-reports.md` + `17-clickhouse-analytics.md`  
**Program wave:** S5 (definitions can start earlier with LED/ODM data)  
**Packages:** `@gvcrm/mod-reporting`, `gvcrm-dar-api`

---

## 1. Purpose

Homepage and analytics workspace: dashboards, report builder, sharing/scheduling, and the **report engine** used by AIA conversational reports. Every run writes ClickHouse **`report_runs`**.

---

## 2. Priority slices

| Priority | Capabilities |
|----------|--------------|
| **P0** | Homepage widgets, dashboards, custom/pre-built reports, charts, activity/deal reports, sharing, conversational report API |
| **P1** | Email/call analytics, API usage dashboard, report preview |
| **P2** | Advanced heat maps / niche chart polish |

---

## 3. Spiral cycles

| Cycle | Focus |
|-------|-------|
| **DAR-S1** | Schema + CH `report_runs` writer + run API skeleton |
| **DAR-S2** | Pre-built reports + homepage widgets |
| **DAR-S3** | Custom report builder + charts + export |
| **DAR-S4** | Sharing + scheduled delivery |
| **DAR-S5** | Conversational report contract for AIA |
| **DAR-S6** | API usage + email/call packs (P1) |

---

## 4. Cycle DAR-S1 — Execution spine

### Objectives
- MySQL report/dashboard definition tables
- ClickHouse `report_runs` (MergeTree, monthly partition)
- Run endpoint: resolve query via Facades, enforce RLS/FLS, append CH row

### Risks
| Risk | Mitigation |
|------|------------|
| Bypassing sharing | Query planner always applies user context |
| CH treated as SoR | Definitions stay MySQL |

### Evaluation
- [ ] Sample report run creates CH row with user/org/source

---

## 5. Cycle DAR-S2 — Homepage & packs

### Objectives
- User homepage &lt;2s; pre-built activity/deal reports
- Widgets for pipeline and (later) leaderboards via SPM Facade

### Evaluation
- [ ] Homepage loads under NFR with seeded data

---

## 6. Cycle DAR-S3 — Builder

### Objectives
- Drag-drop dashboards; custom report builder; chart types
- Export PDF/XLS/CSV

### Evaluation
- [ ] User builds bar chart on deals and exports CSV

---

## 7. Cycle DAR-S4 — Share & schedule

### Objectives
- Dashboard/report shares (≠ record access)
- Scheduled delivery jobs

### Risks
| Risk | Mitigation |
|------|------------|
| Share grants record peek | Document + test: share ≠ ACL |

### Evaluation
- [ ] Shared dashboard respects underlying record ACL

---

## 8. Cycle DAR-S5 — AIA contract

### Objectives
- API: accept report spec draft → validate required fields → preview → run → optional save
- `source=assistant` on `report_runs`

### Evaluation
- [ ] Spec missing metrics returns structured “ask user” payload

---

## 9. Cycle DAR-S6 — P1 packs

### Objectives
- Email/call report packs; API usage dashboard (`api_usage_snapshots` / CH hits)

### Evaluation
- [ ] API usage visible to admins

---

## 10. Cross-cutting SDLC checklist

| Stage | DAR activity |
|-------|--------------|
| Requirements | DAR-FR + AIA dependency contract |
| Design | Query DSL; CH schema; chart catalog |
| Build | Runner + UI builder |
| Test | RLS regression suite mandatory |
| Deploy | CH + MySQL both required |
| Ops | Retention ≥13 months on `report_runs` |

---

## 11. Dependencies

| Needs | Provides |
|-------|----------|
| Domain Facades with data; IAM; CH | SPM widgets, AIA reports, MKT API usage |

---

## 12. Exit criteria (module MVP)

Homepage + custom/pre-built reports + charts + sharing + every run audited in ClickHouse + conversational API ready for AIA.
