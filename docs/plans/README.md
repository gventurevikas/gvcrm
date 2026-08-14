# GVCRM Spiral SDLC Plans

This folder turns product specs (`docs/requirements/`), physical schemas (`docs/database/`), and developer rules (`docs/developer/`) into **complete spiral-method implementation plans**.

Each plan is independent enough for a module team to execute, while the program master plan defines wave order and exit gates.

---

## Spiral method (how we work)

Boehm’s spiral model, applied per module and at program level:

| Quadrant | What we do each cycle |
|----------|------------------------|
| **1. Objectives** | Goals, scope slice, stakeholders, success metrics, requirement IDs in scope |
| **2. Risk analysis** | Technical, compliance, dependency, and delivery risks + mitigations |
| **3. Engineering** | Design → build → unit/API/UI tests against acceptance criteria |
| **4. Evaluation** | Demo, stakeholder review, exit criteria, backlog for next spiral |

Rules:

1. Prefer a **vertical slice** (schema + API + `@gvcrm/mod-*` UI + Facade contracts) over horizontal layers.
2. Never start a domain spiral before **Access / IAM** can issue JWT with `orgId`, roles, perms, and modules.
3. Cross-module access only via **Facade + `@gvcrm/contracts`** — no cross-DB FKs.
4. Every list/mutate filters by **`org_id`**. Report runs always write ClickHouse **`report_runs`**.
5. Keep requirement IDs (`ACM-FR-001`, …) as ticket and test traceability keys.

---

## Document index

| File | Covers |
|------|--------|
| [00-program-master-spiral-plan.md](./00-program-master-spiral-plan.md) | Full program SDLC, waves S0–S7, MVP/v1 gates |
| [00-foundation-platform-skeleton.md](./00-foundation-platform-skeleton.md) | Host, gateway, IAM, contracts, styles, local stack |
| [01-accounts-and-contacts-spiral-plan.md](./01-accounts-and-contacts-spiral-plan.md) | ACM |
| [02-customer-communication-spiral-plan.md](./02-customer-communication-spiral-plan.md) | CCM |
| [03-dashboards-and-reports-spiral-plan.md](./03-dashboards-and-reports-spiral-plan.md) | DAR |
| [04-documents-spiral-plan.md](./04-documents-spiral-plan.md) | DOC |
| [05-leads-spiral-plan.md](./05-leads-spiral-plan.md) | LED |
| [06-opportunities-deals-spiral-plan.md](./06-opportunities-deals-spiral-plan.md) | ODM |
| [07-products-spiral-plan.md](./07-products-spiral-plan.md) | PRD |
| [08-quotes-orders-contracts-spiral-plan.md](./08-quotes-orders-contracts-spiral-plan.md) | QOC |
| [09-platform-capabilities-spiral-plan.md](./09-platform-capabilities-spiral-plan.md) | PLT |
| [10-sales-performance-spiral-plan.md](./10-sales-performance-spiral-plan.md) | SPM |
| [11-team-collaboration-spiral-plan.md](./11-team-collaboration-spiral-plan.md) | TCL |
| [12-workflows-automation-spiral-plan.md](./12-workflows-automation-spiral-plan.md) | WPA |
| [13-marketplace-publishing-spiral-plan.md](./13-marketplace-publishing-spiral-plan.md) | MKT |
| [14-ai-assistant-central-chat-spiral-plan.md](./14-ai-assistant-central-chat-spiral-plan.md) | AIA |
| [15-us-insurance-remote-sales-spiral-plan.md](./15-us-insurance-remote-sales-spiral-plan.md) | INS |

---

## Program wave map (summary)

| Wave | Focus | Primary plans |
|------|--------|----------------|
| **S0** | Platform skeleton | Foundation + IAM |
| **S1** | Metadata + party model | PLT (thin) + ACM |
| **S2** | Pipeline core | LED + ODM + PRD (catalog) |
| **S3** | Engage + automate | CCM (P0) + WPA + DOC (thin) |
| **S4** | Insurance vertical MVP | INS + LED Meta/LinkedIn + QOC quotes |
| **S5** | Visibility & motivation | DAR + SPM (D/W/M boards) |
| **S6** | Collaboration & assistant | TCL + AIA MVP |
| **S7** | Platform economy / v1 | MKT + polish (SMS analytics, portals, paid apps) |

Waves may overlap once Facades and contracts exist; **S0 is a hard gate**.

---

## How to use a module plan

1. Open the matching requirement and database docs.
2. Confirm which spiral cycle you are in (P0 first).
3. Copy Objectives / Risks / Engineering / Evaluation into sprint tickets.
4. Trace every story to `{PREFIX}-FR-NNN` and acceptance criteria.
5. Do not exit a spiral until Evaluation exit criteria are met.

---

## Related documentation

| Need | Location |
|------|----------|
| Product FRs | `docs/requirements/` |
| Detailed use cases | `docs/use-cases/` |
| Tables / columns | `docs/database/` |
| Day-to-day engineering rules | `docs/developer/` |
| Product overview | root `README.md` |
