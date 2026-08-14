# GVCRM

**CRM for US insurance agencies and insurance companies — built for remote, sales-first producers.**

GVCRM is a full-lifecycle sales CRM oriented to **independent and captive agencies**, **MGAs/IMOs**, and **carrier sales teams in the United States**. Agents often work from home or the field: they need instant **Meta and LinkedIn** leads, insurance pipelines (new business, cross-sell, renewal), a **central ChatGPT-mini assistant**, and **daily / weekly / monthly leaderboards** so distributed teams stay competitive without an office floor.

The platform still covers accounts, quotes-to-cash, collaboration, reporting, custom apps, and a **Marketplace** (in-product plus external stores such as Salesforce AppExchange, HubSpot Marketplace, Microsoft AppSource, Google Workspace Marketplace, and Slack).

> **Status:** Product requirements are published and implementation-ready. Application code is not in this repository yet.

---

## Table of contents

- [Why GVCRM](#why-gvcrm)
- [Who it is for](#who-it-is-for)
- [What you can do](#what-you-can-do)
- [US insurance and remote sales](#us-insurance-and-remote-sales)
- [Product modules](#product-modules)
- [Central chat and ChatGPT-mini assistant](#central-chat-and-chatgpt-mini-assistant)
- [Marketplace and app publishing](#marketplace-and-app-publishing)
- [Platform foundations](#platform-foundations)
- [Repository layout](#repository-layout)
- [Documentation](#documentation)
- [Requirement IDs](#requirement-ids)
- [Current status and roadmap](#current-status-and-roadmap)
- [Getting started](#getting-started)
- [Contributing](#contributing)
- [Security](#security)
- [License](#license)

---

## Why GVCRM

Most CRMs stop at records and reports. GVCRM is specified as both a **sales system of record** and a **platform**:

| Pillar | What it means |
|--------|----------------|
| **Sell** | Insurance new business, cross-sell, and renewals — quotes, binds, book of business |
| **Run** | Remote agent workspace, forecasts, Meta/LinkedIn campaigns, D/W/M leaderboards |
| **Ask & act** | Central ChatGPT-mini chat to operate any module and build custom reports |
| **Automate** | Visual sales processes, workflow rules, validation, and approvals |
| **Extend** | Custom fields, modules, layouts, and full custom apps |
| **Publish** | Package an app once; list it on the in-product marketplace or an external store |

Detailed specifications live in independent, implementable requirement documents under `docs/requirements/`.

---

## Who it is for

| Audience | How they use GVCRM |
|----------|--------------------|
| Remote producers / agents | Work Meta/LinkedIn leads, quote and bind, call/SMS, chat, watch today’s leaderboard |
| ISAs / inside sales | Speed-to-lead, round-robin queues, appointment set for producers |
| Agency principals / sales managers | Book growth, D/W/M leaderboards, renewals, producer coaching |
| Carrier sales / wholesalers | Appointed agencies, pipeline by LOB and state |
| Admins and compliance | Sandbox deploy, TCPA/DNC, license expiry, assistant governance |
| Partners and ISVs | Industry packs, raters, carrier connectors via Marketplace |

---

## What you can do

- Maintain **account hierarchies** and **360° contact views**, including org charts and maps
- Capture **leads** from forms, import, email parser, card scan, APIs, and **real-time Meta + LinkedIn campaigns**; score and auto-assign them
- Run **insurance pipelines** (new business, cross-sell, renewal) on a Kanban board, with win probability and **rotting-deal** alerts
- Communicate from CRM or Gmail/Outlook: email, SMS, calls, templates, tracking, and mass send
- Generate **quotes, orders, contracts, invoices**, and supply/payment schedules
- Store **documents and playbooks** with search, share links, and version history
- Track performance with **goals, forecasts** (best / likely / worst), Meta/LinkedIn campaign ROI, and **complete gamification** (daily, weekly, monthly leaderboards)
- Collaborate with **feeds, mentions, private chat, tags, user groups, and field check-in**
- Automate with **approvals, validation rules, workflow rules, and a visual sales process editor**
- Use **central chat (ChatGPT-mini)** to run operations across modules and **create custom reports** from required details
- Extend the CRM with **custom apps**, then **install or publish** them through Marketplace

---

## Product modules

Each module has its own requirement file. Specs are independent so a team can implement one area without reading every document.

| Module | Summary | Spec |
|--------|---------|------|
| **Accounts & Contacts** | Company/person 360°, hierarchy, org charts, maps, individual and group scheduling | [01](docs/requirements/01-accounts-and-contacts-management.md) |
| **Customer Communication** | Calls, native email, Gmail/Outlook, SMS, templates, tracking, mass email | [02](docs/requirements/02-customer-communication-management.md) |
| **Dashboards & Reports** | Homepage, pre-built and custom analytics, charts, sharing, API usage; engine for chat-built reports | [03](docs/requirements/03-dashboards-and-reports.md) |
| **Documents** | Repository, attachments, encrypted share links, search, conversion, playbooks, versions | [04](docs/requirements/04-documents-management.md) |
| **Leads** | Multi-source capture including **real-time Meta & LinkedIn**, scoring, assignment, parser, card scan, win-loss | [05](docs/requirements/05-leads-management.md) |
| **Opportunities / Deals** | Multi-pipeline, Kanban, probability, rotting (P0), activity timeline, journey designer | [06](docs/requirements/06-opportunities-deals-management.md) |
| **Products** | Catalog, taxonomy, groups, costs/pricing, branded prospect portals | [07](docs/requirements/07-products-management.md) |
| **Quotes, Orders & Contracts** | Quote-to-cash, website order intake, invoices, amendments, supply schedules | [08](docs/requirements/08-quotes-orders-and-contracts-management.md) |
| **Platform** | Custom fields/layouts/modules/apps, sandbox, deploy, i18n, multi-currency, cases, notes | [09](docs/requirements/09-platform-capabilities.md) |
| **Sales Performance** | Goals, forecasting, Meta/LinkedIn campaigns, **complete gamification**, **D/W/M leaderboards** | [10](docs/requirements/10-sales-performance-management.md) |
| **Team Collaboration** | Feeds, geo check-in, mentions, private chat, tags, user groups | [11](docs/requirements/11-team-collaboration.md) |
| **Workflows & Automation** | Sales process editor, workflow rules, templates, validation, approvals | [12](docs/requirements/12-workflows-and-process-automation.md) |
| **Marketplace & Publishing** | In-app store, publisher portal, external marketplace hub | [13](docs/requirements/13-marketplace-and-app-publishing.md) |
| **AI Assistant & Central Chat** | ChatGPT-mini system assistant: help, business operations, conversational custom reports | [14](docs/requirements/14-ai-assistant-and-central-chat.md) |
| **US Insurance & Remote Sales** | Agency/carrier orientation, households, LOBs, book of business, remote workspace, US compliance | [15](docs/requirements/15-us-insurance-agency-and-remote-sales.md) |
| **Kafka Messaging** | Independent realtime bus: lead ingest, notifications, workflows, gamification, `report_runs` | [16](docs/requirements/16-kafka-messaging-platform.md) |
| **Platform API Docs (Scalar)** | Public OpenAPI portal so ISVs build like Salesforce / HubSpot / Zoho | [17](docs/requirements/17-platform-api-documentation-scalar.md) |

Full index, ID convention, and priority legend: [docs/requirements/README.md](docs/requirements/README.md).

---

## US insurance and remote sales

GVCRM is **not a generic CRM first**. It is specified for how insurance is sold in the USA when producers are distributed:

| Need | How GVCRM helps |
|------|-----------------|
| Agency or carrier org | Tenant modes, LOBs (auto, home, life, health, commercial, …), USD, state/ZIP |
| Households and book | Insured accounts, policies in CRM, renewal opportunities, cross-sell prompts |
| Remote work | Mobile queue, push alerts, OOO-aware routing, check-in, central assistant |
| Paid social leads | **Meta Lead Ads** and **LinkedIn Lead Gen Forms** into CRM in seconds, then assign + notify |
| Motivation without an office | **Daily, weekly, and monthly leaderboards** (premium, quotes, speed-to-lead, points, badges) |
| US outreach rules | TCPA/DNC/consent on call, SMS, email, and assistant sends |

This is a **sales CRM for insurance**, not a full policy-admin or rating system. Carrier quoting/binding can be added through Marketplace apps.

Details: [docs/requirements/15-us-insurance-agency-and-remote-sales.md](docs/requirements/15-us-insurance-agency-and-remote-sales.md).

---

## Central chat and ChatGPT-mini assistant

GVCRM includes one **central chat** available from every screen. **ChatGPT-mini** is the overall-system assistant: it understands all modules, helps users complete work, and can **execute permitted business operations** (create a lead, update a deal, log a call, draft an email, open a case, and more).

It also **builds custom reports from required details**. If the user omits object, metrics, filters, date range, grouping, or chart type, the assistant asks for what is still needed, previews the spec, then runs and optionally saves a real report in Dashboards and Reports.

| You type | Assistant does |
|----------|----------------|
| “Show my new Meta and LinkedIn leads” | Lists today’s ad leads and offers claim / first-touch call |
| “Add a homeowners cross-sell on the Smith household” | Preview → confirm → create opportunity on the book |
| “Premium bound by producer this month, bar chart” | Collect missing details → run report → save / share / pin |
| “Where am I on this week’s leaderboard?” | Returns rank, metric, and gap to #1 |

Writes always respect role, sharing, and field-level security. Risky actions (send email, mass update, delete) require explicit confirmation and an audit trail.

Details: [docs/requirements/14-ai-assistant-and-central-chat.md](docs/requirements/14-ai-assistant-and-central-chat.md).

---

## Marketplace and app publishing

GVCRM is designed so a **marketplace exists inside the product**, and so teams can **publish an app according to each target store**.

### A. GVCRM Marketplace (in product)

Admins and users browse, install, and license apps (connectors, industry packs, UI extensions). ISVs and customers package **custom apps** built on the platform and submit them for private, unlisted, or public listing.

Typical flow:

1. Build a custom app in sandbox (objects, fields, workflows, dashboards, OAuth scopes).
2. Package and submit via the publisher portal.
3. Operator review (security, scopes, listing quality).
4. Install into sandbox, then production, with explicit consent.
5. Update, rate, unsubscribe, or uninstall without corrupting core CRM data.

### B. External marketplace hub

The same product (or a connector such as “GVCRM for Gmail”) can be listed on third-party stores. Each target has its own metadata, screenshots, OAuth scopes, privacy/support URLs, and certification checklist.

Examples: **Salesforce AppExchange**, **HubSpot Marketplace**, **Microsoft AppSource / Teams**, **Google Workspace Marketplace**, **Slack App Directory**, **Zoho Marketplace**, and later cloud stores (AWS / Azure).

Publishing “according to the marketplace” means: pick the target → complete that store’s required artifacts → export or submit → track Draft → Submitted → Certification → Live.

Details: [docs/requirements/13-marketplace-and-app-publishing.md](docs/requirements/13-marketplace-and-app-publishing.md).

---

## Platform foundations

These cross-cutting capabilities apply across modules:

- Role-based access, record sharing, field-level security, and audit history
- Multi-language UI (language packs) and multi-currency commercial records
- Sandbox create / clone / refresh and **configuration deployment to production**
- Custom fields, page layouts, list views, custom modules, and custom apps
- Real-time notifications, follow-up reminders, notes (text and audio)
- Case management and bulk spreadsheet-style editing
- Validation, workflow automation, and multi-step approvals (discount, contract, documents, T&E)
- Central ChatGPT-mini assistant for help, operations, and conversational reports across all modules
- US insurance defaults (LOB, households, USD, state) and remote-agent notifications
- Daily / weekly / monthly leaderboard widgets on the homepage

---

## Repository layout

```text
gvcrm/
├── README.md                          ← you are here
├── docs/
│   ├── requirements/                  ← detailed, independent specs
│   │   ├── README.md
│   │   ├── 01-accounts-and-contacts-management.md
│   │   ├── …
│   │   ├── 15-us-insurance-agency-and-remote-sales.md
│   │   ├── 16-kafka-messaging-platform.md
│   │   └── 17-platform-api-documentation-scalar.md
│   ├── database/                      ← MySQL + ClickHouse table/field plan
│   │   ├── README.md
│   │   ├── 00-conventions.md
│   │   ├── …
│   │   └── 17-clickhouse-analytics.md
│   ├── plans/                         ← spiral SDLC implementation plans
│   │   ├── README.md
│   │   ├── 00-program-master-spiral-plan.md
│   │   ├── 00-foundation-platform-skeleton.md
│   │   └── 01–15 module spiral plans
│   ├── use-cases/                     ← detailed use cases (all FRs + E2E journeys)
│   │   ├── README.md
│   │   ├── 00-actors-and-conventions.md
│   │   ├── 00-access-and-session-use-cases.md
│   │   ├── 00-end-to-end-journeys.md
│   │   └── 01–17 module use cases
│   └── developer/                     ← join-ready developer rules (Angular + platform)
│       ├── README.md
│       ├── 01-getting-started.md
│       ├── 02-angular-development-rules.md
│       └── …
└── (application source will land here)
```

This repository currently holds **product definition**. Implementation (services, web app, mobile, APIs) will be added in follow-on work.

---

## Documentation

| Document | Use it for |
|----------|------------|
| [docs/requirements/README.md](docs/requirements/README.md) | Spec index, ID prefixes, P0/P1/P2 legend |
| [docs/requirements/01–17](docs/requirements/) | Implement or review a single module (incl. Kafka + Scalar) |
| [docs/database/README.md](docs/database/README.md) | Physical databases, tables, and every column |
| [docs/plans/README.md](docs/plans/README.md) | **Spiral SDLC plans** — program waves S0–S7 and per-module cycles |
| [docs/use-cases/README.md](docs/use-cases/README.md) | **Detailed use cases** — actors, flows, and FR traceability for the full app |
| [docs/developer/README.md](docs/developer/README.md) | **Developer rules** for joiners (Angular + API + DB + Access + Git + testing) |
| [docs/developer/02-angular-development-rules.md](docs/developer/02-angular-development-rules.md) | Final Angular standards (PR blockers) |

Every requirement file includes: purpose, scope, users, functional requirements with user stories and acceptance criteria, data entities, integrations, security, non-functionals, and dependencies. The database folder turns those entities into MySQL/ClickHouse schemas. The plans folder maps specs into spiral-method delivery. The use-cases folder turns every FR into actor flows for BA/QA/UX. The developer folder is what new engineers read before their first PR.

---

## Requirement IDs

IDs are stable and suitable for tickets and traceability:

```text
{PREFIX}-{TYPE}-{NNN}
```

| Type | Meaning |
|------|---------|
| `FR` | Functional requirement |
| `NFR` | Non-functional requirement |
| `INT` | Integration |
| `SEC` | Security / permission |

Examples: `INS-FR-001` (US insurance orientation), `LED-FR-008` (Meta/LinkedIn real-time leads), `SPM-FR-006` (D/W/M leaderboards), `AIA-FR-005` (custom reports from chat).

| Priority | Meaning |
|----------|---------|
| **P0** | Must have for MVP / core CRM |
| **P1** | Should have in first production release |
| **P2** | Later phase |

---

## Current status and roadmap

| Phase | Focus |
|-------|--------|
| **Now** | Open requirements and project definition |
| **MVP** | US insurance agency orientation, remote agent workspace, accounts/households, leads (incl. **Meta + LinkedIn real-time**), deals/renewals, communication basics, quotes, dashboards, **D/W/M leaderboards + gamification**, platform, core workflows, ChatGPT-mini chat, marketplace for free apps |
| **v1** | Insurance industry pack polish, SMS analytics, portals, paid marketplace licensing, external listing workspace, assistant email/SMS send, license/NPN reminders |
| **Later** | Comparative rater / AMS marketplace apps, usage-based app billing, ISV payouts, multi-step assistant agents |

Suggested marketplace delivery is also spelled out in the [Marketplace spec](docs/requirements/13-marketplace-and-app-publishing.md#14-suggested-delivery-phases).

---

## Getting started

You do not need a runtime to work with this repo today.

```bash
git clone https://github.com/<org>/gvcrm.git
cd gvcrm
```

1. Read this README for the product picture.
2. Open [docs/requirements/README.md](docs/requirements/README.md) for the spec map.
3. Pick one module file and implement or review against its acceptance criteria.

When application code is added, this section will include install, environment, and run instructions.

---

## Contributing

Contributions are welcome once the project is public.

1. Open an issue describing the change (bug, spec gap, or feature).
2. Keep requirement IDs stable; add new IDs instead of silently rewriting old ones.
3. If you change behaviour, update the matching spec under `docs/requirements/`.
4. Submit a pull request with a short summary and test plan.

Please do not commit secrets (API keys, `.env`, marketplace developer credentials).

---

## Security

- Least-privilege OAuth scopes for marketplace apps
- Sandbox install before production
- Encrypted document share links; revoke and expiry
- Consent, TCPA, and do-not-contact honoured across email, SMS, automation, and assistant-sent messages
- Operator kill switch for malicious or compromised apps
- Assistant runs only as the signed-in user; no privilege escalation; kill switch for ChatGPT-mini chat

To report a vulnerability, use GitHub Security Advisories or contact the maintainers privately. Do not open a public issue for exploitable findings.

---

## License

License for this repository is **to be confirmed** before the first public release.

Until a `LICENSE` file is added, all rights are reserved by the authors. If you fork or reuse this material, wait for an explicit open-source license or obtain written permission.

---

**GVCRM** — US insurance sales CRM for remote agents: sell, compete, ask & act, automate, extend, and publish.
