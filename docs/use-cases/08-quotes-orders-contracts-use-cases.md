# Quotes, Orders, and Contracts — Use Cases

**Document ID:** GVCRM-UC-QOC  
**Requirements:** `docs/requirements/08-quotes-orders-and-contracts-management.md`

---

## QOC-UC-001 — Generate and send a quote

| Field | Value |
|-------|-------|
| **Requirement** | QOC-FR-001 |
| **Priority** | P0 |
| **Primary actor** | A-AE / A-PROD |
| **Security** | QOC-SEC-001, QOC-SEC-004, QOC-SEC-005 |

### Main flow
1. From opportunity, user **Create Quote**; customer and products pre-filled.
2. Adjusts lines/discounts; **server recalculates totals**.
3. If discount over threshold, approval required (WPA / E2E-UC-004).
4. Generates PDF (DOC); emails customer link/PDF (CCM).
5. Customer accepts via secure link (no other CRM data exposed).
6. System creates order and/or contract draft per template rules.

---

## QOC-UC-002 — Create and track orders

| Field | Value |
|-------|-------|
| **Requirement** | QOC-FR-002 |
| **Priority** | P0 |
| **Primary actor** | A-AE / order manager |

### Main flow
1. User creates order from quote, opportunity, or blank using templates.
2. Sets status; adds lines (price snapshots).
3. Tracks fulfillment status through configured statuses.

---

## QOC-UC-003 — Automatically create orders from website

| Field | Value |
|-------|-------|
| **Requirement** | QOC-FR-003 |
| **Priority** | P1 |
| **Primary actor** | A-SYS / A-OPS |
| **Security** | QOC-SEC-003 |

### Main flow
1. Ops configures signed webhook / e-commerce mapping.
2. Checkout event arrives with idempotency key.
3. Order created once; duplicates ignored.
4. Optional confirmation email to customer.

---

## QOC-UC-004 — View order history timeline

| Field | Value |
|-------|-------|
| **Requirement** | QOC-FR-004 |
| **Priority** | P0 |

### Main flow
1. User opens order → **History**.
2. Sees chronology: status changes, documents, communications, payments.
3. Filters by type; opens related artifacts.

---

## QOC-UC-005 — Segment and filter orders

| Field | Value |
|-------|-------|
| **Requirement** | QOC-FR-005 |
| **Priority** | P1 |

### Main flow
1. User filters orders by account, status, product, owner, date.
2. Saves segment for reuse/reporting.

---

## QOC-UC-006 — Create contracts from templates

| Field | Value |
|-------|-------|
| **Requirement** | QOC-FR-006 |
| **Priority** | P0 |
| **Primary actor** | A-AE / A-LEG |

### Main flow
1. User creates contract from template/quote/order/opportunity.
2. Merge fields populate; attachments added (DOC).
3. Sends for e-sign via Marketplace app when configured (QOC-INT-004).

---

## QOC-UC-007 — Manage contract terms and amendments

| Field | Value |
|-------|-------|
| **Requirement** | QOC-FR-007 |
| **Priority** | P0 |
| **Security** | QOC-SEC-002 |

### Main flow
1. User manages terms, renewal dates, reminders.
2. On sign, contract becomes **immutable snapshot**.
3. Changes require **amendment** record linked to prior version.
4. History retained for audit.

### Exceptions
- **E1 Edit signed contract:** API rejects (409).

---

## QOC-UC-008 — Issue invoices and track payments

| Field | Value |
|-------|-------|
| **Requirement** | QOC-FR-008 |
| **Priority** | P0 |
| **Primary actor** | A-FIN |

### Main flow
1. User issues invoice from template/order.
2. Issued invoice immutable; due-date alerts fire.
3. Payments recorded; balance updates.
4. Overdue invoices escalate via notification/workflow.

---

## QOC-UC-009 — Plan supply and payment schedules

| Field | Value |
|-------|-------|
| **Requirement** | QOC-FR-009 |
| **Priority** | P1 |

### Main flow
1. User applies supply/payment schedule template to order/contract.
2. System generates dated milestones.
3. Milestone due → generate invoice or task as configured.

---

## Traceability matrix

| UC | FR | Priority |
|----|-----|----------|
| QOC-UC-001…009 | QOC-FR-001…009 | as above |
