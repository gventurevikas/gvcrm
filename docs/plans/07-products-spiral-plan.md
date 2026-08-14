# Products Management (PRD) — Spiral Plan

**Document ID:** GVCRM-PLAN-PRD  
**Requirement:** `docs/requirements/07-products-management.md`  
**Database:** `docs/database/08-prd-products.md` (`gvcrm_prd`)  
**Program wave:** S2 (catalog); portals P1 later  
**Packages:** `@gvcrm/mod-products`, `gvcrm-prd-api`

---

## 1. Purpose

Sellable catalog with taxonomy, price books, groups, and optional branded prospect portals (CTA → lead). Cost fields default-hidden via FLS.

---

## 2. Priority slices

| Priority | Capabilities |
|----------|--------------|
| **P0** | Products, catalog, taxonomy, price books, link to deals/quotes |
| **P1** | Product groups, branded portals |
| **P2** | Portal SEO |

---

## 3. Spiral cycles

| Cycle | Focus |
|-------|-------|
| **PRD-S1** | Categories, products, cost/price, FLS on cost |
| **PRD-S2** | Price books + entries; search &lt;1s @50k target path |
| **PRD-S3** | Groups (static/dynamic) |
| **PRD-S4** | Branded portals + CTA → LED |

---

## 4. Cycle PRD-S1 — Product master

### Objectives
- Product CRUD; active/inactive; custom fields via `custom_json` or PLT
- Cost hidden unless permitted

### Risks
| Risk | Mitigation |
|------|------------|
| Cost leak to portal/export | FLS + portal DTO excludes cost |

### Evaluation
- [ ] AE cannot see cost without permission

---

## 5. Cycle PRD-S2 — Price books

### Objectives
- Multiple price books; currency-aware entries (PLT FX later)
- ODM/QOC snapshot name/price on line add

### Evaluation
- [ ] Quote line freezes price at add time

---

## 6. Cycle PRD-S3 — Groups

### Objectives
- Static and dynamic product groups for bundling

### Evaluation
- [ ] Group selectable on opportunity line helper

---

## 7. Cycle PRD-S4 — Portals

### Objectives
- Branded public portal; HTTPS custom domain path
- CTA creates LED lead; no internal data leakage

### Risks
| Risk | Mitigation |
|------|------------|
| SSRF / open redirect on custom domain | Allowlist + cert provisioning |

### Evaluation
- [ ] Public CTA creates lead with portal source

---

## 8. Cross-cutting SDLC checklist

| Stage | PRD activity |
|-------|--------------|
| Requirements | PRD-FR / SEC cost |
| Design | Price book model; portal tenancy |
| Build | Admin UI + public portal app route |
| Test | FLS, snapshot immutability |
| Deploy | CDN for portal assets |
| Ops | Portal uptime |

---

## 9. Dependencies

| Needs | Provides |
|-------|----------|
| IAM FLS; LED for CTA; ODM/QOC consumers | Catalog for quote-to-cash |

---

## 10. Exit criteria (module MVP)

P0 catalog + price books usable from ODM/QOC; cost FLS enforced.
