# Platform API Documentation (Scalar) Use Cases

**Document ID:** GVCRM-UC-SCL  
**Sources:** `docs/requirements/17-platform-api-documentation-scalar.md`, `docs/dev-docs/scalar.md`, MKT-FR-014  
**Actors:** External ISV (A-ISV), Customer developer (A-DEV), Module API owner (A-API), Platform/DevRel (A-PLT)

---

## SCL-UC-001 — Explore complete Platform API in Scalar

| Field | Value |
|-------|-------|
| **Requirement** | SCL-FR-001, SCL-FR-002, SCL-FR-011, SCL-FR-013 |
| **Actors** | A-ISV, A-DEV |
| **Priority** | P0 |
| **Goal** | Discover all public APIs in one portal like HubSpot/Salesforce docs |

### Main flow
1. Developer opens Scalar portal (Auth, Guides, API Reference, Webhooks, Changelog).
2. Browses tags by module (Leads, Deals, Quotes, Metadata, …).
3. Opens an operation; sees envelope, scopes, errors, code samples.
4. Uses deep link to share exact operation with teammates.

### Exceptions
- **E1 Spec load failure:** Portal shows error; Sev-2 if sandbox Try-it broken (SCL-NFR-005).

---

## SCL-UC-002 — First sandbox call in ≤30 minutes

| Field | Value |
|-------|-------|
| **Requirement** | SCL-FR-004, SCL-FR-012, SCL-NFR-003 |
| **Actors** | A-ISV |
| **Priority** | P0 |

### Main flow
1. Follow Getting Started: create sandbox org → OAuth app → install with scopes.
2. Authorize from Scalar Auth panel (sandbox).
3. Try-it `GET /v1/led/leads` returns `success: true` envelope.
4. Total time ≤ 30 minutes for a new ISV following the guide.

---

## SCL-UC-003 — OpenAPI CI keeps docs equal to gateway

| Field | Value |
|-------|-------|
| **Requirement** | SCL-FR-003, SCL-FR-005, SCL-NFR-001, SCL-NFR-002 |
| **Actors** | A-API, A-PLT |
| **Priority** | P0 |

### Main flow
1. Engineer adds public gateway route + OpenAPI fragment + `x-gvcrm-*` extensions.
2. CI validates OpenAPI; fails if public route lacks entry or permission unknown to IAM.
3. Aggregator publishes `public.v1.yaml`; Scalar updates within 15 minutes of merge.

### Exceptions
- **E1 Undocumented public route:** PR blocked.
- **E2 Permission not in IAM catalog:** PR blocked.

---

## SCL-UC-004 — OAuth scopes and least privilege

| Field | Value |
|-------|-------|
| **Requirement** | SCL-FR-010; MKT-FR-014 |
| **Actors** | A-ISV, Org admin |
| **Priority** | P0 |

### Main flow
1. ISV selects scopes from documented catalog (`led.leads.read`, …).
2. Admin consents at install; tokens issued with those scopes only.
3. Call with insufficient scope returns 403; Scalar documents required scope on the operation.

---

## SCL-UC-005 — Subscribe to signed webhooks

| Field | Value |
|-------|-------|
| **Requirement** | SCL-FR-014 |
| **Actors** | A-ISV |
| **Priority** | P0 |

### Main flow
1. ISV registers webhook URL for `lead.created` / `lead.assigned` (etc.).
2. Event fires; GVCRM POSTs signed payload (`X-Gvcrm-Signature`).
3. ISV verifies signature using sample from docs; processes idempotently.
4. Invalid signature rejected; retries follow documented schedule.

### Business rules
- Partners use HTTPS webhooks, not Kafka credentials.
- Scalar links Kafka requirements for internal event-driven design.

---

## SCL-UC-006 — Build without Angular source

| Field | Value |
|-------|-------|
| **Requirement** | SCL-FR-006, SCL-FR-012 |
| **Actors** | A-ISV |
| **Priority** | P0 |

### Main flow
1. ISV completes “Build a lead sync app” guide using Scalar + sandbox only.
2. No internal Slack or Angular repo required.
3. Sample uses synthetic PII only.

---

## SCL-UC-007 — Download OpenAPI and Postman / SDK

| Field | Value |
|-------|-------|
| **Requirement** | SCL-FR-008 |
| **Actors** | A-DEV |
| **Priority** | P0 |

### Main flow
1. Developer downloads OpenAPI YAML/JSON from portal.
2. Imports generated Postman collection.
3. Optionally installs generated TypeScript `@gvcrm/api-client`.

---

## SCL-UC-008 — Document path, envelope, and versioning

| Field | Value |
|-------|-------|
| **Requirement** | SCL-FR-007, SCL-FR-009 |
| **Actors** | A-PLT, A-API |
| **Priority** | P0 |

### Main flow
1. All public paths documented as `/v1/{appCode}/…`.
2. Responses documented with platform envelope schemas.
3. When `v2` exists, Scalar version selector defaults to `v1`.

---

## SCL-UC-009 — Public vs internal OpenAPI security

| Field | Value |
|-------|-------|
| **Requirement** | SCL-SEC-001…006 |
| **Actors** | A-PLT |
| **Priority** | P0 |

### Main flow
1. Public bundle excludes admin/debug and IAM secret endpoints.
2. Try-it only accepts sandbox credentials; production secrets never embedded.
3. CORS allowlists docs host for Try-it.

---

## SCL-UC-010 — Changelog and migration guides

| Field | Value |
|-------|-------|
| **Requirement** | SCL-FR-015, SCL-FR-016 |
| **Actors** | A-PLT, A-ISV |
| **Priority** | P0 / P1 |

### Main flow
1. Release publishes changelog (additive vs breaking).
2. Breaking change requires version bump + migration notes.
3. Migrate-from HubSpot/Salesforce/Zoho cheat sheet maps objects to GVCRM tags.

---

## Coverage map

| FR / NFR / SEC | Use case(s) |
|----------------|-------------|
| SCL-FR-001, 002, 011, 013 | SCL-UC-001 |
| SCL-FR-004, 012, NFR-003 | SCL-UC-002 |
| SCL-FR-003, 005, NFR-001, 002 | SCL-UC-003 |
| SCL-FR-010 | SCL-UC-004 |
| SCL-FR-014 | SCL-UC-005 |
| SCL-FR-006 | SCL-UC-006 |
| SCL-FR-008 | SCL-UC-007 |
| SCL-FR-007, 009 | SCL-UC-008 |
| SCL-SEC-* | SCL-UC-009 |
| SCL-FR-015, 016 | SCL-UC-010 |
| SCL-NFR-004, 005 | Portal acceptance + Sev-2 Try-it alert |
