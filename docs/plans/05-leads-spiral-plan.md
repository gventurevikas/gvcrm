# Leads Management (LED) — Spiral Plan

**Document ID:** GVCRM-PLAN-LED  
**Requirement:** `docs/requirements/05-leads-management.md`  
**Database:** `docs/database/06-led-leads.md` (`gvcrm_led`)  
**Program wave:** S2 core; Meta/LinkedIn in S4  
**Packages:** `@gvcrm/mod-leads`, `gvcrm-led-api`

---

## 1. Purpose

Capture, score, assign, convert, and analyze leads — including **real-time Meta Lead Ads and LinkedIn Lead Gen** for remote insurance producers (P95 notify ≤15s).

---

## 2. Priority slices

| Priority | Capabilities |
|----------|--------------|
| **P0** | Multi-source capture, assignment/round-robin, scoring, lifecycle/convert, Meta/LinkedIn real-time |
| **P1** | Email parser, card scanner, win-loss analytics |
| **P2** | Advanced parser NLP polish |

---

## 3. Spiral cycles

| Cycle | Focus |
|-------|-------|
| **LED-S1** | Lead object CRUD, import, web form, dedupe |
| **LED-S2** | Assignment rules + round-robin queues |
| **LED-S3** | Scoring + MQL/SQL + lifecycle |
| **LED-S4** | Convert to ACM/ODM via Facade |
| **LED-S5** | Meta + LinkedIn ingest (LED-FR-008) |
| **LED-S6** | Parser, card scan, win-loss (P1) |

---

## 4. Cycle LED-S1 — Capture

### Objectives
- `leads` table; manual create; CSV import; web form with spam protection
- Source/UTM/payload fields; dedupe rules

### Risks
| Risk | Mitigation |
|------|------------|
| Duplicate spam | Configurable match + review queue |
| Form abuse | CAPTCHA/honeypot + rate limits |

### Evaluation
- [ ] Manual + CSV + form produce same Lead object; form &lt;10s

---

## 5. Cycle LED-S2 — Assignment

### Objectives
- Rules by geo/product/score/source; round-robin with concurrent-safe locks
- OOO-aware hooks (INS remote later)

### Risks
| Risk | Mitigation |
|------|------------|
| Double assignment | Queue row locks / transactional claim |

### Evaluation
- [ ] Two concurrent claims → one owner

---

## 6. Cycle LED-S3 — Scoring & lifecycle

### Objectives
- Scoring rules; thresholds; status lifecycle
- Touches history

### Evaluation
- [ ] Score updates on field change; MQL status flips

---

## 7. Cycle LED-S4 — Convert

### Objectives
- Convert → Account/Contact/Opportunity via ACM/ODM Facades
- Preserve source lineage on opportunity

### Evaluation
- [ ] Convert creates ACM+ODM records; lead marked converted

---

## 8. Cycle LED-S5 — Meta & LinkedIn

### Objectives
- Ad connections (encrypted OAuth); ingest events; idempotency key
- Webhook → lead ≤15s; notify assignee; consent snapshot → CCM

### Risks
| Risk | Mitigation |
|------|------------|
| Duplicate webhook deliveries | `org+provider+idempotency_key` unique |
| TCPA miss | Write CCM consent before notify-to-call |
| Provider API drift | Adapter interface + contract tests |

### Evaluation
- [ ] Replay webhook does not duplicate lead
- [ ] P95 ingest-to-notify ≤15s in staging

---

## 9. Cycle LED-S6 — P1 tools

### Objectives
- Email parser; mobile card scan (PII handling); win-loss / speed-to-lead

### Evaluation
- [ ] Forwarded email creates lead; card scan creates draft; win-loss report works

---

## 10. Cross-cutting SDLC checklist

| Stage | LED activity |
|-------|--------------|
| Requirements | LED-FR-001…008 + INT/SEC |
| Design | Ingest state machine; assignment DSL |
| Build | API + queue workers + Angular queue UI |
| Test | Idempotency, race, consent, load ≤15s |
| Deploy | Webhook public endpoints + secrets |
| Ops | Dead-letter for failed ingest |

---

## 11. Dependencies

| Needs | Provides |
|-------|----------|
| IAM; ACM/ODM for convert; CCM consent; SPM campaign ids optional | INS remote queue, SPM ROI, AIA “show my Meta leads” |

---

## 12. Exit criteria (module MVP)

P0 capture/assign/score/convert live; Meta+LinkedIn real-time path meets ≤15s with consent; no cross-tenant leads.
