# Platform Capabilities (PLT) — Spiral Plan

**Document ID:** GVCRM-PLAN-PLT  
**Requirement:** `docs/requirements/09-platform-capabilities.md`  
**Database:** `docs/database/10-plt-platform.md` (`gvcrm_plt`)  
**Program wave:** S1 thin → deepen through S7  
**Packages:** `@gvcrm/mod-platform`, `gvcrm-plt-api`

---

## 1. Purpose

Extensible foundation consumed by all modules: metadata, layouts, custom apps, cases, notes, notifications, i18n, multi-currency, sharing/audit, sandbox → production deploy. Feeds Marketplace packaging.

---

## 2. Priority slices

| Priority | Capabilities |
|----------|--------------|
| **P0** | Bulk edit, cases, sandbox/deploy, custom fields/layouts/modules/apps/views, reminders, i18n, multi-currency, notes, notifications, record shares, record audit |
| **P1** | Color activity icons, RTL |
| **P2** | Audio transcription |

---

## 3. Spiral cycles

| Cycle | Focus | Wave align |
|-------|-------|------------|
| **PLT-S1** | `record_shares`, `record_audit_events`, notes, notifications | S1 |
| **PLT-S2** | Custom fields via `custom_json` + layouts/list views | S1–S2 |
| **PLT-S3** | Cases, reminders, bulk spreadsheet edit | S3 |
| **PLT-S4** | EAV custom fields, custom modules, record types | S5–S6 |
| **PLT-S5** | i18n language packs, FX rates | S5 |
| **PLT-S6** | Sandbox create/clone/refresh + config deploy | S6–S7 |
| **PLT-S7** | Custom apps packaging hooks for MKT | S7 |

---

## 4. Cycle PLT-S1 — Sharing & audit spine

### Objectives
- Record share grants (user/group); CRUD audit events
- Notes (text); in-app notifications with safe previews

### Risks
| Risk | Mitigation |
|------|------------|
| Notification leaks restricted fields | Preview sanitizer uses FLS |
| Share ignored by modules | Shared library helper mandatory in APIs |

### Evaluation
- [ ] Shared record visible to grantee; audit row on update

---

## 5. Cycle PLT-S2 — Layouts & light customization

### Objectives
- Page layouts; list views/filters
- MVP custom data on `custom_json` (per DB guidance)

### Evaluation
- [ ] Admin changes layout; user sees new field order

---

## 6. Cycle PLT-S3 — Ops tools

### Objectives
- Cases; follow-up reminders; bulk edit with validation (WPA)

### Evaluation
- [ ] Bulk edit updates N rows with per-row errors report

---

## 7. Cycle PLT-S4 — Metadata depth

### Objectives
- Searchable custom fields / EAV when needed
- Custom modules + custom records
- Record types

### Risks
| Risk | Mitigation |
|------|------------|
| EAV performance | Index strategy; limit indexed customs |

### Evaluation
- [ ] Custom module CRUD works; entitled privately by default

---

## 8. Cycle PLT-S5 — i18n & FX

### Objectives
- Language packs; multi-currency amounts + `exchange_rates`

### Evaluation
- [ ] UI language switch; FX conversion on commercial display

---

## 9. Cycle PLT-S6 — Sandbox & deploy

### Objectives
- Sandbox create/clone/refresh with PII masking
- Configuration deployment sandbox → prod (optional dual-control)

### Risks
| Risk | Mitigation |
|------|------------|
| Prod data in sandbox | Masking checklist |
| Destructive deploy | Dry-run + rollback package |

### Evaluation
- [ ] Deploy package applies metadata without copying passwords

---

## 10. Cycle PLT-S7 — App packaging

### Objectives
- Metadata package format consumed by MKT
- Custom app boundary documentation

### Evaluation
- [ ] Package export installs into another org sandbox

---

## 11. Cross-cutting SDLC checklist

| Stage | PLT activity |
|-------|--------------|
| Requirements | Almost all PLT-FR are P0 — phase by dependency |
| Design | Metadata model; share evaluator |
| Build | Platform admin UI + shared libs |
| Test | Share matrix; deploy dry-run |
| Deploy | PLT always entitled for admins |
| Ops | Sandbox cost controls |

---

## 12. Dependencies

| Needs | Provides |
|-------|----------|
| IAM; TCL groups for share grantees | Every module’s sharing, audit, metadata, MKT packages |

---

## 13. Exit criteria (module MVP)

Shares + audit + notes + notifications + layouts + light custom fields live before multi-user CRM scale-up; sandbox/deploy before Marketplace public apps.
