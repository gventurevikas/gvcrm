# Access, security, and RBAC rules

**Controlling application:** Access (`iam`) — `@gvcrm/mod-access` + `gvcrm-access-api`  
**Detail:** `docs/dev-docs/14-central-access-rbac.md`, `docs/database/01-iam-access.md`

Everyone on the team follows these rules — not only the Access squad.

---

## 1. What Access owns

| Owns | Does not own |
|------|----------------|
| Login / logout / refresh | Lead/deal/report business data |
| Password hashes | Module domain schemas |
| Email / phone verification | CCM marketing / sales SMS |
| MFA: SMS OTP, Google Authenticator (TOTP), recovery codes | Hardcoded `isAdmin` in features |
| User types, system roles, **custom roles** | Inventing permission codes in random PRs without registration |
| Permission catalog | Per-module password / MFA tables |
| Module entitlements | |

---

## 2. Hard rules

| # | Rule |
|---|------|
| S1 | Only Access stores passwords and issues sessions/JWTs for interactive users. |
| S2 | Authorization uses **permission codes** `{app}.{resource}.{action}`, not role name string compares in features. |
| S3 | **Custom roles** only attach existing catalog permissions; UI cannot invent new codes. |
| S4 | Custom roles cannot grant permissions for modules the org is not entitled to. |
| S5 | System roles (`kind=system`) are read-only in tenant UI. |
| S6 | Effective permissions = union of all active assigned roles (system + custom) for `(user, org)`. |
| S7 | Angular **and** Express must check the same codes. |
| S8 | Never log tokens, password hashes, MFA secrets, SMS/email OTPs, recovery codes, or OAuth refresh tokens. |
| S9 | PII (NPN, policy numbers, card scans, phone numbers) — minimize in logs; mask phones in UI (`***-***-1234`). |
| S10 | Assistant / workflows run **as the user** (or documented automation user) — no silent privilege escalation. |
| S11 | Auth SMS OTPs are **IAM transactional** (not CCM campaigns); still rate-limited and provider-secured. |
| S12 | TOTP must work with **Google Authenticator** (RFC 6238 `otpauth://`); secrets encrypted; QR shown once at enroll. |
| S13 | When org `require_mfa` is on, do not issue product-module JWTs until MFA enrolled (after grace). |

---

## 3. Permission codes

Examples:

- `iam.users.manage`, `iam.roles.manage`, `iam.roles.assign`, `iam.entitlements.manage`
- `led.leads.read`, `led.leads.create`, `led.ad_connections.manage`
- `dar.reports.run`, `dar.api_usage.read`
- `aia.assistant.use`, `aia.assistant.operate`

**Adding a permission**

1. Add to module `manifest.permissions`.  
2. Seed/migrate into `gvcrm_iam.permissions` with `module_id`.  
3. Use in Angular `data.permissions` / `*gvcrmCan` and Express `rbac`.  
4. Document in the module README or Access catalog notes.

---

## 4. Custom roles (product feature)

Agency admins create roles like `West ISA Lead` in **Access → Roles**:

1. Optional clone from a system role  
2. Attach subset of catalog permissions  
3. Assign to users in that org  
4. Disable role → grants nothing (no code deploy)

Developers do **not** insert custom roles via one-off SQL in production as the normal path.

---

## 5. Module entitlements

Outer gate before roles:

```text
effective modules = org_modules ∩ (user_modules if any else all org_modules)
```

Host `ModuleRegistry` only loads entitled modules. Marketplace/install and Access entitlements stay consistent with product licensing.

---

## 6. Enforcement chain

```text
*gvcrmCan / nav hide     → UX
Route guards             → UX
Gateway JWT + rbac       → required
Module API rbac          → required
Domain/Facade rules      → when more than a permission code
```

---

## 7. Security PR checklist

```text
## Security
- [ ] No new password/role/MFA tables outside iam
- [ ] Permission codes registered + used on UI and API
- [ ] No secrets in logs or client responses (incl. OTP / TOTP / recovery)
- [ ] org_id from token enforced
- [ ] MFA challenge required when user or org policy demands it
- [ ] Dangerous ops (mass email, deploy, delete) use is_dangerous / confirm + permission
```
