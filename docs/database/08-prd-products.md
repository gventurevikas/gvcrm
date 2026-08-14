# Products — `gvcrm_prd`

**Module:** PRD  
**Cross-refs:** ODM/QOC line items snapshot product name/price; portal CTAs create LED leads.

Cost fields are sensitive (PRD-SEC-001) — FLS via PLT + IAM.

---

## `product_categories`

Taxonomy tree.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `parent_id` | `CHAR(26)` | YES | NULL | |
| `name` | `VARCHAR(128)` | NO | | |
| `code` | `VARCHAR(64)` | YES | NULL | |
| `sort_order` | `INT` | NO | 0 | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**FK:** `parent_id` → `product_categories(id)` SET NULL  
**UNIQUE:** `(org_id, code)`

---

## `products`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `sku` | `VARCHAR(64)` | YES | NULL | |
| `name` | `VARCHAR(255)` | NO | | |
| `description` | `TEXT` | YES | NULL | |
| `product_type` | `ENUM('product','service','coverage','bundle')` | NO | `product` | Insurance coverages as `coverage` |
| `category_id` | `CHAR(26)` | YES | NULL | |
| `status` | `ENUM('draft','active','retired')` | NO | `draft` | |
| `lob` | `VARCHAR(32)` | YES | NULL | INS line |
| `cost` | `DECIMAL(18,4)` | YES | NULL | Sensitive |
| `cost_to_produce` | `DECIMAL(18,4)` | YES | NULL | Sensitive |
| `default_price` | `DECIMAL(18,4)` | YES | NULL | List price fallback |
| `currency_code` | `CHAR(3)` | NO | `USD` | |
| `is_taxable` | `TINYINT(1)` | NO | 1 | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `updated_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**Indexes:** `PRIMARY (id)`, `UNIQUE uq_prd_sku (org_id, sku)`, `INDEX idx_prd_org_status (org_id, status)`, `FULLTEXT ft_prd_name (name)`  
**FK:** `category_id` → `product_categories` SET NULL

---

## `price_books`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `name` | `VARCHAR(128)` | NO | | |
| `currency_code` | `CHAR(3)` | NO | `USD` | |
| `is_standard` | `TINYINT(1)` | NO | 0 | One standard per org+currency recommended |
| `is_active` | `TINYINT(1)` | NO | 1 | |
| `segment` | `VARCHAR(64)` | YES | NULL | Partner/account segment visibility |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

---

## `price_book_entries`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `price_book_id` | `CHAR(26)` | NO | | |
| `product_id` | `CHAR(26)` | NO | | |
| `list_price` | `DECIMAL(18,4)` | NO | | |
| `is_active` | `TINYINT(1)` | NO | 1 | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |

**FK:** `price_book_id` → `price_books` CASCADE, `product_id` → `products` CASCADE  
**UNIQUE:** `(price_book_id, product_id)`

---

## `product_groups`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `name` | `VARCHAR(128)` | NO | | |
| `kind` | `ENUM('static','dynamic')` | NO | `static` | Dynamic uses filter |
| `filter_json` | `JSON` | YES | NULL | Dynamic membership |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

---

## `product_group_members`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `product_group_id` | `CHAR(26)` | NO | | |
| `product_id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `created_at` | `DATETIME(3)` | NO | | |

**PK:** `(product_group_id, product_id)`  
**FK:** both CASCADE

---

## `product_images`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `product_id` | `CHAR(26)` | NO | | |
| `document_id` | `CHAR(26)` | YES | NULL | DOC storage |
| `cdn_url` | `VARCHAR(1024)` | YES | NULL | Public catalog URL |
| `alt_text` | `VARCHAR(255)` | YES | NULL | |
| `sort_order` | `INT` | NO | 0 | |
| `created_at` | `DATETIME(3)` | NO | | |

**FK:** `product_id` → `products` CASCADE

---

## `portals`

Branded product/service showcase (public or authenticated).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `name` | `VARCHAR(128)` | NO | | |
| `hostname` | `VARCHAR(255)` | YES | NULL | Custom domain; HTTPS required in prod |
| `status` | `ENUM('draft','live','disabled')` | NO | `draft` | |
| `branding_json` | `JSON` | YES | NULL | |
| `auth_mode` | `ENUM('public','token','sso')` | NO | `public` | Portal session ≠ CRM session |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**UNIQUE:** `(org_id, hostname)`

---

## `portal_views`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `portal_id` | `CHAR(26)` | NO | | |
| `name` | `VARCHAR(128)` | NO | | |
| `layout_json` | `JSON` | NO | | Published dataset + layout |
| `price_book_id` | `CHAR(26)` | YES | NULL | |
| `is_default` | `TINYINT(1)` | NO | 0 | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |

**FK:** `portal_id` → `portals` CASCADE, `price_book_id` → `price_books` SET NULL

---

## `portal_cta_events`

Lead/case attribution from portal CTAs.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `portal_id` | `CHAR(26)` | NO | | |
| `product_id` | `CHAR(26)` | YES | NULL | |
| `cta_type` | `VARCHAR(32)` | NO | | `request_quote`, `contact_us` |
| `lead_id` | `CHAR(26)` | YES | NULL | LED id created |
| `case_id` | `CHAR(26)` | YES | NULL | PLT case id |
| `payload_json` | `JSON` | YES | NULL | Form fields |
| `created_at` | `DATETIME(3)` | NO | | |

**Indexes:** `INDEX idx_prd_cta_portal (org_id, portal_id, created_at)`
