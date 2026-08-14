# GVCRM Detailed Requirements

This folder contains **independent, implementation-ready requirement specifications** for GVCRM. The product is oriented to **US insurance agencies and insurance companies**, with **remote, sales-first producers**, plus Marketplace, ChatGPT-mini central chat, Meta/LinkedIn real-time leads, and **daily / weekly / monthly leaderboards**.

Each module file is self-contained. A team can implement or review one section without reading the others. Cross-module dependencies are listed inside each file.

Physical tables and columns for these entities: [docs/database/README.md](../database/README.md).  
Spiral SDLC implementation plans (program + per module): [docs/plans/README.md](../plans/README.md).  
Detailed use cases (actors, flows, FR traceability): [docs/use-cases/README.md](../use-cases/README.md).

## Document index

| # | Module | File | Prefix |
|---|--------|------|--------|
| 00 | Access — Authentication & MFA | [00-access-authentication-and-mfa.md](./00-access-authentication-and-mfa.md) | IAM |
| 01 | Accounts and Contacts Management | [01-accounts-and-contacts-management.md](./01-accounts-and-contacts-management.md) | ACM |
| 02 | Customer Communication Management | [02-customer-communication-management.md](./02-customer-communication-management.md) | CCM |
| 03 | Dashboards and Reports | [03-dashboards-and-reports.md](./03-dashboards-and-reports.md) | DAR |
| 04 | Documents Management | [04-documents-management.md](./04-documents-management.md) | DOC |
| 05 | Leads Management | [05-leads-management.md](./05-leads-management.md) | LED |
| 06 | Opportunities / Deals Management | [06-opportunities-deals-management.md](./06-opportunities-deals-management.md) | ODM |
| 07 | Products Management | [07-products-management.md](./07-products-management.md) | PRD |
| 08 | Quotes, Orders, and Contracts Management | [08-quotes-orders-and-contracts-management.md](./08-quotes-orders-and-contracts-management.md) | QOC |
| 09 | Platform Capabilities | [09-platform-capabilities.md](./09-platform-capabilities.md) | PLT |
| 10 | Sales Performance Management | [10-sales-performance-management.md](./10-sales-performance-management.md) | SPM |
| 11 | Team Collaboration | [11-team-collaboration.md](./11-team-collaboration.md) | TCL |
| 12 | Workflows and Process Automation | [12-workflows-and-process-automation.md](./12-workflows-and-process-automation.md) | WPA |
| 13 | Marketplace and App Publishing | [13-marketplace-and-app-publishing.md](./13-marketplace-and-app-publishing.md) | MKT |
| 14 | AI Assistant and Central Chat | [14-ai-assistant-and-central-chat.md](./14-ai-assistant-and-central-chat.md) | AIA |
| 15 | US Insurance Agency and Remote Sales | [15-us-insurance-agency-and-remote-sales.md](./15-us-insurance-agency-and-remote-sales.md) | INS |

## How to read each file

Every module document follows the same structure:

1. Purpose and scope
2. Users and business objectives
3. Functional requirements (with IDs, user stories, and acceptance criteria)
4. Data entities
5. Integrations
6. Permissions and security
7. Non-functional requirements
8. Dependencies on other modules
9. Out of scope for that module

## Requirement ID convention

`{PREFIX}-{TYPE}-{NNN}`

- **FR** — Functional requirement
- **NFR** — Non-functional requirement
- **INT** — Integration requirement
- **SEC** — Security / permission requirement

Example: `ACM-FR-003` is the third functional requirement in Accounts and Contacts Management.

## Priority legend

Used where a capability is foundational or marked high priority.

| Priority | Meaning |
|----------|---------|
| P0 | Must have for MVP / core CRM |
| P1 | Should have in first production release |
| P2 | Nice to have / later phase |

Where a capability is marked **High** (for example Opportunity Rotting), it is treated as **P0**.

## Cross-cutting platform themes

These apply across modules and are specified in detail inside Platform, Workflows, Marketplace, and AI Assistant:

- Multi-language UI and multi-currency commercial records
- Role-based access, record sharing, and audit history
- Sandbox → production configuration deployment
- Custom fields, layouts, modules, views, and custom apps
- Workflow, validation, and approval automation
- Internal marketplace for installing and publishing apps
- Optional publishing of GVCRM (or GVCRM apps) to external marketplaces
- Central chat (ChatGPT-mini) to help and run business operations across all modules
- Conversational custom reports from required details
- US insurance agency / carrier orientation for remote sales producers
- Real-time Meta and LinkedIn campaign leads
- Complete gamification with published daily, weekly, and monthly leaderboards
