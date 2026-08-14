# Dashboards and Reports — Use Cases

**Document ID:** GVCRM-UC-DAR  
**Requirements:** `docs/requirements/03-dashboards-and-reports.md`

---

## DAR-UC-001 — Use customizable homepage after login

| Field | Value |
|-------|-------|
| **Requirement** | DAR-FR-001 |
| **Priority** | P0 |
| **Primary actor** | A-PROD / A-AE / A-MGR |

### Main flow
1. User logs in (IAM-UC-001).
2. Homepage loads (&lt;2s target) with widgets: my leads, deals, tasks, alerts, charts, leaderboard tile (if SPM entitled).
3. User rearranges/hides widgets within admin-allowed catalog.
4. Clicks widget → drills to list or record.

### Business rules
- Widgets only show records user can access (DAR-SEC-001).

---

## DAR-UC-002 — Open pre-built dashboards

| Field | Value |
|-------|-------|
| **Requirement** | DAR-FR-002 |
| **Priority** | P0 |

### Main flow
1. User opens Dashboards catalog (sales, pipeline, activity, email, calls).
2. Opens a pre-built dashboard.
3. Optionally **clones** to customize (DAR-UC-003).

---

## DAR-UC-003 — Build a custom dashboard

| Field | Value |
|-------|-------|
| **Requirement** | DAR-FR-003 |
| **Priority** | P0 |
| **Primary actor** | A-MGR / A-OPS |

### Main flow
1. User creates dashboard; drag-drops charts and KPI tiles.
2. Configures filters (team, date, pipeline).
3. Publishes; sharable per DAR-UC-014.

---

## DAR-UC-004 — Run pre-built reports

| Field | Value |
|-------|-------|
| **Requirement** | DAR-FR-004 |
| **Priority** | P0 |

### Main flow
1. User selects template report (pipeline, milestones, performance).
2. Sets parameters; runs.
3. System executes under user security; writes ClickHouse `report_runs`.
4. User views table/chart; may save as personal copy.

---

## DAR-UC-005 — Build a custom report

| Field | Value |
|-------|-------|
| **Requirement** | DAR-FR-005 |
| **Priority** | P0 |
| **Primary actor** | A-OPS / A-AE |

### Main flow
1. User opens report builder; selects primary object (e.g. Opportunity).
2. Adds columns, filters, groupings, date ranges — no SQL.
3. Runs; drills into rows to records.
4. Saves report definition in MySQL DAR schema.

### Exceptions
- **E1 Too heavy:** Timeout/NFR messaging; suggest narrower filters.

---

## DAR-UC-006 — Visualize with interactive charts

| Field | Value |
|-------|-------|
| **Requirement** | DAR-FR-006 |
| **Priority** | P0 |

### Main flow
1. From report or dashboard, user chooses chart type (bar, line, funnel, pie, heat map, …).
2. Interacts (hover, drill-down).
3. Chart respects same security as underlying report.

---

## DAR-UC-007 — Run activity reports

| Field | Value |
|-------|-------|
| **Requirement** | DAR-FR-007 |
| **Priority** | P0 |

### Main flow
1. User runs activity report (emails, calls, tasks, appointments).
2. Filters by user/team/date; exports if permitted.

---

## DAR-UC-008 — Run deal reports

| Field | Value |
|-------|-------|
| **Requirement** | DAR-FR-008 |
| **Priority** | P0 |

### Main flow
1. User runs deal report: closed-won, revenue, stages, aging, win/loss.
2. Manager drills to rotting or aging deals.

---

## DAR-UC-009 — Analyze email performance

| Field | Value |
|-------|-------|
| **Requirement** | DAR-FR-009 |
| **Priority** | P1 |

### Main flow
1. User opens email reports (delivery/open/click by person and time grain).
2. Uses results to coach or tune templates.

---

## DAR-UC-010 — Analyze call performance

| Field | Value |
|-------|-------|
| **Requirement** | DAR-FR-010 |
| **Priority** | P1 |

### Main flow
1. User views call volume, connect rate, duration, peak hours.
2. Filters by team; exports.

---

## DAR-UC-011 — Monitor API usage

| Field | Value |
|-------|-------|
| **Requirement** | DAR-FR-011 |
| **Priority** | P1 |
| **Primary actor** | A-ADM |
| **Security** | DAR-SEC-005 |

### Main flow
1. Admin opens API usage dashboard.
2. Sees quota, consumers, methods, threshold alerts.
3. Investigates spikes (e.g. marketplace app).

---

## DAR-UC-012 — Preview report before publish

| Field | Value |
|-------|-------|
| **Requirement** | DAR-FR-012 |
| **Priority** | P1 |

### Main flow
1. Builder clicks **Preview**.
2. Sees sample table/chart without publishing.
3. Adjusts and saves.

---

## DAR-UC-013 — Share and schedule reports

| Field | Value |
|-------|-------|
| **Requirement** | DAR-FR-013 |
| **Priority** | P0 |

### Main flow
1. User exports PDF/XLS/CSV (permissioned separately — DAR-SEC-003).
2. Schedules recurring email delivery to recipients.
3. Recipients receive export; **do not** gain CRM record access beyond what report already allowed at run time.

### Alternate
- **A1 Run as owner:** Restricted + audited (DAR-SEC-004).

---

## DAR-UC-014 — Share dashboards

| Field | Value |
|-------|-------|
| **Requirement** | DAR-FR-014 |
| **Priority** | P0 |

### Main flow
1. Owner shares dashboard with users/groups.
2. Viewer opens dashboard; widgets empty/hidden where underlying records inaccessible (DAR-SEC-002).
3. Optional PDF export / scheduled email.

---

## DAR-UC-015 — Execute conversational report specification (engine)

| Field | Value |
|-------|-------|
| **Requirement** | DAR-FR-015 |
| **Priority** | P0 |
| **Primary actor** | A-SYS (called by AIA) / A-OPS |
| **Integrations** | DAR-INT-005 |

### Main flow
1. AIA (or API client) submits structured report spec.
2. Engine validates required fields; returns “missing fields” payload if incomplete.
3. On complete spec: preview → run under **requesting user’s** security → optional save as DAR report.
4. Appends `report_runs` with `source=assistant` when from AIA.

### Business rules
- Never bypass RLS/FLS; hallucinated objects rejected.

---

## Traceability matrix

| UC | FR | Priority |
|----|-----|----------|
| DAR-UC-001…015 | DAR-FR-001…015 | as above |
