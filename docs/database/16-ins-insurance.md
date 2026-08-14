# US Insurance pack — `gvcrm_ins`

**Module:** INS  
**Cross-refs:** ACM household accounts; LED state/LOB routing + TCPA; ODM pipelines (`new_business` / `cross_sell` / `renewal`); SPM/ClickHouse KPIs; DOC for ACORD/dec pages.

This is a **CRM book-of-business**, not a policy admin system (PAS). Policy numbers and NPN are sensitive PII.

---

## `org_insurance_profiles`

Agency vs carrier mode, licensed states, defaults.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `org_id` | `CHAR(26)` | NO | | PK — IAM org |
| `operating_mode` | `ENUM('independent_agency','captive_agency','mga_imo','carrier')` | NO | | Should align with IAM `orgs.org_kind` |
| `licensed_states_json` | `JSON` | NO | | `["TX","OK","NM"]` |
| `default_lob` | `VARCHAR(32)` | YES | NULL | |
| `default_timezone` | `VARCHAR(64)` | YES | NULL | |
| `tcpa_strict` | `TINYINT(1)` | NO | 1 | Enforce consent on all outbound incl. AIA |
| `pack_installed_at` | `DATETIME(3)` | YES | NULL | Idempotent install |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `updated_by_user_id` | `CHAR(26)` | YES | NULL | |

---

## `lines_of_business`

LOB catalog (system seed + org extras).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | YES | NULL | NULL = platform seed |
| `code` | `VARCHAR(32)` | NO | | `auto`, `home`, `life`, `health`, `commercial`, `umbrella`, … |
| `name` | `VARCHAR(128)` | NO | | |
| `is_active` | `TINYINT(1)` | NO | 1 | |
| `sort_order` | `INT` | NO | 0 | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |

**UNIQUE:** `(org_id, code)`

---

## `producer_profiles`

NPN, licenses, remote flag — one per IAM user in an insurance org.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `user_id` | `CHAR(26)` | NO | | IAM user |
| `npn` | `VARCHAR(16)` | YES | NULL | National Producer Number — sensitive |
| `is_remote` | `TINYINT(1)` | NO | 1 | Remote sales workspace |
| `hire_date` | `DATE` | YES | NULL | |
| `status` | `ENUM('active','leave','terminated')` | NO | `active` | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `updated_by_user_id` | `CHAR(26)` | YES | NULL | |

**UNIQUE:** `(org_id, user_id)`  
**Indexes:** `INDEX idx_ins_prod_npn (org_id, npn)`

---

## `producer_licenses`

State licenses / LOB appointments on the producer.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `producer_profile_id` | `CHAR(26)` | NO | | |
| `state` | `CHAR(2)` | NO | | |
| `lob_code` | `VARCHAR(32)` | YES | NULL | NULL = all LOBs in that state |
| `license_number` | `VARCHAR(64)` | YES | NULL | Sensitive |
| `expires_on` | `DATE` | YES | NULL | Expiry alerts |
| `document_id` | `CHAR(26)` | YES | NULL | License scan in DOC |
| `status` | `ENUM('active','expired','pending')` | NO | `active` | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |

**FK:** `producer_profile_id` → `producer_profiles` CASCADE  
**Indexes:** `INDEX idx_ins_lic_exp (org_id, expires_on)`, `UNIQUE uq_ins_lic (producer_profile_id, state, lob_code, license_number)`

---

## `carrier_appointments`

Agency ↔ carrier + LOB + status (and carrier-view of appointed agencies).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | Tenant that owns the row (agency or carrier) |
| `carrier_account_id` | `CHAR(26)` | YES | NULL | ACM account `type=carrier` |
| `agency_account_id` | `CHAR(26)` | YES | NULL | ACM account `type=agency` |
| `carrier_name` | `VARCHAR(255)` | YES | NULL | Snapshot if no account yet |
| `lob_code` | `VARCHAR(32)` | YES | NULL | |
| `status` | `ENUM('pending','active','terminated','suspended')` | NO | `pending` | |
| `appointed_on` | `DATE` | YES | NULL | |
| `terminated_on` | `DATE` | YES | NULL | |
| `external_appointment_id` | `VARCHAR(128)` | YES | NULL | Carrier portal id |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |

**Indexes:** `INDEX idx_ins_appt_org_status (org_id, status)`, `INDEX idx_ins_appt_carrier (org_id, carrier_account_id)`

Carriers see appointed-agency data only as configured (INS-SEC-001).

---

## `household_members`

Contact role on an insured household account (complements ACM `account_contact_roles`).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `account_id` | `CHAR(26)` | NO | | ACM household |
| `contact_id` | `CHAR(26)` | NO | | ACM contact |
| `relationship` | `VARCHAR(32)` | NO | | `primary_insured`, `spouse`, `dependent`, `driver`, … |
| `is_primary_named_insured` | `TINYINT(1)` | NO | 0 | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |

**UNIQUE:** `(org_id, account_id, contact_id, relationship)`  
**Indexes:** `INDEX idx_ins_hh_account (org_id, account_id)`

---

## `policies`

Book-of-business CRM record (not PAS).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `policy_number` | `VARCHAR(64)` | NO | | Sensitive PII |
| `status` | `ENUM('quoted','bound','in_force','pending_cancel','cancelled','expired','rewritten')` | NO | `quoted` | |
| `lob_code` | `VARCHAR(32)` | NO | | |
| `writing_state` | `CHAR(2)` | YES | NULL | |
| `account_id` | `CHAR(26)` | YES | NULL | Household / commercial account |
| `primary_contact_id` | `CHAR(26)` | YES | NULL | |
| `producer_user_id` | `CHAR(26)` | YES | NULL | Book owner |
| `carrier_appointment_id` | `CHAR(26)` | YES | NULL | |
| `opportunity_id` | `CHAR(26)` | YES | NULL | ODM source deal |
| `quote_id` | `CHAR(26)` | YES | NULL | QOC quote |
| `premium` | `DECIMAL(18,4)` | YES | NULL | Written / in-force premium |
| `currency_code` | `CHAR(3)` | NO | `USD` | |
| `effective_date` | `DATE` | YES | NULL | |
| `expiration_date` | `DATE` | YES | NULL | Renewal pipeline input |
| `cancellation_date` | `DATE` | YES | NULL | |
| `renewal_opportunity_id` | `CHAR(26)` | YES | NULL | ODM renewal deal |
| `source_system` | `VARCHAR(64)` | YES | NULL | AMS / rater import |
| `external_policy_id` | `VARCHAR(128)` | YES | NULL | PAS id if integrated |
| `notes` | `TEXT` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `updated_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**Indexes:** `PRIMARY (id)`, `UNIQUE uq_ins_pol_num (org_id, policy_number)`, `INDEX idx_ins_pol_producer (org_id, producer_user_id, status)`, `INDEX idx_ins_pol_exp (org_id, expiration_date)`, `INDEX idx_ins_pol_account (org_id, account_id)`, `INDEX idx_ins_pol_lob_state (org_id, lob_code, writing_state)`  
**FK:** `carrier_appointment_id` → `carrier_appointments` SET NULL

Producers see their book; principals see agency (INS-SEC-001) via owner + PLT shares.

---

## `insurance_kpi_snapshots`

Pre-aggregated D/W/M metrics header. Fact rows may live here or in ClickHouse `insurance_kpi_facts`.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `period` | `ENUM('daily','weekly','monthly')` | NO | | |
| `period_start` | `DATE` | NO | | |
| `period_end` | `DATE` | NO | | |
| `user_id` | `CHAR(26)` | YES | NULL | NULL = org total |
| `lob_code` | `VARCHAR(32)` | YES | NULL | |
| `state` | `CHAR(2)` | YES | NULL | |
| `premium_bound` | `DECIMAL(18,4)` | NO | 0 | |
| `policies_bound` | `INT` | NO | 0 | |
| `quotes_issued` | `INT` | NO | 0 | |
| `leads_worked` | `INT` | NO | 0 | |
| `computed_at` | `DATETIME(3)` | NO | | |

**UNIQUE:** `(org_id, period, period_start, user_id, lob_code, state)`  
Feeds SPM leaderboards (`kpi_code=premium_bound` etc.).

---

## Consent / DNC

Do **not** duplicate TCPA/DNC tables here. Use `gvcrm_ccm.communication_consents` and ACM contact DNC flags. INS profile `tcpa_strict` tells CCM/AIA to require opt-in.
