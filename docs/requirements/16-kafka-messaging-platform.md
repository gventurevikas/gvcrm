# Kafka Messaging Platform

**Document ID:** GVCRM-REQ-KFK  
**Version:** 1.0  
**Status:** Draft for implementation  
**Module:** Messaging infrastructure (`gvcrm-messaging`) — not a product CRM UI module  
**Engineering detail:** `docs/dev-docs/kafka.md` (local architecture)  
**Related:** Leads (realtime ingest), Workflows, Notifications (PLT), Sales Performance, Dashboards (`report_runs`), Marketplace kill/install events  

This document is **independent**. Domain modules own business rules; this module owns durable realtime messaging so those rules can run without blocking HTTP or sharing databases.

---

## 1. Purpose

Provide **speedy, reliable, real-time communication** across independent module APIs so GVCRM can:

| Need | Why Kafka |
|------|-----------|
| Meta / LinkedIn lead ingest ≤15s | Decouple webhook intake from assignment, notify, scoring |
| Notifications (push / in-app / digests) | Fan-out without blocking request threads |
| Workflows (immediate + time-based) | Durable events; retry without losing work |
| Gamification / leaderboard snapshots | Idempotent high-volume fact streams |
| Email / SMS tracking, report_runs | Async writers to MySQL / ClickHouse |
| Cross-module reactions | Modules stay independent — **events**, not cross-DB joins |

Kafka is **shared backend infrastructure**, owned as its own project and consumed by every `gvcrm-*-api` that publishes or subscribes.

---

## 2. Scope

**In scope**

- Independent project `gvcrm-messaging` (or `gvcrm-kafka`)
- Topic registry, CloudEvents-compatible envelope, TypeScript client SDK
- Outbox helper, consumer workers (platform), DLQ + redrive
- Local Compose + staging/prod deploy stubs
- Observability (lag, rates, failures, correlation ids)

**Out of scope**

- Replacing MySQL / ClickHouse as systems of record
- Using Kafka as a long-term document/blob store
- Replacing WebSocket/SSE/push for browsers (Kafka **feeds** the notifier)
- Cross-org event broadcasting
- Claiming exactly-once end-to-end without outbox + idempotent consumers

---

## 3. Users

| Persona | Typical actions |
|---------|-----------------|
| Platform / messaging engineer | Own cluster, topics, SDK, DLQ tooling |
| Module API owner | Publish/subscribe declared topics; never invent private clusters |
| Ops / SRE | Lag alerts, ACL rotation, redrive |
| Partner / ISV | **Does not** consume Kafka directly — uses HTTPS webhooks (see SCL / MKT) |

---

## 4. Business objectives

- Meet realtime SLAs for ad-lead ingest and notifications
- Keep HTTP APIs fast (persist + publish / outbox, return)
- Preserve module independence and tenant isolation
- Make async work durable, replayable, and operable (DLQ, metrics)

---

## 5. Independent project definition

| Item | Value |
|------|--------|
| **Repo / project** | `gvcrm-messaging` |
| **Role** | Brokers (ops), topic catalog, schemas, client SDKs, workers, DLQ, local Compose |
| **Does not own** | Business MySQL schemas, Angular UI, Access password store |
| **Consumers** | Gateway (optional edge publish), every `gvcrm-*-api`, dedicated `gvcrm-*-worker` processes |

**Deliverables**

1. Kafka cluster config (Compose + Helm/Terraform stubs)  
2. Declarative topic registry (names, partitions, retention, compaction)  
3. Envelope + JSON Schema / AsyncAPI in contracts  
4. `@gvcrm/messaging-client` (produce, consume, outbox, idempotency, tracing)  
5. Shared workers (notification fan-out, ClickHouse `report_runs`, DLQ redrive)  
6. Runbooks for lag, poison messages, topic expansion, ACL rotation  

---

## 6. Functional requirements

### 6.1 Durable messaging service

**Priority:** P0  
**ID:** KFK-FR-001

The platform shall provide durable, ordered (per partition key), replayable messaging for GVCRM domain events and commands.

**Acceptance criteria**

- Messages survive broker restart within configured retention.  
- Same `partitionkey` preserves order for an aggregate lifecycle.  
- Consumers can reset/replay under documented ops controls.

---

### 6.2 Realtime product paths

**Priority:** P0  
**ID:** KFK-FR-002

Messaging shall support realtime paths: ad-lead ingest, notifications, activity fan-out, and email/SMS tracking webhooks.

**Acceptance criteria**

- LED ad-ingest path is implemented on Kafka (not only nightly batch).  
- Notification intents are published for assign and other P0 events.  
- Tracking events update CRM without request-thread blocking.

---

### 6.3 Delivery semantics

**Priority:** P0  
**ID:** KFK-FR-003

Delivery shall be **at-least-once**. All consumers shall be **idempotent**.

**Acceptance criteria**

- Duplicate produce/consume does not create duplicate leads, points, or sends when `idempotencykey` is honored.  
- Consumer groups and handlers document dedupe store (Redis/MySQL unique).

---

### 6.4 Tenant isolation

**Priority:** P0  
**ID:** KFK-FR-004

Tenant isolation shall be enforced via payload `orgid` and optional topic ACLs / principals per environment.

**Acceptance criteria**

- Tenant events without `orgid` are rejected by SDK validation / CI rules.  
- Consumers filter/enforce `orgid` before side effects.  
- No cross-org broadcast topics.

---

### 6.5 Standard envelope

**Priority:** P0  
**ID:** KFK-FR-005

Every message value shall be JSON matching the platform CloudEvents-inspired envelope.

**Required fields (minimum):** `specversion`, `id`, `type`, `source`, `time`, `datacontenttype`, `orgid` (tenant events), `correlationid`, `idempotencykey`, `partitionkey`, `data`.

**Type naming:** `gvcrm.{app}.{entity}.{action}.v{n}`

**Acceptance criteria**

- SDK rejects publish without required fields.  
- Kafka headers mirror `correlationid`, `orgid`, `type` where used for routing.  
- Forbidden in `data`: password hashes, MFA secrets, raw OAuth refresh tokens, unrestricted PII dumps to analytics topics.

---

### 6.6 Dead-letter and redrive

**Priority:** P0  
**ID:** KFK-FR-006

Poison messages shall move to dead-letter topics after max retries, with redrive tooling.

**Acceptance criteria**

- Topic `gvcrm.sys.dlq` (or env-qualified equivalent) receives failed messages with original topic/error headers.  
- Ops can redrive with audit trail.  
- DLQ console access is admin-only.

---

### 6.7 Observability

**Priority:** P0  
**ID:** KFK-FR-007

The platform shall expose lag, produce/consume rates, fail rates, and end-to-end correlation ids.

**Acceptance criteria**

- Metrics exist per topic/group for success/fail, lag, processing latency, DLQ rate, outbox backlog age.  
- Logs include `correlationid`, `orgid`, `type`, `idempotencykey` without full PII bodies at info level.  
- OpenTelemetry links HTTP → produce → consume where instrumented.

---

### 6.8 Local developer stack

**Priority:** P0  
**ID:** KFK-FR-008

One Compose profile shall bring up Kafka + UI (e.g. AKHQ / Redpanda Console) and apply the topic registry.

**Acceptance criteria**

- Smoke produce/consume passes locally.  
- Unit tests may use in-memory fakes when `KAFKA_BROKERS` unset.  
- Local laptops never point at production brokers.

---

### 6.9 Independent versioning

**Priority:** P0  
**ID:** KFK-FR-009

Messaging infrastructure shall version independently from product modules.

**Acceptance criteria**

- Topic registry and SDK versions are released from `gvcrm-messaging`.  
- Module PRs cannot introduce undeclared topic names (review blocker).

---

### 6.10 Transactional outbox pattern

**Priority:** P0  
**ID:** KFK-FR-010

For money, compliance, and lead paths, APIs shall write business row + outbox row in the same MySQL transaction, then relay to Kafka.

**Acceptance criteria**

- HTTP returns after durable outbox write (or bounded produce when outbox not yet available in early phase).  
- Produce wait does not block HTTP beyond soft limit when outbox exists (e.g. 200ms).  
- Outbox relay marks published; failures leave backlog visible to ops.

---

### 6.11 Messaging patterns

**Priority:** P0  
**ID:** KFK-FR-011

The platform shall support domain events, commands, integration events, notification intents, and fact/audit streams as first-class patterns.

| Pattern | Example |
|---------|---------|
| Domain event | `led.lead.created` |
| Command | `wpa.workflow.execute` |
| Integration event | `led.ad_ingest.received` |
| Notification intent | `plt.notification.requested` |
| Fact stream | `dar.report_run.recorded` → ClickHouse |

---

### 6.12 Topic catalog ownership

**Priority:** P0  
**ID:** KFK-FR-012

A complete topic catalog shall be the source of truth in `gvcrm-messaging` (declarative `topics.yaml` or equivalent), covering at least:

- Platform: DLQ, notifications, audit hints, metadata changed  
- IAM: user lifecycle, session security signals, entitlements  
- LED: ad_ingest, lead created/updated/assigned/converted, scoring, dedupe  
- ACM, ODM, CCM, DOC, PRD/QOC, DAR, SPM, TCL, WPA, MKT, AIA, INS as listed in engineering `kafka.md`

**Acceptance criteria**

- Naming: `gvcrm.{env}.{domain}.{name}` (env optional locally).  
- Hot topics sized for org-key parallelism (start guidance 12–24 partitions).  
- Module README links to catalog; rogue topics fail review.

---

### 6.13 TypeScript messaging SDK

**Priority:** P0  
**ID:** KFK-FR-013

`@gvcrm/messaging-client` shall provide publish, subscribe (graceful shutdown), outbox poller helper, idempotency middleware, envelope validation, and metrics hooks.

**Acceptance criteria**

- Module APIs depend on the SDK, not raw broker clients, for P0 paths.  
- Typed payloads from AsyncAPI are Should-have.

---

### 6.14 Platform workers

**Priority:** P0  
**ID:** KFK-FR-014

Shared workers shall exist for notification fan-out, ClickHouse `report_runs` writer, and DLQ redrive (CLI/UI).

**Acceptance criteria**

- `dar.report_run.recorded` consumer writes ClickHouse successfully.  
- Notification worker consumes `plt.notification.requested` and drives in-app/push/digest channels.  
- One logical processor family ⇒ one consumer group (no shared groups across unrelated features).

---

## 7. Realtime and speed requirements (NFR)

| ID | Path | Target |
|----|------|--------|
| KFK-NFR-001 | Meta/LinkedIn → assigned + notify intent | P95 ≤ **15s** |
| KFK-NFR-002 | Email open/click → CRM UI | P95 ≤ **10s** |
| KFK-NFR-003 | In-app notification after assign | P95 ≤ **2s** after assign event |
| KFK-NFR-004 | Opportunity activity to followers | Near-realtime |
| KFK-NFR-005 | Leaderboard freshness | ≤ **5 min** |
| KFK-NFR-006 | Report run audit durability | Async OK; not on user critical path |

---

## 8. Security requirements

| ID | Requirement |
|----|-------------|
| KFK-SEC-001 | Kafka ACLs: produce/consume least privilege per service principal. |
| KFK-SEC-002 | TLS in transit (staging/prod); SASL/mTLS as env standard. |
| KFK-SEC-003 | No secrets in event `data`; reference vault/ids only. |
| KFK-SEC-004 | Consumers re-validate org entitlement where acting for automations. |
| KFK-SEC-005 | Assistant tool events must not escalate privileges; store acting user context. |
| KFK-SEC-006 | Consent-sensitive commands (`email.send`, `sms.send`) only after CCM consent check before publish or at consumer start (fail-closed). |
| KFK-SEC-007 | Short retention on raw ingest topics (e.g. 7–14 days); longer only where compacted id streams are justified. |
| KFK-SEC-008 | Audit access to DLQ and broker console — admin only. |

---

## 9. Reliability requirements

| ID | Concern | Approach |
|----|---------|----------|
| KFK-NFR-010 | Duplicates | `idempotencykey` + consumer-side unique store |
| KFK-NFR-011 | Ordering | Same `partitionkey` for aggregate lifecycle |
| KFK-NFR-012 | Poison messages | Max retries → DLQ with `x-original-topic` / error headers |
| KFK-NFR-013 | Schema evolution | Additive `data` within `vN`; bump `.vN` for breaking changes |
| KFK-NFR-014 | Multi-AZ prod | RF≥3; `min.insync.replicas=2` |

---

## 10. Integrations

| ID | Integration | Purpose |
|----|-------------|---------|
| KFK-INT-001 | `gvcrm-gateway` / ingest edge | Validate, ack, publish ad ingest |
| KFK-INT-002 | Every `gvcrm-*-api` | Produce/consume via SDK |
| KFK-INT-003 | MySQL outbox tables (per API) | Reliable publish |
| KFK-INT-004 | ClickHouse analytics | `report_runs` and optional KPI facts |
| KFK-INT-005 | WS / push / email / SMS providers | Notification delivery edge |
| KFK-INT-006 | `@gvcrm/contracts` / AsyncAPI | Envelope and typed payloads |
| KFK-INT-007 | Scalar / partner docs (SCL) | Public webhook mirror of selected events |

---

## 11. Module coverage matrix (priority)

| Module | Publishes / consumes (summary) | Priority |
|--------|--------------------------------|----------|
| IAM | lifecycle, entitlements | P0 |
| LED | ingest, lead.*, scoring / assign | **P0** |
| CCM | send, tracking, consent | P0 |
| PLT | notification, metadata | P0 |
| ODM | opp.*, activity, rotting | P0 |
| WPA | triggers, actions, approvals | P0 |
| DAR | report_run → CH | P0 |
| SPM | gamification, snapshots | P0 |
| INS | renewal_due, kpi | P0 with INS pack |
| DOC, QOC, PRD, TCL, MKT, AIA, ACM | As catalog | P1 |

---

## 12. Delivery phases

| Phase | Scope |
|-------|--------|
| **M0** | Compose Kafka + topic registry + SDK stub + outbox helper |
| **M1** | LED ingest/assign/notify pipeline (Meta/LinkedIn speed path) |
| **M2** | Notifications + CCM tracking + DAR `report_runs` writer |
| **M3** | WPA engine + ODM rotting/journeys |
| **M4** | SPM gamification + leaderboard snapshots |
| **M5** | DOC/QOC/MKT/AIA topics + DLQ console polish |

Do **not** block S0 IAM on Kafka. Introduce Kafka by **M1** before claiming Meta/LinkedIn realtime SLAs in production.

---

## 13. Acceptance criteria (platform)

1. Local Compose brings healthy Kafka; smoke produce/consume passes.  
2. Topic registry applied idempotently in each env.  
3. Vertical path live: **ad ingest → lead created → assigned → notification.requested**.  
4. `report_run.recorded` consumer writes ClickHouse successfully.  
5. Duplicate webhook publish does not create duplicate leads.  
6. DLQ receives poison messages after N failures; redrive documented.  
7. Lag alert fires in staging under synthetic load.  
8. No undeclared topic names merged to main.

---

## 14. Dependencies

| Module / doc | Relationship |
|--------------|--------------|
| LED | Realtime ingest SLAs depend on KFK M1 |
| WPA | Durable automation wake/execute |
| SPM | Idempotent gamification events |
| DAR / ClickHouse | `report_runs` sink |
| PLT | Notification intents |
| MKT / SCL | Partners use webhooks; Kafka remains internal |
| IAM | Events carry `orgId` + `actorUserId`; never password material |

---

## 15. Out of scope (reminder)

- Product UI for “Kafka admin” for end customers  
- Partner direct Kafka credentials  
- Using Kafka as CRM system of record  

---

## 16. Traceability

| Area | Requirement IDs |
|------|-----------------|
| Core messaging | KFK-FR-001…014 |
| Speed | KFK-NFR-001…006 |
| Reliability | KFK-NFR-010…014 |
| Security | KFK-SEC-001…008 |
| Integrations | KFK-INT-001…007 |

**Engineering depth (topics, consumer groups, layout):** `docs/dev-docs/kafka.md`  
**Partner-facing event docs:** [17-platform-api-documentation-scalar.md](./17-platform-api-documentation-scalar.md)
