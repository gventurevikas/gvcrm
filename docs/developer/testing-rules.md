# Testing rules

Independent modules must be **testable without the other fourteen**. The host smoke-tests composition.

---

## 1. Test pyramid

| Level | Where | Required when |
|-------|--------|----------------|
| Unit | Module or API repo | Reducers, Facade methods, domain rules, pure mappers |
| Component / harness | `gvcrm-module-harness` + module | New/changed screens |
| API | `*-api` | New/changed endpoints (success, 401/403, validation) |
| Contract | `@gvcrm/contracts` consumers | Envelope / `data` shape changes |
| Host smoke | `gvcrm-web` | Login → entitled module → one happy path (CI nightly or before release) |
| Access | `mod-access` + `access-api` | Login, custom role CRUD, entitlement deny |

---

## 2. Angular testing rules

| Do | Do not |
|----|--------|
| Mock `AccessFacade` / `ApiClient` in unit tests | Hit real production APIs from unit tests |
| Prefer testing reducers/selectors/effects | Only shallow “component created” tests with no asserts |
| Harness: real `MainLayout` + mock Access | Require full MySQL for every UI unit test |
| Assert `*gvcrmCan` paths (visible vs hidden) for privileged actions | Assume “admin sees everything” without permission codes |

---

## 3. API testing rules

| Case | Assert |
|------|--------|
| Happy path | `success: true`, shape matches contracts |
| Missing auth | 401 |
| Missing permission | 403 |
| Wrong org id / cross-tenant id | 404 or 403 — never leak other tenant data |
| Validation | 400 + `errors[].field` |
| Idempotent ingest | Second webhook does not double-create |

Use Testcontainers (or project-standard MySQL) for repository tests when practical.

---

## 4. Report runs

Any test that **runs** a report must either:

- Assert ClickHouse insert (integration), or  
- Assert the audit decorator/Facade was invoked (unit with mock client).

Never ship a “run report” path that skips `report_runs`.

---

## 5. Flaky tests

- No fixed `sleep` for timing — use fakeAsync / wait for condition.  
- No order dependence across files.  
- No reliance on wall-clock timezone without freezing time.

---

## 6. CI expectations

| Gate | Meaning |
|------|---------|
| Lint | ESLint / Prettier (or repo equivalent) must pass |
| Unit | Module/API unit suite green |
| Build | `gvcrm-web` or module package builds |
| Contract | Breaking Facade/envelope changes fail consumers |

A module PR should merge when **its** tests + contracts pass. Full host integration is not a blocker for every leads bugfix.

---

## 7. Testing PR checklist

```text
## Testing
- [ ] Unit coverage for new logic
- [ ] API cases: 200 + 401/403 + validation (if API)
- [ ] Harness/smoke for new screen (if UI)
- [ ] No secrets in fixtures
- [ ] report_runs covered if report execution
```
