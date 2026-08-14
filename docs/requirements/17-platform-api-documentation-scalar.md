# Platform API Documentation (Scalar)

**Document ID:** GVCRM-REQ-SCL  
**Version:** 1.0  
**Status:** Draft for implementation  
**Module:** Public API documentation portal (`gvcrm-api-docs`) — not a product CRM UI module  
**Tooling:** [Scalar](https://scalar.com) (OpenAPI-native API reference + try-it console)  
**Engineering detail:** `docs/dev-docs/scalar.md` (local architecture)  
**Related:** Marketplace OAuth apps ([MKT-FR-014](./13-marketplace-and-app-publishing.md)), API backend rules, Kafka messaging ([16](./16-kafka-messaging-platform.md)), all product module APIs  

This document specifies how GVCRM publishes **complete, public-facing API documentation** so anyone can build on the platform like **Zoho CRM, Salesforce, or HubSpot**.

---

## 1. Purpose

GVCRM is a **platform**. Partners and customers must be able to:

| Goal | Industry parallel |
|------|-------------------|
| Read/write CRM objects via HTTP | Salesforce REST / HubSpot CRM APIs / Zoho CRM APIs |
| Install OAuth apps with scoped permissions | AppExchange connected apps / HubSpot apps / Zoho clients |
| Subscribe to webhooks / events | Platform Events / HubSpot webhooks / Zoho notifications |
| Build custom UI extensions & connectors | Lightning / HubSpot UI extensions / Zoho widgets |
| Discover every endpoint in one place | Salesforce Developer Docs / HubSpot API Reference |

**Scalar** is the chosen API documentation and explorer experience. It **publishes** `@gvcrm/contracts` and gateway OpenAPI — it does not replace them.

**Promise:** If a capability is supported in product for an entitled org, there is a **documented, scoped API** to automate it — discoverable in Scalar.

---

## 2. Scope

**In scope**

- Independent project `gvcrm-api-docs` (or `gvcrm-scalar`)
- Aggregated OpenAPI 3.1 for Public Platform API
- Scalar UI (Auth, Guides, API Reference, Webhooks, Changelog)
- Sandbox Try-it (OAuth / sandbox keys)
- Webhook catalog for partners; link to Kafka/AsyncAPI for internal engineers
- Postman/Insomnia export; optional TS/Python client stubs
- Versioning policy (`v1`, future `v2`)

**Out of scope**

- Documenting private cross-module RPCs not on the gateway  
- Replacing Marketplace listing UX  
- Exposing IAM password-hash or MFA-secret endpoints  
- Auto-publishing unpublished experimental routes without `x-gvcrm-stability`

---

## 3. Users

| Persona | Typical actions |
|---------|-----------------|
| External ISV / partner | Discover APIs, OAuth, Try-it, webhooks, build connectors |
| Customer developer / admin | Automate org processes; sync engines |
| Module API owner | Maintain OpenAPI fragments; keep Scalar in sync |
| Platform / DevRel | Own portal, aggregator CI, guides, sample apps |
| Internal engineer | Use public + internal OpenAPI bundles |

---

## 4. Business objectives

- Enable ecosystem growth without reverse-engineering Angular UI  
- Make Marketplace apps (MKT-FR-014) fully documentable and tryable  
- Shorten time-to-first-successful-sandbox-call  
- Keep docs identical to production contracts via CI  

---

## 5. Independent project definition

| Item | Value |
|------|--------|
| **Project** | `gvcrm-api-docs` |
| **Role** | Aggregate OpenAPI, host Scalar UI, version docs, sandbox keys UX |
| **Source of truth for shapes** | `@gvcrm/contracts` + per-module `openapi.yaml` |
| **Runtime APIs** | Still served by `gvcrm-gateway` |
| **Audience** | Internal engineers + **external developers** |

**Deliverables**

1. Aggregated OpenAPI 3.1 bundles (`public`, optional `internal`, AsyncAPI link)  
2. Scalar web app at `/docs` or `developers.*`  
3. Auth guides (OAuth 2.0, sandbox tokens)  
4. Webhook & event catalog pages  
5. Postman / Insomnia export from OpenAPI  
6. Changelog + API versioning policy  
7. Quickstarts: “Build like Salesforce/HubSpot/Zoho”  

---

## 6. Positioning vs Zoho / Salesforce / HubSpot

| Capability | Documented in Scalar |
|------------|----------------------|
| Objects CRUD `/v1/{app}/…` | Yes — per module tag |
| Search / query (list + filter + cursor) | Yes |
| OAuth apps / scopes | Yes — Auth + securitySchemes |
| Webhooks (signed HTTPS) | Yes — Webhooks tag |
| Bulk jobs | Yes — where exposed |
| Metadata (fields, modules, layouts) | Yes — Platform (`plt`) |
| Analytics (reports run, usage) | Yes — `dar` (FLS/RLS noted) |
| Realtime async | Public webhooks in Scalar; Kafka internal → [16](./16-kafka-messaging-platform.md) |
| Rate limits | Yes — 429 + headers |
| Sandbox first | Yes — Getting Started |

---

## 7. Functional requirements

### 7.1 Complete Platform API Reference

**Priority:** P0  
**ID:** SCL-FR-001

Publish a complete Platform API Reference in Scalar covering all public module APIs.

**Acceptance criteria**

- Every gateway route marked `public` or `partner` has an OpenAPI path.  
- CI fails the PR otherwise.

---

### 7.2 Single developer portal experience

**Priority:** P0  
**ID:** SCL-FR-002

Provide one portal experience: Auth, Guides, API Reference, Webhooks, Changelog.

**Acceptance criteria**

- Navigation reaches all five areas without leaving the docs host.  
- Deep links to operations work (`#tag/…`).

---

### 7.3 OpenAPI as source of truth

**Priority:** P0  
**ID:** SCL-FR-003

OpenAPI 3.1 shall be generated/validated in CI; Scalar always reflects the same contracts as the production gateway.

**Acceptance criteria**

- Aggregator builds `public.openapi.yaml` (and versioned `public.v1.yaml`) from contracts + fragments.  
- Docs publish after API merge within NFR target.

---

### 7.4 Interactive Try-it (sandbox)

**Priority:** P0  
**ID:** SCL-FR-004

Interactive “Try it” shall work against **sandbox** with OAuth or sandbox API key.

**Acceptance criteria**

- Servers dropdown includes Sandbox (default) and Production (documented; Try-it optional/admin-gated).  
- Partner can authorize sandbox OAuth from the Auth panel.  
- Try-it `GET /v1/led/leads` returns success envelope in sandbox.

---

### 7.5 Per-endpoint documentation completeness

**Priority:** P0  
**ID:** SCL-FR-005

Every endpoint shall document: permission/scope, envelope, errors, idempotency, rate-limit class.

**OpenAPI extensions (required where applicable)**

| Extension | Meaning |
|-----------|---------|
| `x-gvcrm-app` | Module appCode |
| `x-gvcrm-permission` | RBAC permission code |
| `x-gvcrm-scope` | OAuth scope string |
| `x-gvcrm-stability` | `stable` \| `beta` \| `experimental` |
| `x-gvcrm-idempotent` | Safe to retry |
| `x-gvcrm-webhook-event` | Event type emitted on success |

**Acceptance criteria**

- Every `x-gvcrm-permission` exists in IAM permission catalog.  
- Error responses use shared `EnvelopeError` / `ErrorItem` schemas.

---

### 7.6 External builder independence

**Priority:** P0  
**ID:** SCL-FR-006

External ISVs shall build CRM extensions, sync engines, and industry apps **without reading Angular source**.

**Acceptance criteria**

- Guides and reference contain no required internal file paths.  
- “Build a lead sync app” completable from docs + sandbox alone.

---

### 7.7 API versioning visibility

**Priority:** P0  
**ID:** SCL-FR-007

Versioning (`v1`, future `v2`) shall be visible in Scalar and in URL paths.

**Acceptance criteria**

- Paths use `/v1/{appCode}/…`.  
- Version selector exists when `v2` ships (`v1` default).

---

### 7.8 Downloadable artifacts

**Priority:** P0  
**ID:** SCL-FR-008

Developers shall download OpenAPI JSON/YAML and optional client SDK stubs (TS/Python).

**Acceptance criteria**

- OpenAPI download links on portal.  
- Postman collection generated from same OpenAPI (P0).  
- TypeScript client `@gvcrm/api-client` generated (P0); Python P1.

---

### 7.9 Path and envelope conventions

**Priority:** P0  
**ID:** SCL-FR-009

Public routes shall follow `/v1/{appCode}/…` and the platform JSON envelope.

**appCode values:** `iam`, `acm`, `ccm`, `dar`, `doc`, `led`, `odm`, `prd`, `qoc`, `plt`, `spm`, `tcl`, `wpa`, `mkt`, `aia`, `ins`.

**Envelope fields:** `success`, `app`, `apiVersion`, `requestId`, `orgId`, `actor`, `data`, `meta`, `errors`.

**Acceptance criteria**

- OpenAPI components include `EnvelopeSuccess`, `EnvelopeError`, `ErrorItem`.  
- Examples use synthetic PII only.

---

### 7.10 Security schemes in Scalar

**Priority:** P0  
**ID:** SCL-FR-010

Scalar Auth panel shall document OAuth2 (authorization code) with full scope catalog and Bearer JWT for first-party apps.

**Acceptance criteria**

- Marketplace apps use OAuth2; first-party may use BearerJwt — both documented.  
- Scope list is human-readable + technical name.

---

### 7.11 Scalar product UX

**Priority:** P0  
**ID:** SCL-FR-011

Scalar API Reference shall be configured with OpenAPI 3.1 URL(s), sidebar by tag (= module), search, code samples (curl, JS, Python), Servers dropdown, and session-persisted Try-it auth for sandbox only.

**Acceptance criteria**

- Theme aligns with GVCRM developer brand (not consumer CRM chrome).  
- Deep links to operations work for sharing and Marketplace docs embeds.

---

### 7.12 Guides section

**Priority:** P0  
**ID:** SCL-FR-012

Ship narrative guides (Markdown → portal), at minimum:

| Guide | Content |
|-------|---------|
| Getting started | Sandbox → OAuth app → install → first `GET /v1/led/leads` |
| Authentication | Auth code + refresh, PKCE, rotate secrets |
| Permissions & scopes | Map scopes ↔ UI; least privilege |
| Envelope & errors | Decode `errors[].code`; `requestId` support |
| Tenancy | `orgId` from token; never spoof |
| Idempotency | `Idempotency-Key` on creates |
| Webhooks | Signature, retry, event catalog |
| Rate limits | Budgets, 429 `Retry-After`, usage dashboard |
| Metadata API | Custom objects like Salesforce custom objects |
| Sync patterns | Incremental cursors |
| Build a lead sync app | End-to-end sample (Node/Python) |
| Build an insurance connector | INS + LED + QOC |
| Migrate from HubSpot/Salesforce/Zoho | Object mapping cheat sheet |

---

### 7.13 Complete API surface (tags)

**Priority:** P0  
**ID:** SCL-FR-013

Organize Scalar tags to cover the full public surface:

**Core CRM:** Authentication, Users & Roles, Accounts, Contacts, Scheduling, Leads, Ad ingest, Opportunities, Products, Quotes, Orders, Contracts, Invoices  

**Engagement:** Email, SMS, Calls, Consent, Documents, Collaboration  

**Intelligence:** Reports, Dashboards, API usage, Goals & forecasts, Campaigns, Gamification, Workflows, Assistant  

**Platform & ecosystem:** Metadata, Sandbox & deploy, Cases/notes/notifications, i18n/FX, Marketplace, Insurance  

**Acceptance criteria**

- MVP sell path (Auth + Leads + Accounts + Opportunities) documented before claiming partner readiness for Meta/LinkedIn + quote journeys.  
- Remaining tags land per delivery phases D2–D4.

---

### 7.14 Public webhooks catalog

**Priority:** P0  
**ID:** SCL-FR-014

Document partner HTTPS webhooks under tag **Webhooks**, including payload schema, `X-Gvcrm-Signature`, retry schedule, and idempotency.

**Minimum event types**

| Event type | Typical trigger |
|------------|-----------------|
| `lead.created` / `lead.updated` / `lead.assigned` | LED |
| `opportunity.stage_changed` | ODM |
| `quote.accepted` | QOC |
| `consent.changed` | CCM |
| `approval.completed` | WPA |
| `install.completed` / `app.uninstalled` | MKT |

**Acceptance criteria**

- Signature verification example passes in sample repo.  
- Scalar links “Event-driven architecture” to Kafka requirements for platform engineers; partners primarily use HTTPS webhooks.

---

### 7.15 Object model migration cheat sheet

**Priority:** P1  
**ID:** SCL-FR-015

Guides shall include Salesforce / HubSpot / Zoho → GVCRM object mapping (Account, Contact, Lead, Opportunity, Product, Quote, custom object, workflow, connected app, events).

---

### 7.16 Changelog

**Priority:** P0  
**ID:** SCL-FR-016

Publish a changelog that lists additive vs breaking changes per release.

**Acceptance criteria**

- Breaking changes require version bump and migration notes.  
- Additive fields documented without forcing major version.

---

## 8. Non-functional requirements (developer experience)

| ID | Metric | Target |
|----|--------|--------|
| SCL-NFR-001 | OpenAPI CI validation | Fail PR on breaking undocumented change |
| SCL-NFR-002 | Docs publish after API merge | ≤ **15 minutes** |
| SCL-NFR-003 | New ISV → first successful sandbox call | ≤ **30 minutes** following Getting Started |
| SCL-NFR-004 | Public reference coverage of partner routes | **100%** |
| SCL-NFR-005 | Broken Try-it against sandbox | Alert; treat as Sev-2 for platform |

---

## 9. Security requirements

| ID | Requirement |
|----|-------------|
| SCL-SEC-001 | No production secrets in Scalar; sandbox credentials only in Try-it. |
| SCL-SEC-002 | Separate internal OpenAPI; admin/debug routes not in public bundle. |
| SCL-SEC-003 | Scope display: human-readable + technical name. |
| SCL-SEC-004 | PII in examples: synthetic only. |
| SCL-SEC-005 | CORS: Try-it origins allowlisted to docs host. |
| SCL-SEC-006 | Never document IAM password-hash or MFA-secret endpoints. |

---

## 10. Integrations

| ID | Integration | Purpose |
|----|-------------|---------|
| SCL-INT-001 | `@gvcrm/contracts` + module OpenAPI fragments | Source of truth |
| SCL-INT-002 | OpenAPI aggregator CI | Public/internal bundles |
| SCL-INT-003 | `gvcrm-gateway` sandbox | Try-it runtime |
| SCL-INT-004 | Marketplace OAuth (MKT) | Connected apps + scopes |
| SCL-INT-005 | IAM permission catalog | Validate `x-gvcrm-permission` |
| SCL-INT-006 | Kafka / AsyncAPI (KFK) | Internal events; webhook mirror docs |
| SCL-INT-007 | DAR API usage | Rate-limit / usage docs |
| SCL-INT-008 | npm / codegen | `@gvcrm/api-client`, Postman |

---

## 11. Data / content entities

| Entity | Purpose |
|--------|---------|
| OpenAPIBundle | Versioned public/internal spec artifact |
| GuidePage | Narrative Markdown guide |
| WebhookEventDef | Partner event schema + signature rules |
| ChangelogEntry | Release notes (additive/breaking) |
| SampleApp | Lead sync / insurance connector gallery items |
| SdkArtifact | Generated client / collection downloads |

---

## 12. Delivery phases

| Phase | Outcome |
|-------|---------|
| **D0** | `gvcrm-api-docs` repo + Scalar empty OpenAPI shell |
| **D1** | Auth + Leads + Accounts + Opportunities fully documented (MVP sell path) |
| **D2** | CCM, DOC, QOC, DAR, SPM leaderboards |
| **D3** | PLT metadata, WPA, MKT OAuth, webhooks catalog |
| **D4** | INS, AIA constrained APIs, codegen TS client, Postman |
| **D5** | Public developers portal marketing + sample apps gallery |

Align D1 with Meta/LinkedIn + quote path so partners can automate the same journeys as E2E-UC-001/002.

---

## 13. Acceptance criteria (platform)

1. Scalar loads `public.v1.yaml` without errors.  
2. Partner can authorize sandbox OAuth from the docs Auth panel.  
3. Try-it `GET /v1/led/leads` returns envelope with `success: true` in sandbox.  
4. Every `x-gvcrm-permission` on a path exists in IAM permission catalog.  
5. Webhook signature verification example passes in sample repo.  
6. CI blocks merge if gateway public route lacks OpenAPI entry.  
7. Changelog lists additive vs breaking changes per release.  
8. External reader completes “Build a lead sync app” without internal Slack.

---

## 14. Dependencies

| Module / doc | Relationship |
|--------------|--------------|
| Marketplace | MKT-FR-014 runtime APIs; SCL documents them |
| All product modules | Own OpenAPI fragments for their `/v1/{app}` routes |
| IAM | Tokens, permissions, entitlements |
| Kafka | Internal bus; SCL documents partner webhooks |
| API backend rules | Envelope, Facade, path conventions |

**PR blocker:** new public endpoint without OpenAPI + Scalar tag + scope documentation.

---

## 15. Out of scope (reminder)

- Hosting Marketplace checkout UX inside Scalar  
- Exposing Kafka credentials to partners  
- Documenting unpublished experimental routes as stable  

---

## 16. Traceability

| Area | Requirement IDs |
|------|-----------------|
| Portal & coverage | SCL-FR-001…016 |
| DX SLAs | SCL-NFR-001…005 |
| Security | SCL-SEC-001…006 |
| Integrations | SCL-INT-001…008 |

**Engineering depth (architecture, embed, phases):** `docs/dev-docs/scalar.md`  
**Marketplace runtime APIs:** [13-marketplace-and-app-publishing.md](./13-marketplace-and-app-publishing.md) §9 (MKT-FR-014)  
**Internal realtime bus:** [16-kafka-messaging-platform.md](./16-kafka-messaging-platform.md)
