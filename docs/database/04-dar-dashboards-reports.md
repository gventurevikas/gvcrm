# Dashboards & Reports — `gvcrm_dar`

**Module:** DAR  
**Related:** ClickHouse `report_runs` ([17](./17-clickhouse-analytics.md)); AIA `report_spec_drafts` promote into `reports`.

This database stores **definitions and sharing**, not fact tables. Running a report queries other modules (via Facade/query engine) and **always** writes ClickHouse `report_runs`.

---

## `report_folders`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `parent_id` | `CHAR(26)` | YES | NULL | Nested folders |
| `name` | `VARCHAR(128)` | NO | | |
| `owner_user_id` | `CHAR(26)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**FK:** `parent_id` → `report_folders(id)` SET NULL

---

## `reports`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | Public report id (`report_id` in ClickHouse) |
| `org_id` | `CHAR(26)` | NO | | |
| `folder_id` | `CHAR(26)` | YES | NULL | |
| `name` | `VARCHAR(255)` | NO | | |
| `description` | `TEXT` | YES | NULL | |
| `kind` | `ENUM('prebuilt','custom','conversational')` | NO | `custom` | Conversational = saved from AIA |
| `source_object` | `VARCHAR(64)` | NO | | Primary object: `lead`, `opportunity`, `activity`, … |
| `definition_json` | `JSON` | NO | | Columns, filters, joins, aggregations, chart type — **not** raw SQL from end users |
| `chart_type` | `VARCHAR(32)` | YES | NULL | `bar`, `line`, `pie`, `table`, … |
| `is_prebuilt` | `TINYINT(1)` | NO | 0 | Seeded catalog |
| `prebuilt_code` | `VARCHAR(64)` | YES | NULL | Stable code for prebuilts (`win_loss`, `email_activity`) |
| `owner_user_id` | `CHAR(26)` | NO | | |
| `visibility` | `ENUM('private','org','shared')` | NO | `private` | Sharing rows refine `shared` |
| `created_from_thread_id` | `CHAR(26)` | YES | NULL | AIA thread id (no FK) |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `updated_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**Indexes:** `PRIMARY (id)`, `INDEX idx_dar_reports_org_owner (org_id, owner_user_id)`, `INDEX idx_dar_reports_folder (org_id, folder_id)`, `UNIQUE uq_dar_prebuilt (org_id, prebuilt_code)`  
**FK:** `folder_id` → `report_folders` SET NULL

`definition_json` is executed by the query engine with **RLS/FLS** of the runner (or audited “run as owner”).

---

## `report_shares`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `report_id` | `CHAR(26)` | NO | | |
| `grantee_type` | `ENUM('user','group','role')` | NO | | |
| `grantee_id` | `CHAR(26)` | NO | | IAM user / TCL group / IAM role id |
| `can_run` | `TINYINT(1)` | NO | 1 | |
| `can_edit` | `TINYINT(1)` | NO | 0 | |
| `run_as_owner` | `TINYINT(1)` | NO | 0 | Restricted + audited |
| `created_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |

**FK:** `report_id` → `reports` CASCADE  
**Indexes:** `UNIQUE uq_dar_rshare (report_id, grantee_type, grantee_id)`

Sharing a report does **not** grant record access (DAR-SEC-002).

---

## `dashboards`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `name` | `VARCHAR(255)` | NO | | |
| `kind` | `ENUM('homepage','prebuilt','custom')` | NO | `custom` | |
| `is_default_homepage` | `TINYINT(1)` | NO | 0 | At most one per user (enforced in app) or org default |
| `owner_user_id` | `CHAR(26)` | YES | NULL | NULL = org prebuilt |
| `layout_json` | `JSON` | YES | NULL | Grid layout if not using widget rows only |
| `visibility` | `ENUM('private','org','shared')` | NO | `private` | |
| `prebuilt_code` | `VARCHAR(64)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `updated_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**Indexes:** `PRIMARY (id)`, `INDEX idx_dar_dash_org_owner (org_id, owner_user_id)`, `UNIQUE uq_dar_dash_prebuilt (org_id, prebuilt_code)`

---

## `dashboard_widgets`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `dashboard_id` | `CHAR(26)` | NO | | |
| `widget_type` | `VARCHAR(32)` | NO | | `chart`, `kpi`, `table`, `leaderboard`, `assistant_pin` |
| `title` | `VARCHAR(128)` | YES | NULL | |
| `report_id` | `CHAR(26)` | YES | NULL | Bound report |
| `config_json` | `JSON` | YES | NULL | Position (x,y,w,h), KPI code, leaderboard period |
| `sort_order` | `INT` | NO | 0 | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |

**FK:** `dashboard_id` → `dashboards` CASCADE, `report_id` → `reports` SET NULL

---

## `dashboard_shares`

Same shape as `report_shares` with `dashboard_id` instead of `report_id`.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `dashboard_id` | `CHAR(26)` | NO | | |
| `grantee_type` | `ENUM('user','group','role')` | NO | | |
| `grantee_id` | `CHAR(26)` | NO | | |
| `can_edit` | `TINYINT(1)` | NO | 0 | |
| `created_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |

**FK:** `dashboard_id` → `dashboards` CASCADE  
**UNIQUE:** `(dashboard_id, grantee_type, grantee_id)`

---

## `kpi_definitions`

Reusable metric formulas for dashboards and SPM (SPM may copy or reference by `code`).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | YES | NULL | NULL = system KPI |
| `code` | `VARCHAR(64)` | NO | | `premium_bound`, `leads_worked`, `win_rate` |
| `name` | `VARCHAR(128)` | NO | | |
| `description` | `VARCHAR(512)` | YES | NULL | |
| `formula_json` | `JSON` | NO | | Object, filters, aggregation |
| `unit` | `VARCHAR(32)` | YES | NULL | `currency`, `count`, `percent` |
| `is_system` | `TINYINT(1)` | NO | 0 | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |

**Indexes:** `UNIQUE uq_dar_kpi (org_id, code)`

---

## `scheduled_deliveries`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `target_type` | `ENUM('report','dashboard')` | NO | | |
| `target_id` | `CHAR(26)` | NO | | |
| `cron_expr` | `VARCHAR(64)` | YES | NULL | Or use interval fields |
| `timezone` | `VARCHAR(64)` | NO | | |
| `format` | `ENUM('pdf','xlsx','csv','email_inline')` | NO | `pdf` | |
| `recipient_user_ids_json` | `JSON` | NO | | IAM user ids |
| `recipient_emails_json` | `JSON` | YES | NULL | External; permissioned |
| `status` | `ENUM('active','paused')` | NO | `active` | |
| `last_run_at` | `DATETIME(3)` | YES | NULL | |
| `last_run_id` | `CHAR(36)` | YES | NULL | ClickHouse `run_id` |
| `last_error` | `VARCHAR(512)` | YES | NULL | |
| `owner_user_id` | `CHAR(26)` | NO | | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**Indexes:** `PRIMARY (id)`, `INDEX idx_dar_sched_org_status (org_id, status)`

Each execution still writes ClickHouse `report_runs` with `source=schedule`.

---

## `api_usage_snapshots`

Hourly rollup for API usage dashboard (admin). Optional if ClickHouse `api_usage_hits` is queried live.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `bucket_start` | `DATETIME(3)` | NO | | Hour UTC |
| `app_code` | `VARCHAR(16)` | NO | | |
| `request_count` | `BIGINT` | NO | 0 | |
| `error_count` | `BIGINT` | NO | 0 | |
| `p95_duration_ms` | `INT` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |

**Indexes:** `PRIMARY (id)`, `UNIQUE uq_dar_api_snap (org_id, bucket_start, app_code)`

---

## `report_runs` (MySQL pointer, optional)

You may store a thin MySQL row for “my recent runs” UI if you do not want ClickHouse on the read path for the last N runs.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | Same as ClickHouse `run_id` (UUID stored as CHAR(36) if needed — prefer CHAR(36) UUID here to match CH) |
| `org_id` | `CHAR(26)` | NO | | |
| `report_id` | `CHAR(26)` | NO | | |
| `status` | `VARCHAR(16)` | NO | | |
| `source` | `VARCHAR(16)` | NO | | |
| `user_id` | `CHAR(26)` | NO | | |
| `started_at` | `DATETIME(3)` | NO | | |
| `finished_at` | `DATETIME(3)` | YES | NULL | |
| `row_count` | `BIGINT` | YES | NULL | |
| `error_code` | `VARCHAR(64)` | YES | NULL | |

**Recommendation:** ClickHouse is source of truth; skip MySQL duplicate unless latency requires it.
