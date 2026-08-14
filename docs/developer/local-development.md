# Local development

Practical setup notes for day-to-day work. Exact scripts follow each repo’s `package.json` when code lands; this file defines **expectations**.

---

## 1. Minimum local stack

| Component | Who needs it |
|-----------|----------------|
| Node 20+ | Everyone |
| `gvcrm-web` or module harness | Angular |
| MySQL 8 with `gvcrm_iam` | Login / any authenticated API |
| Your module DB `gvcrm_{app}` | Module API |
| ClickHouse | Reporting / `report_runs` |
| Gateway | Full multi-API path (optional early — can point UI at one API) |
| Mail/SMS providers | Mock locally; never use prod keys |

---

## 2. Environment variables (typical)

Never commit real values. Use `.env.example` in each repo.

| Variable | Meaning |
|----------|---------|
| `DATABASE_URL` / `MYSQL_*` | Module or IAM DB |
| `CLICKHOUSE_*` | Reporting audit |
| `JWT_ISSUER` / JWKS URL | Access public keys |
| `GATEWAY_URL` | Angular `environment.gatewayUrl` |
| `ACCESS_URL` | Login / refresh base if split |
| Provider secrets | Meta / LinkedIn / SMTP — encrypted at rest; local mocks preferred |

Angular `environment.ts` points at local gateway; `environment.prod.ts` at deployed API.

---

## 3. Recommended workflows

### A. UI-only on one module

1. Start `gvcrm-access-api` + MySQL IAM (or mock Access in harness).  
2. Start `gvcrm-module-harness` with `@gvcrm/mod-{you}`.  
3. Start `{you}-api` if screens need data.  
4. Develop under `features/…` with hot reload.

### B. Full host

1. IAM + Access API + gateway.  
2. Your module API (+ others you need).  
3. `gvcrm-web` with entitled modules registered.  
4. Login at `/access/login` → open your module from switcher.

### C. API-only

1. MySQL for your DB (+ IAM if testing auth).  
2. Run API with `auth` disabled **only** in a documented local test profile — never in shared/dev servers. Prefer test JWTs from Access.

---

## 4. Seed data

- System roles, permissions, modules: migrations.  
- Local admin user: seed script (password only in local env).  
- Sample leads/accounts: optional fixtures per module — mark PII as fake.

Do not copy production dumps with real insured data onto laptops without approval and masking (PLT sandbox rules).

---

## 5. Design system locally

Link or workspace-install `@gvcrm/styles`. If you change a token, verify:

- One host screen  
- One module harness screen  
- Buttons / tables / banners still align  

---

## 6. Contracts locally

When you change `@gvcrm/contracts`:

1. Bump according to semver (breaking = major).  
2. Update API + Angular consumers in the same effort when possible.  
3. Run contract/consumer tests.

---

## 7. Troubleshooting quick list

| Symptom | Check |
|---------|--------|
| Redirect loop to login | Access URL, cookie/SameSite, clock skew, refresh token |
| 403 on screen you “should” see | Permission on role; module entitlement; custom role disabled |
| Empty module switcher | `org_modules` / JWT `modules` claim |
| Report run OK but no audit | ClickHouse connectivity; decorator registered |
| Styles missing | `@gvcrm/styles` import in host; build of design-system package |
| Cross-module data undefined | Calling Facade/API vs wrong DB join |

---

## 8. Definition of a healthy local day

- You can login (or harness mock Access).  
- You can open your module route.  
- You can hit one authenticated API through the envelope.  
- Lint + unit tests run for your package.  
- You know which **app code** and **requirement ID** you are implementing.
