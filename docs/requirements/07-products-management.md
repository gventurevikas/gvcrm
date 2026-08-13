# Products Management

**Document ID:** GVCRM-REQ-PRD  
**Version:** 1.0  
**Status:** Draft for implementation  
**Module:** Products Management  
**This document is independent.** Related modules are listed only as dependencies.

---

## 1. Purpose

Maintain the company’s **sellable catalog**: products and services with codes, costs, pricing, taxonomy, grouping, and optional **branded portals** so prospects can explore offerings. Products must link to deals, contacts, quotes, and orders.

## 2. Scope

**In scope**

- Custom product records (codes, costs, notes, filters, linking)
- Product catalog with pricing and taxonomy
- Product groups by brand, category, and custom attributes
- Branded prospect portals to explore products/services

**Out of scope**

- Quote/order/invoice generation — Quotes, Orders, and Contracts
- Inventory/warehouse WMS — not part of CRM MVP unless later scoped
- Public app marketplace storefront — Marketplace module (portals here are product/service showcases, not app listings)

## 3. Users

| Persona | Typical actions |
|---------|-----------------|
| Product manager / sales ops | Create products, prices, groups, taxonomy |
| Sales representative | Attach products to deals and contacts |
| Prospect (external) | Browse branded portal |
| Marketing | Portal branding, imagery, tags |
| Admin | Portal domains, published views, permissions |

## 4. Business objectives

- One accurate catalog feeding quotes, orders, and deals
- Easy findability via taxonomy and groups
- Prospect self-serve exploration without exposing internal CRM data

---

## 5. Functional requirements

### 5.1 Custom products

**Source capability:** Custom Products  
**Priority:** P0  
**ID:** PRD-FR-001

The solution shall support generating custom products with product codes, costs, cost to produce, special notes, and more. Products shall be filterable with unique filters and linkable to deals and contacts.

**User story**  
As a sales ops user, I want to create SKU-level products with cost and notes, then let AEs attach them to deals.

**Detailed requirements**

1. Product record fields include at least: name, product code/SKU (unique per org or per price book), description, status (active/inactive/draft), family/category, unit of measure, standard price, cost, cost to produce, currency, tax code, special notes, images, owner.
2. Custom fields from Platform Capabilities apply to Product.
3. Unique filters on list views: code, category, price range, active flag, custom attributes.
4. Link products to Opportunities (line items), Contacts (installed/interested), Accounts (installed base), Quotes, and Orders.
5. Inactive products cannot be added to new quotes/deals; historical line items remain.
6. Duplicate code warning/block configurable.

**Acceptance criteria**

- Creating a product with unique code succeeds; duplicate code is blocked or warned per setting.
- Filtering by category + active status returns the correct set.
- Adding a product to an opportunity creates a line item with price defaulted from catalog.
- Linking a product to a contact appears on both records.
- Cost and cost-to-produce can be field-level restricted from general sales roles.

---

### 5.2 Product catalog

**Source capability:** Product Catalog  
**Priority:** P0  
**ID:** PRD-FR-002

The solution shall facilitate a product catalog listing what the company offers, including pricing information, and a product taxonomy for classification.

**User story**  
As an AE building a quote, I want to browse a classified catalog with current prices, not a flat unsearchable list.

**Detailed requirements**

1. Catalog browse UI: taxonomy tree + search + product cards (image, name, code, price, tags).
2. Pricing: standard price, optional multiple price books (e.g. list, partner, region), validity dates, currency.
3. Taxonomy: hierarchical classification (category → subcategory → …) assignable to products; a product may have a primary category and optional additional classifications.
4. Published catalog vs internal-only products (visibility flag).
5. Bulk update prices via import; effective-dating optional (P1).
6. Catalog is the source of truth for quote/order product pickers.

**Acceptance criteria**

- Taxonomy navigation shows only products in that node (including descendants if configured).
- Price book selection changes displayed price.
- Unpublished products do not appear in the sales catalog picker but remain in admin list.
- Import updates prices with an error report for invalid rows.

---

### 5.3 Product groups

**Source capability:** Product Groups  
**Priority:** P1  
**ID:** PRD-FR-003

The solution shall group products based on custom or pre-defined attributes such as brand, category, etc., to structure and organize the catalog.

**User story**  
As a product manager, I want a “Brand = Acme / Category = Sensors” group to reuse in portals, price rules, and reports.

**Detailed requirements**

1. Pre-defined grouping dimensions: brand, category/taxonomy node, family, product type.
2. Custom grouping attributes (Platform custom fields or dedicated attributes).
3. Named Product Groups: static membership (picked SKUs) and/or dynamic rules (attribute filters).
4. Groups usable in: catalog filters, portals, reporting, eligibility for quotes, journey/workflow conditions.
5. A product may belong to multiple groups.

**Acceptance criteria**

- Dynamic group “brand = X and active” auto-includes a newly created matching product.
- Static group only contains explicitly added SKUs.
- Removing a product from a group does not delete the product.
- Reports can filter opportunities by product group.

---

### 5.4 Custom portals (product / service showcase)

**Source capability:** Custom Portals  
**Priority:** P1  
**ID:** PRD-FR-004

The solution shall allow creating branded portals using the CRM database for prospects to explore the company’s products and services. Views shall display records with images, tags, color codes, and more.

**User story**  
As marketing, I want a branded portal where prospects browse our services with images and tags, without seeing internal costs or other customers.

**Detailed requirements**

1. Multiple portals per org: name, custom domain or subdomain, branding (logo, colors, typography), login optional (public vs authenticated prospect).
2. Portal views bound to published products/services (and optionally other allowed objects) with cards: image, title, tags, color codes, short description, CTA (request demo / contact / add to quote request).
3. View builder: layout, filters visible to visitors, sort, featured items.
4. CTAs create Leads or Cases in CRM with portal attribution.
5. No internal fields (cost, cost to produce, internal notes) are exposed unless explicitly mapped to a public field.
6. SEO basics for public pages (title, meta) — P2.
7. Portal analytics: views, CTA conversions (Dashboard can consume).

**Acceptance criteria**

- A public visitor can browse only published portal items.
- Submitting “request demo” creates a lead with product interest and portal source.
- Changing portal brand colors/logo is visible on the live portal after publish.
- Authenticated prospect portal can show personalized views (e.g. products related to their account) without leaking other accounts’ data.
- Color codes and tags appear on cards as configured.

---

## 6. Data entities

| Entity | Purpose |
|--------|---------|
| Product | Sellable item/service |
| ProductCategory / TaxonomyNode | Classification tree |
| PriceBook / PriceBookEntry | Price lists and amounts |
| ProductGroup | Static or dynamic collection |
| ProductImage / Asset | Media for catalog and portal |
| Portal | Branded experience config |
| PortalView | Layout and published dataset |
| PortalCtaEvent | Lead/case attribution |

## 7. Integrations

| ID | Integration | Purpose |
|----|-------------|---------|
| PRD-INT-001 | Opportunities / Quotes / Orders | Line items |
| PRD-INT-002 | Leads | Portal CTAs |
| PRD-INT-003 | CDN / file storage | Images and portal assets |
| PRD-INT-004 | DNS / custom domains | Portal hostnames |
| PRD-INT-005 | Multi-currency (Platform) | Price books per currency |

## 8. Permissions and security

| ID | Requirement |
|----|-------------|
| PRD-SEC-001 | Cost and cost-to-produce are sensitive; default hidden from standard sales profiles. |
| PRD-SEC-002 | Portal tokens/sessions cannot access CRM APIs beyond published portal queries. |
| PRD-SEC-003 | Public portals are read-only except explicit CTA forms. |
| PRD-SEC-004 | Price book visibility can be limited by partner/account segment. |
| PRD-SEC-005 | Custom domain HTTPS is required for production portals. |

## 9. Non-functional requirements

| ID | Requirement |
|----|-------------|
| PRD-NFR-001 | Catalog search P95 < 1s for 50k products. |
| PRD-NFR-002 | Public portal TTFB P95 < 1s for cached catalog pages. |
| PRD-NFR-003 | Price changes are consistent across quote picker and catalog within 60s (or immediately if cache busted). |
| PRD-NFR-004 | Portal is responsive (mobile/desktop). |

## 10. Dependencies

| Module | Why |
|--------|-----|
| Opportunities / Deals | Product line items |
| Quotes, Orders, and Contracts | Quote/order product selection |
| Accounts and Contacts | Installed base / interest links; portal personalization |
| Leads | Portal capture |
| Dashboards | Portal and product performance |
| Platform | Custom fields, multi-currency, layouts |
| Documents | Product collateral attachments |
| Marketplace | Portal or catalog extensions; distinct from product showcase portals |

## 11. Traceability

| Source capability | Requirement IDs |
|-------------------|-----------------|
| Custom Portals | PRD-FR-004 |
| Custom Products | PRD-FR-001 |
| Product Catalog | PRD-FR-002 |
| Product Groups | PRD-FR-003 |
