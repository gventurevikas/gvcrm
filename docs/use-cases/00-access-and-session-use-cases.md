# Access and Session Use Cases

**Document ID:** GVCRM-UC-IAM  
**Sources:** `docs/database/01-iam-access.md`, `docs/developer/access-security-rules.md`, `docs/requirements/00-access-authentication-and-mfa.md`  
**Note:** Product modules assume these succeed before any module FR runs.

Supported **verified login / step-up** methods:

| Method | Code | Typical use |
|--------|------|-------------|
| Password | `password` | Primary factor (always) |
| Email magic / verify link | `email_otp` | Registration & recovery verification |
| SMS one-time code | `sms_otp` | Second factor or verified phone login assist |
| Google Authenticator (TOTP) | `totp` | App-based MFA (RFC 6238) |
| Recovery codes | `recovery` | Break-glass when MFA device lost |

Users may **register and strengthen** their account over time (phone verify → SMS MFA → TOTP → recovery codes). Org policy may **require** MFA for producers/admins.

---

## IAM-UC-001 — Log in with password (primary factor)

| Field | Value |
|-------|-------|
| **Requirement** | IAM-FR-001 |
| **Actors** | Any entitled user (A-PROD … A-ADM) |
| **Priority** | P0 |
| **Goal** | Prove password identity; continue to MFA if required |

### Preconditions
- User exists in `gvcrm_iam`, status `active`, org membership active.
- Email verified (unless org allows invite-pending edge cases).

### Main flow
1. User opens `gvcrm-web` Access login; enters email + password.
2. Access validates credentials; records `login_attempts`.
3. If MFA **not** required → issue tokens (step 5).
4. If MFA required → return `mfa_challenge` (no full session yet); continue IAM-UC-008 / IAM-UC-009.
5. System issues access + refresh tokens with claims (`sub`, `orgId`, `roles`, `perm`, `modules`).
6. ModuleRegistry shows only entitled modules; user lands on homepage.

### Alternate flows
- **A1 Multi-org:** After auth, user picks org context.
- **A2 Remember this device:** Optional trusted-device cookie skips MFA for policy window (admin-configurable; never for high-risk roles if policy forbids).

### Exceptions
- **E1 Invalid credentials / lockout:** Generic error; attempt counted; `locked_until` enforced.
- **E2 Unverified email:** Prompt to resend verification (IAM-UC-007); login blocked if policy requires verify.
- **E3 Inactive user / suspended org:** Access denied.

### Business rules
- Passwords and MFA secrets live **only** in IAM.
- Never log passwords, OTP codes, TOTP secrets, or recovery codes.

---

## IAM-UC-002 — Refresh session and log out

| Field | Value |
|-------|-------|
| **Requirement** | IAM-FR-002 |
| **Actors** | Authenticated user |
| **Priority** | P0 |

### Main flow
1. Access token nears expiry; client uses refresh token.
2. Access rotates refresh token; issues new access token.
3. On logout, client clears session; server revokes refresh token(s).

### Exceptions
- **E1 Reused/stolen refresh:** Rotation detects reuse; revoke token family; force full re-login + MFA.

---

## IAM-UC-003 — Assign roles and custom roles

| Field | Value |
|-------|-------|
| **Requirement** | IAM-FR-003 |
| **Actors** | A-ADM |
| **Priority** | P0 |

### Main flow
1. Admin opens Access admin → Roles.
2. Creates/edits custom role from permission catalog.
3. Assigns role(s) to user within org.
4. Effective permissions = union of active assigned roles.
5. Next token reflects updated `perm` / `roles`.

### Business rules
- Custom roles cannot invent permission codes.
- Role changes are IAM-audited.

---

## IAM-UC-004 — Entitle modules for an organization

| Field | Value |
|-------|-------|
| **Requirement** | IAM-FR-004 |
| **Actors** | A-ADM (or Marketplace install) |
| **Priority** | P0 |

### Main flow
1. Admin enables modules on `org_modules`.
2. Optionally restricts via `user_modules`.
3. Effective modules = `org_modules` ∩ (`user_modules` if any, else all org modules).
4. Switcher hides non-entitled modules.

---

## IAM-UC-005 — Invite user to organization

| Field | Value |
|-------|-------|
| **Requirement** | IAM-FR-005 |
| **Actors** | A-ADM |
| **Priority** | P0 |

### Main flow
1. Admin invites email with role + modules; optional “MFA required on first login”.
2. Invitee opens secure link → IAM-UC-007 registration / activation.
3. After verify + password (+ MFA if required), membership becomes active.
4. First full login via IAM-UC-001.

### Exceptions
- **E1 Expired invite:** Re-invite required.

---

## IAM-UC-006 — Password reset (verified)

| Field | Value |
|-------|-------|
| **Requirement** | IAM-FR-006 |
| **Actors** | User |
| **Priority** | P0 |

### Main flow
1. User requests reset with email.
2. System sends one-time email link/code (rate-limited).
3. User sets new password meeting complexity policy.
4. If MFA enrolled, user must pass MFA (SMS or TOTP) before reset completes.
5. All refresh sessions revoked; audit logged.

### Alternate
- **A1 Phone assist:** If phone verified, offer SMS OTP as additional proof when org allows.

---

## IAM-UC-007 — Register / activate with verified email (secure onboarding)

| Field | Value |
|-------|-------|
| **Requirement** | IAM-FR-007 |
| **Actors** | Invitee or self-serve registrant (org policy) |
| **Priority** | P0 |
| **Goal** | Create or activate account only after email proof |

### Main flow
1. User receives invite or starts allowed registration with work email.
2. Chooses strong password (complexity + breach checks as configured).
3. System sends **email verification** OTP/link.
4. User verifies email → `email_verified_at` set; status can become `active`.
5. Security setup wizard offered: verify phone → enable SMS MFA and/or Google Authenticator (IAM-UC-010…012).
6. If org **requires MFA**, wizard is mandatory before first CRM session.

### Alternate
- **A1 Skip optional MFA** when org policy = optional; show “Secure your account” banner until enrolled.

### Exceptions
- **E1 Disposable / blocked domain:** Registration rejected per org allow-list.
- **E2 OTP expired / too many tries:** Resend with backoff.

### Postconditions
- No CRM tokens until email verified (and MFA if required).
- `iam_audit_events`: `user.registered`, `email.verified`.

---

## IAM-UC-008 — Complete login with SMS one-time code

| Field | Value |
|-------|-------|
| **Requirement** | IAM-FR-008 |
| **Actors** | User with verified phone + SMS MFA enabled |
| **Priority** | P0 |
| **Goal** | Second factor (or step-up) via SMS OTP |

### Preconditions
- Password (or prior factor) accepted; challenge id issued.
- `phone_e164` present and `phone_verified_at` set.
- Method `sms_otp` enabled on user (and allowed by org).

### Main flow
1. User chooses **SMS** on MFA challenge screen (or it is the only enrolled method).
2. System sends 6-digit OTP to masked phone (e.g. `***-***-1234`); TTL short (e.g. 5 min).
3. User enters code; Access validates (constant-time); increments attempt counter on failure.
4. On success, issue full session tokens; clear challenge.
5. Audit: `mfa.sms.success`.

### Alternate
- **A1 Resend SMS:** Rate-limited (e.g. 1/min, daily cap).
- **A2 Switch to Authenticator** if also enrolled.
- **A3 Use recovery code** (IAM-UC-013).

### Exceptions
- **E1 Invalid/expired OTP:** Remain on challenge; lock MFA after N failures (temporary).
- **E2 SMS provider failure:** Offer TOTP/recovery if enrolled; else support path.

### Business rules
- SMS is for **verification / MFA**, not a replacement for password on privileged roles unless org explicitly allows passwordless (future); MVP = password + SMS MFA.
- OTP never logged; phone shown masked only.
- TCPA: auth OTPs are transactional; still respect SMS gateway compliance settings.

---

## IAM-UC-009 — Complete login with Google Authenticator (TOTP)

| Field | Value |
|-------|-------|
| **Requirement** | IAM-FR-009 |
| **Actors** | User with TOTP enrolled |
| **Priority** | P0 |
| **Goal** | Second factor via Google Authenticator / any TOTP app |

### Preconditions
- Password accepted; MFA challenge issued.
- TOTP secret enrolled and confirmed (`totp` method active).

### Main flow
1. User selects **Authenticator app** (or default).
2. Opens Google Authenticator (or Authy / 1Password / etc.) and enters current 6-digit code.
3. Access validates TOTP (allow ±1 time step skew).
4. On success, issue session tokens; audit `mfa.totp.success`.

### Alternate
- **A1 SMS fallback** if also enrolled and org allows.
- **A2 Recovery code** (IAM-UC-013).

### Exceptions
- **E1 Wrong code / clock skew:** Retry; after N failures temporary lock + support guidance to re-sync time.

### Business rules
- Compatible with **Google Authenticator** and any RFC 6238 TOTP client.
- Secret stored encrypted (`mfa_secret_encrypted` / method table); shown as QR **only once** at enrollment.

---

## IAM-UC-010 — Verify mobile phone number

| Field | Value |
|-------|-------|
| **Requirement** | IAM-FR-010 |
| **Actors** | Authenticated user (or mid-registration wizard) |
| **Priority** | P0 |
| **Goal** | Bind a trusted phone for SMS MFA and secure recovery |

### Main flow
1. User opens **Security → Phone** (or onboarding wizard).
2. Enters mobile in E.164; confirms country.
3. System sends SMS verification OTP.
4. User enters OTP → `phone_verified_at` set; phone stored.
5. User may immediately enable SMS MFA (IAM-UC-011).

### Exceptions
- **E1 Number already used by another active user:** Reject or require support (org policy).
- **E2 Landline / unsupported:** Validation error.

### Postconditions
- Unverified phone cannot receive login MFA SMS.

---

## IAM-UC-011 — Enable SMS as a secured login method

| Field | Value |
|-------|-------|
| **Requirement** | IAM-FR-011 |
| **Actors** | User |
| **Priority** | P0 |
| **Goal** | Register SMS OTP as an MFA method (“more secured working”) |

### Preconditions
- Phone verified (IAM-UC-010).
- User re-authenticates (password and/or existing MFA) — step-up.

### Main flow
1. User enables **SMS verification for login**.
2. System sends confirm OTP; user enters it.
3. Method `sms_otp` marked active; `mfa_enabled = 1`.
4. Recovery codes offered if none exist (IAM-UC-013 enrollment).
5. Audit `mfa.sms.enrolled`.

### Alternate
- **A1 Admin forces MFA:** User must complete this or TOTP before accessing CRM.

### Exceptions
- **E1 Org disables SMS MFA:** Only TOTP allowed; UI explains.

---

## IAM-UC-012 — Enroll Google Authenticator (secure upgrade)

| Field | Value |
|-------|-------|
| **Requirement** | IAM-FR-012 |
| **Actors** | User |
| **Priority** | P0 |
| **Goal** | Register TOTP app as MFA — recommended stronger method |

### Preconditions
- Step-up re-auth completed.
- Email verified.

### Main flow
1. User opens **Security → Authenticator app**.
2. System generates TOTP secret; shows **QR code** + manual key (once).
3. User adds account in **Google Authenticator** (or compatible app).
4. User enters a live code to confirm enrollment.
5. Method `totp` active; `mfa_enabled = 1`; recovery codes generated/displayed once if new.
6. Audit `mfa.totp.enrolled`.

### Alternate
- **A1 Replace authenticator:** Requires step-up + invalidate old secret; force re-enroll.
- **A2 Keep SMS as backup** alongside TOTP (recommended).

### Exceptions
- **E1 Confirm code invalid:** Secret not activated; user retries with same or regenerated secret.

### Business rules
- Prefer TOTP over SMS when org policy = “strong MFA”.
- QR never re-shown after success; user must re-enroll to rotate.

---

## IAM-UC-013 — Recovery codes (break-glass)

| Field | Value |
|-------|-------|
| **Requirement** | IAM-FR-013 |
| **Actors** | User / A-ADM (reset assist) |
| **Priority** | P0 |

### Main flow — enroll
1. On first MFA enable, system generates one-time recovery codes (hashed at rest).
2. User downloads/prints; acknowledges storage.
3. Codes shown only once.

### Main flow — use at login
1. On MFA challenge, user chooses **Recovery code**.
2. Enters unused code; code marked consumed.
3. Session issued; user prompted to re-enroll MFA if device lost.

### Alternate — admin assist
- **A1 Admin clears MFA** after identity proof (ticket); user must re-enroll before next login if policy requires MFA.

---

## IAM-UC-014 — Manage secured login methods (user security center)

| Field | Value |
|-------|-------|
| **Requirement** | IAM-FR-014 |
| **Actors** | User |
| **Priority** | P0 |
| **Goal** | View and upgrade security posture |

### Main flow
1. User opens **Access → Security**.
2. Sees status: email verified, phone verified, SMS MFA, Authenticator, recovery codes remaining, trusted devices.
3. Enables/disables methods (cannot disable last MFA method if org requires MFA).
4. Rotates password; revokes trusted devices; regenerates recovery codes (invalidates old).

### Business rules
- Disabling MFA when org-required is blocked.
- All changes need recent re-auth (step-up).

---

## IAM-UC-015 — Org policy: require verified + MFA

| Field | Value |
|-------|-------|
| **Requirement** | IAM-FR-015 |
| **Actors** | A-ADM |
| **Priority** | P0 |
| **Goal** | Force secured working for the tenant |

### Main flow
1. Admin sets org auth policy: require email verify; require MFA; allowed methods (`sms_otp`, `totp`); grace period days; trusted-device days.
2. Users without compliance see blocking wizard (IAM-UC-007/010–012).
3. Admins/producers can be targeted by role (e.g. MFA required for all `producer` / `admin`).

### Postconditions
- Non-compliant users cannot obtain CRM module tokens after grace ends.
- Policy changes audited.

---

## Traceability matrix

| UC | FR | Topic |
|----|-----|--------|
| IAM-UC-001 | IAM-FR-001 | Password login |
| IAM-UC-002 | IAM-FR-002 | Refresh / logout |
| IAM-UC-003 | IAM-FR-003 | Roles |
| IAM-UC-004 | IAM-FR-004 | Entitlements |
| IAM-UC-005 | IAM-FR-005 | Invite |
| IAM-UC-006 | IAM-FR-006 | Password reset |
| IAM-UC-007 | IAM-FR-007 | Verified registration |
| IAM-UC-008 | IAM-FR-008 | SMS OTP login factor |
| IAM-UC-009 | IAM-FR-009 | Google Authenticator / TOTP |
| IAM-UC-010 | IAM-FR-010 | Phone verify |
| IAM-UC-011 | IAM-FR-011 | Enable SMS MFA |
| IAM-UC-012 | IAM-FR-012 | Enroll Authenticator |
| IAM-UC-013 | IAM-FR-013 | Recovery codes |
| IAM-UC-014 | IAM-FR-014 | Security center |
| IAM-UC-015 | IAM-FR-015 | Org MFA policy |

Product FR tests should fail closed if IAM-UC-001 and (when policy on) IAM-UC-008/009 are not met.
