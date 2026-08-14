# Database conventions

Applies to every MySQL `gvcrm_*` database and to ClickHouse where noted.

---

## 1. Identifiers

| Kind | Type | Format | Notes |
|------|------|--------|--------|
| Primary key | `CHAR(26)` | ULID (Crockford base32) | Time-sortable, fits in indexes better than UUID text |
| Cross-module / cross-DB reference | `CHAR(26)` | Same ULID | **No FK** across databases |
| Short codes | `VARCHAR(16)`–`VARCHAR(64)` | snake or dotted | Module ids (`led`), permission codes (`dar.reports.run`) |
| External provider ids | `VARCHAR(128)` | opaque | Meta leadgen id, LinkedIn form response id — always unique per org + provider |

Do not use auto-increment integers as public ids. Do not expose internal numeric PKs in APIs.

ClickHouse may store the same ids as `String`.

---

## 2. Multi-tenancy

Every tenant-owned row has:

| Column | Type | Meaning |
|--------|------|---------|
| `org_id` | `CHAR(26)` NOT NULL | IAM organization. All queries **must** filter by `org_id`. |

IAM tables `user_types`, `permissions`, `modules`, and **system** `roles` (`org_id` NULL) are global. Custom roles are org-scoped.

**Row-level security in SQL:** application always adds `WHERE org_id = ?`. Database users per module should not be able to `SELECT` other orgs’ rows if using a shared DB user — enforce in API + optional MySQL views later.

---

## 3. Standard columns (MySQL)

Listed on every business table unless the table is a pure junction or append-only log.

| Column | Type | Null | Default | Meaning |
|--------|------|------|---------|---------|
| `id` | `CHAR(26)` | NO | | ULID primary key |
| `org_id` | `CHAR(26)` | NO | | Tenant |
| `created_at` | `DATETIME(3)` | NO | | Insert time UTC |
| `updated_at` | `DATETIME(3)` | NO | | Last update UTC (application-set) |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | IAM user who created; NULL = system/automation |
| `updated_by_user_id` | `CHAR(26)` | YES | NULL | IAM user who last updated |
| `deleted_at` | `DATETIME(3)` | YES | NULL | Soft delete; NULL = live |

Hard-delete only: refresh tokens after expiry, ingest payloads after retention, ClickHouse partitions.

Automation / webhook rows may set `created_by_user_id` to an “automation user” id documented in IAM.

---

## 4. Types and enums

| Concept | MySQL type | Notes |
|---------|------------|--------|
| Money | `DECIMAL(18,4)` | Store in record currency; FX in `gvcrm_plt.exchange_rates` |
| Percent / probability | `DECIMAL(5,2)` | 0–100 |
| Boolean | `TINYINT(1)` | 0/1 |
| Closed status sets | `ENUM(...)` | Documented per table; adding a value is a migration |
| Open / org-defined labels | `VARCHAR` + lookup table | Do not use ENUM for custom picklists |
| Flexible maps | `JSON` | `source_detail`, widget config, journey graph — validate in app |
| Long body | `MEDIUMTEXT` | Email HTML, assistant messages |
| Email | `VARCHAR(255)` | Always stored lowercased for identity; display copy may differ |
| Phone | `VARCHAR(32)` | E.164 preferred (`+1…`) |
| US state | `CHAR(2)` | `TX`, `CA`; NULL if unknown |
| IANA timezone | `VARCHAR(64)` | e.g. `America/Chicago` |
| Locale | `VARCHAR(16)` | `en-US` |
| Currency code | `CHAR(3)` | ISO 4217 (`USD`) |
| IP | `VARCHAR(45)` | IPv4/IPv6 |

Timestamps are **UTC**. Display uses the user’s `timezone` (IAM) or org default.

---

## 5. Indexes

Minimum on tenant tables:

- `PRIMARY KEY (id)`
- `INDEX idx_{table}_org (org_id, created_at)`
- Unique business keys always include `org_id` (e.g. `UNIQUE (org_id, email)` on contacts if required)

Add covering indexes for list/filter screens (owner, status, LOB, pipeline stage). Document extra indexes on each table.

Full-text: MySQL `FULLTEXT` on name/email where useful; document search also uses an indexer (DOC, ACM NFR).

---

## 6. Foreign keys (within one database only)

- `ON DELETE RESTRICT` for money/legal parents (invoice → order)
- `ON DELETE CASCADE` for owned children (quote_lines → quotes)
- `ON DELETE SET NULL` for optional refs (contact.reports_to)

Never FK to `gvcrm_iam` or another module DB.

---

## 7. Sharing, FLS, and audit (cross-cutting)

| Concern | Where |
|---------|--------|
| Who may **open a module** | IAM `org_modules` / `user_modules` |
| Who may **perform an action** | IAM roles + permissions (including custom roles) |
| Who may **see a record** | Owner + `gvcrm_plt.record_shares` + group membership (TCL) |
| Field-level security | `gvcrm_plt.custom_fields` + layout + IAM permission codes |
| Auth/RBAC audit | `gvcrm_iam.iam_audit_events` |
| Record CRUD audit | `gvcrm_plt.record_audit_events` (or per-module `_audit` if volume demands) |
| Report execution audit | ClickHouse `report_runs` |

---

## 8. Naming

| Object | Pattern |
|--------|---------|
| Database | `gvcrm_{appCode}` e.g. `gvcrm_led` |
| Table | `snake_plural` e.g. `assignment_rules` |
| Junction | `{left}_{right}` e.g. `role_permissions` |
| Boolean column | `is_` / `has_` or domain flag `remote_producer` |
| Status column | `status` + ENUM |
| JSON column | `*_json` |

App codes: `iam`, `acm`, `ccm`, `dar`, `doc`, `led`, `odm`, `prd`, `qoc`, `plt`, `spm`, `tcl`, `wpa`, `mkt`, `aia`, `ins`.

---

## 9. Seed vs tenant data

| Seeded globally (migrations) | Tenant-created |
|------------------------------|----------------|
| `user_types`, `permissions`, `modules` | Users, orgs, custom roles |
| System `roles` (`kind=system`, `org_id` NULL) | Custom roles, assignments |
| Default LOB catalog (INS, copy-on-entitle optional) | Org insurance profile, policies |
| System KPI definitions (SPM/DAR) | Org goals, custom KPIs |

---

## 10. Character set and engine

```sql
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_0900_ai_ci
ENGINE=InnoDB
```

Row format: `DYNAMIC`. JSON columns require MySQL 8+.
