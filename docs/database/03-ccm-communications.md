# Customer Communication — `gvcrm_ccm`

**Module:** CCM  
**Cross-refs:** TCPA/DNC with INS + LED consent flags; SPM campaigns may send via these tables; AIA drafts email/SMS here.

OAuth tokens and SMTP secrets are **encrypted at rest** (`*_encrypted` columns). Never log them.

---

## `mailbox_connections`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `user_id` | `CHAR(26)` | YES | NULL | User mailbox; NULL = org shared mailbox |
| `provider` | `ENUM('gmail','microsoft','imap_smtp')` | NO | | |
| `email_address` | `VARCHAR(255)` | NO | | Connected address |
| `status` | `ENUM('active','expired','revoked','error')` | NO | `active` | |
| `access_token_encrypted` | `VARBINARY(2048)` | YES | NULL | |
| `refresh_token_encrypted` | `VARBINARY(2048)` | YES | NULL | |
| `smtp_host` | `VARCHAR(255)` | YES | NULL | IMAP/SMTP only |
| `smtp_port` | `INT` | YES | NULL | |
| `imap_host` | `VARCHAR(255)` | YES | NULL | |
| `imap_port` | `INT` | YES | NULL | |
| `secret_encrypted` | `VARBINARY(2048)` | YES | NULL | SMTP password |
| `last_sync_at` | `DATETIME(3)` | YES | NULL | |
| `last_error` | `VARCHAR(512)` | YES | NULL | Safe message |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**Indexes:** `PRIMARY (id)`, `INDEX idx_ccm_mbox_org_user (org_id, user_id)`, `UNIQUE uq_ccm_mbox_email (org_id, email_address)`

---

## `email_threads`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `subject` | `VARCHAR(998)` | YES | NULL | Latest subject |
| `mailbox_connection_id` | `CHAR(26)` | YES | NULL | |
| `account_id` | `CHAR(26)` | YES | NULL | ACM id |
| `contact_id` | `CHAR(26)` | YES | NULL | |
| `lead_id` | `CHAR(26)` | YES | NULL | |
| `opportunity_id` | `CHAR(26)` | YES | NULL | |
| `last_message_at` | `DATETIME(3)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |

**Indexes:** `PRIMARY (id)`, `INDEX idx_ccm_thread_org_last (org_id, last_message_at)`, `INDEX idx_ccm_thread_contact (org_id, contact_id)`

---

## `email_messages`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `thread_id` | `CHAR(26)` | YES | NULL | |
| `mailbox_connection_id` | `CHAR(26)` | YES | NULL | |
| `direction` | `ENUM('inbound','outbound')` | NO | | |
| `status` | `ENUM('draft','scheduled','sending','sent','failed','bounced','received')` | NO | `draft` | |
| `from_address` | `VARCHAR(255)` | NO | | |
| `to_addresses_json` | `JSON` | NO | | Array of emails |
| `cc_addresses_json` | `JSON` | YES | NULL | |
| `bcc_addresses_json` | `JSON` | YES | NULL | |
| `subject` | `VARCHAR(998)` | YES | NULL | |
| `body_text` | `MEDIUMTEXT` | YES | NULL | |
| `body_html` | `MEDIUMTEXT` | YES | NULL | |
| `provider_message_id` | `VARCHAR(256)` | YES | NULL | RFC Message-ID / Gmail id |
| `in_reply_to` | `VARCHAR(256)` | YES | NULL | |
| `scheduled_at` | `DATETIME(3)` | YES | NULL | |
| `sent_at` | `DATETIME(3)` | YES | NULL | |
| `template_id` | `CHAR(26)` | YES | NULL | |
| `mass_email_job_id` | `CHAR(26)` | YES | NULL | |
| `account_id` | `CHAR(26)` | YES | NULL | |
| `contact_id` | `CHAR(26)` | YES | NULL | |
| `lead_id` | `CHAR(26)` | YES | NULL | |
| `opportunity_id` | `CHAR(26)` | YES | NULL | |
| `owner_user_id` | `CHAR(26)` | YES | NULL | Sender / assignee |
| `tracking_enabled` | `TINYINT(1)` | NO | 0 | Open/click pixels |
| `error_code` | `VARCHAR(64)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**Indexes:** `PRIMARY (id)`, `INDEX idx_ccm_email_org_status (org_id, status, scheduled_at)`, `INDEX idx_ccm_email_thread (thread_id)`, `UNIQUE uq_ccm_email_provider (org_id, provider_message_id)`, `INDEX idx_ccm_email_lead (org_id, lead_id)`  
**FK:** `thread_id` → `email_threads` SET NULL

---

## `email_templates`

Reusable email (transactional vs marketing).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `name` | `VARCHAR(128)` | NO | | |
| `kind` | `ENUM('transactional','marketing','canned')` | NO | `transactional` | Mass send uses marketing; canned = composer snippets |
| `subject` | `VARCHAR(998)` | YES | NULL | Merge fields allowed |
| `body_html` | `MEDIUMTEXT` | YES | NULL | |
| `body_text` | `MEDIUMTEXT` | YES | NULL | |
| `is_active` | `TINYINT(1)` | NO | 1 | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `updated_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**Indexes:** `PRIMARY (id)`, `INDEX idx_ccm_tpl_org_kind (org_id, kind, name)`

`canned_responses` can be `kind=canned` here (no separate table required). If you prefer a dedicated table, same columns minus `subject`.

---

## `mass_email_jobs`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `name` | `VARCHAR(128)` | NO | | |
| `template_id` | `CHAR(26)` | YES | NULL | |
| `status` | `ENUM('draft','queued','running','paused','completed','failed','cancelled')` | NO | `draft` | Resumable |
| `audience_json` | `JSON` | NO | | List view / filter / ids (no extra PII dump) |
| `scheduled_at` | `DATETIME(3)` | YES | NULL | |
| `started_at` | `DATETIME(3)` | YES | NULL | |
| `finished_at` | `DATETIME(3)` | YES | NULL | |
| `total_count` | `INT` | NO | 0 | |
| `sent_count` | `INT` | NO | 0 | |
| `failed_count` | `INT` | NO | 0 | |
| `owner_user_id` | `CHAR(26)` | NO | | Requires `ccm.mass_email.send` |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |

**Indexes:** `PRIMARY (id)`, `INDEX idx_ccm_mass_org_status (org_id, status)`

---

## `mass_email_recipients`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `job_id` | `CHAR(26)` | NO | | |
| `email_message_id` | `CHAR(26)` | YES | NULL | Created outbound message |
| `contact_id` | `CHAR(26)` | YES | NULL | |
| `lead_id` | `CHAR(26)` | YES | NULL | |
| `email` | `VARCHAR(255)` | NO | | Snapshot at send time |
| `status` | `ENUM('pending','sent','skipped_consent','failed')` | NO | `pending` | |
| `error_code` | `VARCHAR(64)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |

**FK:** `job_id` → `mass_email_jobs` CASCADE  
**Indexes:** `INDEX idx_ccm_mass_rcp (job_id, status)`

---

## `call_activities`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `direction` | `ENUM('inbound','outbound')` | NO | | |
| `status` | `ENUM('scheduled','completed','missed','cancelled')` | NO | `scheduled` | |
| `scheduled_at` | `DATETIME(3)` | YES | NULL | Reminder time |
| `started_at` | `DATETIME(3)` | YES | NULL | |
| `ended_at` | `DATETIME(3)` | YES | NULL | |
| `duration_sec` | `INT` | YES | NULL | |
| `phone` | `VARCHAR(32)` | YES | NULL | |
| `outcome` | `VARCHAR(64)` | YES | NULL | Org picklist |
| `notes` | `TEXT` | YES | NULL | |
| `recording_document_id` | `CHAR(26)` | YES | NULL | DOC id if recording stored |
| `account_id` | `CHAR(26)` | YES | NULL | |
| `contact_id` | `CHAR(26)` | YES | NULL | |
| `lead_id` | `CHAR(26)` | YES | NULL | |
| `opportunity_id` | `CHAR(26)` | YES | NULL | |
| `owner_user_id` | `CHAR(26)` | NO | | |
| `reminder_at` | `DATETIME(3)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**Indexes:** `PRIMARY (id)`, `INDEX idx_ccm_call_org_sched (org_id, scheduled_at)`, `INDEX idx_ccm_call_owner (org_id, owner_user_id, status)`

---

## `call_tags`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `call_id` | `CHAR(26)` | NO | | |
| `tag` | `VARCHAR(64)` | NO | | |

**PK alternative:** `PRIMARY (id)`, `UNIQUE (call_id, tag)`  
**FK:** `call_id` → `call_activities` CASCADE

---

## `sms_messages`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `direction` | `ENUM('inbound','outbound')` | NO | | |
| `status` | `ENUM('draft','scheduled','queued','sent','delivered','failed','received')` | NO | `draft` | |
| `from_number` | `VARCHAR(32)` | YES | NULL | |
| `to_number` | `VARCHAR(32)` | NO | | E.164 |
| `body` | `VARCHAR(1600)` | NO | | |
| `provider` | `VARCHAR(32)` | YES | NULL | `twilio`, … |
| `provider_sid` | `VARCHAR(64)` | YES | NULL | Idempotency / webhook match |
| `template_id` | `CHAR(26)` | YES | NULL | |
| `scheduled_at` | `DATETIME(3)` | YES | NULL | |
| `sent_at` | `DATETIME(3)` | YES | NULL | |
| `delivered_at` | `DATETIME(3)` | YES | NULL | |
| `account_id` | `CHAR(26)` | YES | NULL | |
| `contact_id` | `CHAR(26)` | YES | NULL | |
| `lead_id` | `CHAR(26)` | YES | NULL | |
| `opportunity_id` | `CHAR(26)` | YES | NULL | |
| `owner_user_id` | `CHAR(26)` | YES | NULL | |
| `error_code` | `VARCHAR(64)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**Indexes:** `PRIMARY (id)`, `UNIQUE uq_ccm_sms_sid (org_id, provider_sid)`, `INDEX idx_ccm_sms_to (org_id, to_number, created_at)`, `INDEX idx_ccm_sms_sched (org_id, status, scheduled_at)`

---

## `sms_templates`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `name` | `VARCHAR(128)` | NO | | |
| `body` | `VARCHAR(1600)` | NO | | Merge fields |
| `is_active` | `TINYINT(1)` | NO | 1 | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

---

## `communication_consents`

Per-person, per-channel consent (TCPA / CAN-SPAM / DNC). LED ingest copies ad-form flags here.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `subject_type` | `ENUM('contact','lead')` | NO | | |
| `subject_id` | `CHAR(26)` | NO | | |
| `channel` | `ENUM('email','sms','call')` | NO | | |
| `status` | `ENUM('opt_in','opt_out','unknown')` | NO | `unknown` | Outbound allowed only if `opt_in` (or org policy) |
| `source` | `VARCHAR(64)` | YES | NULL | `web_form`, `meta_lead_ad`, `linkedin`, `manual`, `unsubscribe_link` |
| `evidence_json` | `JSON` | YES | NULL | Timestamp, IP, form id — no full payload dump |
| `captured_at` | `DATETIME(3)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `updated_by_user_id` | `CHAR(26)` | YES | NULL | |

**Indexes:** `PRIMARY (id)`, `UNIQUE uq_ccm_consent (org_id, subject_type, subject_id, channel)`

---

## `tracking_events`

Opens, clicks, bounces, SMS delivery (CCM analytics + DAR email/call reports).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `channel` | `ENUM('email','sms')` | NO | | |
| `message_id` | `CHAR(26)` | NO | | `email_messages.id` or `sms_messages.id` |
| `event_type` | `VARCHAR(32)` | NO | | `open`, `click`, `bounce`, `complaint`, `delivered`, `failed` |
| `url` | `VARCHAR(2048)` | YES | NULL | Clicked URL (wrapped) |
| `meta_json` | `JSON` | YES | NULL | User-agent, bounce code — sanitized |
| `occurred_at` | `DATETIME(3)` | NO | | |
| `created_at` | `DATETIME(3)` | NO | | |

**Indexes:** `PRIMARY (id)`, `INDEX idx_ccm_track_msg (org_id, message_id, event_type)`, `INDEX idx_ccm_track_time (org_id, occurred_at)`

High volume: optionally ship to ClickHouse later; MySQL is fine for MVP.
