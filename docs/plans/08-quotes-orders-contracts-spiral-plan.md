# Quotes, Orders & Contracts (QOC) — Spiral Plan

**Document ID:** GVCRM-PLAN-QOC  
**Requirement:** `docs/requirements/08-quotes-orders-and-contracts-management.md`  
**Database:** `docs/database/09-qoc-quotes-orders-contracts.md` (`gvcrm_qoc`)  
**Program wave:** S4 (quotes first); full quote-to-cash across cycles  
**Packages:** `@gvcrm/mod-commerce`, `gvcrm-qoc-api`

---

## 1. Purpose

Quote-to-cash: quotes, orders, contracts, invoices, amendments, and schedules — with **immutability** for issued invoices and signed contracts.

---

## 2. Priority slices

| Priority | Capabilities |
|----------|--------------|
| **P0** | Quote from opportunity, order, history, contract create/manage, invoice |
| **P1** | Website order intake, segmentation, supply/payment schedules |
| **P2** | Advanced e-sign provider matrix polish |

---

## 3. Spiral cycles

| Cycle | Focus |
|-------|-------|
| **QOC-S1** | Quote templates, lines, PDF via DOC, accept flow |
| **QOC-S2** | Orders from quote + manual; order history timeline |
| **QOC-S3** | Contracts + amendments; discount → WPA approval |
| **QOC-S4** | Invoices + due alerts; payment records |
| **QOC-S5** | Website intake webhooks (signed, idempotent) |
| **QOC-S6** | Supply/payment schedule templates (P1) |

---

## 4. Cycle QOC-S1 — Quotes

### Objectives
- Quote from ODM opportunity; PRD price book; server-side totals
- PDF generation stored in DOC
- Accept → create order and/or contract draft

### Risks
| Risk | Mitigation |
|------|------------|
| Client-side total tampering | Recalculate on server |
| Stale prices | Snapshot line fields |

### Evaluation
- [ ] Accept quote creates downstream records; PDF attached

---

## 5. Cycle QOC-S2 — Orders

### Objectives
- Orders; history events; status machine

### Evaluation
- [ ] Order timeline shows quote acceptance and status changes

---

## 6. Cycle QOC-S3 — Contracts

### Objectives
- Contracts + amendments; signed state immutable
- Discount thresholds require WPA approval

### Risks
| Risk | Mitigation |
|------|------------|
| Edit after sign | API rejects mutations when signed |

### Evaluation
- [ ] Signed contract update returns 409; amendment creates new version

---

## 7. Cycle QOC-S4 — Invoices

### Objectives
- Invoices + lines; issued immutable; due alerts via PLT notifications

### Evaluation
- [ ] Issued invoice cannot change amounts; due alert fires

---

## 8. Cycle QOC-S5 — Website intake

### Objectives
- Signed webhooks; idempotent order create

### Evaluation
- [ ] Replay webhook does not duplicate order

---

## 9. Cycle QOC-S6 — Schedules

### Objectives
- Supply and payment schedule templates

### Evaluation
- [ ] Schedule generates dated milestones on order

---

## 10. Cross-cutting SDLC checklist

| Stage | QOC activity |
|-------|--------------|
| Requirements | QOC-FR / NFR immutability |
| Design | State machines; money DECIMAL rules |
| Build | API + Angular wizards |
| Test | Immutability, idempotency, approval gates |
| Deploy | Entitle `qoc` |
| Ops | Failed PDF / webhook DLQ |

---

## 11. Dependencies

| Needs | Provides |
|-------|----------|
| ACM, ODM, PRD, DOC, WPA (approvals) | INS quotes on policies; DAR revenue reports |

---

## 12. Exit criteria (module MVP)

Quote → order/contract → invoice happy path; PDFs in DOC; immutability enforced; discounts approval-gated.
