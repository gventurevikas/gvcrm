# Products Management — Use Cases

**Document ID:** GVCRM-UC-PRD  
**Requirements:** `docs/requirements/07-products-management.md`

---

## PRD-UC-001 — Create and maintain custom products

| Field | Value |
|-------|-------|
| **Requirement** | PRD-FR-001 |
| **Priority** | P0 |
| **Primary actor** | A-OPS / product manager |
| **Security** | PRD-SEC-001 |

### Main flow
1. User creates product (code, name, description, cost, list price, notes).
2. Cost hidden from standard sales roles by default.
3. Rep links product to opportunity/contact/quote lines (snapshots price/name).

---

## PRD-UC-002 — Browse product catalog and price books

| Field | Value |
|-------|-------|
| **Requirement** | PRD-FR-002 |
| **Priority** | P0 |
| **Primary actor** | A-AE |

### Main flow
1. User opens catalog; filters by taxonomy/category.
2. Selects price book appropriate to segment (PRD-SEC-004).
3. Searches products (&lt;1s @50k target path).
4. Adds to quote/opportunity.

---

## PRD-UC-003 — Organize product groups

| Field | Value |
|-------|-------|
| **Requirement** | PRD-FR-003 |
| **Priority** | P1 |
| **Primary actor** | A-OPS |

### Main flow
1. User creates static or rule-based dynamic groups (brand, LOB, eligibility).
2. Groups used in portals, reports, and quoting helpers.

---

## PRD-UC-004 — Publish branded prospect portal

| Field | Value |
|-------|-------|
| **Requirement** | PRD-FR-004 |
| **Priority** | P1 |
| **Primary actors** | A-MKT (publish), A-EXT (browse), A-SYS (CTA → lead) |
| **Security** | PRD-SEC-002, PRD-SEC-003, PRD-SEC-005 |

### Main flow
1. Marketing configures branded portal (logo, products, CTA).
2. Custom domain HTTPS provisioned.
3. Prospect browses published products (no costs, no CRM APIs beyond published queries).
4. Prospect submits CTA → LED creates lead with portal source.
5. Assignment/notify proceeds as lead capture.

### Exceptions
- **E1 Domain/TLS failure:** Portal stays unpublished.

---

## Traceability matrix

| UC | FR | Priority |
|----|-----|----------|
| PRD-UC-001…004 | PRD-FR-001…004 | as above |
