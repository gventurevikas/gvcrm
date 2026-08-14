# Foundation & Platform Skeleton — Spiral Plan

**Document ID:** GVCRM-PLAN-FOUNDATION  
**Prefix:** IAM / HOST / GW  
**Program wave:** S0 (hard gate)  
**Sources:** `docs/developer/*`, `docs/database/00-conventions.md`, `docs/database/01-iam-access.md`, `docs/dev-docs/` (if present)

---

## 1. Purpose

Establish the runnable platform every product module plugs into: one Angular host, Access/IAM, API gateway, shared contracts and styles, and local data stores — **before** any CRM feature UI.

---

## 2. Scope

**In scope**

- Monorepo / package layout for `gvcrm-web`, `@gvcrm/mod-*`, `*-api`, gateway
- MySQL `gvcrm_iam` full schema + seeds
- AuthN (login, refresh, sessions), AuthZ (roles, custom roles, module entitlements)
- ModuleRegistry, chrome layout, design tokens
- Application JSON envelope; Facade stubs
- Local Docker Compose: MySQL (+ ClickHouse stub for later DAR)
- CI lint/test/PR checklist hooks matching developer rules

**Out of scope**

- Product module business logic (deferred to module plans)
- Full ClickHouse report UX (DAR plan)
- Marketplace packaging (MKT plan)

---

## 3. Spiral cycles

| Cycle | Name | Outcome |
|-------|------|---------|
| **S0.1** | Repo & host shell | Empty `gvcrm-web` boots with layout chrome |
| **S0.2** | IAM core | Login + JWT + org membership |
| **S0.3** | Gateway & contracts | Envelope, health, Auth interceptor/guards |
| **S0.4** | Entitlements & harness | Module gating + module harness for isolated UI |
| **S0.5** | Hardening | Audit events, rate limits on login, security review |

---

## 4. Cycle S0.1 — Repo & host shell

### 4.1 Objectives

- Create packages listed in developer getting-started
- One layout: sidebar, header, module switcher (no copy into pages)
- `@gvcrm/styles` tokens; no hardcoded hex in feature SCSS (yet)

### 4.2 Risks

| Risk | Mitigation |
|------|------------|
| Multiple SPAs created | Enforce single `gvcrm-web` in PR checklist |
| Inline templates creep | Angular rules: separate `.ts`/`.html`/`.scss` |

### 4.3 Engineering

| Layer | Work |
|-------|------|
| Design | App shell wireframes; ModuleRegistry interface |
| Build | Angular app + angular-kit; empty routed outlet |
| Test | Smoke: app boots; layout renders |

### 4.4 Evaluation

- [ ] Developer can `ng serve` host and see chrome
- [ ] No second product SPA in repo

---

## 5. Cycle S0.2 — IAM core

### 5.1 Objectives

- Migrate `gvcrm_iam` per `docs/database/01-iam-access.md` (including MFA tables)
- Seed `user_types`, `modules`, `permissions`, system `roles`
- Login, refresh tokens, sessions, password reset
- **Verified registration** (email OTP) + optional/required MFA path
- JWT claims: `sub`, `orgId`, `typ`, `roles`, `perm`, `modules`

### 5.2 Risks

| Risk | Mitigation |
|------|------------|
| Passwords in domain DBs | Schema review gate; only IAM stores hashes |
| Weak session handling | Refresh rotation; `login_attempts` lockout |
| MFA secrets leaked | Encrypt TOTP; never log OTP; QR once |
| SMS OTP abuse | Rate limits; verified phone only |

### 5.3 Engineering

| Layer | Work |
|-------|------|
| Design | Auth + MFA sequence diagrams; challenge API; Google Authenticator QR |
| Build | `gvcrm-access-api`; login; email verify; SMS OTP; TOTP enroll/verify; recovery codes; org MFA policy |
| Test | API auth tests; MFA matrix (sms/totp/recovery); org isolation |

### 5.4 Evaluation

- [ ] User logs in and receives valid JWT
- [ ] With MFA on: password alone does not issue product session
- [ ] SMS OTP and Google Authenticator both complete login
- [ ] Wrong-org data impossible at claim level
- [ ] Seeds load on fresh migrate

---

## 6. Cycle S0.3 — Gateway & contracts

### 6.1 Objectives

- Gateway routes to Access API
- Shared JSON envelope for success/error
- Angular auth interceptor + route guards + `*gvcrmCan`
- Forbid `user.role === 'admin'` checks in UI

### 6.2 Risks

| Risk | Mitigation |
|------|------------|
| Inconsistent error shapes | Envelope contract tests |
| Guard bypass | E2E: unauthenticated redirect |

### 6.3 Engineering

| Layer | Work |
|-------|------|
| Design | OpenAPI for auth; envelope TypeScript types |
| Build | Gateway; interceptor; `*gvcrmCan` directive |
| Test | Contract tests; unauthorized → 401 envelope |

### 6.4 Evaluation

- [ ] All Access responses use envelope
- [ ] Guard blocks entitled-only routes

---

## 7. Cycle S0.4 — Entitlements & harness

### 7.1 Objectives

- Effective modules = `org_modules` ∩ (`user_modules` if any, else all org modules)
- Custom roles assignable without inventing permission codes
- `gvcrm-module-harness` runs a fake module with mock Access facade
- Placeholder empty schemas for future module DBs (optional)

### 7.2 Risks

| Risk | Mitigation |
|------|------------|
| Modules load when not entitled | Integration test on ModuleRegistry |
| Cross-import of private APIs | ESLint boundary rules |

### 7.3 Engineering

| Layer | Work |
|-------|------|
| Design | Entitlement resolution algorithm (from IAM doc) |
| Build | org/user module admin screens (minimal); harness |
| Test | Harness boots `@gvcrm/mod-example` |

### 7.4 Evaluation

- [ ] Disabling `org_modules` hides module from switcher
- [ ] New module team can scaffold via harness alone

---

## 8. Cycle S0.5 — Hardening

### 8.1 Objectives

- `iam_audit_events` for login, role changes, entitlement changes
- Security review against `docs/developer/access-security-rules.md`
- Local-development doc verified end-to-end
- CI: lint, unit, PR template with rule checklist

### 8.2 Risks

| Risk | Mitigation |
|------|------------|
| Audit gaps | Checklist of audited actions |
| Local setup drift | Single compose file + getting-started dry run |

### 8.3 Engineering

| Layer | Work |
|-------|------|
| Design | Audit event catalog |
| Build | Audit writers; CI pipeline |
| Test | Security smoke; compose up smoke |

### 8.4 Evaluation

- [ ] S0 exit criteria from master plan met
- [ ] Written go-ahead for Wave S1

---

## 9. SDLC artifacts produced

| Artifact | Location / owner |
|----------|------------------|
| Package layout | repo root |
| IAM migrations | Access API |
| Contracts | `@gvcrm/contracts` |
| Dev compose | `docs/developer/local-development.md` aligned |
| PR checklist | `.github` or equivalent |

---

## 10. Dependencies

| Depends on | Provides to |
|------------|-------------|
| Specs & DB docs (done) | Every module plan (S1+) |

---

## 11. Definition of done (S0)

1. Login works locally against MySQL IAM.
2. One entitled stub module appears; unentitled does not.
3. Facade boundary lint is green.
4. Developer rules documents match reality (or docs updated).
5. Program lead signs Wave S1 start.
