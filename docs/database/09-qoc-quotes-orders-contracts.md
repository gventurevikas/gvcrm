# Quotes, Orders & Contracts — `gvcrm_qoc`

**Module:** QOC  
**Rules:** Issued invoices and signed contracts are **immutable snapshots**. Discount thresholds trigger WPA approvals.

---

## `commercial_templates`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `kind` | `ENUM('quote','order','invoice','contract','schedule')` | NO | | |
| `name` | `VARCHAR(128)` | NO | | |
| `body_html` | `MEDIUMTEXT` | YES | NULL | Merge template |
| `is_active` | `TINYINT(1)` | NO | 1 | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

---

## `quotes`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `quote_number` | `VARCHAR(32)` | NO | | Human-readable, unique per org |
| `status` | `ENUM('draft','presented','accepted','rejected','expired','converted')` | NO | `draft` | |
| `account_id` | `CHAR(26)` | YES | NULL | ACM |
| `contact_id` | `CHAR(26)` | YES | NULL | ACM |
| `opportunity_id` | `CHAR(26)` | YES | NULL | ODM |
| `owner_user_id` | `CHAR(26)` | YES | NULL | |
| `price_book_id` | `CHAR(26)` | YES | NULL | PRD |
| `currency_code` | `CHAR(3)` | NO | `USD` | |
| `subtotal` | `DECIMAL(18,4)` | NO | 0 | |
| `discount_total` | `DECIMAL(18,4)` | NO | 0 | |
| `tax_total` | `DECIMAL(18,4)` | NO | 0 | |
| `grand_total` | `DECIMAL(18,4)` | NO | 0 | |
| `valid_until` | `DATE` | YES | NULL | |
| `template_id` | `CHAR(26)` | YES | NULL | |
| `pdf_document_id` | `CHAR(26)` | YES | NULL | DOC snapshot |
| `public_token_hash` | `CHAR(64)` | YES | NULL | Customer-facing link |
| `notes` | `TEXT` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `updated_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**Indexes:** `PRIMARY (id)`, `UNIQUE uq_qoc_quote_num (org_id, quote_number)`, `INDEX idx_qoc_quote_opp (org_id, opportunity_id)`, `INDEX idx_qoc_quote_status (org_id, status)`  
**FK:** `template_id` → `commercial_templates` SET NULL

---

## `quote_lines`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `quote_id` | `CHAR(26)` | NO | | |
| `product_id` | `CHAR(26)` | YES | NULL | PRD |
| `name` | `VARCHAR(255)` | NO | | Snapshot |
| `quantity` | `DECIMAL(18,4)` | NO | 1 | |
| `unit_price` | `DECIMAL(18,4)` | NO | | |
| `discount_pct` | `DECIMAL(5,2)` | NO | 0 | |
| `tax_pct` | `DECIMAL(5,2)` | NO | 0 | |
| `amount` | `DECIMAL(18,4)` | NO | | |
| `sort_order` | `INT` | NO | 0 | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |

**FK:** `quote_id` → `quotes` CASCADE

---

## `orders`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `order_number` | `VARCHAR(32)` | NO | | |
| `status` | `ENUM('draft','confirmed','in_fulfillment','completed','cancelled')` | NO | `draft` | |
| `account_id` | `CHAR(26)` | YES | NULL | |
| `contact_id` | `CHAR(26)` | YES | NULL | |
| `opportunity_id` | `CHAR(26)` | YES | NULL | |
| `quote_id` | `CHAR(26)` | YES | NULL | Source quote |
| `owner_user_id` | `CHAR(26)` | YES | NULL | |
| `currency_code` | `CHAR(3)` | NO | `USD` | |
| `subtotal` | `DECIMAL(18,4)` | NO | 0 | |
| `tax_total` | `DECIMAL(18,4)` | NO | 0 | |
| `grand_total` | `DECIMAL(18,4)` | NO | 0 | |
| `segment` | `VARCHAR(64)` | YES | NULL | Order segmentation |
| `website_intake_id` | `CHAR(26)` | YES | NULL | |
| `notes` | `TEXT` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `updated_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**Indexes:** `UNIQUE uq_qoc_order_num (org_id, order_number)`, `INDEX idx_qoc_order_status (org_id, status, created_at)`  
**FK:** `quote_id` → `quotes` SET NULL

---

## `order_lines`

Same shape as `quote_lines` with `order_id` → `orders` CASCADE.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `order_id` | `CHAR(26)` | NO | | |
| `product_id` | `CHAR(26)` | YES | NULL | |
| `name` | `VARCHAR(255)` | NO | | |
| `quantity` | `DECIMAL(18,4)` | NO | 1 | |
| `unit_price` | `DECIMAL(18,4)` | NO | | |
| `discount_pct` | `DECIMAL(5,2)` | NO | 0 | |
| `amount` | `DECIMAL(18,4)` | NO | | |
| `sort_order` | `INT` | NO | 0 | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |

---

## `order_status_history`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `order_id` | `CHAR(26)` | NO | | |
| `from_status` | `VARCHAR(32)` | YES | NULL | |
| `to_status` | `VARCHAR(32)` | NO | | |
| `changed_by_user_id` | `CHAR(26)` | YES | NULL | |
| `note` | `VARCHAR(512)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |

**FK:** `order_id` → `orders` CASCADE

---

## `contracts`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `contract_number` | `VARCHAR(32)` | NO | | |
| `status` | `ENUM('draft','in_review','sent','signed','active','expired','cancelled')` | NO | `draft` | |
| `account_id` | `CHAR(26)` | YES | NULL | |
| `opportunity_id` | `CHAR(26)` | YES | NULL | |
| `order_id` | `CHAR(26)` | YES | NULL | |
| `owner_user_id` | `CHAR(26)` | YES | NULL | |
| `start_date` | `DATE` | YES | NULL | |
| `end_date` | `DATE` | YES | NULL | |
| `signed_at` | `DATETIME(3)` | YES | NULL | |
| `esign_provider` | `VARCHAR(32)` | YES | NULL | Marketplace eSign app |
| `esign_envelope_id` | `VARCHAR(128)` | YES | NULL | |
| `document_id` | `CHAR(26)` | YES | NULL | Immutable signed PDF in DOC |
| `is_immutable` | `TINYINT(1)` | NO | 0 | 1 after signed |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**UNIQUE:** `(org_id, contract_number)`

---

## `contract_amendments`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `contract_id` | `CHAR(26)` | NO | | |
| `amendment_number` | `INT` | NO | | |
| `summary` | `TEXT` | YES | NULL | |
| `document_id` | `CHAR(26)` | YES | NULL | |
| `effective_date` | `DATE` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |

**FK:** `contract_id` → `contracts` RESTRICT  
**UNIQUE:** `(contract_id, amendment_number)`

---

## `invoices`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `invoice_number` | `VARCHAR(32)` | NO | | |
| `status` | `ENUM('draft','issued','paid','partial','void','overdue')` | NO | `draft` | Issued+ = immutable snapshot |
| `account_id` | `CHAR(26)` | YES | NULL | |
| `order_id` | `CHAR(26)` | YES | NULL | |
| `currency_code` | `CHAR(3)` | NO | `USD` | |
| `subtotal` | `DECIMAL(18,4)` | NO | 0 | |
| `tax_total` | `DECIMAL(18,4)` | NO | 0 | |
| `grand_total` | `DECIMAL(18,4)` | NO | 0 | |
| `amount_paid` | `DECIMAL(18,4)` | NO | 0 | |
| `due_date` | `DATE` | YES | NULL | |
| `issued_at` | `DATETIME(3)` | YES | NULL | |
| `pdf_document_id` | `CHAR(26)` | YES | NULL | |
| `public_token_hash` | `CHAR(64)` | YES | NULL | Customer link — no other CRM data |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**UNIQUE:** `(org_id, invoice_number)`  
**FK:** `order_id` → `orders` SET NULL

---

## `invoice_lines`

Same pattern as quote lines; `invoice_id` → `invoices` CASCADE. After invoice `issued`, lines must not update (app enforcement).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `invoice_id` | `CHAR(26)` | NO | | |
| `name` | `VARCHAR(255)` | NO | | |
| `quantity` | `DECIMAL(18,4)` | NO | 1 | |
| `unit_price` | `DECIMAL(18,4)` | NO | | |
| `amount` | `DECIMAL(18,4)` | NO | | |
| `sort_order` | `INT` | NO | 0 | |
| `created_at` | `DATETIME(3)` | NO | | |

---

## `payments`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `invoice_id` | `CHAR(26)` | NO | | |
| `amount` | `DECIMAL(18,4)` | NO | | |
| `currency_code` | `CHAR(3)` | NO | `USD` | |
| `method` | `VARCHAR(32)` | YES | NULL | `ach`, `card`, `check`, `gateway` |
| `gateway_ref` | `VARCHAR(128)` | YES | NULL | |
| `paid_at` | `DATETIME(3)` | NO | | |
| `created_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |

**FK:** `invoice_id` → `invoices` RESTRICT

---

## `supply_schedules`

Supply and payment plan header.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `order_id` | `CHAR(26)` | YES | NULL | |
| `contract_id` | `CHAR(26)` | YES | NULL | |
| `name` | `VARCHAR(128)` | NO | | |
| `status` | `ENUM('draft','active','completed','cancelled')` | NO | `draft` | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |

**FK:** `order_id` → `orders` SET NULL, `contract_id` → `contracts` SET NULL

---

## `supply_schedule_lines`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `schedule_id` | `CHAR(26)` | NO | | |
| `line_kind` | `ENUM('supply','payment')` | NO | | |
| `due_on` | `DATE` | NO | | |
| `amount` | `DECIMAL(18,4)` | YES | NULL | Payment lines |
| `quantity` | `DECIMAL(18,4)` | YES | NULL | Supply lines |
| `description` | `VARCHAR(255)` | YES | NULL | |
| `status` | `ENUM('pending','done','skipped')` | NO | `pending` | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |

**FK:** `schedule_id` → `supply_schedules` CASCADE

---

## `website_order_intakes`

Signed webhook + idempotency for automatic orders.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `idempotency_key` | `VARCHAR(191)` | NO | | From website/e-comm |
| `payload_json` | `JSON` | NO | | Mapped fields |
| `status` | `ENUM('received','mapped','order_created','failed')` | NO | `received` | |
| `order_id` | `CHAR(26)` | YES | NULL | |
| `error_code` | `VARCHAR(64)` | YES | NULL | |
| `received_at` | `DATETIME(3)` | NO | | |
| `created_at` | `DATETIME(3)` | NO | | |

**UNIQUE:** `(org_id, idempotency_key)`  
**FK:** `order_id` → `orders` SET NULL
