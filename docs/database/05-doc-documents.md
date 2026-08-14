# Documents — `gvcrm_doc`

**Module:** DOC  
**Blobs:** object storage (S3-compatible); this DB holds metadata, ACLs, versions, share policy. Bytes are not in MySQL.

---

## `folders`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `parent_id` | `CHAR(26)` | YES | NULL | |
| `name` | `VARCHAR(255)` | NO | | |
| `owner_user_id` | `CHAR(26)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**FK:** `parent_id` → `folders(id)` SET NULL  
**Indexes:** `INDEX idx_doc_folders_org_parent (org_id, parent_id)`

---

## `folder_acls`

Repository ACL (most restrictive vs record sharing wins — DOC-SEC-001).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `folder_id` | `CHAR(26)` | NO | | |
| `grantee_type` | `ENUM('user','group','role')` | NO | | |
| `grantee_id` | `CHAR(26)` | NO | | |
| `access_level` | `ENUM('read','write','manage')` | NO | `read` | |
| `created_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |

**FK:** `folder_id` → `folders` CASCADE  
**UNIQUE:** `(folder_id, grantee_type, grantee_id)`

---

## `documents`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `folder_id` | `CHAR(26)` | YES | NULL | |
| `name` | `VARCHAR(255)` | NO | | Display filename |
| `status` | `ENUM('draft','active','archived')` | NO | `active` | |
| `mime_type` | `VARCHAR(128)` | YES | NULL | Latest version mime |
| `current_version_id` | `CHAR(26)` | YES | NULL | FK to `document_versions` (set after first upload) |
| `owner_user_id` | `CHAR(26)` | YES | NULL | |
| `description` | `TEXT` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `updated_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**Indexes:** `PRIMARY (id)`, `INDEX idx_doc_docs_org_folder (org_id, folder_id)`, `INDEX idx_doc_docs_name (org_id, name)`, `FULLTEXT ft_doc_name (name)`  
**FK:** `folder_id` → `folders` SET NULL

---

## `document_versions`

Immutable bytes pointer + conversion output.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `document_id` | `CHAR(26)` | NO | | |
| `version_number` | `INT` | NO | | 1, 2, 3… |
| `storage_key` | `VARCHAR(512)` | NO | | Object-store key (encrypted bucket) |
| `checksum_sha256` | `CHAR(64)` | YES | NULL | |
| `byte_size` | `BIGINT` | NO | | |
| `mime_type` | `VARCHAR(128)` | NO | | |
| `malware_scan_status` | `ENUM('pending','clean','infected','skipped')` | NO | `pending` | Upload gate |
| `preview_storage_key` | `VARCHAR(512)` | YES | NULL | Converted PDF/web preview |
| `preview_status` | `ENUM('none','pending','ready','failed')` | NO | `none` | |
| `created_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |

**FK:** `document_id` → `documents` CASCADE  
**UNIQUE:** `(document_id, version_number)`  
**Indexes:** `INDEX idx_doc_ver_scan (malware_scan_status, created_at)`

---

## `document_links`

Attach a document to a CRM record (lead, account, policy, …).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `document_id` | `CHAR(26)` | NO | | |
| `subject_type` | `VARCHAR(32)` | NO | | `account`, `contact`, `lead`, `opportunity`, `policy`, `quote`, … |
| `subject_id` | `CHAR(26)` | NO | | |
| `created_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |

**FK:** `document_id` → `documents` CASCADE  
**Indexes:** `UNIQUE uq_doc_link (org_id, document_id, subject_type, subject_id)`, `INDEX idx_doc_link_subject (org_id, subject_type, subject_id)`

---

## `share_links`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `document_id` | `CHAR(26)` | NO | | |
| `token_hash` | `CHAR(64)` | NO | | SHA-256 of secret token (raw token only in URL once) |
| `scope` | `ENUM('internal','external')` | NO | `external` | |
| `can_download` | `TINYINT(1)` | NO | 1 | |
| `can_print` | `TINYINT(1)` | NO | 1 | |
| `password_hash` | `VARCHAR(255)` | YES | NULL | Optional link password |
| `expires_at` | `DATETIME(3)` | YES | NULL | |
| `max_downloads` | `INT` | YES | NULL | |
| `download_count` | `INT` | NO | 0 | |
| `revoked_at` | `DATETIME(3)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |

**FK:** `document_id` → `documents` CASCADE  
**Indexes:** `UNIQUE uq_doc_share_token (token_hash)`, `INDEX idx_doc_share_doc (document_id)`

External viewers never receive a CRM session (DOC-SEC-004).

---

## `share_access_logs`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `share_link_id` | `CHAR(26)` | NO | | |
| `event_type` | `ENUM('view','download','denied','revoked')` | NO | | |
| `ip` | `VARCHAR(45)` | YES | NULL | |
| `user_agent` | `VARCHAR(512)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |

**FK:** `share_link_id` → `share_links` CASCADE  
**Indexes:** `INDEX idx_doc_share_log (share_link_id, created_at)`

---

## `playbooks`

Interactive sales/compliance checklist content.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `name` | `VARCHAR(255)` | NO | | |
| `description` | `TEXT` | YES | NULL | |
| `status` | `ENUM('draft','published','archived')` | NO | `draft` | |
| `definition_json` | `JSON` | NO | | Steps, branching, linked documents |
| `owner_user_id` | `CHAR(26)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

---

## `playbook_progress`

Per-record checklist state.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `playbook_id` | `CHAR(26)` | NO | | |
| `subject_type` | `VARCHAR(32)` | NO | | `opportunity`, `lead`, `account`, … |
| `subject_id` | `CHAR(26)` | NO | | |
| `status` | `ENUM('not_started','in_progress','completed')` | NO | `not_started` | |
| `progress_json` | `JSON` | NO | | Step id → done/skipped + user + time |
| `owner_user_id` | `CHAR(26)` | YES | NULL | |
| `completed_at` | `DATETIME(3)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |

**FK:** `playbook_id` → `playbooks` CASCADE  
**UNIQUE:** `(org_id, playbook_id, subject_type, subject_id)`
