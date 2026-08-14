# Sales Performance — Use Cases

**Document ID:** GVCRM-UC-SPM  
**Requirements:** `docs/requirements/10-sales-performance-management.md`

---

## SPM-UC-001 — Set and track goals

| Field | Value |
|-------|-------|
| **Requirement** | SPM-FR-001 |
| **Priority** | P0 |
| **Primary actors** | A-MGR (set), A-PROD (track) |
| **Security** | SPM-SEC-001 |

### Main flow
1. Manager sets user/team KPI targets for a period (premium, quotes, activities…).
2. System aggregates progress from ODM/INS/CCM Facades.
3. Producer views own goals; manager views team.

---

## SPM-UC-002 — View target achievement

| Field | Value |
|-------|-------|
| **Requirement** | SPM-FR-002 |
| **Priority** | P0 |
| **Primary actor** | A-MGR / executive |

### Main flow
1. User opens attainment dashboard (% to target).
2. Switches company / team / individual; drills to contributing records.
3. Quota confidentiality honored via FLS (SPM-SEC-005).

---

## SPM-UC-003 — Forecast sales (best / likely / worst)

| Field | Value |
|-------|-------|
| **Requirement** | SPM-FR-003 |
| **Priority** | P0 |
| **Primary actor** | A-MGR / A-AE |
| **Security** | SPM-SEC-002 |

### Main flow
1. User opens forecast vs quota.
2. Sees best / likely / worst from pipeline probabilities/categories.
3. Manager adjusts forecast (permissioned + audited) when enabled (P1 depth).

---

## SPM-UC-004 — Run sales campaigns and measure ROI

| Field | Value |
|-------|-------|
| **Requirement** | SPM-FR-004 |
| **Priority** | P1 |
| **Primary actor** | A-MKT / A-MGR |
| **Security** | SPM-SEC-003 |
| **Integrations** | SPM-INT-006 |

### Main flow
1. User creates campaign (email, phone, webinar, Meta, LinkedIn).
2. Adds members (respecting lead/contact sharing).
3. Tracks responses and influenced opportunities.
4. Analyzes ROI including ad spend vs attributed premium/pipeline.

---

## SPM-UC-005 — Participate in complete gamification

| Field | Value |
|-------|-------|
| **Requirement** | SPM-FR-005 |
| **Priority** | P0 |
| **Primary actor** | A-PROD |
| **Integrations** | SPM-INT-003 |

### Main flow
1. Enablement configures points, badges, streaks, challenges, seasons.
2. Sales outcomes/activities emit **idempotent** gamification events.
3. Producer earns points/badges; sees progress.
4. Duplicate event retries do not double-award.

---

## SPM-UC-006 — View daily, weekly, and monthly leaderboards

| Field | Value |
|-------|-------|
| **Requirement** | SPM-FR-006 |
| **Priority** | P0 |
| **Primary actors** | A-PROD, A-MGR |
| **Security** | SPM-SEC-004 |
| **Integrations** | SPM-INT-007 (insurance KPIs) |

### Main flow
1. Snapshot job publishes rankings for **daily / weekly / monthly** periods (freshness ≤5 min).
2. Producer opens boards (premium bound, quotes, speed-to-lead, points…).
3. Homepage widget shows today’s rank and gap to #1.
4. Optional digests emailed/pushed.
5. Boards show aggregates only — no peer deal PII the viewer cannot access.

### Alternate
- **A1 Assistant ask:** “Where am I on this week’s leaderboard?” (AIA + SPM).

---

## Traceability matrix

| UC | FR | Priority |
|----|-----|----------|
| SPM-UC-001…006 | SPM-FR-001…006 | as above |
