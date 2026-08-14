# GVCRM Database Plan

This folder is the **physical data model** for GVCRM: every database, table, and column, with why it exists.

Product behavior lives in `docs/requirements/`. Runtime topology (one Angular app, independent modules, Facade, Access/RBAC) lives in `docs/dev-docs/`. This plan is what those modules persist.

---

## 1. Storage topology

| Store | Engine | Databases / schemas | Holds |
|-------|--------|---------------------|--------|
| **Identity** | MySQL 8 InnoDB, `utf8mb4` | `gvcrm_iam` | Users, orgs, passwords, RBAC, custom roles, module entitlements, sessions, IAM audit |
| **Domain** | MySQL 8 InnoDB, `utf8mb4` | One database **per module** (or one instance with separate DBs): `gvcrm_acm`, `gvcrm_led`, … | Module system of record |
| **Analytics / audit volume** | ClickHouse | `gvcrm_analytics` | `report_runs`, optional leaderboard/KPI snapshots, API usage facts |

**Rules**

1. Only `gvcrm_iam` stores password hashes and RBAC. Product modules never copy a users/roles table.
2. Modules **do not** foreign-key into another module’s database. They store the other record’s **id** (ULID) and call that module’s API/Facade.
3. `org_id` on every tenant row is an IAM org id (no cross-DB FK).
4. `owner_user_id` / `created_by_user_id` are IAM user ids (no cross-DB FK).
5. ClickHouse is **append-mostly**. It is not the system of record for CRM entities.

You may start with **one MySQL server** hosting all `gvcrm_*` databases. Split hosts when a module’s load or team ownership requires it. Table names stay the same.

---

## 2. Document index

| File | Database | Module |
|------|----------|--------|
| [00-conventions.md](./00-conventions.md) | all | IDs, tenancy, audit columns, types, indexes |
| [01-iam-access.md](./01-iam-access.md) | `gvcrm_iam` | Access — AuthN / AuthZ / RBAC / custom roles |
| [02-acm-accounts-contacts.md](./02-acm-accounts-contacts.md) | `gvcrm_acm` | Accounts, contacts, appointments |
| [03-ccm-communications.md](./03-ccm-communications.md) | `gvcrm_ccm` | Email, SMS, calls, consent, tracking |
| [04-dar-dashboards-reports.md](./04-dar-dashboards-reports.md) | `gvcrm_dar` | Dashboards, report definitions, schedules |
| [05-doc-documents.md](./05-doc-documents.md) | `gvcrm_doc` | Folders, files, versions, share links, playbooks |
| [06-led-leads.md](./06-led-leads.md) | `gvcrm_led` | Leads, scoring, assignment, Meta/LinkedIn ingest |
| [07-odm-opportunities.md](./07-odm-opportunities.md) | `gvcrm_odm` | Pipelines, deals, rotting, journeys |
| [08-prd-products.md](./08-prd-products.md) | `gvcrm_prd` | Products, price books, portals |
| [09-qoc-quotes-orders-contracts.md](./09-qoc-quotes-orders-contracts.md) | `gvcrm_qoc` | Quotes, orders, contracts, invoices, schedules |
| [10-plt-platform.md](./10-plt-platform.md) | `gvcrm_plt` | Metadata, sandbox, cases, notes, sharing, notifications, i18n, FX |
| [11-spm-sales-performance.md](./11-spm-sales-performance.md) | `gvcrm_spm` | Goals, forecasts, campaigns, gamification, leaderboards |
| [12-tcl-collaboration.md](./12-tcl-collaboration.md) | `gvcrm_tcl` | Feeds, chat, tags, groups, check-ins |
| [13-wpa-workflows.md](./13-wpa-workflows.md) | `gvcrm_wpa` | Sales processes, workflow, validation, approvals |
| [14-mkt-marketplace.md](./14-mkt-marketplace.md) | `gvcrm_mkt` | Listings, packages, installs, external stores |
| [15-aia-assistant.md](./15-aia-assistant.md) | `gvcrm_aia` | ChatGPT threads, tools, report drafts, usage |
| [16-ins-insurance.md](./16-ins-insurance.md) | `gvcrm_ins` | LOB, NPN, policies, households, appointments |
| [17-clickhouse-analytics.md](./17-clickhouse-analytics.md) | `gvcrm_analytics` | `report_runs` and high-volume snapshots |

---

## 3. How to read a table page

Each module file lists:

1. Database purpose and what must **not** live there
2. Entity relationship summary
3. Every table: purpose, columns (name, type, nullability, default, meaning), indexes, foreign keys, notes

Column types follow [00-conventions.md](./00-conventions.md). Standard tenant/audit columns are still listed on every table so the catalog is complete.

---

## 4. MVP physical slice

Ship first:

1. `gvcrm_iam` — full Access schema (required before any other module)
2. `gvcrm_dar` + ClickHouse `report_runs`
3. `gvcrm_led` (including ad ingest tables)
4. `gvcrm_acm` + `gvcrm_odm` as soon as conversion/pipeline is in scope
5. `gvcrm_ins` when the insurance pack is entitled

Other module databases can be empty schemas until that team starts.

---

## 5. Related docs

| Doc | Relationship |
|-----|----------------|
| `docs/requirements/*` | Business entities and FRs this model implements |
| `docs/plans/*` | Spiral SDLC plans that sequence these schemas |
| `docs/dev-docs/01-multi-project-platform.md` | One app, independent modules, Facade |
| `docs/dev-docs/10-mysql-identity.md` | IAM login flow (schema detail is **this** folder) |
| `docs/dev-docs/11-clickhouse-report-runs.md` | Report-run write path |
| `docs/dev-docs/14-central-access-rbac.md` | Custom roles and entitlements |
