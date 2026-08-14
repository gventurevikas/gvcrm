# Platform — `gvcrm_plt`

**Module:** PLT  
**Owns:** metadata (custom fields/layouts/modules/apps), sandbox/deploy, cases, notes, reminders, notifications, i18n, FX, **record sharing**, **record audit**.

This is the cross-cutting CRM platform database. IAM still owns users/roles; PLT owns **what a record looks like** and **who can see a given record**.

---

## `custom_fields`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `object_api_name` | `VARCHAR(64)` | NO | | `lead`, `account`, `opportunity`, `custom__foo` |
| `api_name` | `VARCHAR(64)` | NO | | `npn_c`, `household_size_c` |
| `label` | `VARCHAR(128)` | NO | | |
| `data_type` | `VARCHAR(32)` | NO | | `text`, `number`, `date`, `boolean`, `picklist`, `lookup`, … |
| `is_required` | `TINYINT(1)` | NO | 0 | |
| `is_unique` | `TINYINT(1)` | NO | 0 | |
| `config_json` | `JSON` | YES | NULL | Picklist values, lookup object, length |
| `fls_default` | `VARCHAR(16)` | YES | NULL | Default FLS hint |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**UNIQUE:** `(org_id, object_api_name, api_name)`  
Values for custom fields live in the owning module table as `custom_json` **or** in `custom_field_values` below.

---

## `custom_field_values`

EAV store when the owning module does not add a JSON column. Prefer `custom_json` on the record for MVP; use this for searchable indexed fields.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `field_id` | `CHAR(26)` | NO | | |
| `record_id` | `CHAR(26)` | NO | | |
| `value_text` | `TEXT` | YES | NULL | |
| `value_number` | `DECIMAL(18,6)` | YES | NULL | |
| `value_date` | `DATE` | YES | NULL | |
| `value_bool` | `TINYINT(1)` | YES | NULL | |
| `updated_at` | `DATETIME(3)` | NO | | |

**FK:** `field_id` → `custom_fields` CASCADE  
**UNIQUE:** `(field_id, record_id)`  
**Indexes:** `INDEX idx_plt_cfv_record (org_id, record_id)`

---

## `record_types`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `object_api_name` | `VARCHAR(64)` | NO | | |
| `name` | `VARCHAR(128)` | NO | | |
| `code` | `VARCHAR(64)` | NO | | |
| `is_default` | `TINYINT(1)` | NO | 0 | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**UNIQUE:** `(org_id, object_api_name, code)`

---

## `layouts`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `object_api_name` | `VARCHAR(64)` | NO | | |
| `record_type_id` | `CHAR(26)` | YES | NULL | |
| `name` | `VARCHAR(128)` | NO | | |
| `kind` | `ENUM('page','list','mobile')` | NO | `page` | |
| `definition_json` | `JSON` | NO | | Sections, fields, related lists |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**FK:** `record_type_id` → `record_types` SET NULL

---

## `custom_modules`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `api_name` | `VARCHAR(64)` | NO | | |
| `label` | `VARCHAR(128)` | NO | | |
| `label_plural` | `VARCHAR(128)` | NO | | |
| `sharing_default` | `ENUM('private','public_read','public_read_write')` | NO | `private` | PLT-SEC-004 |
| `status` | `ENUM('draft','active','deprecated')` | NO | `draft` | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**UNIQUE:** `(org_id, api_name)`

Custom module **rows** live in `custom_records`.

---

## `custom_records`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `module_id` | `CHAR(26)` | NO | | |
| `name` | `VARCHAR(255)` | YES | NULL | Display name |
| `owner_user_id` | `CHAR(26)` | YES | NULL | |
| `data_json` | `JSON` | NO | | Field values |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**FK:** `module_id` → `custom_modules` CASCADE  
**Indexes:** `INDEX idx_plt_crec_org_mod (org_id, module_id, updated_at)`

---

## `custom_apps`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `name` | `VARCHAR(128)` | NO | | |
| `nav_json` | `JSON` | YES | NULL | App launcher items |
| `status` | `ENUM('draft','active')` | NO | `draft` | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

---

## `metadata_packages`

Export/import/deploy unit (sandbox + Marketplace).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `name` | `VARCHAR(128)` | NO | | |
| `version` | `VARCHAR(32)` | NO | | Semver |
| `manifest_json` | `JSON` | NO | | Component list |
| `artifact_document_id` | `CHAR(26)` | YES | NULL | Signed zip in DOC |
| `created_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |

---

## `sandbox_environments`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | Production org id |
| `name` | `VARCHAR(128)` | NO | | |
| `kind` | `ENUM('metadata_only','partial_data','full')` | NO | `metadata_only` | |
| `status` | `ENUM('creating','ready','refreshing','failed','deleted')` | NO | `creating` | |
| `mask_pii` | `TINYINT(1)` | NO | 1 | Non-prod |
| `sandbox_org_id` | `CHAR(26)` | YES | NULL | Isolated IAM org clone |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |

---

## `deployment_jobs`

Sandbox → production promotion.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | Target prod org |
| `sandbox_id` | `CHAR(26)` | YES | NULL | |
| `package_id` | `CHAR(26)` | YES | NULL | |
| `status` | `ENUM('pending','running','succeeded','failed','cancelled')` | NO | `pending` | |
| `requires_dual_control` | `TINYINT(1)` | NO | 0 | |
| `approved_by_user_id` | `CHAR(26)` | YES | NULL | |
| `log_json` | `JSON` | YES | NULL | Per-component results |
| `started_at` | `DATETIME(3)` | YES | NULL | |
| `finished_at` | `DATETIME(3)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |

**FK:** `sandbox_id` → `sandbox_environments` SET NULL, `package_id` → `metadata_packages` SET NULL

---

## `list_views`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `object_api_name` | `VARCHAR(64)` | NO | | |
| `name` | `VARCHAR(128)` | NO | | |
| `filter_json` | `JSON` | NO | | |
| `columns_json` | `JSON` | YES | NULL | |
| `is_shared` | `TINYINT(1)` | NO | 0 | |
| `owner_user_id` | `CHAR(26)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

`filter_definitions` can be embedded in `filter_json` (no extra table required).

---

## `cases`

Support / feedback tracking.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `case_number` | `VARCHAR(32)` | NO | | |
| `subject` | `VARCHAR(255)` | NO | | |
| `description` | `TEXT` | YES | NULL | |
| `status` | `VARCHAR(32)` | NO | `new` | |
| `priority` | `ENUM('low','medium','high','urgent')` | NO | `medium` | |
| `account_id` | `CHAR(26)` | YES | NULL | |
| `contact_id` | `CHAR(26)` | YES | NULL | |
| `owner_user_id` | `CHAR(26)` | YES | NULL | |
| `origin` | `VARCHAR(32)` | YES | NULL | `email`, `web`, `phone`, `portal` |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**UNIQUE:** `(org_id, case_number)`

---

## `notes`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `subject_type` | `VARCHAR(32)` | NO | | |
| `subject_id` | `CHAR(26)` | NO | | |
| `body` | `MEDIUMTEXT` | YES | NULL | Text note |
| `audio_document_id` | `CHAR(26)` | YES | NULL | Optional audio |
| `transcript` | `MEDIUMTEXT` | YES | NULL | STT |
| `owner_user_id` | `CHAR(26)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**Indexes:** `INDEX idx_plt_notes_subject (org_id, subject_type, subject_id)`

---

## `reminders`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `user_id` | `CHAR(26)` | NO | | Who is reminded |
| `subject_type` | `VARCHAR(32)` | YES | NULL | |
| `subject_id` | `CHAR(26)` | YES | NULL | |
| `title` | `VARCHAR(255)` | NO | | |
| `due_at` | `DATETIME(3)` | NO | | |
| `status` | `ENUM('open','done','dismissed')` | NO | `open` | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |

**Indexes:** `INDEX idx_plt_remind_user_due (org_id, user_id, status, due_at)`

---

## `notifications`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `user_id` | `CHAR(26)` | NO | | Recipient |
| `channel` | `ENUM('in_app','email','push')` | NO | `in_app` | |
| `title` | `VARCHAR(255)` | NO | | Must not leak unauthorized fields |
| `body` | `TEXT` | YES | NULL | |
| `link_path` | `VARCHAR(512)` | YES | NULL | In-app route |
| `read_at` | `DATETIME(3)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |

**Indexes:** `INDEX idx_plt_notif_user (org_id, user_id, read_at, created_at)`

---

## `notification_preferences`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `user_id` | `CHAR(26)` | NO | | |
| `event_type` | `VARCHAR(64)` | NO | | `mention`, `assignment`, `approval`, … |
| `in_app` | `TINYINT(1)` | NO | 1 | |
| `email` | `TINYINT(1)` | NO | 1 | |
| `push` | `TINYINT(1)` | NO | 0 | |
| `updated_at` | `DATETIME(3)` | NO | | |

**UNIQUE:** `(org_id, user_id, event_type)`

---

## `language_packs` / `translations`

| Table | Purpose |
|-------|---------|
| `language_packs` | Installed locales per org (`locale`, `is_default`) |
| `translations` | `locale` + `msg_key` + `value` for UI strings |

### `language_packs`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `locale` | `VARCHAR(16)` | NO | | `en-US`, `es-US` |
| `is_default` | `TINYINT(1)` | NO | 0 | |
| `created_at` | `DATETIME(3)` | NO | | |

**UNIQUE:** `(org_id, locale)`

### `translations`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | YES | NULL | NULL = system pack |
| `locale` | `VARCHAR(16)` | NO | | |
| `msg_key` | `VARCHAR(191)` | NO | | |
| `value` | `TEXT` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |

**UNIQUE:** `(org_id, locale, msg_key)`

---

## `currencies` / `exchange_rates`

### `currencies`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `org_id` | `CHAR(26)` | NO | | |
| `code` | `CHAR(3)` | NO | | ISO 4217 |
| `name` | `VARCHAR(64)` | NO | | |
| `is_corporate` | `TINYINT(1)` | NO | 0 | Org corporate currency |
| `decimal_places` | `TINYINT` | NO | 2 | |
| `is_active` | `TINYINT(1)` | NO | 1 | |

**PK:** `(org_id, code)`

### `exchange_rates`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `from_code` | `CHAR(3)` | NO | | |
| `to_code` | `CHAR(3)` | NO | | |
| `rate` | `DECIMAL(18,8)` | NO | | |
| `effective_on` | `DATE` | NO | | |
| `source` | `VARCHAR(32)` | YES | NULL | Manual / FX feed |
| `created_at` | `DATETIME(3)` | NO | | |

**UNIQUE:** `(org_id, from_code, to_code, effective_on)`

---

## `record_shares`

Who can see a CRM record beyond owner. Used by ACM/LED/ODM/etc. Facades.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `object_api_name` | `VARCHAR(64)` | NO | | `lead`, `account`, `opportunity`, … |
| `record_id` | `CHAR(26)` | NO | | |
| `grantee_type` | `ENUM('user','group','role')` | NO | | `group` = TCL user group |
| `grantee_id` | `CHAR(26)` | NO | | |
| `access_level` | `ENUM('read','write','owner')` | NO | `read` | |
| `created_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |

**UNIQUE:** `(org_id, object_api_name, record_id, grantee_type, grantee_id)`  
**Indexes:** `INDEX idx_plt_share_grantee (org_id, grantee_type, grantee_id, object_api_name)`

---

## `record_audit_events`

CRUD / view-export audit for CRM records (ACM-NFR-004, merge, PII export).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `object_api_name` | `VARCHAR(64)` | NO | | |
| `record_id` | `CHAR(26)` | NO | | |
| `action` | `VARCHAR(32)` | NO | | `create`, `update`, `delete`, `merge`, `export`, `view_pii` |
| `actor_user_id` | `CHAR(26)` | YES | NULL | |
| `diff_json` | `JSON` | YES | NULL | Changed fields; redact secrets |
| `request_id` | `VARCHAR(36)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |

**Indexes:** `INDEX idx_plt_audit_rec (org_id, object_api_name, record_id, created_at)`, `INDEX idx_plt_audit_actor (org_id, actor_user_id, created_at)`

High volume: partition by month or move to ClickHouse later.
