# Marketplace — `gvcrm_mkt`

**Module:** MKT  
**Rules:** Packages signed; tokens revoked on uninstall; publisher payout data encrypted; kill switch revokes app tokens globally.

---

## `publisher_accounts`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | YES | NULL | Internal publisher org; NULL = external ISV only |
| `name` | `VARCHAR(255)` | NO | | |
| `status` | `ENUM('pending','approved','suspended')` | NO | `pending` | |
| `website` | `VARCHAR(512)` | YES | NULL | |
| `payout_account_encrypted` | `VARBINARY(1024)` | YES | NULL | Tax/payout — restricted |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |

---

## `marketplace_listings`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `publisher_id` | `CHAR(26)` | NO | | |
| `slug` | `VARCHAR(128)` | NO | | Public URL key |
| `name` | `VARCHAR(255)` | NO | | |
| `summary` | `VARCHAR(512)` | YES | NULL | |
| `description` | `MEDIUMTEXT` | YES | NULL | |
| `visibility` | `ENUM('public','private','unlisted')` | NO | `private` | |
| `status` | `ENUM('draft','in_review','live','rejected','killed')` | NO | `draft` | Kill switch → `killed` |
| `category` | `VARCHAR(64)` | YES | NULL | |
| `icon_document_id` | `CHAR(26)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `published_at` | `DATETIME(3)` | YES | NULL | |

**FK:** `publisher_id` → `publisher_accounts` RESTRICT  
**UNIQUE:** `(slug)`  
**Indexes:** `INDEX idx_mkt_list_status (status, visibility, category)`

---

## `app_packages`

Immutable install artifact header.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `listing_id` | `CHAR(26)` | NO | | |
| `version` | `VARCHAR(32)` | NO | | Semver |
| `status` | `ENUM('uploaded','scanning','certified','rejected','yanked')` | NO | `uploaded` | |
| `storage_key` | `VARCHAR(512)` | NO | | Signed blob |
| `checksum_sha256` | `CHAR(64)` | NO | | Tamper check |
| `signature` | `TEXT` | YES | NULL | Package signature |
| `manifest_json` | `JSON` | NO | | Metadata components + scopes |
| `release_notes` | `TEXT` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |

**FK:** `listing_id` → `marketplace_listings` CASCADE  
**UNIQUE:** `(listing_id, version)`

`app_versions` is this table (one row per version).

---

## `listing_reviews`

Operator certification (security review before Live).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `listing_id` | `CHAR(26)` | NO | | |
| `package_id` | `CHAR(26)` | YES | NULL | |
| `reviewer_user_id` | `CHAR(26)` | YES | NULL | gvcrm_ops |
| `decision` | `ENUM('pending','approved','rejected')` | NO | `pending` | |
| `notes` | `TEXT` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |

**FK:** `listing_id` → `marketplace_listings` CASCADE, `package_id` → `app_packages` SET NULL

---

## `plans`

Commercial rights catalog.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `listing_id` | `CHAR(26)` | NO | | |
| `code` | `VARCHAR(64)` | NO | | `free`, `pro`, `enterprise` |
| `name` | `VARCHAR(128)` | NO | | |
| `billing_period` | `ENUM('free','monthly','yearly','one_time')` | NO | `free` | |
| `price` | `DECIMAL(18,4)` | NO | 0 | |
| `currency_code` | `CHAR(3)` | NO | `USD` | |
| `is_active` | `TINYINT(1)` | NO | 1 | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |

**FK:** `listing_id` → `marketplace_listings` CASCADE  
**UNIQUE:** `(listing_id, code)`

---

## `subscriptions`

Tenant entitlement to a listing/plan (`Entitlement` in requirements).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | Installing tenant |
| `listing_id` | `CHAR(26)` | NO | | |
| `plan_id` | `CHAR(26)` | YES | NULL | |
| `status` | `ENUM('trial','active','past_due','cancelled')` | NO | `trial` | |
| `external_billing_id` | `VARCHAR(128)` | YES | NULL | Stripe etc. |
| `starts_at` | `DATETIME(3)` | NO | | |
| `ends_at` | `DATETIME(3)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |

**Indexes:** `INDEX idx_mkt_sub_org (org_id, status)`  
**FK:** `listing_id` → `marketplace_listings` RESTRICT, `plan_id` → `plans` SET NULL

---

## `install_records`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `listing_id` | `CHAR(26)` | NO | | |
| `package_id` | `CHAR(26)` | NO | | Installed version |
| `environment` | `ENUM('sandbox','production')` | NO | `sandbox` | |
| `status` | `ENUM('installing','installed','failed','uninstalled')` | NO | `installing` | |
| `config_json` | `JSON` | YES | NULL | App settings (no secrets in plaintext) |
| `installed_by_user_id` | `CHAR(26)` | NO | | Org admin |
| `uninstalled_at` | `DATETIME(3)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |

**FK:** `package_id` → `app_packages` RESTRICT  
**Indexes:** `INDEX idx_mkt_install_org (org_id, status)`

Uninstall revokes tokens P95 < 30s (MKT-NFR-003).

---

## `review_ratings`

Customer feedback.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | Reviewer tenant |
| `listing_id` | `CHAR(26)` | NO | | |
| `user_id` | `CHAR(26)` | NO | | |
| `rating` | `TINYINT` | NO | | 1–5 |
| `title` | `VARCHAR(128)` | YES | NULL | |
| `body` | `TEXT` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |

**UNIQUE:** `(org_id, listing_id, user_id)`

---

## `external_marketplace_targets`

Store definition + schema (AppExchange, HubSpot, AppSource, …).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `code` | `VARCHAR(64)` | NO | | `appexchange`, `hubspot`, `appsource`, `google_workspace`, `slack` |
| `name` | `VARCHAR(128)` | NO | | |
| `schema_json` | `JSON` | YES | NULL | Required listing fields |
| `is_active` | `TINYINT(1)` | NO | 1 | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |

**UNIQUE:** `(code)`

---

## `external_listings`

GVCRM (or a connector) on an external store.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | YES | NULL | Publisher tenant |
| `listing_id` | `CHAR(26)` | YES | NULL | Internal listing being published out |
| `target_id` | `CHAR(26)` | NO | | |
| `external_listing_id` | `VARCHAR(128)` | YES | NULL | Id on the store |
| `status` | `ENUM('draft','submitted','live','rejected','unpublished')` | NO | `draft` | |
| `payload_json` | `JSON` | YES | NULL | Last submitted payload |
| `credentials_encrypted` | `VARBINARY(2048)` | YES | NULL | Store developer creds |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |

**FK:** `target_id` → `external_marketplace_targets` RESTRICT, `listing_id` → `marketplace_listings` SET NULL

---

## `compliance_artifacts`

Reusable security/legal files for store submissions.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | YES | NULL | |
| `listing_id` | `CHAR(26)` | YES | NULL | |
| `kind` | `VARCHAR(64)` | NO | | `soc2`, `privacy_policy`, `penetration_test` |
| `document_id` | `CHAR(26)` | NO | | DOC |
| `created_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |

---

## `oauth_clients`

Runtime integration for installed apps.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | Tenant that installed |
| `install_id` | `CHAR(26)` | NO | | |
| `client_id` | `VARCHAR(64)` | NO | | Public id |
| `client_secret_hash` | `CHAR(64)` | NO | | |
| `scopes_json` | `JSON` | NO | | Consented scopes |
| `status` | `ENUM('active','revoked')` | NO | `active` | Kill switch / uninstall |
| `created_at` | `DATETIME(3)` | NO | | |
| `revoked_at` | `DATETIME(3)` | YES | NULL | |

**FK:** `install_id` → `install_records` CASCADE  
**UNIQUE:** `(client_id)`

---

## `webhook_subscriptions`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `install_id` | `CHAR(26)` | NO | | |
| `url` | `VARCHAR(1024)` | NO | | |
| `events_json` | `JSON` | NO | | Subscribed event names |
| `secret_encrypted` | `VARBINARY(512)` | YES | NULL | |
| `status` | `ENUM('active','disabled')` | NO | `active` | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |

**FK:** `install_id` → `install_records` CASCADE
