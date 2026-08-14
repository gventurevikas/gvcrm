# Angular development rules

**Status:** final team standard for all Angular work on GVCRM  
**Applies to:** `gvcrm-web`, every `@gvcrm/mod-*`, `@gvcrm/angular-kit`  
**Stack:** Angular + **NgRx** + **RxJS** + `@gvcrm/styles`

This is the document new Angular developers follow. Architecture essays live in `docs/dev-docs/02–07`; **rules and PR blockers live here**.

---

## 1. Mental model

```text
Browser
  └── gvcrm-web                          ← only SPA
        ├── MainLayout (chrome once)
        ├── AccessFacade / interceptor / guards
        └── ModuleRegistry
              ├── @gvcrm/mod-access      ← /access
              ├── @gvcrm/mod-leads       ← /leads
              ├── @gvcrm/mod-reporting   ← /reporting
              └── …
```

| Do | Do not |
|----|--------|
| Add features inside your `@gvcrm/mod-*` | Create a new Angular SPA for a product area |
| Export a **Facade** + **manifest** from the module | Export private pages for other modules to import |
| Navigate with Angular routes (`/leads/...`) | Open another app host or iframe another module |
| Consume `AccessFacade` for auth state | Build a second login or role store in your module |

---

## 2. Hard rules (PR blockers)

Violating any of these fails review.

| # | Rule |
|---|------|
| A1 | Feature and layout components use **`templateUrl` + `styleUrls` only**. No inline `template` / `styles` on product screens. |
| A2 | One component folder = `*.component.ts` + `*.component.html` + `*.component.scss` (+ optional `*.spec.ts`). |
| A3 | Do **not** copy sidebar, header, filter bar, or module switcher into a page. Chrome is `MainLayout` / kit only. |
| A4 | Do **not** call `HttpClient` from a page/component. Use data-access / NgRx effects / `ApiClient`. |
| A5 | Do **not** import another module’s private components, stores, or internals. Call that module’s **Facade** (or navigate). |
| A6 | Do **not** hardcode colors (`#…`, `rgb(…)`) in feature SCSS. Use `@gvcrm/styles` variables/mixins/classes. |
| A7 | Do **not** write `*ngIf="user.role === 'admin'"` (or similar). Use `*gvcrmCan="'led.leads.create'"` / `AccessFacade.has`. |
| A8 | Routes that need auth sit under `MainLayout` with `authGuard`; privileged routes add `permissionGuard` / `moduleEntitlementGuard`. |
| A9 | Feature modules **lazy-load**. Do not eager-load all product features into the host. |
| A10 | Server state goes through **NgRx** (or a documented exception for tiny local UI state). No ad-hoc global `BehaviorSubject` soup for API data. |

**Allowed exception for A1:** tiny presentational widgets in `@gvcrm/angular-kit` only if under ~15 lines of template **and** documented. Never for product pages.

---

## 3. Folder and naming conventions

### 3.1 Host (`gvcrm-web`)

```text
src/app/
  app.config.ts / app.component.*
  app-routing.*
  core/                 ← ApplicationFacade, ModuleRegistry wiring
  layouts/main-layout/  ← chrome only
  features/home/        ← launcher tiles (optional)
```

Product screens do **not** live in the host.

### 3.2 Independent module (`@gvcrm/mod-{name}`)

```text
src/
  public-api.ts           ← export GvcrmModuleApi only
  manifest.ts             ← appCode, routes, navItems, permissions
  {name}.facade.ts        ← only cross-module entry
  shared/                 ← dumb UI used by ≥2 features in THIS module
  features/
    {feature}/
      pages/{name}-page/  ← *.ts *.html *.scss
      components/         ← feature-private, still split files
      store/              ← actions, reducers, selectors, effects
      data-access/        ← *Api services using ApiClient
```

### 3.3 Naming

| Kind | Pattern | Example |
|------|---------|---------|
| Page | `{thing}-page.component.*` | `lead-list-page.component.ts` |
| Presentational | `{thing}.component.*` | `lead-score-badge.component.ts` |
| Facade | `{module}.facade.ts` | `leads.facade.ts` |
| API | `{thing}.api.ts` | `leads.api.ts` |
| Route path | kebab under module prefix | `/leads`, `/leads/:id` |
| Permission | `{app}.{resource}.{action}` | `led.leads.create` |

Selectors / CSS: BEM-like with module prefix when needed (`.lead-list-page__row`). Prefer design-system classes (`.btn`, `.table`, `.banner`) first.

---

## 4. Layouts and routing

### 4.1 Layouts

| Layout | Use |
|--------|-----|
| `AuthLayout` | Access login / forgot password only |
| `MainLayout` | All signed-in screens |

`MainLayout` owns:

- Module switcher (`gvcrm-module-switcher`)
- Sidebar (items from entitled modules’ manifests)
- Header (org, user menu, notifications)
- Optional filter bar (driven by route `data.filterKey`)
- `<router-outlet>` for page content

### 4.2 Routing rules

1. Host composes routes from `ModuleRegistry` / manifests.  
2. Module route prefix matches Access path (`/leads`, `/reporting`, `/access`).  
3. Set `data: { permissions: ['led.leads.read'], filterKey?: 'leads' }` on routes that need them.  
4. Deep links stay in-app: `/deals/opportunities/123` — not a second hostname.  
5. Unknown routes → not-found **inside** `MainLayout` (still signed in).

Example (conceptual):

```ts
{
  path: 'leads',
  canActivate: [moduleEntitlementGuard],
  loadChildren: () => import('@gvcrm/mod-leads').then(/* routes */),
  data: { appCode: 'led' },
}
```

---

## 5. NgRx + RxJS

| Use NgRx for | Use local state / signals for |
|--------------|-------------------------------|
| Lists/details from API | Toggle open/closed on a panel |
| Filters that drive effects | Ephemeral form wizard step UI |
| Auth / entitled modules (host) | Pure presentational hover state |
| Async report run progress | |

**Rules**

1. Pages dispatch **actions**; they do not call `*Api` directly (prefer effects → ApiClient).  
2. Select data with selectors; avoid nested `subscribe` hell — use `async` pipe or `toSignal`.  
3. Unsubscribe: prefer `async` pipe / `takeUntilDestroyed`.  
4. Cross-feature communication inside a module: store or Facade — not random EventEmitters across distant trees.  
5. Cross-**module** communication: Facade / gateway only.

Effects check `ApplicationResponse.success` / `errors` from the envelope (see API rules).

---

## 6. Services and Facades

### 6.1 Layers

```text
Page
  → dispatches / injects feature Facade (UI)
    → NgRx effect or data-access *Api
      → ApiClient (@gvcrm/angular-kit)
        → gateway → module API
```

### 6.2 AccessFacade (every module)

Inject from kit / Access. Do not reimplement.

- `currentUser$`, `org$`, `permissions$`, `entitledModules$`
- `has(permission)` / `hasAll(...)`
- `canOpenModule(appCode)`
- `logout()` / `switchOrg()`

### 6.3 Module Facade

Public methods only. Example: `LeadsFacade.getLead(id)`, `ReportingFacade.run(reportId, params)`.

When Deals needs a lead summary, it calls **LeadsFacade** (HTTP under the hood) — it does **not** import Leads NgRx store.

### 6.4 ApiClient

```ts
this.api.get<Lead[]>('led', '/leads', params);
this.api.post<ReportRun>('dar', `/reports/${id}/runs`, body);
```

`app` codes: `iam`, `led`, `dar`, `acm`, … — never invent a free-form URL outside `/v1/{app}/…`.

---

## 7. Auth, guards, and template RBAC

| Mechanism | Responsibility |
|-----------|----------------|
| `authInterceptor` | Attach Bearer token, `X-Request-Id`, refresh once on 401 |
| `authGuard` | Must be logged in |
| `moduleEntitlementGuard` | Org/user may open this module |
| `permissionGuard` | Route `data.permissions` (AND) |
| `*gvcrmCan="'…'"` | Hide/disable buttons |

**Login** lives in Access (`/access/login`), not inside Leads/Reporting.  
**Logout** via `AccessFacade` — clears session for the whole app.

Server still enforces the same permission codes. UI hide is UX only.

---

## 8. SCSS and design system

1. Import `@gvcrm/styles` in the host global styles; feature SCSS uses tokens/mixins.  
2. Prefer utility / component classes: `.btn`, `.btn--primary`, `.table`, `.banner`, `.form-field`, `.progress`, `.spinner`.  
3. Fixing a button look = change design system once — not 50 pages.  
4. Spacing and type scale from tokens (`$space-*`, `$font-*`).  
5. Do not fight `MainLayout` padding with one-off page margins that break chrome.

Insurance / remote-sales screens still use the same system — no one-off “agent theme” without design-system tokens.

---

## 9. Forms and UX patterns

| Pattern | Rule |
|---------|------|
| Create/edit forms | Reactive forms; validate before submit; show envelope `errors[].field` |
| Lists | Paginate via API (`page`, `pageSize`, `sort`, `q`); never load unbounded sets |
| Destructive actions | Confirm dialog; require permission |
| Async work (report run, import) | Progress UI (`.progress` / `.spinner`); do not block the shell |
| Empty states | Shared empty-state component; clear next action |
| Toasts | `ToastService` from kit — not `alert()` |
| Dates | Store/display with user timezone from Access profile |
| Money | Show currency from org/record; never assume format in three places |

Accessibility: buttons need labels; icons need `aria-label`; do not rely on color alone for rotting-deal severity.

---

## 10. Manifest and ModuleRegistry

Every module exports something equivalent to:

```ts
export interface GvcrmModuleManifest {
  appCode: string;          // 'led'
  displayName: string;
  version: string;
  routes: Route[];
  navItems: NavItem[];
  permissions: string[];    // catalog this module contributes
}
```

When you add a screen:

1. Add page files (ts/html/scss)  
2. Add lazy route  
3. Add `navItems` entry with `permission`  
4. Register any **new** permission codes with Access (migration + manifest)  
5. Bump module version; host pins or loads the new version  

---

## 11. Independent development and testing (Angular)

| Mode | When |
|------|------|
| `gvcrm-module-harness` + your module | Day-to-day UI without full host |
| `gvcrm-web` with your module | Integration / entitlement / switcher |
| Unit tests | Reducers, selectors, pure pipes, Facade methods |
| Component tests | Pages with mocked Facade / store |

Your module PR must be reviewable **without** requiring all 15 modules to build.

See [07-testing-rules.md](./07-testing-rules.md).

---

## 12. Module-specific Angular notes

| Module | Extra rule |
|--------|------------|
| **Reporting (`dar`)** | Every Run report calls `POST /v1/dar/reports/:id/runs` so ClickHouse `report_runs` is written. Show run progress. |
| **Leads (`led`)** | Preserve Meta/LinkedIn consent flags; do not invent a second consent store — CCM is SoR after sync. |
| **Access (`iam`)** | Custom role UI only attaches catalog permissions; never invent codes in the UI. |
| **Assistant (`aia`)** | Writes go through preview/confirm; assistant cannot bypass `*gvcrmCan` / server RBAC. |
| **Insurance (`ins`)** | NPN / policy numbers are sensitive — no logging to console in production builds. |

---

## 13. Angular PR checklist (paste into PR)

```text
## Angular
- [ ] Page/layout: separate .ts / .html / .scss
- [ ] No chrome copy-paste; under MainLayout
- [ ] No HttpClient in component
- [ ] NgRx or documented local state
- [ ] Route guards + *gvcrmCan for privileged actions
- [ ] Styles use @gvcrm/styles (no hex)
- [ ] Cross-module only via Facade / navigation
- [ ] Manifest nav + permissions updated if needed
- [ ] Tests / harness smoke for the change
```

---

## 14. Anti-patterns (reject these)

- “Temporary” inline template “we’ll split later”  
- Shared `components/` dumping ground at repo root  
- Importing `@gvcrm/mod-leads/.../lead-list-page` from Deals  
- `localStorage.setItem('token', …)` outside Access/kit  
- Hardcoded sidebar HTML in a feature page  
- `any` on API responses instead of `@gvcrm/contracts` types  
- Duplicating Access permission logic in a feature service  

---

## 15. Where to go deeper

| Topic | Doc |
|-------|-----|
| Host vs module folders | `docs/dev-docs/02-angular-application-structure.md` |
| Layouts / switcher | `docs/dev-docs/03-angular-layouts-routing.md` |
| SCSS tokens | `docs/dev-docs/04-angular-scss-design-system.md` |
| NgRx slices | `docs/dev-docs/05-angular-ngrx-rxjs.md` |
| Services | `docs/dev-docs/06-angular-services.md` |
| Interceptor / guards | `docs/dev-docs/07-angular-auth-rbac.md` |
| Platform composition | `docs/dev-docs/01-multi-project-platform.md` |
