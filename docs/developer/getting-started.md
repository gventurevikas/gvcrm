# Getting started

Welcome to GVCRM. Read this on day one before opening a PR.

---

## 1. What you are building

| Layer | Name | Your mental model |
|-------|------|-------------------|
| Product | US insurance CRM | Agencies / carriers, remote producers, Meta/LinkedIn leads, D/W/M leaderboards, ChatGPT assistant |
| UI | `gvcrm-web` | **One** Angular application users open |
| Features | `@gvcrm/mod-*` | Independent modules (Leads, Reporting, Access, …) loaded into the host |
| Auth | Access (`iam`) | Login, RBAC, **custom roles**, module entitlements |
| API | Express TS APIs + gateway | Same JSON for Angular and any other client |
| Data | MySQL per module + `gvcrm_iam` | ClickHouse for `report_runs` |

Ask your lead which **app code** you own: `iam`, `led`, `dar`, `acm`, `odm`, …

---

## 2. Reading order (first week)

| Day | Read | Why |
|-----|------|-----|
| 0 | [README.md](../../README.md) + [requirements/README.md](../requirements/README.md) | Product |
| 0 | [developer/README.md](./README.md) + this file | Rules map |
| 1 | [02-angular-development-rules.md](./02-angular-development-rules.md) | If you touch UI |
| 1 | [03-api-backend-rules.md](./03-api-backend-rules.md) | If you touch APIs |
| 1 | [05-access-security-rules.md](./05-access-security-rules.md) | Everyone |
| 2 | Your module’s `docs/requirements/0x-*.md` | Behavior you will implement |
| 2 | Matching `docs/database/*.md` | Tables you will use |
| 3 | [06-git-pr-review.md](./06-git-pr-review.md) + [07-testing-rules.md](./07-testing-rules.md) | Ship quality |
| Optional | `docs/dev-docs/` (if available locally) | Deep architecture |

Do **not** try to memorize all 15 modules on day one.

---

## 3. What to clone

Minimum for an Angular feature developer:

```text
gvcrm-web
@gvcrm/angular-kit (or monorepo package)
@gvcrm/styles
@gvcrm/contracts
@gvcrm/mod-{your-module}     e.g. mod-leads
gvcrm-{your-module}-api        if you also own API
gvcrm-access-api               login locally
gvcrm-gateway                  optional if APIs are reached via gateway
```

Use `gvcrm-module-harness` to run **only your module** with a mock Access facade when the full host is not needed.

Do **not** clone every module “just in case.”

---

## 4. Tooling baseline

| Tool | Version / note |
|------|----------------|
| Node.js | 20 LTS or newer |
| Package manager | Match repo (`npm` / `pnpm` — follow existing lockfile) |
| Angular CLI | Same major as `gvcrm-web` / kit |
| MySQL | 8.x — at least `gvcrm_iam` |
| ClickHouse | Only if you touch reporting / `report_runs` |
| IDE | Cursor / VS Code; enable ESLint + Prettier for the repo |

See [08-local-development.md](./08-local-development.md) for env vars and run scripts.

---

## 5. Your first useful PR (examples)

**Angular**

- One new page under `features/…` with `.ts` + `.html` + `.scss`
- Lazy route + `data.permissions`
- Nav entry on module `manifest.ts`
- `*gvcrmCan` on privileged buttons
- Spec or harness smoke

**API**

- One route under `/v1/{app}/…`
- Auth + RBAC middleware
- Controller → Facade only
- Application JSON envelope
- Contract type update if `data` shape changed

**Access**

- Prefer extending permissions catalog + custom role UI — never invent a second users table

---

## 6. Who to ask

| Question | Owner |
|----------|--------|
| Which module / app code? | Tech lead |
| New permission code? | Access owner + module owner |
| Cross-module data? | Facades / gateway — never direct DB |
| Design token / button style? | Design system (`@gvcrm/styles`) |
| Schema change? | Module owner + `docs/database` update in same PR |

---

## 7. Definition of done (personal checklist)

Before you mark a ticket done:

- [ ] Matches the requirement ID (e.g. `LED-FR-002`) when one exists  
- [ ] Follows Angular or API rules in this folder  
- [ ] Permissions checked (UI **and** server)  
- [ ] `org_id` scoped  
- [ ] Tests at the level required in [07](./07-testing-rules.md)  
- [ ] Docs updated if you added a table, permission, or public Facade method  
