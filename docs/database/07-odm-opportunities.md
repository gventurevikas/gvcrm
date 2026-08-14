# Opportunities / Deals — `gvcrm_odm`

**Module:** ODM  
**Cross-refs:** LED convert; PRD line items; QOC quotes; INS new business / cross-sell / renewal pipelines; WPA stage validation/approvals.

---

## `pipelines`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `name` | `VARCHAR(128)` | NO | | e.g. “New business — Auto” |
| `code` | `VARCHAR(64)` | YES | NULL | `new_business`, `cross_sell`, `renewal` |
| `is_active` | `TINYINT(1)` | NO | 1 | |
| `sort_order` | `INT` | NO | 0 | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**Indexes:** `UNIQUE uq_odm_pipe_code (org_id, code)`, `INDEX idx_odm_pipe_org (org_id, is_active)`

---

## `pipeline_stages`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `pipeline_id` | `CHAR(26)` | NO | | |
| `name` | `VARCHAR(128)` | NO | | |
| `sort_order` | `INT` | NO | | Kanban column order |
| `probability` | `DECIMAL(5,2)` | NO | 0 | Default win probability 0–100 |
| `forecast_category` | `ENUM('omitted','pipeline','best_case','commit','closed')` | NO | `pipeline` | |
| `is_won` | `TINYINT(1)` | NO | 0 | |
| `is_lost` | `TINYINT(1)` | NO | 0 | |
| `required_fields_json` | `JSON` | YES | NULL | Field API names required to enter stage |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |

**FK:** `pipeline_id` → `pipelines` CASCADE  
**Indexes:** `INDEX idx_odm_stage_pipe (pipeline_id, sort_order)`

---

## `opportunities`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `name` | `VARCHAR(255)` | NO | | |
| `pipeline_id` | `CHAR(26)` | NO | | |
| `stage_id` | `CHAR(26)` | NO | | |
| `amount` | `DECIMAL(18,4)` | YES | NULL | Expected premium / revenue |
| `currency_code` | `CHAR(3)` | NO | `USD` | |
| `probability` | `DECIMAL(5,2)` | YES | NULL | Override; NULL = stage default |
| `close_date` | `DATE` | YES | NULL | |
| `forecast_category` | `VARCHAR(32)` | YES | NULL | Override stage category |
| `account_id` | `CHAR(26)` | YES | NULL | ACM |
| `primary_contact_id` | `CHAR(26)` | YES | NULL | ACM |
| `lead_id` | `CHAR(26)` | YES | NULL | Source lead |
| `owner_user_id` | `CHAR(26)` | YES | NULL | |
| `lob` | `VARCHAR(32)` | YES | NULL | Insurance LOB |
| `deal_type` | `VARCHAR(32)` | YES | NULL | `new_business`, `cross_sell`, `renewal` |
| `lost_reason` | `VARCHAR(64)` | YES | NULL | |
| `next_step` | `VARCHAR(255)` | YES | NULL | |
| `description` | `TEXT` | YES | NULL | |
| `last_activity_at` | `DATETIME(3)` | YES | NULL | Rotting input |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `updated_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**Indexes:** `PRIMARY (id)`, `INDEX idx_odm_opp_org_pipe_stage (org_id, pipeline_id, stage_id)`, `INDEX idx_odm_opp_owner (org_id, owner_user_id, close_date)`, `INDEX idx_odm_opp_account (org_id, account_id)`, `INDEX idx_odm_opp_close (org_id, close_date)`  
**FK:** `pipeline_id` → `pipelines` RESTRICT, `stage_id` → `pipeline_stages` RESTRICT

---

## `opportunity_line_items`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `opportunity_id` | `CHAR(26)` | NO | | |
| `product_id` | `CHAR(26)` | YES | NULL | PRD id (no FK) |
| `product_name` | `VARCHAR(255)` | NO | | Snapshot |
| `quantity` | `DECIMAL(18,4)` | NO | 1 | |
| `unit_price` | `DECIMAL(18,4)` | NO | | |
| `discount_pct` | `DECIMAL(5,2)` | NO | 0 | |
| `amount` | `DECIMAL(18,4)` | NO | | Net line amount |
| `sort_order` | `INT` | NO | 0 | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |

**FK:** `opportunity_id` → `opportunities` CASCADE

---

## `opportunity_history`

Stage / amount / probability changes.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `opportunity_id` | `CHAR(26)` | NO | | |
| `from_stage_id` | `CHAR(26)` | YES | NULL | |
| `to_stage_id` | `CHAR(26)` | YES | NULL | |
| `from_amount` | `DECIMAL(18,4)` | YES | NULL | |
| `to_amount` | `DECIMAL(18,4)` | YES | NULL | |
| `from_probability` | `DECIMAL(5,2)` | YES | NULL | |
| `to_probability` | `DECIMAL(5,2)` | YES | NULL | |
| `changed_by_user_id` | `CHAR(26)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |

**FK:** `opportunity_id` → `opportunities` CASCADE  
**Indexes:** `INDEX idx_odm_hist (opportunity_id, created_at)`

---

## `rotting_rules`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `pipeline_id` | `CHAR(26)` | YES | NULL | NULL = all pipelines |
| `name` | `VARCHAR(128)` | NO | | |
| `idle_days` | `INT` | NO | | No activity / stage change |
| `severity` | `ENUM('watch','warning','critical')` | NO | `warning` | |
| `is_active` | `TINYINT(1)` | NO | 1 | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |

---

## `rotting_states`

Current highlight flags (recomputed by job or on read).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `opportunity_id` | `CHAR(26)` | NO | | |
| `rule_id` | `CHAR(26)` | NO | | |
| `severity` | `VARCHAR(16)` | NO | | |
| `idle_days` | `INT` | NO | | Snapshot |
| `flagged_at` | `DATETIME(3)` | NO | | |
| `cleared_at` | `DATETIME(3)` | YES | NULL | |

**FK:** `opportunity_id` → `opportunities` CASCADE, `rule_id` → `rotting_rules` CASCADE  
**UNIQUE:** `(opportunity_id, rule_id)` where `cleared_at IS NULL` (app or partial unique)

---

## `journeys`

Visual automation definition header.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `name` | `VARCHAR(128)` | NO | | |
| `status` | `ENUM('draft','published','archived')` | NO | `draft` | Publish permission ≠ edit |
| `published_version_id` | `CHAR(26)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

---

## `journey_versions`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `journey_id` | `CHAR(26)` | NO | | |
| `version_number` | `INT` | NO | | |
| `graph_json` | `JSON` | NO | | Nodes/edges (wait, email, update field, …) |
| `created_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |

**FK:** `journey_id` → `journeys` CASCADE  
**UNIQUE:** `(journey_id, version_number)`

---

## `journey_enrollments`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `journey_id` | `CHAR(26)` | NO | | |
| `journey_version_id` | `CHAR(26)` | NO | | |
| `opportunity_id` | `CHAR(26)` | NO | | |
| `status` | `ENUM('active','completed','exited','error')` | NO | `active` | |
| `current_node_id` | `VARCHAR(64)` | YES | NULL | Id inside `graph_json` |
| `state_json` | `JSON` | YES | NULL | Wait-until, counters |
| `started_at` | `DATETIME(3)` | NO | | |
| `ended_at` | `DATETIME(3)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |

**FK:** `opportunity_id` → `opportunities` CASCADE  
**Indexes:** `INDEX idx_odm_enroll_opp (opportunity_id, status)`

---

## `opportunity_followers`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `org_id` | `CHAR(26)` | NO | | |
| `opportunity_id` | `CHAR(26)` | NO | | |
| `user_id` | `CHAR(26)` | NO | | IAM user |
| `created_at` | `DATETIME(3)` | NO | | |

**PK:** `(opportunity_id, user_id)`  
**FK:** `opportunity_id` → `opportunities` CASCADE
