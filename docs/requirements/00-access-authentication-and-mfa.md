# Access — Authentication, Verification, and MFA

**Document ID:** GVCRM-REQ-IAM  
**Version:** 1.0  
**Status:** Draft for implementation  
**Module:** Access (`iam`) — foundation (not a product CRM module)  
**Related use cases:** `docs/use-cases/00-access-and-session-use-cases.md`  
**Related schema:** `docs/database/01-iam-access.md`

This document specifies how users **register, verify, and log in** securely. Passwords, MFA secrets, and sessions live only in `gvcrm_iam`.

---

## 1. Purpose

Provide password authentication plus **verified second factors** so remote producers and admins can run a **more secured** account:

- Email verification at registration / invite activation  
- SMS one-time codes (OTP)  
- Google Authenticator–compatible TOTP  
- Recovery codes and org-enforced MFA policy  

---

## 2. Scope

**In scope**

- Password login, refresh, logout, lockout  
- Invite + self-serve activation (org policy)  
- Email verification; phone verification  
- MFA: `sms_otp`, `totp` (Google Authenticator and any RFC 6238 app)  
- Recovery codes; user security center  
- Org policy: require verify + MFA; allowed methods  

**Out of scope**

- Social login / SAML / OIDC IdP federation (later)  
- WebAuthn / passkeys (later; schema may reserve)  
- Replacing CCM customer SMS (auth SMS is IAM-owned transactional)

---

## 3. Users

| Persona | Actions |
|---------|---------|
| Remote producer / any user | Register/verify, enroll SMS & Authenticator, login with MFA |
| Admin | Invite users, set MFA-required policy, clear MFA after identity proof |
| Support (ops) | Assist lockouts without reading secrets |

---

## 4. Functional requirements

### 4.1 Password login

**Priority:** P0  
**ID:** IAM-FR-001

The solution shall authenticate users with email + password and issue JWT sessions only after all required factors succeed.

**Acceptance criteria**

- Valid credentials alone are insufficient when MFA is required.  
- Failed attempts increment lockout counters without revealing whether email exists.  
- Passwords stored as argon2id/bcrypt hashes only in IAM.

---

### 4.2 Session refresh and logout

**Priority:** P0  
**ID:** IAM-FR-002

Refresh token rotation and logout shall revoke server-side sessions. Refresh reuse shall revoke the token family.

---

### 4.3 Roles and custom roles

**Priority:** P0  
**ID:** IAM-FR-003

Admins assign system and custom roles; custom roles only attach catalog permissions.

---

### 4.4 Module entitlements

**Priority:** P0  
**ID:** IAM-FR-004

Org/user module entitlements gate which product modules appear and which APIs accept calls.

---

### 4.5 Invite user

**Priority:** P0  
**ID:** IAM-FR-005

Admins invite users by email with roles/modules; invite links expire; optional “MFA required on activation.”

---

### 4.6 Password reset

**Priority:** P0  
**ID:** IAM-FR-006

Password reset requires email proof and, when MFA is enrolled, a second factor before the new password is accepted. All sessions revoke on success.

---

### 4.7 Verified registration / activation

**Priority:** P0  
**ID:** IAM-FR-007

Users shall not receive CRM module access until **email is verified**. A security wizard shall offer phone verify + MFA enrollment; wizard is mandatory when org requires MFA.

**Acceptance criteria**

- Unverified email cannot complete login to product modules.  
- Verification OTPs/links are single-use, TTL-bound, and rate-limited.

---

### 4.8 SMS OTP as login factor

**Priority:** P0  
**ID:** IAM-FR-008

After password success, users with SMS MFA enabled shall complete login by entering an SMS one-time code sent to their verified mobile number.

**Acceptance criteria**

- Phone displayed masked only.  
- OTP length ≥ 6; short TTL; resend rate-limited.  
- Invalid attempts lock the challenge after configured threshold.  
- Auth SMS is transactional and separate from CCM marketing SMS.

---

### 4.9 Google Authenticator (TOTP) as login factor

**Priority:** P0  
**ID:** IAM-FR-009

Users with TOTP enrolled shall complete login using a code from **Google Authenticator** or any RFC 6238–compatible app.

**Acceptance criteria**

- Server allows small clock skew (±1 step).  
- TOTP secret encrypted at rest; never returned after enrollment.  
- Compatible with Google Authenticator QR (`otpauth://` URI).

---

### 4.10 Verify mobile phone

**Priority:** P0  
**ID:** IAM-FR-010

Users shall verify a mobile number via SMS OTP before that number can be used for MFA.

---

### 4.11 Enable SMS MFA

**Priority:** P0  
**ID:** IAM-FR-011

Verified users shall be able to **register SMS** as a secured login method (enable MFA), with step-up re-authentication and a confirming OTP.

---

### 4.12 Enroll Google Authenticator

**Priority:** P0  
**ID:** IAM-FR-012

Users shall enroll TOTP by scanning a one-time QR and confirming a live code. Enrollment upgrades the account to a more secured working mode (`mfa_enabled`).

---

### 4.13 Recovery codes

**Priority:** P0  
**ID:** IAM-FR-013

When MFA is first enabled, the system shall issue single-use recovery codes (stored hashed). Users can complete MFA challenge with an unused code and must be prompted to re-secure the account.

---

### 4.14 Security center

**Priority:** P0  
**ID:** IAM-FR-014

Users shall view and manage email/phone verification, MFA methods, recovery codes, password change, and trusted devices. Org-required MFA cannot be fully disabled by the user.

---

### 4.15 Organization MFA policy

**Priority:** P0  
**ID:** IAM-FR-015

Admins shall configure: require email verification; require MFA; allowed methods (`sms_otp`, `totp`); grace period; trusted-device lifetime; which roles must comply.

**Acceptance criteria**

- After grace, non-compliant users cannot obtain product module tokens.  
- Policy changes are audited.

---

## 5. Integrations

| ID | Integration |
|----|-------------|
| IAM-INT-001 | Transactional email (verification, reset, invite) |
| IAM-INT-002 | SMS gateway for auth OTP (Twilio or equivalent) — distinct credentials from CCM where practical |
| IAM-INT-003 | TOTP library (RFC 6238) |

---

## 6. Security

| ID | Rule |
|----|------|
| IAM-SEC-001 | Never log OTP, TOTP secrets, recovery codes, password hashes |
| IAM-SEC-002 | MFA secrets encrypted at rest |
| IAM-SEC-003 | Challenge tokens short-lived; bound to user + device fingerprint optional |
| IAM-SEC-004 | Rate-limit SMS/email OTP send and verify |
| IAM-SEC-005 | Prefer TOTP when org selects “strong MFA”; SMS allowed as factor or backup |

---

## 7. Non-functional

- MFA challenge verify P95 &lt; 500ms (excluding SMS delivery).  
- SMS delivery dependent on carrier; show clear “code sent” + resend UX.  
- First Authenticator enrollment UX completable in &lt; 2 minutes for typical users.

---

## 8. Dependencies

- CCM is **not** required for auth SMS (IAM may share gateway infra but consent model differs).  
- All product modules depend on successful Access session + entitlements.
