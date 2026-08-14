# Kafka Messaging Use Cases

**Document ID:** GVCRM-UC-KFK  
**Sources:** `docs/requirements/16-kafka-messaging-platform.md`, `docs/dev-docs/kafka.md`  
**Actors:** Platform engineer (A-PLT), Module API owner (A-API), Ops/SRE (A-OPS). Partners do **not** consume Kafka (see SCL webhooks).

---

## KFK-UC-001 — Publish and consume durable domain events

| Field | Value |
|-------|-------|
| **Requirement** | KFK-FR-001, KFK-FR-005, KFK-FR-011 |
| **Actors** | A-API, A-PLT |
| **Priority** | P0 |
| **Goal** | Module services exchange events via standard envelope without shared DB |

### Main flow
1. Producer API writes business change; builds envelope (`type`, `orgid`, `idempotencykey`, `partitionkey`, `data`).
2. Message published to declared topic via `@gvcrm/messaging-client`.
3. Consumer group receives message; validates envelope; applies idempotent handler.
4. Side effects complete (notify, score, CH write, etc.); ack offset.

### Exceptions
- **E1 Missing orgid / idempotencykey:** SDK rejects publish.
- **E2 Handler failure:** Retry then DLQ (KFK-UC-004).

---

## KFK-UC-002 — Meta/LinkedIn ingest to assigned + notify (≤15s)

| Field | Value |
|-------|-------|
| **Requirement** | KFK-FR-002, KFK-NFR-001; LED-NFR-001 |
| **Actors** | Ingest edge, leads-api/worker, notification-worker |
| **Priority** | P0 |

### Main flow
1. Ad platform webhook → gateway validates → publish `ad_ingest.received`.
2. Leads worker creates lead → `lead.created` → assignment → `lead.assigned`.
3. Publish `plt.notification.requested`; producer receives push/in-app alert.
4. End-to-end P95 ≤ 15s from ingest publish to notify intent (excludes carrier SMS latency).

### Business rules
- Duplicate provider lead id does not create duplicate CRM leads.
- Consent flags preserved for CCM.

---

## KFK-UC-003 — Transactional outbox for critical paths

| Field | Value |
|-------|-------|
| **Requirement** | KFK-FR-003, KFK-FR-010 |
| **Actors** | A-API |
| **Priority** | P0 |

### Main flow
1. HTTP handler writes business row + outbox row in one MySQL TX; returns 200/202.
2. Outbox relay publishes to Kafka; marks published.
3. Consumer handles at-least-once with idempotency store.

---

## KFK-UC-004 — Dead-letter and redrive

| Field | Value |
|-------|-------|
| **Requirement** | KFK-FR-006, KFK-SEC-008 |
| **Actors** | A-OPS |
| **Priority** | P0 |

### Main flow
1. Consumer fails N times on poison payload.
2. Message lands on `gvcrm.sys.dlq` with original topic/error headers.
3. Ops inspects (admin-only console); fixes schema/handler; redrives with audit.

---

## KFK-UC-005 — Local Compose messaging stack

| Field | Value |
|-------|-------|
| **Requirement** | KFK-FR-008 |
| **Actors** | A-PLT, A-API |
| **Priority** | P0 |

### Main flow
1. Developer runs messaging Compose profile.
2. Topic registry applied; smoke produce/consume passes.
3. Module tests use fakes when `KAFKA_BROKERS` unset.

---

## KFK-UC-006 — Observability and lag alert

| Field | Value |
|-------|-------|
| **Requirement** | KFK-FR-007 |
| **Actors** | A-OPS |
| **Priority** | P0 |

### Main flow
1. Metrics scrape produce/consume rates, lag, DLQ rate, outbox age.
2. Synthetic load in staging exceeds lag threshold → alert fires.
3. Logs correlate via `correlationid` without full PII bodies.

---

## KFK-UC-007 — Enforce topic catalog and tenant isolation

| Field | Value |
|-------|-------|
| **Requirement** | KFK-FR-004, KFK-FR-009, KFK-FR-012 |
| **Actors** | A-PLT (review), A-API |
| **Priority** | P0 |

### Main flow
1. Module proposes new event type; updates declarative topic registry in `gvcrm-messaging`.
2. PR without registry entry or with missing `orgid` is blocked.
3. Consumers enforce `orgid` before side effects.

---

## KFK-UC-008 — Report run to ClickHouse via Kafka

| Field | Value |
|-------|-------|
| **Requirement** | KFK-FR-014; DAR report_runs |
| **Actors** | reporting-api, clickhouse-writer worker |
| **Priority** | P0 |

### Main flow
1. Report run completes → publish `dar.report_run.recorded`.
2. CH writer consumer inserts `report_runs` row.
3. User critical path does not wait on CH write.

---

## KFK-UC-009 — Consent-safe outbound send commands

| Field | Value |
|-------|-------|
| **Requirement** | KFK-SEC-006 |
| **Actors** | CCM / WPA producers and send workers |
| **Priority** | P0 |

### Main flow
1. Before publish (or at consumer start), consent/TCPA/DNC checked fail-closed.
2. Only then email/SMS send command proceeds.
3. Missing consent → no send; audit reason recorded.

---

## KFK-UC-010 — SDK publish/subscribe for module teams

| Field | Value |
|-------|-------|
| **Requirement** | KFK-FR-013 |
| **Actors** | A-API |
| **Priority** | P0 |

### Main flow
1. Module depends on `@gvcrm/messaging-client` only (no ad-hoc broker clients on P0 paths).
2. Uses `publish` / `subscribe` with graceful shutdown and metrics hooks.
3. Envelope validation runs on produce and consume.

---

## Coverage map

| FR / NFR / SEC | Use case(s) |
|----------------|-------------|
| KFK-FR-001, 005, 011 | KFK-UC-001 |
| KFK-FR-002, KFK-NFR-001 | KFK-UC-002 |
| KFK-FR-003, 010 | KFK-UC-003 |
| KFK-FR-006, SEC-008 | KFK-UC-004 |
| KFK-FR-008 | KFK-UC-005 |
| KFK-FR-007 | KFK-UC-006 |
| KFK-FR-004, 009, 012 | KFK-UC-007 |
| KFK-FR-014 | KFK-UC-008 |
| KFK-SEC-006 | KFK-UC-009 |
| KFK-FR-013 | KFK-UC-010 |
| Remaining SEC/NFR | Enforced as cross-cutting rules in UC-001…010 and platform acceptance in requirements §13 |
