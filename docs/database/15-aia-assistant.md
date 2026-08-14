# AI Assistant — `gvcrm_aia`

**Module:** AIA (ChatGPT central chat)  
**Rules:** Assistant never bypasses RBAC/sharing. PII to the model is minimized. Conversations follow org retention. Sandbox assistant cannot mutate production.

Report executions from chat still write ClickHouse `report_runs` with `source=assistant`.

---

## `assistant_org_settings`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `org_id` | `CHAR(26)` | NO | | PK |
| `is_enabled` | `TINYINT(1)` | NO | 1 | Kill switch |
| `model` | `VARCHAR(64)` | NO | | e.g. `gpt-4o-mini` (internal; UI may say ChatGPT) |
| `region` | `VARCHAR(32)` | YES | NULL | Vendor region option |
| `retention_days` | `INT` | YES | NULL | NULL = default policy |
| `allow_write_ops` | `TINYINT(1)` | NO | 1 | |
| `allow_mass_ops` | `TINYINT(1)` | NO | 0 | Extra confirm + permission |
| `role_allowlist_json` | `JSON` | YES | NULL | IAM role codes allowed to use assistant |
| `max_tokens_per_day` | `INT` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `updated_by_user_id` | `CHAR(26)` | YES | NULL | |

---

## `assistant_threads`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `owner_user_id` | `CHAR(26)` | NO | | |
| `title` | `VARCHAR(255)` | YES | NULL | Auto from first message |
| `status` | `ENUM('active','archived')` | NO | `active` | |
| `environment` | `ENUM('production','sandbox')` | NO | `production` | Must not cross-mutate |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**Indexes:** `INDEX idx_aia_thread_owner (org_id, owner_user_id, updated_at)`

---

## `assistant_messages`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `thread_id` | `CHAR(26)` | NO | | |
| `role` | `ENUM('user','assistant','system','tool')` | NO | | |
| `content` | `MEDIUMTEXT` | YES | NULL | User/assistant text |
| `token_count` | `INT` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |

**FK:** `thread_id` → `assistant_threads` CASCADE  
**Indexes:** `INDEX idx_aia_msg_thread (thread_id, created_at)`

---

## `assistant_context_chips`

Attached record, file, or module context.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `thread_id` | `CHAR(26)` | NO | | |
| `message_id` | `CHAR(26)` | YES | NULL | Optional pin to a message |
| `chip_type` | `ENUM('record','document','module','report')` | NO | | |
| `object_api_name` | `VARCHAR(64)` | YES | NULL | |
| `record_id` | `CHAR(26)` | YES | NULL | |
| `document_id` | `CHAR(26)` | YES | NULL | |
| `module_id` | `VARCHAR(16)` | YES | NULL | `led`, `dar`, … |
| `label` | `VARCHAR(255)` | NO | | UI chip text |
| `created_at` | `DATETIME(3)` | NO | | |

**FK:** `thread_id` → `assistant_threads` CASCADE, `message_id` → `assistant_messages` SET NULL

---

## `assistant_tool_calls`

Planned/executed GVCRM operations. Idempotent via `operation_id`.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `thread_id` | `CHAR(26)` | NO | | |
| `message_id` | `CHAR(26)` | YES | NULL | Assistant message that invoked the tool |
| `operation_id` | `CHAR(26)` | NO | | Client-generated idempotency id |
| `tool_name` | `VARCHAR(64)` | NO | | `crm.search`, `crm.update`, `dar.run_report`, `ccm.send_email` |
| `app_code` | `VARCHAR(16)` | YES | NULL | Target module |
| `request_json` | `JSON` | NO | | Minimized args (ids + needed fields) |
| `result_json` | `JSON` | YES | NULL | Authorized query results only |
| `status` | `ENUM('planned','preview','confirmed','executed','failed','cancelled')` | NO | `planned` | Preview/confirm for writes |
| `error_code` | `VARCHAR(64)` | YES | NULL | |
| `actor_user_id` | `CHAR(26)` | NO | | Always the human; never a privileged bot user |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |

**UNIQUE:** `(org_id, operation_id)`  
**FK:** `thread_id` → `assistant_threads` CASCADE  
**Indexes:** `INDEX idx_aia_tool_thread (thread_id, created_at)`

---

## `report_spec_drafts`

Conversational custom-report definition before save into DAR.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `thread_id` | `CHAR(26)` | NO | | |
| `owner_user_id` | `CHAR(26)` | NO | | |
| `title` | `VARCHAR(255)` | YES | NULL | |
| `spec_json` | `JSON` | NO | | Columns, filters, chart — same shape as DAR `definition_json` |
| `status` | `ENUM('draft','saved','discarded')` | NO | `draft` | |
| `saved_report_id` | `CHAR(26)` | YES | NULL | DAR `reports.id` after save |
| `last_run_id` | `CHAR(36)` | YES | NULL | ClickHouse run id |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |

**FK:** `thread_id` → `assistant_threads` CASCADE

---

## `assistant_usage_snapshots`

Token and operation telemetry (org admin dashboard).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `user_id` | `CHAR(26)` | YES | NULL | NULL = org rollup row |
| `bucket_start` | `DATETIME(3)` | NO | | Hour or day UTC |
| `prompt_tokens` | `BIGINT` | NO | 0 | |
| `completion_tokens` | `BIGINT` | NO | 0 | |
| `tool_call_count` | `INT` | NO | 0 | |
| `write_op_count` | `INT` | NO | 0 | |
| `created_at` | `DATETIME(3)` | NO | | |

**UNIQUE:** `(org_id, user_id, bucket_start)`

---

## `assistant_audit_events`

Immutable log of writes / dangerous ops (AIA-FR audit).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `thread_id` | `CHAR(26)` | YES | NULL | |
| `tool_call_id` | `CHAR(26)` | YES | NULL | |
| `actor_user_id` | `CHAR(26)` | NO | | |
| `action` | `VARCHAR(64)` | NO | | `record.update`, `email.send`, `report.run`, `deploy.blocked` |
| `object_api_name` | `VARCHAR(64)` | YES | NULL | |
| `record_id` | `CHAR(26)` | YES | NULL | |
| `payload_json` | `JSON` | YES | NULL | Redacted |
| `created_at` | `DATETIME(3)` | NO | | |

**Indexes:** `INDEX idx_aia_audit_org_time (org_id, created_at)`, `INDEX idx_aia_audit_actor (org_id, actor_user_id, created_at)`  
Retention ≥ conversation / eDiscovery policy.
