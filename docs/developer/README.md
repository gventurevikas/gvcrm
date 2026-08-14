# GVCRM Developer Rules

**Audience:** every engineer joining GVCRM (Angular, Node, full-stack, QA).  
**Purpose:** one place for **day-to-day rules**. Architecture depth lives in `docs/dev-docs/` (local); product specs in `docs/requirements/`; schemas in `docs/database/`.

If a PR breaks a rule in this folder, it is a **blocker** unless a tech lead documents an exception.

---

## Start here (first day)

1. [01-getting-started.md](./01-getting-started.md) — what to read, clone, and run  
2. [02-angular-development-rules.md](./02-angular-development-rules.md) — **Angular rules (primary)**  
3. [03-api-backend-rules.md](./03-api-backend-rules.md) — Express / TypeScript / Facade  
4. [04-database-rules.md](./04-database-rules.md) — MySQL / ClickHouse / tenancy  
5. [05-access-security-rules.md](./05-access-security-rules.md) — AuthN / AuthZ / RBAC / custom roles  
6. [06-git-pr-review.md](./06-git-pr-review.md) — branches, commits, PR checklist  
7. [07-testing-rules.md](./07-testing-rules.md) — unit, harness, API, contracts  
8. [08-local-development.md](./08-local-development.md) — local stack, env, workflows  

---

## Platform in one paragraph

Users run **one** Angular app: `gvcrm-web`. Product areas (Leads, Reporting, Access, …) are **independent modules** (`@gvcrm/mod-*`) that plug in through a **Facade**. **Access (`iam`)** is the controlling app for login, permissions, **custom roles**, and which modules you may open. APIs are **Node + TypeScript + Express** behind a gateway, with one **application JSON envelope**. Identity lives in **MySQL** (`gvcrm_iam`); report run audit lives in **ClickHouse** (`report_runs`).

---

## Non-negotiables (all teams)

| # | Rule |
|---|------|
| 1 | One user-facing app (`gvcrm-web`). No new standalone product SPAs. |
| 2 | Modules connect only via **Facade** + `@gvcrm/contracts`. No private cross-imports. No cross-module DB queries. |
| 3 | Passwords, roles, and custom roles live only in **Access / `gvcrm_iam`**. |
| 4 | Angular feature screens: separate **`.ts` + `.html` + `.scss`**. No inline templates/styles. |
| 5 | Chrome (sidebar, header, module switcher) lives in **one layout** — never copy into pages. |
| 6 | UI tokens from `@gvcrm/styles` only — no hardcoded hex in feature SCSS. |
| 7 | Auth via interceptor + guards + `*gvcrmCan`. Never `user.role === 'admin'`. |
| 8 | Every API response uses the **application JSON envelope**. |
| 9 | Every list/mutate query filters by **`org_id`**. |
| 10 | Report runs (any client) write ClickHouse **`report_runs`**. |

---

## Document map (where else to look)

| Need | Location |
|------|----------|
| Product behavior / FRs | `docs/requirements/` |
| Detailed use cases | `docs/use-cases/` |
| Table & column catalog | `docs/database/` |
| Spiral SDLC delivery plans | `docs/plans/` |
| Deep architecture (NgRx, Express patterns, …) | `docs/dev-docs/` (local / gitignored engineering notes) |
| Public product overview | root `README.md` |

---

## Ownership

| Area | Typical owner |
|------|----------------|
| Host chrome, ModuleRegistry | `gvcrm-web` + `@gvcrm/angular-kit` |
| Access / RBAC UI + API | `@gvcrm/mod-access` + `gvcrm-access-api` |
| A product feature | That module’s `@gvcrm/mod-*` + `*-api` |
| Shared types | `@gvcrm/contracts` |
| Design system | `@gvcrm/styles` |
