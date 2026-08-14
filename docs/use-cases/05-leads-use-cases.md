# Leads Management — Use Cases

**Document ID:** GVCRM-UC-LED  
**Requirements:** `docs/requirements/05-leads-management.md`

---

## LED-UC-001 — Capture leads from multiple sources

| Field | Value |
|-------|-------|
| **Requirement** | LED-FR-001 |
| **Priority** | P0 |
| **Primary actors** | A-MKT, A-AE, A-SYS, A-EXT |

### Main flow
1. Lead enters via manual create, web form, CSV import, API, campaign, chat, or partner app.
2. System stores `lead_source`, `source_detail`, UTM, original payload.
3. Dedup rules match email/phone/domain+name → create, update, or review queue.
4. Form submissions appear within 10 seconds; spam protections applied (LED-SEC-003).

### Alternate
- **A1 Import wizard:** Column map, validation errors, partial success report.
- **A2 Update existing:** Enrich lead; log source touch.

### Business rules
- All sources land in one Lead object.

---

## LED-UC-002 — Automatically distribute leads

| Field | Value |
|-------|-------|
| **Requirement** | LED-FR-002 |
| **Priority** | P0 |
| **Primary actor** | A-OPS (config), A-SYS (assign), A-PROD (receive) |
| **Security** | LED-SEC-005 |

### Main flow
1. Ops defines criteria rules (geo, product/LOB, score, source) and/or round-robin queues.
2. New lead evaluates rules; concurrent-safe claim assigns owner/queue.
3. Assignee notified (push/in-app).
4. Unassigned SLA escalation optional via workflow.

### Exceptions
- **E1 No matching queue:** Park in default queue; alert ops.
- **E2 Double claim race:** Only one owner wins.

---

## LED-UC-003 — Score and prioritize leads

| Field | Value |
|-------|-------|
| **Requirement** | LED-FR-003 |
| **Priority** | P0 |
| **Primary actor** | A-MKT (rules), A-AE (work) |

### Main flow
1. Ops configures scoring rules and MQL/SQL thresholds.
2. On create/update, score recalculates; breakdown visible.
3. Rep sorts queue by score; works highest first.

---

## LED-UC-004 — Create lead from forwarded email (parser)

| Field | Value |
|-------|-------|
| **Requirement** | LED-FR-004 |
| **Priority** | P1 |
| **Security** | LED-SEC-002 |

### Main flow
1. User forwards lead email to org parser address (unguessable; allow-listed senders).
2. Parser extracts fields; creates/updates lead.
3. User reviews low-confidence fields.

---

## LED-UC-005 — Scan business card to create lead

| Field | Value |
|-------|-------|
| **Requirement** | LED-FR-005 |
| **Priority** | P1 |
| **Primary actor** | A-PROD |
| **Security** | LED-SEC-004 |

### Main flow
1. On mobile, user photographs card.
2. OCR drafts lead; user confirms; saves (offline queue if needed).
3. Image stored encrypted with retention policy.

---

## LED-UC-006 — Analyze win-loss and speed-to-lead

| Field | Value |
|-------|-------|
| **Requirement** | LED-FR-006 |
| **Priority** | P1 |
| **Primary actor** | A-MGR |

### Main flow
1. Manager opens win-loss / lifecycle analytics.
2. Filters by source, owner, campaign (incl. Meta/LinkedIn).
3. Reviews loss reasons and speed-to-lead; exports if allowed.

---

## LED-UC-007 — Progress lead lifecycle and convert

| Field | Value |
|-------|-------|
| **Requirement** | LED-FR-007 |
| **Priority** | P0 |
| **Primary actor** | A-AE / A-PROD |

### Main flow
1. User moves lead through statuses (new → working → qualified…).
2. On convert: selects create Account / Contact / Opportunity (ACM/ODM Facades).
3. Lead marked converted; lineage retained on opportunity.
4. On loss: **loss reason required**.

### Exceptions
- **E1 Insufficient permission** on ACM/ODM: convert blocked.

---

## LED-UC-008 — Ingest real-time Meta and LinkedIn leads

| Field | Value |
|-------|-------|
| **Requirement** | LED-FR-008 |
| **Priority** | P0 |
| **Primary actors** | A-SYS, A-MKT (connect), A-PROD (work) |
| **Integrations** | LED-INT-007, LED-INT-008 |
| **Security** | LED-SEC-006, LED-SEC-007 |

### Preconditions
- Ad account OAuth connected (encrypted tokens); page/form mapped; assignment ready.

### Main flow
1. Prospect submits Meta Lead Ad or LinkedIn Lead Gen Form.
2. Webhook/sync delivers payload; idempotency key prevents duplicates.
3. Lead created with ad attribution; **consent preserved** into CCM.
4. Assignment + notify within P95 ≤15s.
5. Remote producer works lead (E2E-UC-001).

### Exceptions
- **E1 Provider outage:** Queue retries; ops alert.
- **E2 Token expired:** Connection status unhealthy; pause ingest.

### Business rules
- Outbound follow-up must honor stored ad consent (INS/CCM).

---

## Traceability matrix

| UC | FR | Priority |
|----|-----|----------|
| LED-UC-001…008 | LED-FR-001…008 | as above |
