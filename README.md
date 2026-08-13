# GVCRM

**Open customer relationship platform for sales teams — CRM, automation, and a marketplace to publish and install apps.**

GVCRM is a full-lifecycle CRM: accounts and contacts, leads, pipelines, quotes-to-cash, collaboration, reporting, and an extensible platform. Organizations can tailor the product with custom apps, then **publish those apps to the GVCRM Marketplace** or to **external stores** (Salesforce AppExchange, HubSpot Marketplace, Microsoft AppSource, Google Workspace Marketplace, Slack, and others).

> **Status:** Product requirements are published and implementation-ready. Application code is not in this repository yet.

---

## Table of contents

- [Why GVCRM](#why-gvcrm)
- [Who it is for](#who-it-is-for)
- [What you can do](#what-you-can-do)
- [Product modules](#product-modules)
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
| **Sell** | Leads → opportunities → quotes, orders, contracts, and invoices in one place |
| **Run** | Dashboards, forecasts, goals, campaigns, and team collaboration |
| **Automate** | Visual sales processes, workflow rules, validation, and approvals |
| **Extend** | Custom fields, modules, layouts, and full custom apps |
| **Publish** | Package an app once; list it on the in-product marketplace or an external store |

The detailed specifications started from the CRM capability sheet in `docs/` and were expanded into independent, implementable requirement documents — including marketplace publishing, which was not in the original sheet.

---

## Who it is for

| Audience | How they use GVCRM |
|----------|--------------------|
| Sales representatives | Work leads and deals, call/email/SMS, book meetings, follow playbooks |
| Managers and RevOps | Pipelines, rotting deals, forecasts, quotas, assignment rules |
| Admins and IT | Sandbox → production deploy, languages, currencies, security |
| Partners and ISVs | Build custom apps, submit to the marketplace, monetize connectors |
| Prospects and customers | Scheduling links, product portals, quote/invoice links (no full CRM login) |

---

## What you can do

- Maintain **account hierarchies** and **360° contact views**, including org charts and maps
- Capture **leads** from forms, import, email parser, card scan, and APIs; score and auto-assign them
- Run **multiple sales pipelines** on a Kanban board, with win probability and **rotting-deal** alerts
- Communicate from CRM or Gmail/Outlook: email, SMS, calls, templates, tracking, and mass send
- Generate **quotes, orders, contracts, invoices**, and supply/payment schedules
- Store **documents and playbooks** with search, share links, and version history
- Track performance with **goals, forecasts** (best / likely / worst), campaigns, and gamification
- Collaborate with **feeds, mentions, private chat, tags, user groups, and field check-in**
- Automate with **approvals, validation rules, workflow rules, and a visual sales process editor**
- Extend the CRM with **custom apps**, then **install or publish** them through Marketplace

---

## Product modules

Each module has its own requirement file. Specs are independent so a team can implement one area without reading every document.

| Module | Summary | Spec |
|--------|---------|------|
| **Accounts & Contacts** | Company/person 360°, hierarchy, org charts, maps, individual and group scheduling | [01](docs/requirements/01-accounts-and-contacts-management.md) |
| **Customer Communication** | Calls, native email, Gmail/Outlook, SMS, templates, tracking, mass email | [02](docs/requirements/02-customer-communication-management.md) |
| **Dashboards & Reports** | Homepage, pre-built and custom analytics, charts, sharing, API usage | [03](docs/requirements/03-dashboards-and-reports.md) |
| **Documents** | Repository, attachments, encrypted share links, search, conversion, playbooks, versions | [04](docs/requirements/04-documents-management.md) |
| **Leads** | Multi-source capture, scoring, round-robin/criteria assignment, parser, card scan, win-loss | [05](docs/requirements/05-leads-management.md) |
| **Opportunities / Deals** | Multi-pipeline, Kanban, probability, rotting (P0), activity timeline, journey designer | [06](docs/requirements/06-opportunities-deals-management.md) |
| **Products** | Catalog, taxonomy, groups, costs/pricing, branded prospect portals | [07](docs/requirements/07-products-management.md) |
| **Quotes, Orders & Contracts** | Quote-to-cash, website order intake, invoices, amendments, supply schedules | [08](docs/requirements/08-quotes-orders-and-contracts-management.md) |
| **Platform** | Custom fields/layouts/modules/apps, sandbox, deploy, i18n, multi-currency, cases, notes | [09](docs/requirements/09-platform-capabilities.md) |
| **Sales Performance** | Goals, target achievement, forecasting, campaigns, gamification | [10](docs/requirements/10-sales-performance-management.md) |
| **Team Collaboration** | Feeds, geo check-in, mentions, private chat, tags, user groups | [11](docs/requirements/11-team-collaboration.md) |
| **Workflows & Automation** | Sales process editor, workflow rules, templates, validation, approvals | [12](docs/requirements/12-workflows-and-process-automation.md) |
| **Marketplace & Publishing** | In-app store, publisher portal, external marketplace hub | [13](docs/requirements/13-marketplace-and-app-publishing.md) |

Full index, ID convention, and priority legend: [docs/requirements/README.md](docs/requirements/README.md).

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

---

## Repository layout

```text
gvcrm/
├── README.md                          ← you are here
├── docs/
│   ├── CRM Requirement - Google Sheets.pdf   ← original capability sheet
│   ├── CRM-Requirement.xlsx
│   └── requirements/                  ← detailed, independent specs
│       ├── README.md
│       ├── 01-accounts-and-contacts-management.md
│       ├── 02-customer-communication-management.md
│       ├── …
│       └── 13-marketplace-and-app-publishing.md
└── (application source will land here)
```

This repository currently holds **product definition**. Implementation (services, web app, mobile, APIs) will be added in follow-on work.

---

## Documentation

| Document | Use it for |
|----------|------------|
| [docs/requirements/README.md](docs/requirements/README.md) | Spec index, ID prefixes, P0/P1/P2 legend |
| [docs/requirements/01–13](docs/requirements/) | Implement or review a single module |
| `docs/CRM Requirement - Google Sheets.pdf` | Original source capabilities |
| `docs/CRM-Requirement.xlsx` | Same source in spreadsheet form |

Every requirement file includes: purpose, scope, users, functional requirements with user stories and acceptance criteria, data entities, integrations, security, non-functionals, and dependencies.

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

Examples: `ACM-FR-003` (contact management), `ODM-FR-005` (opportunity rotting), `MKT-FR-010` (external marketplace profiles).

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
| **MVP** | Accounts/contacts, leads, deals (incl. rotting), communication basics, quotes, dashboards, platform (fields/layouts/sandbox), core workflows, private + public marketplace for free apps |
| **v1** | SMS analytics, portals, website order intake, paid marketplace licensing, external listing workspace (Google, Microsoft, HubSpot) |
| **Later** | Gamification depth, usage-based app billing, ISV payouts, additional store automations |

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
- Consent and do-not-contact honoured across email, SMS, and automation
- Operator kill switch for malicious or compromised apps

To report a vulnerability, use GitHub Security Advisories or contact the maintainers privately. Do not open a public issue for exploitable findings.

---

## License

License for this repository is **to be confirmed** before the first public release.

Until a `LICENSE` file is added, all rights are reserved by the authors. If you fork or reuse this material, wait for an explicit open-source license or obtain written permission.

---

## Source

- `docs/CRM Requirement - Google Sheets.pdf`
- `docs/CRM-Requirement.xlsx`
- Marketplace and app publishing: additional product requirement beyond the original sheet

---

**GVCRM** — sell, run, automate, extend, and publish.
