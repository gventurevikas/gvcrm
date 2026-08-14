# API and backend development rules

**Applies to:** `gvcrm-gateway`, `gvcrm-access-api`, every `gvcrm-*-api`  
**Stack:** Node.js + TypeScript + Express  
**Patterns:** Singleton, Factory, Abstract Factory, Builder, Decorator, **Facade**  
**Public docs:** Partner-facing API reference is published with **Scalar** — see `docs/dev-docs/scalar.md`.

---

## 1. Mental model

```text
Client (gvcrm-web / mobile / partner)
  → gvcrm-gateway          JWT + RBAC + route by appCode
    → gvcrm-access-api     iam
    → gvcrm-leads-api      led
    → gvcrm-reporting-api  dar (+ ClickHouse report_runs)
    → …
```

Controllers stay thin. Business entry point is always a **Facade**.

---

## 2. Hard rules (PR blockers)

| # | Rule |
|---|------|
| B1 | Every success/error body uses the **application JSON envelope** (`success`, `app`, `apiVersion`, `requestId`, `orgId`, `actor`, `data`, `meta`, `errors`). |
| B2 | Controllers call **Facade methods only** — no SQL, no pool, no ClickHouse in controllers. |
| B3 | Routes mount under `/v1/{appCode}/…` (`led`, `dar`, `iam`, …). |
| B4 | Interactive routes use `auth` + `rbac` middleware with a real permission code. |
| B5 | Never query another module’s database. Call that module’s API / internal client. |
| B6 | Never store passwords or invent roles tables outside `gvcrm_iam` / Access. |
| B7 | Always propagate / generate `requestId` (`X-Request-Id`). |
| B8 | Tenant queries always filter by **`org_id`** from the JWT (not from unconstrained client body alone). |
| B9 | Report executions write ClickHouse **`report_runs`** (decorator `withReportRunAudit`). |
| B10 | Types for public `data` shapes live in **`@gvcrm/contracts`** — update contracts in the same change when the shape changes. |

---

## 3. Folder layout (every API repo)

```text
src/
  main.ts
  app.ts
  config/                 ← Singleton Config
  http/
    routes/
    controllers/
    middleware/           ← auth, rbac, requestId, error
  application/
    facades/
    builders/
    decorators/
  domain/
  infrastructure/         ← MySQL repos, ClickHouse, queues
  di/                     ← singletons, factories
```

---

## 4. Application JSON envelope

```json
{
  "success": true,
  "app": "led",
  "apiVersion": "v1",
  "requestId": "…",
  "orgId": "…",
  "actor": { "userId": "…", "userType": "producer", "roles": ["…"] },
  "data": {},
  "meta": {},
  "errors": []
}
```

| Do | Do not |
|----|--------|
| `ApplicationResponseBuilder.success(app, data).meta({…}).build()` | `res.json({ ok: true })` |
| Error codes `{APP}.{SNAKE_REASON}` e.g. `LED.DUPLICATE_AD_LEAD` | Free-text-only errors with no code |
| Lists: `data` is an **array**; totals in `meta.total` | Wrap lists inconsistently |

`app` for Access is **`iam`** (not `idt`).

Full contract: `docs/dev-docs/09-application-json-contracts.md` / `@gvcrm/contracts`.

---

## 5. Auth and RBAC on the server

1. Public: `/health`, `/ready`, Access `POST /v1/iam/login` (and documented public hooks).  
2. All else: Bearer JWT from Access.  
3. `rbac` middleware: route requires e.g. `dar.reports.run`.  
4. Effective permissions already include **custom roles** (resolved at login/refresh in Access).  
5. UI hide ≠ security — API must enforce.

Do not trust `roles: ['admin']` from the client body. Trust JWT validated with Access keys.

---

## 6. Facade and patterns

| Pattern | Use |
|---------|-----|
| **Facade** | One per feature/module entry (`LeadsFacade`, `ReportingFacade`, `RbacFacade`) |
| **Singleton** | `MysqlPool`, `ClickHouseClient`, `Config`, `Logger` |
| **Factory** | Per-request services / unit of work with `orgId` |
| **Builder** | Application response; complex report queries |
| **Decorator** | `withReportRunAudit`, `withLogging`, `withIdempotency` |

Cross-module: `GvcrmApplicationFacade` / HTTP client to sibling API — never shared tables.

---

## 7. Adding an endpoint (checklist)

1. Add/extend type in `@gvcrm/contracts`.  
2. Route under `/v1/{app}/…`.  
3. `auth` + `rbac` with permission string.  
4. Controller → Facade.  
5. Envelope response.  
6. If report run → audit decorator.  
7. Tests (happy path + 401/403 + validation).  
8. Update `docs/database` if schema changed.

---

## 8. Workers and ingest (Leads Meta/LinkedIn)

| Rule | Why |
|------|-----|
| Idempotency key unique per org+provider | Webhook retries |
| Tokens encrypted at rest | LED-SEC-006 |
| Consent flags preserved → CCM | TCPA |
| Concurrent-safe assignment | No double-assign |

Same Facade methods as HTTP when possible so assistant/workers share behavior.

---

## 9. Logging and secrets

- Log `requestId`, `orgId`, `userId`, `appCode` — not tokens, password hashes, OAuth secrets, full card images.  
- Structured logs (JSON).  
- Encrypt `*_encrypted` columns; never return them in `data`.

---

## 10. API PR checklist

```text
## API
- [ ] Application JSON envelope
- [ ] /v1/{appCode}/… path
- [ ] auth + rbac permission
- [ ] Controller → Facade only
- [ ] org_id enforced
- [ ] @gvcrm/contracts updated if needed
- [ ] report_runs audited if report execution
- [ ] No cross-module DB access
- [ ] Tests for success + 403 + validation
```
