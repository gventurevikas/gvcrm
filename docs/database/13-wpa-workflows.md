# Workflows & Process Automation — `gvcrm_wpa`

**Module:** WPA  
**Rules:** Time-based queue is durable; webhook secrets encrypted; validation bypass is rare and audited.

---

## `sales_processes`

Visual process editor (may align 1:1 with an ODM pipeline or be independent).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `name` | `VARCHAR(128)` | NO | | |
| `object_api_name` | `VARCHAR(64)` | NO | `opportunity` | |
| `pipeline_id` | `CHAR(26)` | YES | NULL | ODM pipeline id (no FK) |
| `status` | `ENUM('draft','active','archived')` | NO | `draft` | |
| `canvas_json` | `JSON` | YES | NULL | Visual layout |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

---

## `process_stages`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `process_id` | `CHAR(26)` | NO | | |
| `name` | `VARCHAR(128)` | NO | | |
| `sort_order` | `INT` | NO | | |
| `exit_criteria_json` | `JSON` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |

**FK:** `process_id` → `sales_processes` CASCADE

---

## `workflow_templates`

Catalog starters.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | YES | NULL | NULL = system template |
| `code` | `VARCHAR(64)` | NO | | |
| `name` | `VARCHAR(128)` | NO | | |
| `description` | `TEXT` | YES | NULL | |
| `definition_json` | `JSON` | NO | | |
| `created_at` | `DATETIME(3)` | NO | | |

**UNIQUE:** `(org_id, code)`

---

## `workflow_rules`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `name` | `VARCHAR(128)` | NO | | |
| `object_api_name` | `VARCHAR(64)` | NO | | Trigger object |
| `trigger_on` | `ENUM('create','update','create_or_update','delete')` | NO | `create_or_update` | |
| `criteria_json` | `JSON` | NO | | |
| `is_active` | `TINYINT(1)` | NO | 0 | |
| `is_async` | `TINYINT(1)` | NO | 0 | Async within 5s if set |
| `template_id` | `CHAR(26)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**Indexes:** `INDEX idx_wpa_wf_obj (org_id, object_api_name, is_active)`  
**FK:** `template_id` → `workflow_templates` SET NULL

---

## `workflow_actions`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `rule_id` | `CHAR(26)` | NO | | |
| `sort_order` | `INT` | NO | 0 | |
| `action_type` | `VARCHAR(32)` | NO | | `update_field`, `email`, `sms`, `notify`, `webhook`, `create_task`, `enroll_journey` |
| `config_json` | `JSON` | NO | | Action payload; webhook URL + secret ref |
| `webhook_secret_encrypted` | `VARBINARY(512)` | YES | NULL | If action_type=webhook |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |

**FK:** `rule_id` → `workflow_rules` CASCADE

---

## `time_based_jobs`

Durable queue across deploys (WPA-NFR-002).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `rule_id` | `CHAR(26)` | YES | NULL | |
| `action_id` | `CHAR(26)` | YES | NULL | |
| `subject_type` | `VARCHAR(32)` | NO | | |
| `subject_id` | `CHAR(26)` | NO | | |
| `run_at` | `DATETIME(3)` | NO | | |
| `status` | `ENUM('pending','running','done','failed','cancelled')` | NO | `pending` | |
| `attempts` | `INT` | NO | 0 | |
| `last_error` | `VARCHAR(512)` | YES | NULL | |
| `idempotency_key` | `VARCHAR(191)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |

**Indexes:** `INDEX idx_wpa_tbj_due (status, run_at)`, `UNIQUE uq_wpa_tbj_idem (org_id, idempotency_key)`

---

## `validation_rules`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `name` | `VARCHAR(128)` | NO | | |
| `object_api_name` | `VARCHAR(64)` | NO | | |
| `formula_json` | `JSON` | NO | | Error when true |
| `error_message` | `VARCHAR(512)` | NO | | |
| `error_field` | `VARCHAR(64)` | YES | NULL | |
| `is_active` | `TINYINT(1)` | NO | 1 | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

Bypass permission is rare and fully audited (WPA-SEC-004) via `automation_logs`.

---

## `approval_processes`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `name` | `VARCHAR(128)` | NO | | |
| `object_api_name` | `VARCHAR(64)` | NO | | `opportunity`, `quote`, `document`, … |
| `entry_criteria_json` | `JSON` | YES | NULL | e.g. discount above threshold |
| `is_active` | `TINYINT(1)` | NO | 0 | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

---

## `approval_steps`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `process_id` | `CHAR(26)` | NO | | |
| `sort_order` | `INT` | NO | | |
| `name` | `VARCHAR(128)` | NO | | |
| `approver_type` | `ENUM('user','role','manager','group')` | NO | | |
| `approver_id` | `CHAR(26)` | YES | NULL | User/role/group id |
| `created_at` | `DATETIME(3)` | NO | | |

**FK:** `process_id` → `approval_processes` CASCADE

---

## `approval_requests`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `process_id` | `CHAR(26)` | NO | | |
| `subject_type` | `VARCHAR(32)` | NO | | |
| `subject_id` | `CHAR(26)` | NO | | |
| `status` | `ENUM('pending','approved','rejected','recalled')` | NO | `pending` | |
| `submitted_by_user_id` | `CHAR(26)` | NO | | |
| `comments` | `TEXT` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `resolved_at` | `DATETIME(3)` | YES | NULL | |

**FK:** `process_id` → `approval_processes` RESTRICT  
**Indexes:** `INDEX idx_wpa_appr_subj (org_id, subject_type, subject_id, status)`

---

## `approval_request_steps`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `request_id` | `CHAR(26)` | NO | | |
| `step_id` | `CHAR(26)` | NO | | |
| `approver_user_id` | `CHAR(26)` | YES | NULL | Resolved user (or delegate) |
| `status` | `ENUM('pending','approved','rejected','skipped')` | NO | `pending` | |
| `acted_at` | `DATETIME(3)` | YES | NULL | |
| `comment` | `TEXT` | YES | NULL | |

**FK:** `request_id` → `approval_requests` CASCADE, `step_id` → `approval_steps` RESTRICT

Only designated approvers or delegates may act (WPA-SEC-002).

---

## `automation_logs`

Debug and audit.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `kind` | `ENUM('workflow','validation','approval','time_based')` | NO | | |
| `rule_id` | `CHAR(26)` | YES | NULL | |
| `subject_type` | `VARCHAR(32)` | YES | NULL | |
| `subject_id` | `CHAR(26)` | YES | NULL | |
| `status` | `ENUM('ok','skipped','error')` | NO | | |
| `message` | `VARCHAR(512)` | YES | NULL | |
| `detail_json` | `JSON` | YES | NULL | No secrets |
| `created_at` | `DATETIME(3)` | NO | | |

**Indexes:** `INDEX idx_wpa_alog (org_id, created_at)`, `INDEX idx_wpa_alog_subj (org_id, subject_type, subject_id)`

---

## `automation_limit_snapshots`

Usage vs caps (governance).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `bucket_date` | `DATE` | NO | | |
| `workflow_fire_count` | `INT` | NO | 0 | |
| `email_action_count` | `INT` | NO | 0 | |
| `time_based_count` | `INT` | NO | 0 | |
| `cap_workflow_fire` | `INT` | YES | NULL | Org cap |
| `created_at` | `DATETIME(3)` | NO | | |

**UNIQUE:** `(org_id, bucket_date)`
