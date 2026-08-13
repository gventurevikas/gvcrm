# Quotes, Orders, and Contracts Management

**Document ID:** GVCRM-REQ-QOC  
**Version:** 1.0  
**Status:** Draft for implementation  
**Source:** CRM Requirement sheet — Quotes, Orders, and Contracts Management  
**This document is independent.** Related modules are listed only as dependencies.

---

## 1. Purpose

Turn won or in-progress commercial intent into **quotes, orders, invoices, contracts, and supply/payment schedules**, with templates, automation from the website, full order history, and segmentation.

## 2. Scope

**In scope**

- Quote generation from opportunities (product + customer data)
- Order generation, status tracking, templates
- Automatic order creation from website registration
- Order history (activities, documents, communications)
- Order segmentation / grouping
- Contract creation from templates (quote/order/opportunity)
- Contract management, attachments, amendments history
- Invoice issuance, templates, due-date alerts
- Supply and payments schedule planning

**Out of scope**

- Full ERP/GL accounting — invoices here are CRM commercial documents; deep accounting sync is integration
- eSignature vendor specifics — supported via integration/Marketplace apps
- Product catalog authoring — Products Management

## 3. Users

| Persona | Typical actions |
|---------|-----------------|
| Sales representative | Generate quotes from deals, send to customer |
| Sales ops / deal desk | Templates, discount approvals (with Workflows) |
| Order manager | Create/track orders, segment, history |
| Finance / billing ops | Invoices, payment schedules, due alerts |
| Legal / CS | Contracts, amendments, attachments |
| Website / e-commerce | Automatic order intake |

## 4. Business objectives

- Faster quote-to-cash inside CRM
- Traceable commercial documents tied to the customer and deal
- Fewer missed payments via due-date alerts
- Website orders land in CRM without re-keying

---

## 5. Functional requirements

### 5.1 Quote generation

**Source capability:** Quote Generation  
**Priority:** P0  
**ID:** QOC-FR-001

The solution shall generate quotes by including product and customer information directly from the opportunity.

**User story**  
As an AE, I want to create a quote from the deal so account, contacts, and products are pre-filled.

**Detailed requirements**

1. Action on Opportunity: Create Quote. Pre-fill account, bill-to/ship-to, primary contact, currency, products/line items, discounts, validity date.
2. Editable line items: product, qty, list price, discount, tax, description; totals recalculate.
3. Quote templates (PDF/web) with branding; preview before send.
4. Send quote via email/share link; customer view/accept optional (P1).
5. Multiple quotes per opportunity; one can be marked Primary / Accepted.
6. Accepting a quote can drive order and/or contract creation.

**Acceptance criteria**

- Quote line items match opportunity products unless edited.
- Customer name and address come from the account/contact.
- PDF/web preview shows totals equal to the quote record.
- Status flow: Draft → Sent → Accepted / Rejected / Expired.

---

### 5.2 Order generation

**Source capability:** Order Generation  
**Priority:** P0  
**ID:** QOC-FR-002

The solution shall allow creating orders using standard templates, adding products, and tracking status.

**Detailed requirements**

1. Create order from quote, opportunity, or blank (manual) using standard templates.
2. Add/remove products, quantities, prices; status tracking (configurable: Draft, Confirmed, In fulfillment, Shipped, Completed, Cancelled, etc.).
3. Owner, account, contact, requested date, notes.
4. Template determines default sections, terms, and required fields.
5. Status changes can trigger workflows (notifications, tasks).

**Acceptance criteria**

- Creating an order from an accepted quote copies line items and customer data.
- Status is visible on list, detail, and account 360°.
- Invalid transition (e.g. Completed → Draft) is blocked unless permitted.
- Template selection changes default terms text.

---

### 5.3 Automatic creation of orders

**Source capability:** Automatic Creation of Orders  
**Priority:** P1  
**ID:** QOC-FR-003

The solution shall allow configuring registration of orders from the website and automatically creating order records.

**User story**  
As an ops admin, I want website checkout/registration to create a CRM order without manual entry.

**Detailed requirements**

1. Configurable inbound channel: webhook/API and/or website plugin.
2. Mapping: website payload → Account (match or create), Contact, Order, line items, payment status.
3. Idempotency key so retries do not duplicate orders.
4. Failure queue with retry and alert.
5. Attribution: source = Website, plus campaign/UTM if present.

**Acceptance criteria**

- A valid website payload creates exactly one order.
- Retry with the same idempotency key does not create a second order.
- Unknown SKU is handled per config (reject vs create placeholder vs review queue).
- Created order appears on the matched account.

---

### 5.4 Order history

**Source capability:** Order History  
**Priority:** P0  
**ID:** QOC-FR-004

The solution shall keep the complete chronology of activities, documents, and communications associated with each order.

**Detailed requirements**

1. Order timeline: status changes, field changes, emails, calls, SMS, notes, tasks, files, invoices, contracts, supply events.
2. Filter timeline by type.
3. Nothing in the chronology is deleted silently; corrections are new events.

**Acceptance criteria**

- Sending an email from the order appears on the timeline.
- Attaching a POD PDF appears under documents and timeline.
- Status change shows actor, timestamp, old → new.

---

### 5.5 Order segmentation

**Source capability:** Order Segmentation  
**Priority:** P1  
**ID:** QOC-FR-005

The solution shall allow grouping orders by contacts, accounts, stages, budgets, products or services, owners, etc.

**Detailed requirements**

1. Segment/group orders by: contact, account, status/stage, budget/amount band, product/service, owner, date, custom fields, tags.
2. Saved segments for lists, dashboards, and mass actions (e.g. export, assign).
3. Multi-dimension grouping (e.g. account → status).

**Acceptance criteria**

- Segment “owner = me AND status = Confirmed AND product group = X” returns only matching orders.
- Saved segment remains available on next login.
- Grouped view shows counts and amount totals.

---

### 5.6 Contract creation

**Source capability:** Contract Creation  
**Priority:** P0  
**ID:** QOC-FR-006

The solution shall allow creating contracts manually or using templates by auto-populating necessary fields from a quote, order, or opportunity.

**Detailed requirements**

1. Create contract: blank, from template, from quote, from order, from opportunity.
2. Auto-populate: parties (account), contacts, products/commercial terms, start/end dates, value, related quote/order/opportunity IDs.
3. Template library with merge fields.
4. Draft → In review → Active → Expired / Terminated (configurable).
5. Optional eSign send via connected app (Marketplace).

**Acceptance criteria**

- Creating from a quote copies customer and commercial totals.
- Manual create allows selecting a template and still editing fields.
- Related opportunity/quote/order links are visible and clickable.

---

### 5.7 Contract management

**Source capability:** Contract Management  
**Priority:** P0  
**ID:** QOC-FR-007

The solution shall manage contracts, associated specifications, and additional agreements; attach electronic versions and photocopies; and track contract details and amendments history.

**Detailed requirements**

1. Contract record: term dates, renewal type, notice period, owner, value, status, specifications, related agreements.
2. Attach electronic files and photocopies (Documents module); versioned.
3. Amendments: new version or child amendment record with change summary, effective date, and commercial delta; history never overwritten.
4. Renewal reminders via Follow-up Reminders / Workflows.
5. Related agreements linked (DPA, SOW, MSA + order forms).

**Acceptance criteria**

- Uploading a signed PDF attaches to the contract with version history.
- Recording an amendment keeps the original terms visible in history.
- Specifications and additional agreements are listable on the contract.
- Renewal approaching can create an alert for the owner.

---

### 5.8 Invoice management

**Source capability:** Invoice Management  
**Priority:** P0  
**ID:** QOC-FR-008

The solution shall issue invoices using customizable invoice templates and alert assigned sales representatives when the payment due date approaches.

**Detailed requirements**

1. Create invoice from order, contract, quote, or supply/payment schedule.
2. Customizable invoice templates (brand, tax display, multi-currency).
3. Status: Draft, Issued, Partially paid, Paid, Overdue, Void.
4. Due-date approaching alert to assigned sales representative (and optional finance role); overdue escalation.
5. Record payments (amount, date, method, reference) — not a full ledger.
6. Send invoice via email/share link.

**Acceptance criteria**

- Issuing an invoice assigns a unique invoice number.
- Alert fires according to configured offsets (e.g. 7 days before due, on due date, 7 days overdue).
- Template change is reflected on newly issued invoices only (issued invoices remain immutable snapshots).
- Multi-currency invoice uses the record currency and shows org currency equivalent if enabled.

---

### 5.9 Supply and payments schedule

**Source capability:** Supply and Payments Schedule  
**Priority:** P1  
**ID:** QOC-FR-009

The solution shall plan a schedule of supplies and payments according to customer agreements; allow creating/editing supply schedule templates; group products based on supplies; and issue invoices and contracts according to the schedule.

**User story**  
As a CSM/ops user, I want a 12-month supply plan with quarterly invoices generated from the same template.

**Detailed requirements**

1. Supply/payment schedule linked to account, order, and/or contract.
2. Line schedule: dates, products/groups, quantities, payment amounts, invoice dates, responsible owner.
3. Templates: reusable cadence (e.g. monthly supply + quarterly invoice).
4. Group products by supply batch/shipment.
5. Actions: generate invoice(s) and/or contract artifacts for due schedule lines.
6. Edit future lines; lock past executed lines (with amendment path).

**Acceptance criteria**

- Applying a quarterly invoice template to a yearly contract creates the expected invoice dates.
- “Generate invoices due this week” creates invoices only for due unbilled lines.
- Grouping products into a supply batch is visible on the schedule and order history.
- Editing a template does not retroactively change executed invoices.

---

## 6. Data entities

| Entity | Purpose |
|--------|---------|
| Quote / QuoteLine | Commercial offer |
| Order / OrderLine | Fulfillment commercial record |
| OrderStatusHistory | Chronology of status |
| Contract / ContractAmendment | Legal commercial agreement |
| Invoice / InvoiceLine / Payment | Billing documents |
| SupplySchedule / SupplyScheduleLine | Supply and payment plan |
| CommercialTemplate | Quote/order/invoice/contract/schedule templates |
| WebsiteOrderIntake | Mapping + idempotency |

## 7. Integrations

| ID | Integration | Purpose |
|----|-------------|---------|
| QOC-INT-001 | Website / e-commerce | Automatic orders |
| QOC-INT-002 | Products / Price books | Line items |
| QOC-INT-003 | Email / Documents | Send and store PDFs |
| QOC-INT-004 | eSignature (Marketplace app) | Contract execution |
| QOC-INT-005 | Tax / payment gateway (optional) | Tax calc, payment capture |
| QOC-INT-006 | ERP/accounting (optional) | Invoice sync |

## 8. Permissions and security

| ID | Requirement |
|----|-------------|
| QOC-SEC-001 | Discount above threshold requires approval (Workflows). |
| QOC-SEC-002 | Issued invoices and signed contracts are immutable snapshots. |
| QOC-SEC-003 | Website intake uses signed webhooks and idempotency. |
| QOC-SEC-004 | Customer-facing quote/invoice links expose no other CRM data. |
| QOC-SEC-005 | Finance vs sales field-level security on cost vs price. |

## 9. Non-functional requirements

| ID | Requirement |
|----|-------------|
| QOC-NFR-001 | Quote PDF generation P95 < 5s for typical 50-line quotes. |
| QOC-NFR-002 | Website order intake P95 < 2s to persist + ack. |
| QOC-NFR-003 | Due-date alert job runs at least hourly; no duplicate alerts for the same offset. |
| QOC-NFR-004 | Totals are calculated server-side; client cannot tamper with issued totals. |

## 10. Dependencies

| Module | Why |
|--------|-----|
| Accounts and Contacts | Parties, addresses |
| Opportunities | Quote source |
| Products | Catalog and groups |
| Documents | File attachments, versions, share links |
| Customer Communication | Send quotes/invoices, timeline |
| Workflows | Discount and contract approvals, validation |
| Platform | Templates layouts, multi-currency, reminders, sandbox |
| Dashboards | Revenue and overdue invoice reports |
| Marketplace | eSign, tax, payment, e-commerce connectors |

## 11. Traceability

| Source capability | Requirement IDs |
|-------------------|-----------------|
| Automatic Creation of Orders | QOC-FR-003 |
| Contract Creation | QOC-FR-006 |
| Contract Management | QOC-FR-007 |
| Invoice Management | QOC-FR-008 |
| Order Generation | QOC-FR-002 |
| Order History | QOC-FR-004 |
| Order Segmentation | QOC-FR-005 |
| Quote Generation | QOC-FR-001 |
| Supply and Payments Schedule | QOC-FR-009 |
