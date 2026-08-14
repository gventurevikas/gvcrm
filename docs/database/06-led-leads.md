# Leads — `gvcrm_led`

**Module:** LED  
**Cross-refs:** Meta/LinkedIn ingest (LED-FR-008); convert → ACM contact/account + optional ODM opportunity; CCM consent copied from ad forms.

---

## `leads`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | ULID PK |
| `org_id` | `CHAR(26)` | NO | | |
| `first_name` | `VARCHAR(128)` | YES | NULL | |
| `last_name` | `VARCHAR(128)` | YES | NULL | |
| `email` | `VARCHAR(255)` | YES | NULL | Lowercased |
| `phone` | `VARCHAR(32)` | YES | NULL | E.164 |
| `company` | `VARCHAR(255)` | YES | NULL | |
| `state` | `CHAR(2)` | YES | NULL | US state — routing + INS |
| `postal_code` | `VARCHAR(16)` | YES | NULL | |
| `country` | `CHAR(2)` | NO | `US` | |
| `lob_interest` | `VARCHAR(32)` | YES | NULL | `auto`, `home`, `life`, `health`, `commercial`, … |
| `source` | `VARCHAR(32)` | NO | `manual` | `manual`, `web_form`, `import`, `email_parser`, `card_scan`, `api`, `meta`, `linkedin`, `campaign` |
| `source_detail_json` | `JSON` | YES | NULL | `{ campaignId, formId, adId, pageId }` — no OAuth tokens |
| `status` | `VARCHAR(32)` | NO | `new` | Org lifecycle: `new`, `working`, `qualified`, `unqualified`, `converted`, … |
| `score` | `INT` | NO | 0 | Current total score |
| `owner_user_id` | `CHAR(26)` | YES | NULL | Assigned producer/ISA |
| `queue_id` | `CHAR(26)` | YES | NULL | Round-robin queue if unassigned/pool |
| `converted_account_id` | `CHAR(26)` | YES | NULL | ACM id after convert |
| `converted_contact_id` | `CHAR(26)` | YES | NULL | ACM id |
| `converted_opportunity_id` | `CHAR(26)` | YES | NULL | ODM id |
| `converted_at` | `DATETIME(3)` | YES | NULL | |
| `consent_email` | `TINYINT(1)` | NO | 0 | Snapshot; CCM `communication_consents` is SoR after sync |
| `consent_sms` | `TINYINT(1)` | NO | 0 | TCPA |
| `consent_call` | `TINYINT(1)` | NO | 0 | |
| `unqualified_reason` | `VARCHAR(64)` | YES | NULL | Win-loss / disqualify |
| `description` | `TEXT` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `updated_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**Indexes:** `PRIMARY (id)`, `INDEX idx_led_org_owner (org_id, owner_user_id, status)`, `INDEX idx_led_org_status_created (org_id, status, created_at)`, `INDEX idx_led_org_email (org_id, email)`, `INDEX idx_led_org_source (org_id, source, created_at)`, `INDEX idx_led_org_state_lob (org_id, state, lob_interest)`, `INDEX idx_led_queue (org_id, queue_id)`

---

## `lead_touches`

Attribution / multi-touch events (LeadSource).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `lead_id` | `CHAR(26)` | NO | | |
| `channel` | `VARCHAR(32)` | NO | | `meta`, `linkedin`, `web`, `email`, `phone`, `campaign` |
| `occurred_at` | `DATETIME(3)` | NO | | |
| `campaign_id` | `CHAR(26)` | YES | NULL | SPM campaign id (no FK) |
| `detail_json` | `JSON` | YES | NULL | UTM, ad ids |
| `created_at` | `DATETIME(3)` | NO | | |

**FK:** `lead_id` → `leads` CASCADE  
**Indexes:** `INDEX idx_led_touch_lead (lead_id, occurred_at)`

---

## `assignment_rules`

Ordered matching; first match wins. Concurrent-safe assignment in app (row locks on queue).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `name` | `VARCHAR(128)` | NO | | |
| `priority` | `INT` | NO | 100 | Lower runs first |
| `is_active` | `TINYINT(1)` | NO | 1 | |
| `criteria_json` | `JSON` | NO | | State, LOB, source, score, … |
| `action_type` | `ENUM('user','queue','round_robin')` | NO | `user` | |
| `target_user_id` | `CHAR(26)` | YES | NULL | When `action_type=user` |
| `target_queue_id` | `CHAR(26)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `updated_by_user_id` | `CHAR(26)` | YES | NULL | |

**Indexes:** `INDEX idx_led_assign_org_pri (org_id, is_active, priority)`

---

## `round_robin_queues`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `name` | `VARCHAR(128)` | NO | | e.g. “TX Auto remote ISAs” |
| `last_assigned_member_id` | `CHAR(26)` | YES | NULL | Pointer for next assign |
| `is_active` | `TINYINT(1)` | NO | 1 | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |

---

## `round_robin_queue_members`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `queue_id` | `CHAR(26)` | NO | | |
| `user_id` | `CHAR(26)` | NO | | IAM producer/ISA |
| `weight` | `INT` | NO | 1 | Weighted robin |
| `is_active` | `TINYINT(1)` | NO | 1 | Pause without delete |
| `created_at` | `DATETIME(3)` | NO | | |

**FK:** `queue_id` → `round_robin_queues` CASCADE  
**UNIQUE:** `(queue_id, user_id)`

---

## `scoring_rules`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `name` | `VARCHAR(128)` | NO | | |
| `points` | `INT` | NO | | Positive or negative |
| `criteria_json` | `JSON` | NO | | Field/event conditions |
| `is_active` | `TINYINT(1)` | NO | 1 | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |

---

## `score_breakdowns`

Per-lead rule contributions (explainability).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `lead_id` | `CHAR(26)` | NO | | |
| `rule_id` | `CHAR(26)` | NO | | |
| `points` | `INT` | NO | | |
| `applied_at` | `DATETIME(3)` | NO | | |

**FK:** `lead_id` → `leads` CASCADE, `rule_id` → `scoring_rules` RESTRICT  
**Indexes:** `INDEX idx_led_score_lead (lead_id)`

---

## `parser_inboxes`

Forward-to-lead email parser.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `address_local` | `VARCHAR(64)` | NO | | Unguessable local-part |
| `address_domain` | `VARCHAR(255)` | NO | | |
| `mapping_json` | `JSON` | NO | | Header/body → lead fields |
| `sender_allowlist_json` | `JSON` | YES | NULL | Allowed from-addresses |
| `is_active` | `TINYINT(1)` | NO | 1 | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |

**UNIQUE:** `(org_id, address_local, address_domain)`

---

## `card_scan_jobs`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `document_id` | `CHAR(26)` | YES | NULL | DOC image (PII; retention) |
| `status` | `ENUM('queued','processing','needs_review','synced','failed')` | NO | `queued` | |
| `ocr_json` | `JSON` | YES | NULL | Extracted fields |
| `lead_id` | `CHAR(26)` | YES | NULL | Created/updated lead |
| `error_code` | `VARCHAR(64)` | YES | NULL | |
| `owner_user_id` | `CHAR(26)` | NO | | Scanner user |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |

**Indexes:** `INDEX idx_led_scan_org_status (org_id, status)`

---

## `lead_outcome_snapshots`

Pre-aggregation for win-loss dashboard (optional; can be rebuilt).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `bucket_date` | `DATE` | NO | | |
| `source` | `VARCHAR(32)` | YES | NULL | |
| `lob_interest` | `VARCHAR(32)` | YES | NULL | |
| `owner_user_id` | `CHAR(26)` | YES | NULL | |
| `created_count` | `INT` | NO | 0 | |
| `converted_count` | `INT` | NO | 0 | |
| `unqualified_count` | `INT` | NO | 0 | |
| `created_at` | `DATETIME(3)` | NO | | |

**UNIQUE:** `(org_id, bucket_date, source, lob_interest, owner_user_id)`

---

## `ad_lead_connections`

Meta Lead Ads / LinkedIn Lead Gen OAuth + page/ad account config.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `provider` | `ENUM('meta','linkedin')` | NO | | |
| `name` | `VARCHAR(128)` | NO | | UI label |
| `status` | `ENUM('active','expired','revoked','error')` | NO | `active` | |
| `external_ad_account_id` | `VARCHAR(128)` | YES | NULL | |
| `external_page_id` | `VARCHAR(128)` | YES | NULL | Meta page / LinkedIn org |
| `external_form_ids_json` | `JSON` | YES | NULL | Subscribed form ids |
| `access_token_encrypted` | `VARBINARY(2048)` | YES | NULL | Least-privilege scopes |
| `refresh_token_encrypted` | `VARBINARY(2048)` | YES | NULL | |
| `webhook_verify_token_hash` | `CHAR(64)` | YES | NULL | |
| `last_success_at` | `DATETIME(3)` | YES | NULL | |
| `last_error` | `VARCHAR(512)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**Indexes:** `INDEX idx_led_adconn_org_provider (org_id, provider, status)`

---

## `ad_lead_ingest_events`

Provider payload + idempotency. Workers create/update `leads`.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `connection_id` | `CHAR(26)` | NO | | |
| `provider` | `ENUM('meta','linkedin')` | NO | | |
| `idempotency_key` | `VARCHAR(191)` | NO | | Provider leadgen id / formResponse id |
| `payload_encrypted` | `MEDIUMBLOB` | YES | NULL | Optional encrypted raw; prefer minimized JSON |
| `payload_json` | `JSON` | YES | NULL | Sanitized fields used for mapping |
| `status` | `ENUM('received','processed','duplicate','failed')` | NO | `received` | |
| `lead_id` | `CHAR(26)` | YES | NULL | Resulting lead |
| `error_code` | `VARCHAR(64)` | YES | NULL | |
| `received_at` | `DATETIME(3)` | NO | | |
| `processed_at` | `DATETIME(3)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |

**FK:** `connection_id` → `ad_lead_connections` RESTRICT  
**UNIQUE:** `uq_led_ingest_idem (org_id, provider, idempotency_key)`  
**Indexes:** `INDEX idx_led_ingest_status (org_id, status, received_at)`

Idempotency prevents double assign on webhook retries (LED-NFR-004).
