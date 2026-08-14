# US Insurance Agency and Remote Sales — Use Cases

**Document ID:** GVCRM-UC-INS  
**Requirements:** `docs/requirements/15-us-insurance-agency-and-remote-sales.md`  
**Related FRs owned elsewhere:** LED-FR-008 (Meta/LinkedIn), SPM-FR-005/006 (gamification & boards)

---

## INS-UC-001 — Orient a US insurance tenant

| Field | Value |
|-------|-------|
| **Requirement** | INS-FR-001 |
| **Priority** | P0 |
| **Primary actor** | A-ADM / A-MGR |

### Main flow
1. Admin creates/configures org as agency, MGA/IMO, or carrier.
2. System sets USD default, state/ZIP emphasis, LOB catalog seed.
3. Insurance pipelines enabled (new business, cross-sell, renewal).
4. Remote homepage widgets entitled (queue, boards, assistant).

### Business rules
- CRM is **not** PAS/rating/DOI system of record.

---

## INS-UC-002 — Model agency, producers, carriers, and households

| Field | Value |
|-------|-------|
| **Requirement** | INS-FR-002 |
| **Priority** | P0 |
| **Primary actors** | A-ADM, A-OPS, A-PROD |
| **Security** | INS-SEC-001, INS-SEC-002 |

### Main flow
1. Admin defines agency structure; producer profiles with **NPN/licenses** (docs in DOC).
2. Records carrier appointments.
3. Creates **household** accounts; adds household members (ACM + INS).
4. Assignment/routing uses state + LOB + license eligibility (with LED queues).

### Exceptions
- **E1 Unlicensed for LOB/state:** Producer excluded from that queue.

---

## INS-UC-003 — Manage book of business, policies, and renewals

| Field | Value |
|-------|-------|
| **Requirement** | INS-FR-003 |
| **Priority** | P0 |
| **Primary actor** | A-PROD / A-AM |
| **Security** | INS-SEC-003 |

### Main flow
1. User records policy on household (LOB, carrier, premium, term, policy number).
2. Links related opportunity/quote when present.
3. Approaching term → system creates **renewal** opportunity on renewal pipeline.
4. Cross-sell prompts suggest missing LOBs on household.
5. Producer works renewal/cross-sell through ODM/QOC.

### Alternate
- **A1 Bind new business** from Meta lead path (E2E-UC-002).

---

## INS-UC-004 — Work the remote sales workspace

| Field | Value |
|-------|-------|
| **Requirement** | INS-FR-004 |
| **Priority** | P0 |
| **Primary actor** | A-PROD / A-ISA |

### Main flow
1. Remote producer opens mobile/web queue (new ad leads, renewals due, tasks).
2. Receives push for new Meta/LinkedIn lead.
3. Uses assistant for quick ops; OOO flag removes them from round-robin.
4. Optional field check-in (TCL) for in-person appointments.
5. Homepage usable on mobile (&lt;2s target).

---

## INS-UC-005 — Enforce US insurance sales compliance hooks

| Field | Value |
|-------|-------|
| **Requirement** | INS-FR-005 |
| **Priority** | P0 |
| **Primary actors** | A-LEG / A-SYS / A-PROD |
| **Security** | INS-SEC-004 |

### Main flow
1. Org enables `tcpa_strict` / consent requirements.
2. Ad-source consent stored via LED → CCM SoR (not duplicated in INS).
3. Outbound call/SMS/email (including AIA send) blocked without consent / on DNC.
4. License/NPN expiry reminders notify producer and compliance (v1 polish timing acceptable).

### Exceptions
- **E1 Attempted send without consent:** Hard block + guidance.

---

## INS-UC-006 — Use insurance KPIs on gamification and reports

| Field | Value |
|-------|-------|
| **Requirement** | INS-FR-006 |
| **Priority** | P0 |
| **Depends on** | SPM-UC-005, SPM-UC-006, DAR |

### Main flow
1. System computes KPIs: premium bound, bind ratio, speed-to-lead, renewals retained, quotes issued, etc.
2. KPIs feed D/W/M leaderboards and DAR reports.
3. Snapshots refresh ≤5 min for boards.
4. Privacy: aggregates only per SPM-SEC-004.

---

## INS-UC-007 — Install US Insurance Agency industry pack

| Field | Value |
|-------|-------|
| **Requirement** | INS-FR-007 |
| **Priority** | P1 |
| **Primary actor** | A-ADM |
| **Depends on** | MKT-UC-003 |

### Main flow
1. Admin finds “US Insurance Agency” pack in Marketplace.
2. Installs to sandbox; reviews pipelines, LOBs, layouts, leaderboard templates, workflows.
3. Promotes to production.
4. Org matches INS-UC-001 orientation without manual rebuild.

---

## Traceability matrix

| UC | FR | Priority |
|----|-----|----------|
| INS-UC-001…007 | INS-FR-001…007 | as above |
| (see LED-UC-008) | LED-FR-008 | P0 |
| (see SPM-UC-005/006) | SPM-FR-005/006 | P0 |
