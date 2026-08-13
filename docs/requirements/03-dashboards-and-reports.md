# Dashboards and Reports

**Document ID:** GVCRM-REQ-DAR  
**Version:** 1.0  
**Status:** Draft for implementation  
**Module:** Dashboards and Reports  
**This document is independent.** Related modules are listed only as dependencies.

---

## 1. Purpose

Give every user a **homepage and analytics workspace** to monitor sales activity, pipeline, email and call performance, API usage, and team KPIs — using pre-built content, custom drag-and-drop reports, interactive charts, sharing, and scheduled delivery.

## 2. Scope

**In scope**

- User homepage / personal dashboard
- Pre-built and custom dashboards
- Pre-built and custom reports
- Charts and visualizations with drill-down
- Activity, deal, email, and call reports
- API usage dashboard
- Report preview, export, sharing, and scheduled delivery
- Dashboard sharing and PDF export

**Out of scope**

- Defining sales targets and forecasts — Sales Performance Management (this module visualizes them)
- Building custom apps that embed dashboards — Platform Capabilities
- Marketplace listing analytics — Marketplace module

## 3. Users

| Persona | Typical actions |
|---------|-----------------|
| Sales representative | Homepage of my leads, deals, tasks, alerts |
| Sales manager | Team dashboards, deal and activity reports |
| Sales ops / analyst | Custom reports, filters, scheduled exports |
| Admin | API usage, sharing permissions, pre-built catalog |
| Executive | Pre-built company performance dashboards |

## 4. Business objectives

- Instant snapshot of “what needs my attention today”
- Self-serve analytics without engineering tickets
- Consistent KPI definitions via pre-built templates
- Safe sharing and automated distribution of insights

---

## 5. Functional requirements

### 5.1 User homepage or dashboard

**Source capability:** User Homepage or Dashboard  
**Priority:** P0  
**ID:** DAR-FR-001

The solution shall offer a user homepage or dashboard displaying a customizable summary of assigned leads, opportunities, tasks, alerts, gadgets, recent activities, recommendations, and visualizations.

**User story**  
As a sales representative, I want my landing page after login to show my work queue and alerts so I start selling immediately.

**Detailed requirements**

1. Default homepage after login (user can change default).
2. Widgets (gadgets) include at least: my open leads, my open opportunities, today’s tasks, alerts/notifications, recent activities, recommendations (e.g. rotting deals, unanswered emails), and one or more charts.
3. Users can add/remove/reorder/resize widgets within layout rules.
4. Widget data respects record sharing (only my accessible records).
5. Admin can publish a default homepage layout per profile/role.

**Acceptance criteria**

- After login, homepage renders with the user’s assigned open leads and opportunities.
- Removing a widget persists on next login.
- A manager’s homepage does not show records they cannot access unless they have team visibility.
- Empty widgets show a helpful empty state, not an error.

---

### 5.2 Pre-built dashboards

**Source capability:** Pre-built Dashboards  
**Priority:** P0  
**ID:** DAR-FR-002

The solution shall provide pre-built dashboards to get insights on sales data and team performance quickly.

**Detailed requirements**

1. Shipped catalog includes at least: Sales overview, Team performance, Pipeline, Activity, Email engagement, Calls.
2. Pre-built dashboards are cloneable (copy-on-write) so users can customize without editing the master.
3. Filters: date range, owner, team, product, territory, pipeline.
4. Catalog is searchable by name and KPI.

**Acceptance criteria**

- A new org sees the pre-built catalog without configuration.
- Cloning a dashboard lets the user edit the copy; master remains unchanged.
- Date-range filter refreshes all widgets on the dashboard.

---

### 5.3 Customizable dashboard

**Source capability:** Customizable Dashboard  
**Priority:** P0  
**ID:** DAR-FR-003

The solution shall provide a visual drag-and-drop editor to customize the dashboard with charts, reports, or engagement analytics.

**User story**  
As a sales manager, I want to drag charts onto a canvas and arrange them for my weekly pipeline review.

**Detailed requirements**

1. Drag-and-drop canvas: add chart, report snapshot, KPI tile, engagement analytics widget, rich text, filter control.
2. Each widget binds to a report, a saved metric, or a live query.
3. Layout grid with responsive breakpoints (desktop/tablet).
4. Undo/redo while editing; draft vs published dashboard states.

**Acceptance criteria**

- User can add a chart widget from an existing report and resize it.
- Publishing makes the dashboard visible to intended audience; draft is not.
- Invalid widget (deleted report) shows a repair prompt instead of breaking the whole page.

---

### 5.4 Pre-built reports

**Source capability:** Pre-built Reports  
**Priority:** P0  
**ID:** DAR-FR-004

The solution shall provide pre-built report templates for sales performance snapshots, milestone tracking, or drill-down using saved searches and filters. Users can set up reusable templates using KPIs.

**Detailed requirements**

1. Pre-built report templates covering sales performance, activity, milestones, and pipeline.
2. Templates use saved searches/filters and documented KPI definitions.
3. Users can save a configured template as a personal or org reusable report.
4. KPI library (e.g. win rate, average cycle time, activity per rep) can be reused in new reports.

**Acceptance criteria**

- Running a pre-built “sales performance” report returns rows consistent with the KPI definition.
- Saving a modified template creates a new report, not an overwrite of the system original (unless admin explicitly edits system catalog).
- Saved search filters persist when the report is reopened.

---

### 5.5 Custom reports

**Source capability:** Custom Reports  
**Priority:** P0  
**ID:** DAR-FR-005

The solution shall provide a drag-and-drop interface to create customizable reports with charts and tables, analyze data, and apply filters to drill down.

**User story**  
As a sales ops analyst, I want to join deals to products and filter by stage without writing SQL.

**Detailed requirements**

1. Report builder: select primary object, related objects, columns, groupings, summary aggregations (count, sum, avg, min, max, unique).
2. Filters: AND/OR, date presets, relative dates, field comparisons, saved filters.
3. Visualization toggle: table, and charts listed in DAR-FR-006.
4. Drill-down from summary row/chart segment to underlying records.
5. Calculated fields (simple expressions) where Platform calculated fields exist.
6. Row-level security always applied.

**Acceptance criteria**

- A report on Opportunities grouped by Stage with sum of Amount matches list-view totals for the same filter.
- Drill-down opens the matching record set.
- User without access to a field cannot add it to the report.
- Report save requires name, folder, and visibility scope.

---

### 5.6 Charts and visualizations

**Source capability:** Charts and Visualizations  
**Priority:** P0  
**ID:** DAR-FR-006

The solution shall generate interactive charts with drill-down, customized to visualize large quantities of data. Supported types shall include Bar, Line, Funnel, Table, Column, Donut, Pie, Area maps, and Heat maps.

**Detailed requirements**

1. Chart types: Bar, Line, Funnel, Table, Column, Donut, Pie, Area map, Heat map.
2. Interactive: tooltips, legend toggle, drill-down, optional zoom.
3. Color palettes accessible (color-blind safe option).
4. Large datasets: aggregation at query time; client does not download raw millions of rows to draw a pie chart.
5. Export chart as PNG/SVG; include in dashboard and PDF.

**Acceptance criteria**

- Funnel chart of pipeline stages shows count or amount per stage and drills to records.
- Heat map by territory × month renders for at least 12×20 cells.
- Switching chart type keeps the same underlying report query where compatible.
- Area/heat maps respect user’s geo permission on account/contact data.

---

### 5.7 Activity reports

**Source capability:** Activity Reports  
**Priority:** P0  
**ID:** DAR-FR-007

The solution shall provide out-of-the-box customizable reports to view Emails, Phone Calls, Tasks, and Appointments associated with team members.

**Detailed requirements**

1. Pre-built activity reports: emails, calls, tasks, appointments by user/team/date.
2. Metrics: volume, completed vs open, overdue, duration (calls), outcome.
3. Customizable columns and grouping (by user, activity type, related object).
4. Link-through to the activity record.

**Acceptance criteria**

- Manager running “team calls this week” sees only their permitted team.
- Overdue tasks are identifiable.
- Changing date filter updates totals correctly.

---

### 5.8 Deal reports

**Source capability:** Deal Reports  
**Priority:** P0  
**ID:** DAR-FR-008

The solution shall generate detailed reports such as deals closed in the current month, daily revenue, sales stages, etc.

**Detailed requirements**

1. Pre-built: closed-won this month, daily revenue, deals by stage, deals by owner, aging by stage, win/loss.
2. Filters: pipeline, product, territory, close date, created date.
3. Daily revenue can be based on close date or recognized revenue date (configurable).

**Acceptance criteria**

- “Closed this month” matches opportunity list filtered to Won + close date in current month.
- Daily revenue chart sums to the monthly total.
- Stage report works across multiple pipelines when selected.

---

### 5.9 Email reports

**Source capability:** Email Reports  
**Priority:** P1  
**ID:** DAR-FR-009

The solution shall provide reports to analyze delivery rates (bounce rates, click rates) and engagement for sent emails, classified across each salesperson by number of emails sent daily, weekly, or monthly.

**Detailed requirements**

1. Metrics: sent, delivered, bounce rate, open rate, click rate, unsubscribe, by user and time grain (day/week/month).
2. Classification per salesperson.
3. Template and campaign breakdown optional.
4. Definitions documented (open rate denominator = delivered vs sent — choose delivered and state it).

**Acceptance criteria**

- Sum of daily sends for a user equals weekly total for the same week.
- Bounce rate uses a consistent denominator shown in the report footer.
- Users without email analytics permission cannot open the report.

---

### 5.10 Call analytics

**Source capability:** Call Analytics  
**Priority:** P1  
**ID:** DAR-FR-010

The solution shall provide visualizations and reports to visualize call data and measure the sales team’s performance.

**Detailed requirements**

1. Metrics: calls made, connected, missed, average duration, talk time, calls per rep, conversion to next stage (if attributable).
2. Visualizations: trend lines, leaderboards, heat map by hour-of-day / day-of-week.
3. Filter by call tag, team, outcome.

**Acceptance criteria**

- Leaderboard ranks reps by connected calls for the selected period.
- Heat map highlights peak call hours.
- Missed-call count aligns with Communication module status.

---

### 5.11 API usage dashboard

**Source capability:** API Usage Dashboard  
**Priority:** P1  
**ID:** DAR-FR-011

The solution shall offer dashboards to track the company’s account API usage: consumers, usage pattern, average daily usage, access points, and API methods used.

**User story**  
As an admin, I want to see which integration is consuming our API quota before we hit the limit.

**Detailed requirements**

1. Widgets: total calls vs quota, average daily usage, usage over time, top consumers (OAuth app / API key / user), top methods, access points (IP/region if available).
2. Alerts when usage exceeds warning and critical thresholds.
3. Drill-down to consumer → method → time series.
4. Export usage log summary.

**Acceptance criteria**

- Dashboard shows usage for the current billing period.
- Filtering to one API consumer updates method breakdown.
- Warning notification fires when threshold is crossed.
- Marketplace-installed apps appear as named consumers.

---

### 5.12 Report preview

**Source capability:** Report Preview  
**Priority:** P1  
**ID:** DAR-FR-012

The solution shall allow previewing the report before publishing to verify or edit the data and see how it is represented.

**Detailed requirements**

1. Preview uses sample or live data with a row cap, showing table and selected chart.
2. User can edit columns/filters from preview and refresh.
3. Publish/save is explicit after preview.
4. Preview respects the same security as run.

**Acceptance criteria**

- Preview shows representation (chart type + sample rows) before publish.
- Publishing without preview is allowed but preview is one click away.
- Preview of a report the user cannot access is denied.

---

### 5.13 Report sharing

**Source capability:** Report Sharing  
**Priority:** P0  
**ID:** DAR-FR-013

The solution shall enable exporting reports as PDF, XLS, or CSV, or scheduling automatic delivery on a recurring basis.

**Detailed requirements**

1. Export: PDF, XLS/XLSX, CSV.
2. Schedule: daily/weekly/monthly, timezone, recipients (users, groups, external emails if permitted).
3. Scheduled file generation runs with the owner’s permissions (or a specified run-as user with audit).
4. Large exports are asynchronous with download notification.
5. Password-protect PDF optional.

**Acceptance criteria**

- CSV export columns match the report.
- Scheduled weekly email arrives with the file or a secure download link.
- Disabling the schedule stops future sends.
- External email recipients require an extra permission.

---

### 5.14 Dashboard sharing

**Source capability:** Dashboard Sharing  
**Priority:** P0  
**ID:** DAR-FR-014

The solution shall allow users to share dashboards with others, export them as PDF, or set schedules to send them to selected users via email.

**Detailed requirements**

1. Share with users, roles, or groups: view vs edit.
2. Export dashboard as multi-page PDF (widgets rendered).
3. Schedule dashboard PDF/link delivery.
4. Shared viewers still only see data they are allowed to see (viewer’s permission, not owner’s — default; optional “run as owner” with warning).

**Acceptance criteria**

- Shared viewer opens dashboard and sees only permitted records.
- PDF export includes visible widgets.
- Scheduled send can be cancelled.
- Revoking share immediately removes access.

---

## 6. Data entities

| Entity | Purpose |
|--------|---------|
| Dashboard | Layout, owner, visibility, widgets |
| DashboardWidget | Type, query/report binding, position |
| Report | Definition, object, columns, filters, chart |
| ReportFolder | Organization and sharing container |
| KpiDefinition | Reusable metric formula |
| ScheduledDelivery | Recurrence, recipients, format |
| ApiUsageSnapshot | Aggregated API telemetry |

## 7. Integrations

| ID | Integration | Purpose |
|----|-------------|---------|
| DAR-INT-001 | Email delivery | Scheduled report/dashboard send |
| DAR-INT-002 | Object query engine (all CRM objects) | Report data source |
| DAR-INT-003 | API gateway telemetry | API usage dashboard |
| DAR-INT-004 | Export pipeline (PDF/XLS/CSV workers) | Async file generation |

## 8. Permissions and security

| ID | Requirement |
|----|-------------|
| DAR-SEC-001 | Reports never bypass record-level or field-level security. |
| DAR-SEC-002 | Sharing a dashboard does not implicitly grant record access. |
| DAR-SEC-003 | Export and schedule actions are permissioned separately from view. |
| DAR-SEC-004 | “Run as owner” is audited and restricted. |
| DAR-SEC-005 | API usage dashboard is admin-only by default. |

## 9. Non-functional requirements

| ID | Requirement |
|----|-------------|
| DAR-NFR-001 | Homepage P95 < 2s with default widgets. |
| DAR-NFR-002 | Interactive report run P95 < 5s for up to 100k aggregated source rows; larger runs go async. |
| DAR-NFR-003 | Chart drill-down P95 < 2s. |
| DAR-NFR-004 | Scheduled jobs are idempotent and retryable; failures alert the owner. |
| DAR-NFR-005 | Concurrent viewers of a popular dashboard do not each recompute identical queries (caching with security key). |

## 10. Dependencies

| Module | Why |
|--------|-----|
| All CRM objects | Report sources |
| Customer Communication | Email and call analytics |
| Opportunities / Deals | Deal reports, pipeline charts |
| Sales Performance Management | Targets, forecasts, campaigns as metrics |
| Platform Capabilities | Homepage gadgets, notifications, sandbox copies of dashboards |
| Marketplace | API consumers appear on API usage dashboard |

## 11. Traceability

| Source capability | Requirement IDs |
|-------------------|-----------------|
| Activity Reports | DAR-FR-007 |
| API Usage Dashboard | DAR-FR-011 |
| Call Analytics | DAR-FR-010 |
| Charts and Visualizations | DAR-FR-006 |
| Customizable Dashboard | DAR-FR-003 |
| Custom Reports | DAR-FR-005 |
| Dashboard Sharing | DAR-FR-014 |
| Deal Reports | DAR-FR-008 |
| Email Reports | DAR-FR-009 |
| Pre-built Dashboards | DAR-FR-002 |
| Pre-built Reports | DAR-FR-004 |
| Report Preview | DAR-FR-012 |
| Report Sharing | DAR-FR-013 |
| User Homepage or Dashboard | DAR-FR-001 |
