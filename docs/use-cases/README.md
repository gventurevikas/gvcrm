# GVCRM Use Cases

This folder contains **detailed use cases** for the complete GVCRM application, derived from `docs/requirements/*.md`. Every functional requirement (FR) is covered by at least one use case. Cross-module journeys and shared actors live in the `00-*` documents.

---

## How to read a use case

| Field | Meaning |
|-------|---------|
| **UC ID** | `{PREFIX}-UC-{NNN}` (stable for tickets and tests) |
| **Requirement** | Traceability to `{PREFIX}-FR-{NNN}` (and INT/SEC when relevant) |
| **Priority** | P0 / P1 / P2 (same legend as requirements) |
| **Actors** | Primary and supporting personas |
| **Preconditions / Postconditions** | System state before and after success |
| **Main flow** | Numbered happy path |
| **Alternate / exception flows** | Branches and failures |
| **Business rules** | Constraints that must hold |
| **UI / API touchpoints** | Where the behavior appears |

---

## Document index

| File | Coverage |
|------|----------|
| [00-actors-and-conventions.md](./00-actors-and-conventions.md) | Personas, org types, ID rules, shared preconditions |
| [00-access-and-session-use-cases.md](./00-access-and-session-use-cases.md) | Login, verified registration, SMS OTP, Google Authenticator, MFA policy (IAM-UC-001…015) |
| [00-end-to-end-journeys.md](./00-end-to-end-journeys.md) | Multi-module journeys for US remote insurance MVP |
| [e2e-videos/](./e2e-videos/README.md) | **11 MP4 walkthrough videos** (one per E2E journey) |
| [mock-screens/](./mock-screens/README.md) | **135 UI mock images** (one per product use case) |
| [01-accounts-and-contacts-use-cases.md](./01-accounts-and-contacts-use-cases.md) | ACM-FR-001…007 |
| [02-customer-communication-use-cases.md](./02-customer-communication-use-cases.md) | CCM-FR-001…015 |
| [03-dashboards-and-reports-use-cases.md](./03-dashboards-and-reports-use-cases.md) | DAR-FR-001…015 |
| [04-documents-use-cases.md](./04-documents-use-cases.md) | DOC-FR-001…007 |
| [05-leads-use-cases.md](./05-leads-use-cases.md) | LED-FR-001…008 |
| [06-opportunities-deals-use-cases.md](./06-opportunities-deals-use-cases.md) | ODM-FR-001…007 |
| [07-products-use-cases.md](./07-products-use-cases.md) | PRD-FR-001…004 |
| [08-quotes-orders-contracts-use-cases.md](./08-quotes-orders-contracts-use-cases.md) | QOC-FR-001…009 |
| [09-platform-capabilities-use-cases.md](./09-platform-capabilities-use-cases.md) | PLT-FR-001…015 |
| [10-sales-performance-use-cases.md](./10-sales-performance-use-cases.md) | SPM-FR-001…006 |
| [11-team-collaboration-use-cases.md](./11-team-collaboration-use-cases.md) | TCL-FR-001…006 |
| [12-workflows-automation-use-cases.md](./12-workflows-automation-use-cases.md) | WPA-FR-001…006 |
| [13-marketplace-publishing-use-cases.md](./13-marketplace-publishing-use-cases.md) | MKT-FR-001…014 |
| [14-ai-assistant-central-chat-use-cases.md](./14-ai-assistant-central-chat-use-cases.md) | AIA-FR-001…009 |
| [15-us-insurance-remote-sales-use-cases.md](./15-us-insurance-remote-sales-use-cases.md) | INS-FR-001…007 |
| [16-kafka-messaging-use-cases.md](./16-kafka-messaging-use-cases.md) | KFK-FR-001…014 (+ NFR/SEC via UCs) |
| [17-platform-api-documentation-use-cases.md](./17-platform-api-documentation-use-cases.md) | SCL-FR-001…016 (+ NFR/SEC via UCs) |
| [mock-screens/](./mock-screens/README.md) | **135 UI mock images** (one per product use case) |

---

## Coverage summary

| Module | FRs | Use-case file |
|--------|-----|---------------|
| Access / session | 15 IAM FRs | `00-access-and-session-use-cases.md` |
| ACM | 7 | `01-…` |
| CCM | 15 | `02-…` |
| DAR | 15 | `03-…` |
| DOC | 7 | `04-…` |
| LED | 8 | `05-…` |
| ODM | 7 | `06-…` |
| PRD | 4 | `07-…` |
| QOC | 9 | `08-…` |
| PLT | 15 | `09-…` |
| SPM | 6 | `10-…` |
| TCL | 6 | `11-…` |
| WPA | 6 | `12-…` |
| MKT | 14 | `13-…` |
| AIA | 9 | `14-…` |
| INS | 7 | `15-…` |
| Kafka messaging | 14 KFK FRs | `16-…` |
| Platform API docs (Scalar) | 16 SCL FRs | `17-…` |
| **Product CRM FRs** | **135** | |
| **Access IAM FRs** | **15** | |
| **Platform infra FRs** | **30** (KFK+SCL) | Plus 10 E2E journeys |

---

## Related documentation

| Need | Location |
|------|----------|
| Functional requirements | `docs/requirements/` |
| Physical data model | `docs/database/` |
| Spiral delivery plans | `docs/plans/` |
| Developer rules | `docs/developer/` |
