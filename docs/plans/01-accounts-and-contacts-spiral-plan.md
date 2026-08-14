# Accounts & Contacts (ACM) — Spiral Plan

**Document ID:** GVCRM-PLAN-ACM  
**Requirement:** `docs/requirements/01-accounts-and-contacts-management.md`  
**Database:** `docs/database/02-acm-accounts-contacts.md` (`gvcrm_acm`)  
**Program wave:** S1 (core); scheduling polish may trail  
**Packages:** `@gvcrm/mod-accounts`, `gvcrm-acm-api`

---

## 1. Purpose

Deliver the party system of record: companies and people with hierarchy, 360° views, and scheduling so every other CRM module has a stable account/contact target.

---

## 2. Priority slices

| Priority | Capabilities |
|----------|--------------|
| **P0** | Account CRUD/merge/archive, hierarchy (≤10 levels), contact CRUD, multi-account roles, DNC flags, individual scheduling, 360° basics |
| **P1** | Org charts, geo map + geocoding, group scheduling |
| **P2** | Advanced influence mapping polish |

---

## 3. Spiral cycles

| Cycle | Focus | FR targets (examples) |
|-------|-------|------------------------|
| **ACM-S1** | Accounts + contacts CRUD + org_id isolation | ACM-FR account/contact core |
| **ACM-S2** | Hierarchy + merge + 360° shell | Hierarchy, merge, related lists |
| **ACM-S3** | Individual scheduling | Appointments, availability |
| **ACM-S4** | Org charts + maps + group scheduling | P1 |

---

## 4. Cycle ACM-S1 — Core party CRUD

### Objectives
- Migrate `accounts`, `contacts`, `account_contact_roles`
- List/detail/create/edit with FLS-ready layouts
- Soft delete; owner + created_by from IAM

### Risks
| Risk | Mitigation |
|------|------------|
| Cross-tenant leak | Mandatory `org_id` in every query + tests |
| Duplicate “customer” concepts later in INS | `accounts.type` includes household early |

### Engineering
| Layer | Work |
|-------|------|
| Design | ER from DB doc; Facade DTOs in contracts |
| Build | API CRUD; Angular list/detail; search |
| Test | Isolation tests; NFR search smoke |

### Evaluation
- [ ] Create/update/search account & contact in one org only
- [ ] Acceptance criteria for core CRUD green

---

## 5. Cycle ACM-S2 — Hierarchy & 360°

### Objectives
- Parent account links; cycle detection; depth ≤10
- Merge with audit (PII export/merge logged via PLT audit)
- 360° shell: tabs for contacts, deals, docs, comms (stubs OK)

### Risks
| Risk | Mitigation |
|------|------------|
| Hierarchy cycles | Server-side cycle check |
| Merge data loss | Dry-run preview + audit |

### Engineering
- Hierarchy APIs + tree UI
- Merge wizard
- 360° host consuming Facades (lazy)

### Evaluation
- [ ] Cycle rejected; roll-up metrics stub OK
- [ ] Merge enriches survivor and logs audit

---

## 6. Cycle ACM-S3 — Individual scheduling

### Objectives
- Scheduling pages, appointment types, availability, appointments
- Free/busy only to others (privacy NFR)

### Risks
| Risk | Mitigation |
|------|------------|
| Calendar oversharing | Expose free/busy, not titles, by default |

### Engineering
- Appointment CRUD; calendar UI; optional external sync stub

### Evaluation
- [ ] Book appointment on contact; conflict rules work

---

## 7. Cycle ACM-S4 — P1 visuals & group schedule

### Objectives
- Org chart (reports-to + influence)
- Map + geocoding respecting sharing
- Group scheduling using TCL `user_groups` when available

### Risks
| Risk | Mitigation |
|------|------------|
| Map leaks private addresses | Share filter before geocode display |

### Evaluation
- [ ] Org chart renders; map respects ACL; group booking works

---

## 8. Cross-cutting SDLC checklist

| Stage | ACM activity |
|-------|--------------|
| Requirements | Trace tickets to ACM-FR / NFR / SEC |
| Design | Schema + OpenAPI + screen list |
| Build | Vertical slices per cycle |
| Test | Unit, API contract, harness UI, P95 load smoke |
| Deploy | Entitle `acm` module in IAM |
| Ops | Monitor slow searches; PII audit |

---

## 9. Dependencies

| Needs | Provides |
|-------|----------|
| S0 IAM, thin PLT shares/audit | LED convert, ODM account, INS households, CCM association |

---

## 10. Exit criteria (module MVP)

Accounts + contacts + hierarchy + individual scheduling ship; 360° shows at least contacts and stub related modules; all queries tenant-scoped.
