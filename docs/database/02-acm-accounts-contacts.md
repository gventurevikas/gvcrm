# Accounts & Contacts — `gvcrm_acm`

**Module:** ACM  
**Cross-refs:** INS household/policy uses `account_id`; LED convert writes `account_id` / `contact_id`; ODM `opportunity.account_id`.

---

## Relationship summary

```text
accounts 1───* accounts (parent_account_id)
accounts *───* contacts (account_contact_roles)
contacts 1───* contacts (reports_to_contact_id)
accounts/contacts 1───0..1 geo_coordinates
users (IAM) ── scheduling_pages ── appointments *── appointment_attendees
```

---

## `accounts`

Household, agency, employer, or carrier account. Insurance **household** is `type=household` (INS).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | ULID PK |
| `org_id` | `CHAR(26)` | NO | | Tenant |
| `name` | `VARCHAR(255)` | NO | | Display / legal name |
| `type` | `VARCHAR(32)` | NO | `organization` | `household`, `organization`, `agency`, `carrier`, `partner`, `other` (org picklist may extend via PLT) |
| `status` | `ENUM('active','inactive','merged')` | NO | `active` | Merged accounts are read-only |
| `parent_account_id` | `CHAR(26)` | YES | NULL | Hierarchy parent (same org) |
| `owner_user_id` | `CHAR(26)` | YES | NULL | IAM producer / owner |
| `billing_street` | `VARCHAR(255)` | YES | NULL | |
| `billing_city` | `VARCHAR(128)` | YES | NULL | |
| `billing_state` | `CHAR(2)` | YES | NULL | US state |
| `billing_postal_code` | `VARCHAR(16)` | YES | NULL | ZIP |
| `billing_country` | `CHAR(2)` | NO | `US` | ISO 3166-1 alpha-2 |
| `shipping_street` | `VARCHAR(255)` | YES | NULL | |
| `shipping_city` | `VARCHAR(128)` | YES | NULL | |
| `shipping_state` | `CHAR(2)` | YES | NULL | |
| `shipping_postal_code` | `VARCHAR(16)` | YES | NULL | |
| `shipping_country` | `CHAR(2)` | YES | NULL | |
| `phone` | `VARCHAR(32)` | YES | NULL | E.164 |
| `website` | `VARCHAR(512)` | YES | NULL | |
| `industry` | `VARCHAR(64)` | YES | NULL | |
| `annual_revenue` | `DECIMAL(18,4)` | YES | NULL | |
| `currency_code` | `CHAR(3)` | NO | `USD` | |
| `description` | `TEXT` | YES | NULL | |
| `merged_into_account_id` | `CHAR(26)` | YES | NULL | When `status=merged` |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `updated_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**Indexes:** `PRIMARY (id)`, `INDEX idx_acm_accounts_org_name (org_id, name)`, `INDEX idx_acm_accounts_org_owner (org_id, owner_user_id)`, `INDEX idx_acm_accounts_parent (org_id, parent_account_id)`, `FULLTEXT ft_acm_accounts_name (name)`  
**FK:** `parent_account_id` → `accounts(id)` SET NULL, `merged_into_account_id` → `accounts(id)` SET NULL

---

## `contacts`

Person. May belong to multiple accounts via `account_contact_roles`.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | ULID PK |
| `org_id` | `CHAR(26)` | NO | | |
| `first_name` | `VARCHAR(128)` | NO | | |
| `last_name` | `VARCHAR(128)` | NO | | |
| `email` | `VARCHAR(255)` | YES | NULL | Lowercased |
| `phone` | `VARCHAR(32)` | YES | NULL | |
| `mobile` | `VARCHAR(32)` | YES | NULL | |
| `title` | `VARCHAR(128)` | YES | NULL | Job title |
| `department` | `VARCHAR(128)` | YES | NULL | |
| `timezone` | `VARCHAR(64)` | YES | NULL | |
| `preferred_channel` | `ENUM('email','phone','sms','any')` | YES | `any` | |
| `dnc_call` | `TINYINT(1)` | NO | 0 | Do-not-call flag (also enforced via CCM consent) |
| `dnc_sms` | `TINYINT(1)` | NO | 0 | |
| `dnc_email` | `TINYINT(1)` | NO | 0 | |
| `mailing_street` | `VARCHAR(255)` | YES | NULL | |
| `mailing_city` | `VARCHAR(128)` | YES | NULL | |
| `mailing_state` | `CHAR(2)` | YES | NULL | |
| `mailing_postal_code` | `VARCHAR(16)` | YES | NULL | |
| `mailing_country` | `CHAR(2)` | YES | `US` | |
| `reports_to_contact_id` | `CHAR(26)` | YES | NULL | Org chart |
| `owner_user_id` | `CHAR(26)` | YES | NULL | |
| `primary_account_id` | `CHAR(26)` | YES | NULL | Convenience FK for 360° page |
| `converted_from_lead_id` | `CHAR(26)` | YES | NULL | LED id (no FK) |
| `status` | `ENUM('active','inactive','merged')` | NO | `active` | |
| `merged_into_contact_id` | `CHAR(26)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `updated_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**Indexes:** `PRIMARY (id)`, `INDEX idx_acm_contacts_org_name (org_id, last_name, first_name)`, `INDEX idx_acm_contacts_org_email (org_id, email)`, `INDEX idx_acm_contacts_org_phone (org_id, phone)`, `INDEX idx_acm_contacts_owner (org_id, owner_user_id)`, `INDEX idx_acm_contacts_reports (reports_to_contact_id)`  
**FK:** `reports_to_contact_id` → `contacts(id)` SET NULL, `primary_account_id` → `accounts(id)` SET NULL, `merged_into_contact_id` → `contacts(id)` SET NULL

---

## `account_contact_roles`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `account_id` | `CHAR(26)` | NO | | |
| `contact_id` | `CHAR(26)` | NO | | |
| `role` | `VARCHAR(64)` | NO | | `decision_maker`, `spouse`, `insured`, `beneficiary`, `billing`, `other` |
| `is_primary` | `TINYINT(1)` | NO | 0 | One primary per account recommended |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |

**Indexes:** `PRIMARY (id)`, `UNIQUE uq_acm_acr (org_id, account_id, contact_id, role)`, `INDEX idx_acm_acr_contact (org_id, contact_id)`  
**FK:** `account_id` → `accounts` CASCADE, `contact_id` → `contacts` CASCADE

---

## `geo_coordinates`

Map pin for account or contact address (ACM-FR map).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `subject_type` | `ENUM('account','contact')` | NO | | |
| `subject_id` | `CHAR(26)` | NO | | Account or contact id |
| `latitude` | `DECIMAL(10,7)` | YES | NULL | |
| `longitude` | `DECIMAL(10,7)` | YES | NULL | |
| `geocode_status` | `ENUM('pending','ok','failed','skipped')` | NO | `pending` | |
| `provider` | `VARCHAR(32)` | YES | NULL | `google`, `mapbox`, … |
| `formatted_address` | `VARCHAR(512)` | YES | NULL | |
| `geocoded_at` | `DATETIME(3)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |

**Indexes:** `PRIMARY (id)`, `UNIQUE uq_acm_geo_subject (org_id, subject_type, subject_id)`, `INDEX idx_acm_geo_latlng (org_id, latitude, longitude)`

---

## `scheduling_pages`

Public booking page for a producer or group (remote sales).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `owner_user_id` | `CHAR(26)` | YES | NULL | Individual page; NULL if group page |
| `owner_group_id` | `CHAR(26)` | YES | NULL | TCL `user_groups.id` (no FK) |
| `slug` | `VARCHAR(64)` | NO | | Public path token; unguessable |
| `title` | `VARCHAR(128)` | NO | | |
| `branding_json` | `JSON` | YES | NULL | Logo, colors (no secrets) |
| `timezone` | `VARCHAR(64)` | NO | | |
| `buffer_before_min` | `INT` | NO | 0 | |
| `buffer_after_min` | `INT` | NO | 0 | |
| `status` | `ENUM('active','revoked')` | NO | `active` | Revoke old URLs |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `updated_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**Indexes:** `PRIMARY (id)`, `UNIQUE uq_acm_sched_slug (org_id, slug)`, `INDEX idx_acm_sched_owner (org_id, owner_user_id)`

---

## `scheduling_meeting_types`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `scheduling_page_id` | `CHAR(26)` | NO | | |
| `name` | `VARCHAR(128)` | NO | | e.g. “Discovery call” |
| `duration_min` | `INT` | NO | 30 | |
| `location_type` | `ENUM('phone','video','in_person')` | NO | `video` | |
| `video_provider` | `VARCHAR(32)` | YES | NULL | `meet`, `teams`, `zoom` |
| `is_active` | `TINYINT(1)` | NO | 1 | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |

**FK:** `scheduling_page_id` → `scheduling_pages` CASCADE

---

## `scheduling_availability_windows`

Weekly hours for a scheduling page.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `scheduling_page_id` | `CHAR(26)` | NO | | |
| `weekday` | `TINYINT` | NO | | 0=Sunday … 6=Saturday |
| `start_time` | `TIME` | NO | | Local to page timezone |
| `end_time` | `TIME` | NO | | |

**FK:** `scheduling_page_id` → `scheduling_pages` CASCADE  
**Indexes:** `INDEX idx_acm_avail (scheduling_page_id, weekday)`

---

## `appointments`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `scheduling_page_id` | `CHAR(26)` | YES | NULL | NULL if created internally |
| `meeting_type_id` | `CHAR(26)` | YES | NULL | |
| `title` | `VARCHAR(255)` | NO | | Internal title (never on public free/busy) |
| `appointment_kind` | `ENUM('individual','group')` | NO | `individual` | |
| `status` | `ENUM('scheduled','completed','cancelled','no_show')` | NO | `scheduled` | |
| `starts_at` | `DATETIME(3)` | NO | | UTC |
| `ends_at` | `DATETIME(3)` | NO | | UTC |
| `timezone` | `VARCHAR(64)` | NO | | |
| `location_text` | `VARCHAR(255)` | YES | NULL | |
| `video_url` | `VARCHAR(512)` | YES | NULL | |
| `account_id` | `CHAR(26)` | YES | NULL | |
| `contact_id` | `CHAR(26)` | YES | NULL | |
| `lead_id` | `CHAR(26)` | YES | NULL | LED id (no FK) |
| `host_user_id` | `CHAR(26)` | NO | | Primary host (IAM) |
| `external_calendar_event_id` | `VARCHAR(128)` | YES | NULL | Google/Outlook id |
| `notes` | `TEXT` | YES | NULL | Internal |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `updated_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**Indexes:** `PRIMARY (id)`, `INDEX idx_acm_appt_org_time (org_id, starts_at)`, `INDEX idx_acm_appt_host (org_id, host_user_id, starts_at)`, `INDEX idx_acm_appt_contact (org_id, contact_id)`  
**FK:** `account_id` → `accounts` SET NULL, `contact_id` → `contacts` SET NULL, `scheduling_page_id` → `scheduling_pages` SET NULL

---

## `appointment_attendees`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `appointment_id` | `CHAR(26)` | NO | | |
| `attendee_type` | `ENUM('user','contact','lead','email')` | NO | | |
| `user_id` | `CHAR(26)` | YES | NULL | IAM user |
| `contact_id` | `CHAR(26)` | YES | NULL | |
| `lead_id` | `CHAR(26)` | YES | NULL | |
| `email` | `VARCHAR(255)` | YES | NULL | Guest without CRM record |
| `response` | `ENUM('pending','accepted','declined','tentative')` | NO | `pending` | |
| `created_at` | `DATETIME(3)` | NO | | |

**FK:** `appointment_id` → `appointments` CASCADE  
**Indexes:** `UNIQUE uq_acm_attendee (appointment_id, attendee_type, user_id, contact_id, email)` — enforce uniqueness in app if NULLs complicate unique index
