# Sales Performance (SPM) — Spiral Plan

**Document ID:** GVCRM-PLAN-SPM  
**Requirement:** `docs/requirements/10-sales-performance-management.md`  
**Database:** `docs/database/11-spm-sales-performance.md` (`gvcrm_spm`)  
**Program wave:** S5  
**Packages:** `@gvcrm/mod-performance`, `gvcrm-spm-api`

---

## 1. Purpose

Goals, forecasting, campaigns (incl. Meta/LinkedIn ROI), complete gamification, and **published daily / weekly / monthly leaderboards** for remote teams.

---

## 2. Priority slices

| Priority | Capabilities |
|----------|--------------|
| **P0** | Goals/targets, attainment, forecast best/likely/worst, gamification, D/W/M leaderboards |
| **P1** | First-class campaigns + ROI, manager forecast adjustments |
| **P2** | Advanced challenge types |

---

## 3. Spiral cycles

| Cycle | Focus |
|-------|-------|
| **SPM-S1** | KPI defs, goals, progress from ODM/INS Facades |
| **SPM-S2** | Forecast views (best/likely/worst) |
| **SPM-S3** | Gamification events (idempotent), points, badges, streaks |
| **SPM-S4** | D/W/M leaderboards + homepage widgets + digests (rank ≤5 min) |
| **SPM-S5** | Campaigns + Meta/LinkedIn ROI (P1) |
| **SPM-S6** | Optional CH `leaderboard_snapshot_rows` / insurance KPI facts |

---

## 4. Cycle SPM-S1 — Goals

### Objectives
- Goal CRUD; team via TCL groups; progress aggregation
- Insurance KPIs when INS entitled (premium bound, etc.)

### Risks
| Risk | Mitigation |
|------|------------|
| Wrong metric definitions | Versioned KPI catalog |

### Evaluation
- [ ] Producer sees attainment % for month

---

## 5. Cycle SPM-S2 — Forecast

### Objectives
- Pipeline rollup into best/likely/worst
- Manager adjustment (P1 can stub)

### Evaluation
- [ ] Forecast matches staged probabilities within tolerance

---

## 6. Cycle SPM-S3 — Gamification

### Objectives
- Points/badges/streaks/challenges
- Idempotent event ingestion from LED/ODM/CCM

### Risks
| Risk | Mitigation |
|------|------------|
| Double points on retries | Event idempotency keys |

### Evaluation
- [ ] Duplicate event does not double score

---

## 7. Cycle SPM-S4 — Leaderboards

### Objectives
- Published daily, weekly, monthly boards
- Homepage widgets; email/push digests
- No peer PII/deal leakage beyond sharing rules

### Risks
| Risk | Mitigation |
|------|------------|
| Privacy complaints | Aggregate metrics only; SEC review |
| Stale ranks | Snapshot job ≤5 min |

### Evaluation
- [ ] Three period boards publish; homepage widget &lt;2s
- [ ] User without share cannot see peer deal amounts

---

## 8. Cycle SPM-S5 — Campaigns

### Objectives
- Campaign object; members; influence; ROI including ad spend vs LED

### Evaluation
- [ ] Meta campaign ROI reportable

---

## 9. Cycle SPM-S6 — Analytics scale

### Objectives
- Optional ClickHouse fact tables for large leaderboards

### Evaluation
- [ ] Board generation time acceptable at target org size

---

## 10. Cross-cutting SDLC checklist

| Stage | SPM activity |
|-------|--------------|
| Requirements | SPM-FR-005/006 leaderboards P0 |
| Design | Snapshot algorithm; privacy matrix |
| Build | Jobs + UI + DAR widgets |
| Test | Idempotency; privacy; freshness |
| Deploy | Cron/workers for snapshots |
| Ops | Digest bounce handling |

---

## 11. Dependencies

| Needs | Provides |
|-------|----------|
| ODM, LED, CCM, INS KPIs, DAR homepage, TCL groups | AIA “where am I on the board?”; remote motivation |

---

## 12. Exit criteria (module MVP)

Goals + forecast + gamification + **D/W/M leaderboards** published and privacy-safe.
