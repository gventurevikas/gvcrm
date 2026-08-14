# Actors and Conventions

**Document ID:** GVCRM-UC-ACTORS  
**Status:** Normative for all use-case documents

---

## 1. Primary actors

| Actor ID | Name | Typical goals in GVCRM |
|----------|------|------------------------|
| **A-PROD** | Remote producer / agent | Work Meta/LinkedIn leads, quote/bind, call/SMS, watch D/W/M leaderboards, use assistant |
| **A-ISA** | Inside sales / ISA | Speed-to-lead, round-robin queue, set appointments for producers |
| **A-AE** | Sales representative / AE | Accounts, contacts, deals, quotes, communication, documents |
| **A-AM** | Account manager | Hierarchy, 360°, renewals, cross-sell |
| **A-MGR** | Sales manager / agency principal | Pipeline, rotting deals, team boards, campaign ROI, coaching |
| **A-MKT** | Marketing ops | Forms, Meta/LinkedIn, scoring, templates, mass email compliance |
| **A-OPS** | Sales ops / RevOps | Assignment rules, pipelines, validations, workflows, KPIs |
| **A-FIN** | Finance / billing / deal desk | Invoices, payments, discount approvals |
| **A-LEG** | Legal / compliance | Contracts, TCPA/DNC, license/NPN tracking |
| **A-SUP** | Support / success | Cases, notes, associated email |
| **A-ADM** | CRM admin | Users/roles (via Access), layouts, sandbox, deploy, modules |
| **A-DEV** | Developer / partner / ISV | Custom apps, marketplace packages, external listings |
| **A-OPR** | GVCRM marketplace operator | Review, certify, unlist, kill switch |
| **A-CAR** | Carrier sales / wholesaler | Appointed agencies, pipeline by LOB/state |
| **A-EXT** | External prospect / customer | Scheduling page, portal CTA, share-link viewer, quote accept |
| **A-SYS** | System (time, webhook, worker) | Ingest, rotting, schedules, snapshots, workflows |

---

## 2. Org / tenant context

Use cases assume a signed-in user with:

- Valid Access session (JWT with `sub`, `orgId`, `roles`, `perm`, `modules`)
- Module entitlement for the feature under test
- Record visibility via owner + sharing + (optional) team/group

Tenant modes relevant to INS: **agency**, **MGA/IMO**, **carrier**.

---

## 3. Shared preconditions (apply unless overridden)

1. User is authenticated (all required factors: password + MFA when enrolled/required) and not locked out.
2. User’s org has the module entitled (`org_modules`).
3. Every query/mutation is scoped by `org_id`.
4. Field-level security (FLS) and record sharing are enforced.
5. Outbound email/SMS/call respect CCM consent / DNC / TCPA when INS `tcpa_strict` or consent rules apply.
6. Assistant (AIA) actions run **as the signed-in user**, never as a superuser.

---

## 4. Shared postconditions (success)

1. Changes are audit-logged where SEC requires (PII merge, assistant writes, approvals, deploy).
2. Soft-deleted records use `deleted_at` (business tables).
3. Report executions append ClickHouse `report_runs`.

---

## 5. Use-case ID and priority conventions

- Module use cases: `{PREFIX}-UC-{NNN}` aligned to FR order where practical.
- Foundation: `IAM-UC-{NNN}`, `E2E-UC-{NNN}`.
- Priority mirrors the traced FR (P0/P1/P2). “High” (e.g. rotting) = P0.

---

## 6. Relationship to requirements

| Artifact | Role |
|----------|------|
| `docs/requirements/*` | Authoritative behavior + acceptance criteria |
| `docs/use-cases/*` | Actor-centric flows for BA, QA, UX, and ticket writing |
| `docs/plans/*` | When to build each slice |

When a requirement changes, update the matching use case in the same PR.
