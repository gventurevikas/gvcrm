# Program Master Spiral Plan

**Document ID:** GVCRM-PLAN-MASTER  
**Method:** Spiral SDLC (Boehm)  
**Status:** Ready for execution planning  
**Sources:** `README.md`, `docs/requirements/*`, `docs/database/*`, `docs/developer/*`

---

## 1. Program purpose

Deliver **GVCRM** — a US insurance sales CRM for remote producers — as an incremental product:

| Pillar | Outcome |
|--------|---------|
| Sell | Accounts/households, Meta/LinkedIn leads, insurance pipelines, quotes |
| Run | Remote workspace, forecasts, D/W/M leaderboards |
| Ask & act | Central ChatGPT-mini assistant across modules |
| Automate | Workflows, validation, approvals |
| Extend | Custom fields, layouts, modules, apps |
| Publish | In-product marketplace + external listing hub |

**Current repo state:** product definition only (requirements + database + developer rules). Application source lands under this program plan.

---

## 2. Locked architecture (non-negotiable)

| Layer | Decision |
|-------|----------|
| UI | One Angular app `gvcrm-web`; features as `@gvcrm/mod-*` |
| Cross-module | Facade + `@gvcrm/contracts` only |
| AuthZ | Access / `gvcrm_iam` owns passwords, roles, custom roles, entitlements |
| API | Node + TypeScript + Express; application JSON envelope |
| Data | MySQL 8 per module DB; ClickHouse `report_runs` |
| Tenancy | `org_id` on every tenant row; no cross-module FKs |

Violations are PR blockers per `docs/developer/`.

---

## 3. Full SDLC stages (mapped onto spirals)

| Classic SDLC stage | How it appears in GVCRM spirals |
|--------------------|----------------------------------|
| Requirements | Already published under `docs/requirements/`; each spiral selects a FR slice |
| Analysis / architecture | Risk quadrant + Facade/contract design each cycle |
| Design | Schema slice from `docs/database/`, API OpenAPI/contracts, Angular screens |
| Implementation | Vertical slice per module team |
| Testing | Unit, harness, API contract, E2E against acceptance criteria |
| Deployment | Sandbox → prod config path (PLT); feature flags for entitlements |
| Operations / feedback | Evaluation quadrant → next spiral backlog |

Spirals **do not** re-write requirements from scratch; they **select, refine risks, and prove** them.

---

## 4. Program spirals (waves)

### Wave S0 — Platform skeleton (hard gate)

**Objectives**

- Runnable `gvcrm-web` host + ModuleRegistry + chrome layout
- `gvcrm_iam` full schema, login/refresh, JWT claims (`sub`, `orgId`, `roles`, `perm`, `modules`)
- Gateway + shared envelope + `@gvcrm/contracts` + `@gvcrm/styles`
- Local MySQL (+ optional ClickHouse) developer stack

**Primary risks:** Fake multi-SPA drift; password storage outside IAM; missing `org_id` filters.

**Exit criteria**

- User can log in, see empty module shell for entitled apps only
- New module can register via Facade without private imports
- IAM seed: `user_types`, `modules`, `permissions`, system roles

**Plans:** [00-foundation-platform-skeleton.md](./00-foundation-platform-skeleton.md)

---

### Wave S1 — Metadata + party model

**Objectives**

- Thin Platform: notes, notifications, `record_shares`, `record_audit_events`, `custom_json` path
- ACM P0: accounts, contacts, hierarchy, individual scheduling

**Exit criteria:** Create account + contact; hierarchy without cycles; record visible per sharing.

**Plans:** PLT, ACM

---

### Wave S2 — Pipeline core

**Objectives**

- LED P0 capture, assignment, scoring, lifecycle (without Meta/LinkedIn if blocked — schedule those for S4)
- ODM P0 pipelines, Kanban, probability, rotting
- PRD P0 product catalog + price books (enough for line items)

**Exit criteria:** Lead → convert → opportunity on Kanban; product selectable on deal.

**Plans:** LED, ODM, PRD

---

### Wave S3 — Engage + automate

**Objectives**

- CCM P0: call reminders, email, templates, association, consent store
- WPA P0: validation, workflow rules, approvals (esp. for discounts later)
- DOC thin: upload, attach, version, share link

**Exit criteria:** Email on lead/contact with consent check; validation blocks invalid stage change; PDF attachable.

**Plans:** CCM, WPA, DOC

---

### Wave S4 — Insurance vertical MVP

**Objectives**

- INS P0: org modes, LOBs, households, policies, renewals, remote workspace hooks, TCPA flags
- LED-FR-008 Meta + LinkedIn real-time ingest (≤15s)
- QOC P0 quotes (+ order/contract/invoice basics as capacity allows)

**Exit criteria:** Ad lead lands → assigned producer notified → household/policy → quote PDF.

**Plans:** INS, LED (ingest spiral), QOC

---

### Wave S5 — Visibility & motivation

**Objectives**

- DAR P0 homepage, dashboards, custom/pre-built reports, CH `report_runs`
- SPM P0 goals, forecast, gamification, **daily/weekly/monthly leaderboards**

**Exit criteria:** Homepage &lt;2s; report run audited in ClickHouse; D/W/M boards published.

**Plans:** DAR, SPM

---

### Wave S6 — Collaboration & assistant

**Objectives**

- TCL P0 feeds, mentions, tags, user groups (+ P1 chat if capacity)
- AIA MVP: central chat shell, help, single-record ops with confirm, conversational reports via DAR

**Exit criteria:** Mention notifies safely; assistant creates lead under user RBAC; report draft promotes to DAR.

**Plans:** TCL, AIA

---

### Wave S7 — Platform economy / first production polish (v1)

**Objectives**

- MKT MVP: free apps, package from PLT, sandbox→prod install, OAuth scopes, kill switch
- v1 polish: SMS analytics, portals, paid licensing, external listing workspace, assistant send email/SMS, NPN reminders

**Exit criteria:** Install free app in sandbox then prod; external listing draft pack exportable.

**Plans:** MKT + delta spirals on CCM, PRD, AIA, INS

---

## 5. Cross-cutting every wave

| Concern | Owner / artifact |
|---------|------------------|
| Tenancy + soft delete | Database conventions |
| RBAC / FLS / sharing | IAM + PLT |
| Consent / TCPA / DNC | CCM SoR; INS `tcpa_strict`; LED snapshots |
| Audit lanes | IAM audit, PLT record audit, CH `report_runs` |
| Testing | `docs/developer/testing-rules.md` |
| Git / PR | `docs/developer/git-pr-review.md` |

---

## 6. MVP definition of done (program)

Ship when this story works end-to-end for a US agency tenant:

1. Remote producer logs in (entitled modules only).
2. Meta or LinkedIn lead arrives in ≤15s, assigned, consent stored.
3. Producer works household + new-business or renewal opportunity.
4. First-touch call/email logged with TCPA respected.
5. Quote generated; homepage shows pipeline + **today’s leaderboard**.
6. ChatGPT-mini can answer “where am I on this week’s board?” and run a simple report.
7. Core workflow validation and one approval type available.
8. Free marketplace app installable in sandbox.

Anything not required for that path stays in later spirals (P1/P2).

---

## 7. Risk register (program-level)

| Risk | Impact | Mitigation |
|------|--------|------------|
| Building all 15 UIs before first path | Delay to value | Enforce wave order; empty schemas OK |
| Cross-module DB joins | Coupling / outages | Facade-only; ULID refs |
| TCPA violations | Legal | Consent SoR in CCM before outbound |
| Assistant privilege escalation | Security | Tool calls as signed-in user; confirm + audit + kill switch |
| Leaderboard PII leak | Trust | Share-aware metrics only |
| ClickHouse optionalized away | No report audit | `report_runs` required with DAR |
| Marketplace malware | Tenant risk | Signed packages, review, kill switch |

---

## 8. Evaluation cadence

| Gate | Audience | Evidence |
|------|----------|----------|
| Spiral exit | Module tech lead + product | AC checklist, demo recording |
| Wave exit | Program lead | Integrated demo across modules in wave |
| MVP gate | Stakeholders | Program DoD story above |
| v1 gate | Stakeholders | Paid MKT + external listing + polish list |

---

## 9. Traceability matrix (high level)

| Wave | Requirement prefixes | Databases |
|------|----------------------|-----------|
| S0 | Access / developer rules | `gvcrm_iam` |
| S1 | PLT, ACM | `gvcrm_plt`, `gvcrm_acm` |
| S2 | LED, ODM, PRD | `gvcrm_led`, `gvcrm_odm`, `gvcrm_prd` |
| S3 | CCM, WPA, DOC | `gvcrm_ccm`, `gvcrm_wpa`, `gvcrm_doc` |
| S4 | INS, LED-FR-008, QOC | `gvcrm_ins`, `gvcrm_led`, `gvcrm_qoc` |
| S5 | DAR, SPM | `gvcrm_dar`, `gvcrm_spm`, `gvcrm_analytics` |
| S6 | TCL, AIA | `gvcrm_tcl`, `gvcrm_aia` |
| S7 | MKT (+ deltas) | `gvcrm_mkt` |

---

## 10. Team topology (suggested)

| Squad | Owns |
|-------|------|
| Platform | Host, gateway, contracts, styles, PLT, WPA |
| Access | IAM UI + `gvcrm-access-api` |
| Growth | LED, CCM, SPM campaigns |
| Pipeline | ACM, ODM, PRD, QOC |
| Insurance | INS + compliance hooks |
| Insights | DAR + ClickHouse + SPM boards |
| Experience | TCL + AIA |
| Ecosystem | MKT |

Squads start after S0; Growth + Pipeline may begin S2 in parallel once Facades exist.
