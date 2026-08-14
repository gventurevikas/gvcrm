# IAM / Access — `gvcrm_iam`

**Module:** Access (`iam`) — `gvcrm-access-api`  
**Engine:** MySQL 8  
**Owns:** authentication, authorization, RBAC, custom roles, module entitlements, sessions  
**Must not store:** leads, deals, report facts, documents, insurance policies

This is the **only** database with password hashes. Every other module trusts JWT claims issued from these tables.

Requirements: `docs/dev-docs/14-central-access-rbac.md`, `docs/dev-docs/10-mysql-identity.md`.

---

## Relationship summary

```text
user_types 1───* users *───* orgs (via org_members)
                 │                │
                 │                ├─ org auth policy (require_mfa, …)
                 ├─ user_mfa_methods (sms_otp, totp)
                 ├─ user_mfa_recovery_codes
                 ├─ auth_challenges
                 └─ trusted_devices
                              │
                 ┌────────────┼────────────┐
                 ▼            ▼            ▼
           org_modules    user_roles   user_modules
                 │            │
              modules       roles *───* permissions
                              │         (via role_permissions)
                     kind=system (org_id NULL)
                     kind=custom (org_id = org)
```

Effective permissions for `(user, org)` = union of permissions on all **active** assigned roles (system + custom).  
Effective modules = `org_modules` ∩ (`user_modules` if any rows exist for that user+org, else all org modules).  
Login factors: **password** + optional **SMS OTP** and/or **Google Authenticator (TOTP)** per `docs/requirements/00-access-authentication-and-mfa.md`.

---

## `user_types`

Coarse classification of a person (UI defaults, not authorization). Authorization is **roles**.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | ULID PK |
| `code` | `VARCHAR(64)` | NO | | Stable code: `producer`, `isa`, `principal`, `admin`, `partner`, `gvcrm_ops` |
| `name` | `VARCHAR(128)` | NO | | Display name |
| `description` | `VARCHAR(512)` | YES | NULL | Help text in Access UI |
| `sort_order` | `INT` | NO | 0 | Access picker order |
| `is_system` | `TINYINT(1)` | NO | 1 | 1 = seeded; cannot delete |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |

**Indexes:** `PRIMARY (id)`, `UNIQUE uq_user_types_code (code)`

Seeded rows are required before the first user insert.

---

## `users`

Interactive login principal. Email is globally unique (one human, many orgs via `org_members`).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | ULID PK — appears in every module as `*_user_id` |
| `email` | `VARCHAR(255)` | NO | | Lowercased login email |
| `password_hash` | `VARCHAR(255)` | NO | | argon2id or bcrypt; never plaintext; never log |
| `display_name` | `VARCHAR(255)` | NO | | UI name |
| `user_type_id` | `CHAR(26)` | NO | | FK → `user_types.id` (default type; org may still assign any roles) |
| `status` | `ENUM('invited','active','disabled')` | NO | `invited` | Only `active` may login |
| `timezone` | `VARCHAR(64)` | NO | `America/Chicago` | IANA tz for UI and schedules |
| `locale` | `VARCHAR(16)` | NO | `en-US` | UI language preference |
| `avatar_document_id` | `CHAR(26)` | YES | NULL | Optional DOC id (no FK) |
| `email_verified_at` | `DATETIME(3)` | YES | NULL | NULL = cannot access product modules when org requires verify |
| `phone_e164` | `VARCHAR(20)` | YES | NULL | Mobile in E.164; required before SMS MFA |
| `phone_verified_at` | `DATETIME(3)` | YES | NULL | Set after SMS phone-verify OTP succeeds |
| `mfa_enabled` | `TINYINT(1)` | NO | 0 | 1 when at least one active MFA method (`sms_otp` and/or `totp`) |
| `mfa_primary_method` | `ENUM('sms_otp','totp')` | YES | NULL | Default challenge method when multiple enrolled |
| `failed_login_count` | `INT` | NO | 0 | Consecutive failures; reset on success |
| `locked_until` | `DATETIME(3)` | YES | NULL | Login rejected until this time |
| `last_login_at` | `DATETIME(3)` | YES | NULL | Last successful full login (all factors) |
| `invited_at` | `DATETIME(3)` | YES | NULL | When invite was sent |
| `activated_at` | `DATETIME(3)` | YES | NULL | When status became active |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | Soft delete; email unique still applies to live rows only (use unique on `(email)` where `deleted_at IS NULL` via generated column or app check) |

**Indexes:** `PRIMARY (id)`, `UNIQUE uq_users_email (email)`, `UNIQUE uq_users_phone (phone_e164)` (allow multiple NULLs), `INDEX idx_users_type (user_type_id)`, `INDEX idx_users_status (status)`

**FK:** `user_type_id` → `user_types(id)` RESTRICT

**Note:** TOTP secrets and per-method state live in `user_mfa_methods` (not a single column on `users`) so SMS and Authenticator can coexist.

---

## `orgs`

Tenant: independent agency, captive, MGA/IMO, carrier, or other.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | ULID PK — every domain `org_id` |
| `name` | `VARCHAR(255)` | NO | | Legal / trading name |
| `org_kind` | `ENUM('independent_agency','captive_agency','mga_imo','carrier','other')` | NO | | Insurance-oriented tenant class (INS pack reads this) |
| `status` | `ENUM('active','suspended')` | NO | `active` | Suspended orgs cannot login |
| `default_timezone` | `VARCHAR(64)` | NO | `America/Chicago` | Fallback when user tz missing |
| `default_currency` | `CHAR(3)` | NO | `USD` | Commercial default |
| `default_locale` | `VARCHAR(16)` | NO | `en-US` | |
| `primary_state` | `CHAR(2)` | YES | NULL | HQ / domicile US state |
| `require_email_verified` | `TINYINT(1)` | NO | 1 | Block product login until email verified |
| `require_mfa` | `TINYINT(1)` | NO | 0 | When 1, users in scope must enroll MFA |
| `mfa_allowed_methods` | `VARCHAR(64)` | NO | `sms_otp,totp` | Comma list of allowed MFA method codes |
| `mfa_grace_days` | `INT` | NO | 7 | Days after activation before MFA hard-block |
| `trusted_device_days` | `INT` | NO | 30 | 0 = never trust device to skip MFA |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**Indexes:** `PRIMARY (id)`, `INDEX idx_orgs_status (status)`

---

## `user_mfa_methods`

Enrolled second factors per user. Supports **SMS OTP** and **Google Authenticator (TOTP)** together.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | ULID PK |
| `user_id` | `CHAR(26)` | NO | | FK → `users.id` |
| `method` | `ENUM('sms_otp','totp')` | NO | | Factor type |
| `label` | `VARCHAR(64)` | YES | NULL | Optional UI label (e.g. “iPhone”, “Work Authenticator”) |
| `secret_encrypted` | `VARBINARY(512)` | YES | NULL | TOTP secret (encrypted); NULL for `sms_otp` |
| `phone_e164_snapshot` | `VARCHAR(20)` | YES | NULL | Phone at enroll time for SMS (usually = users.phone_e164) |
| `status` | `ENUM('pending','active','disabled')` | NO | `pending` | `pending` until confirm OTP/code |
| `confirmed_at` | `DATETIME(3)` | YES | NULL | When enrollment confirmed |
| `last_used_at` | `DATETIME(3)` | YES | NULL | Last successful challenge |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |

**Indexes:** `PRIMARY (id)`, `UNIQUE uq_user_mfa_method (user_id, method)`, `INDEX idx_mfa_user (user_id, status)`

**FK:** `user_id` → `users(id)` CASCADE

---

## `user_mfa_recovery_codes`

Single-use break-glass codes (store **hashes only**).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | ULID PK |
| `user_id` | `CHAR(26)` | NO | | FK → `users.id` |
| `code_hash` | `VARCHAR(255)` | NO | | Hash of recovery code |
| `used_at` | `DATETIME(3)` | YES | NULL | NULL = unused |
| `created_at` | `DATETIME(3)` | NO | | |

**Indexes:** `PRIMARY (id)`, `INDEX idx_recovery_user (user_id, used_at)`

**FK:** `user_id` → `users(id)` CASCADE

---

## `auth_challenges`

Short-lived MFA / verification challenges after password (or for phone/email verify).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | ULID PK — returned to client as challenge id |
| `user_id` | `CHAR(26)` | NO | | FK → `users.id` |
| `purpose` | `ENUM('login_mfa','verify_email','verify_phone','enable_sms_mfa','password_reset_mfa')` | NO | | |
| `method` | `ENUM('email_otp','sms_otp','totp','recovery')` | NO | | How user must respond |
| `code_hash` | `VARCHAR(255)` | YES | NULL | Hash of OTP when method is email/sms; NULL for totp/recovery |
| `expires_at` | `DATETIME(3)` | NO | | |
| `attempts` | `INT` | NO | 0 | Failed verify count |
| `max_attempts` | `INT` | NO | 5 | Lock challenge when exceeded |
| `consumed_at` | `DATETIME(3)` | YES | NULL | Set on success |
| `client_meta_json` | `JSON` | YES | NULL | IP / user-agent hash; no secrets |
| `created_at` | `DATETIME(3)` | NO | | |

**Indexes:** `PRIMARY (id)`, `INDEX idx_challenge_user (user_id, purpose, created_at)`

**FK:** `user_id` → `users(id)` CASCADE  
**Retention:** delete/consume rows older than 24h.

---

## `trusted_devices`

Optional MFA skip for remembered browsers (org `trusted_device_days` &gt; 0).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | ULID PK |
| `user_id` | `CHAR(26)` | NO | | FK → `users.id` |
| `device_token_hash` | `VARCHAR(255)` | NO | | Hash of device cookie |
| `label` | `VARCHAR(128)` | YES | NULL | Parsed UA summary |
| `expires_at` | `DATETIME(3)` | NO | | |
| `revoked_at` | `DATETIME(3)` | YES | NULL | |
| `last_seen_at` | `DATETIME(3)` | NO | | |
| `created_at` | `DATETIME(3)` | NO | | |

**Indexes:** `PRIMARY (id)`, `UNIQUE uq_trusted_device (user_id, device_token_hash)`, `INDEX idx_trusted_user (user_id, expires_at)`

**FK:** `user_id` → `users(id)` CASCADE

---

## `org_members`

Which users belong to which org. A user may belong to several orgs (org switcher).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `org_id` | `CHAR(26)` | NO | | FK → `orgs.id` |
| `user_id` | `CHAR(26)` | NO | | FK → `users.id` |
| `status` | `ENUM('active','invited','disabled')` | NO | `active` | Membership can be disabled without disabling the user globally |
| `joined_at` | `DATETIME(3)` | NO | | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |

**PK:** `(org_id, user_id)`  
**FK:** `org_id` → `orgs` CASCADE, `user_id` → `users` CASCADE  
**Indexes:** `INDEX idx_org_members_user (user_id)`

---

## `roles`

System roles (`org_id` NULL, `kind=system`) are seeded and read-only in tenant UI.  
Custom roles (`org_id` set, `kind=custom`) are created in Access → Roles.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | ULID PK |
| `org_id` | `CHAR(26)` | YES | NULL | NULL = system role; else owning org |
| `code` | `VARCHAR(64)` | NO | | Unique per org (or globally when `org_id` IS NULL). Custom example: `west_isa_lead` |
| `name` | `VARCHAR(128)` | NO | | Display name |
| `description` | `VARCHAR(512)` | YES | NULL | |
| `kind` | `ENUM('system','custom')` | NO | `system` | Must match `org_id` nullability |
| `status` | `ENUM('active','disabled')` | NO | `active` | Disabled custom roles grant nothing |
| `cloned_from_id` | `CHAR(26)` | YES | NULL | Role this was cloned from (audit trail) |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | Who created a custom role |
| `updated_by_user_id` | `CHAR(26)` | YES | NULL | |

**Indexes:** `PRIMARY (id)`, `UNIQUE uq_roles_org_code (org_id, code)`  
MySQL unique with NULL `org_id`: multiple system roles still unique on `code` via `UNIQUE uq_roles_system_code (code)` **or** use `org_id = ''` sentinel for system — prefer a generated column `org_key = IFNULL(org_id,'')` unique with `code`.

**FK:** `org_id` → `orgs(id)` CASCADE (custom only), `cloned_from_id` → `roles(id)` SET NULL

**Constraint (app):** `kind=system` ⇒ `org_id IS NULL`; `kind=custom` ⇒ `org_id IS NOT NULL`. Custom roles cannot invent permission codes.

---

## `permissions`

Global catalog. Codes come from module manifests + migrations. Access UI only **attaches** them to roles.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | ULID PK |
| `code` | `VARCHAR(128)` | NO | | `{app}.{resource}.{action}` e.g. `iam.roles.manage`, `led.leads.create` |
| `module_id` | `VARCHAR(16)` | NO | | `iam`, `led`, `dar`, … — FK → `modules.id` |
| `name` | `VARCHAR(128)` | NO | | Short label |
| `description` | `VARCHAR(512)` | YES | NULL | |
| `is_dangerous` | `TINYINT(1)` | NO | 0 | 1 = extra confirm (mass email, metadata deploy, delete) |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |

**Indexes:** `PRIMARY (id)`, `UNIQUE uq_permissions_code (code)`, `INDEX idx_permissions_module (module_id)`  
**FK:** `module_id` → `modules(id)` RESTRICT

Custom roles may only attach permissions whose `module_id` is on the org’s `org_modules`.

---

## `role_permissions`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `role_id` | `CHAR(26)` | NO | | FK → `roles.id` |
| `permission_id` | `CHAR(26)` | NO | | FK → `permissions.id` |
| `created_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | Who attached this permission |

**PK:** `(role_id, permission_id)`  
**FK:** both CASCADE on delete of role or permission

---

## `user_roles`

Assignment of a role to a user **in an org**. Same user can have different roles in different orgs.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `org_id` | `CHAR(26)` | NO | | Must match membership |
| `user_id` | `CHAR(26)` | NO | | |
| `role_id` | `CHAR(26)` | NO | | System or custom role; custom role’s `org_id` must equal this `org_id` |
| `created_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | Assigner |

**PK:** `(org_id, user_id, role_id)`  
**FK:** `org_id`+`user_id` logically ⊆ `org_members`; `role_id` → `roles` RESTRICT  
**Indexes:** `INDEX idx_user_roles_user (user_id, org_id)`, `INDEX idx_user_roles_role (role_id)`

---

## `modules`

Registry of GVCRM product modules the host can load.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `VARCHAR(16)` | NO | | App code PK: `iam`, `led`, `dar`, … |
| `name` | `VARCHAR(128)` | NO | | Display name (Leads, Reporting, Access) |
| `path` | `VARCHAR(128)` | NO | | In-app route prefix: `/access`, `/leads`, `/reporting` |
| `npm_package` | `VARCHAR(128)` | NO | | `@gvcrm/mod-leads` |
| `sort_order` | `INT` | NO | 0 | Module switcher order |
| `is_always_on` | `TINYINT(1)` | NO | 0 | 1 = Access itself; always entitled |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |

**Indexes:** `PRIMARY (id)`, `UNIQUE uq_modules_path (path)`

---

## `org_modules`

Which modules the org **licensed / entitled**. Outer gate before roles.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `org_id` | `CHAR(26)` | NO | | FK → `orgs.id` |
| `module_id` | `VARCHAR(16)` | NO | | FK → `modules.id` |
| `status` | `ENUM('active','disabled')` | NO | `active` | |
| `entitled_at` | `DATETIME(3)` | NO | | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |

**PK:** `(org_id, module_id)`

`iam` should always be present for active orgs.

---

## `user_modules`

Optional **narrowing** of entitlements. If the user has **no** rows for that org, they get all `org_modules`. If any row exists, only those modules (∩ org_modules).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `org_id` | `CHAR(26)` | NO | | |
| `user_id` | `CHAR(26)` | NO | | |
| `module_id` | `VARCHAR(16)` | NO | | |
| `created_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |

**PK:** `(org_id, user_id, module_id)`

---

## `invites`

Pending org invitations (email may not yet exist as a user).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | ULID PK |
| `org_id` | `CHAR(26)` | NO | | |
| `email` | `VARCHAR(255)` | NO | | Invitee |
| `user_type_id` | `CHAR(26)` | NO | | Intended type |
| `role_id` | `CHAR(26)` | YES | NULL | Optional role to assign on accept |
| `token_hash` | `CHAR(64)` | NO | | SHA-256 of invite token |
| `expires_at` | `DATETIME(3)` | NO | | |
| `accepted_at` | `DATETIME(3)` | YES | NULL | |
| `revoked_at` | `DATETIME(3)` | YES | NULL | |
| `invited_by_user_id` | `CHAR(26)` | NO | | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |

**Indexes:** `PRIMARY (id)`, `UNIQUE uq_invites_token (token_hash)`, `INDEX idx_invites_org_email (org_id, email)`

---

## `refresh_tokens`

Refresh token rows. Access token itself is JWT (not stored).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | ULID PK |
| `user_id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | Org context of this session |
| `token_hash` | `CHAR(64)` | NO | | SHA-256 of refresh token; raw token never stored |
| `user_agent` | `VARCHAR(512)` | YES | NULL | Device hint for Access → Sessions |
| `ip` | `VARCHAR(45)` | YES | NULL | Last seen IP |
| `expires_at` | `DATETIME(3)` | NO | | |
| `revoked_at` | `DATETIME(3)` | YES | NULL | Logout or rotation |
| `created_at` | `DATETIME(3)` | NO | | |
| `last_used_at` | `DATETIME(3)` | YES | NULL | |

**Indexes:** `PRIMARY (id)`, `UNIQUE uq_refresh_token_hash (token_hash)`, `INDEX idx_refresh_user (user_id, org_id)`, `INDEX idx_refresh_expires (expires_at)`

Logout revokes all refresh tokens for `(user_id)` or `(user_id, org_id)` depending on scope.

---

## `auth_sessions`

Optional display model for “active sessions” (can be derived from `refresh_tokens`; keep if you want names/devices separately).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | ULID PK |
| `user_id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `refresh_token_id` | `CHAR(26)` | YES | NULL | FK → `refresh_tokens.id` |
| `label` | `VARCHAR(128)` | YES | NULL | “Chrome on Mac” |
| `created_at` | `DATETIME(3)` | NO | | |
| `last_seen_at` | `DATETIME(3)` | NO | | |
| `ended_at` | `DATETIME(3)` | YES | NULL | |

**Indexes:** `PRIMARY (id)`, `INDEX idx_sessions_user (user_id, ended_at)`

---

## `password_reset_tokens`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `user_id` | `CHAR(26)` | NO | | |
| `token_hash` | `CHAR(64)` | NO | | |
| `expires_at` | `DATETIME(3)` | NO | | Short TTL (e.g. 30 min) |
| `used_at` | `DATETIME(3)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `ip` | `VARCHAR(45)` | YES | NULL | |

**Indexes:** `PRIMARY (id)`, `UNIQUE (token_hash)`, `INDEX (user_id)`

---

## `login_attempts`

Lockout / abuse log (also feeds `users.failed_login_count`).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `email` | `VARCHAR(255)` | NO | | Attempted email (may not exist) |
| `user_id` | `CHAR(26)` | YES | NULL | Set if user found |
| `success` | `TINYINT(1)` | NO | | |
| `reason` | `VARCHAR(64)` | YES | NULL | `bad_password`, `locked`, `disabled`, `unknown_user` |
| `ip` | `VARCHAR(45)` | YES | NULL | |
| `user_agent` | `VARCHAR(512)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |

**Indexes:** `PRIMARY (id)`, `INDEX idx_login_attempts_email_time (email, created_at)`, `INDEX idx_login_attempts_ip_time (ip, created_at)`

Do not reveal `unknown_user` vs `bad_password` to the API client; store internally.

---

## `iam_audit_events`

Immutable Access audit (login, role changes, entitlements). Not ClickHouse `report_runs`.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | YES | NULL | NULL for pre-org login failures |
| `actor_user_id` | `CHAR(26)` | YES | NULL | Who did it; NULL = anonymous login attempt |
| `target_user_id` | `CHAR(26)` | YES | NULL | Affected user |
| `action` | `VARCHAR(64)` | NO | | `login.success`, `login.failure`, `role.create`, `role.update`, `role.assign`, `entitlement.grant`, `user.disable`, … |
| `entity_type` | `VARCHAR(64)` | YES | NULL | `role`, `user`, `org_module`, … |
| `entity_id` | `VARCHAR(26)` | YES | NULL | |
| `payload_json` | `JSON` | YES | NULL | Diff / metadata; no secrets, no password hashes |
| `ip` | `VARCHAR(45)` | YES | NULL | |
| `request_id` | `VARCHAR(36)` | YES | NULL | Correlation id |
| `created_at` | `DATETIME(3)` | NO | | |

**Indexes:** `PRIMARY (id)`, `INDEX idx_iam_audit_org_time (org_id, created_at)`, `INDEX idx_iam_audit_actor (actor_user_id, created_at)`, `INDEX idx_iam_audit_action (action, created_at)`

Insert-only. Retention ≥ 13 months (compliance).

---

## JWT claims (derived, not a table)

Issued at login / refresh from the tables above:

| Claim | Source |
|-------|--------|
| `sub` | `users.id` |
| `orgId` | selected `orgs.id` |
| `typ` | `user_types.code` |
| `roles` | codes from assigned active `roles` |
| `perm` | union of `permissions.code` |
| `modules` | effective module ids |
| `iss` | `gvcrm-access` |

---

## Retention

| Table | Policy |
|-------|--------|
| `refresh_tokens` | Delete expired+revoked after 30 days |
| `login_attempts` | 90 days |
| `password_reset_tokens` | 7 days after expiry |
| `iam_audit_events` | ≥ 13 months |
| `users` / `orgs` | Soft delete; hard delete only under legal request + cascade plan |
