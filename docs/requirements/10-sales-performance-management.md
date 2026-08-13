# Sales Performance Management

**Document ID:** GVCRM-REQ-SPM  
**Version:** 1.0  
**Status:** Draft for implementation  
**Module:** Sales Performance Management  
**This document is independent.** Related modules are listed only as dependencies.

---

## 1. Purpose

Drive **quota attainment and predictable revenue** through goals/targets, forecasting, sales campaigns (including **Meta and LinkedIn**), KPI visualization, and **complete gamification** — especially **published daily, weekly, and monthly leaderboards** for remote US insurance sales teams.

## 2. Scope

**In scope**

- Complete gamification: points, badges, trophies, streaks, and **daily / weekly / monthly leaderboards**
- Goals management (user/team, time-bound)
- Sales campaigns (multi-type) including Meta and LinkedIn ads, with effectiveness analytics
- Sales forecasting (target vs actual vs forecast; scenarios)
- Target achievement visualization across KPIs and org levels

**Out of scope**

- Building email/SMS execution engines — Customer Communication
- Pipeline stage design — Opportunities / Deals
- Report rendering engine — Dashboards and Reports (this module defines metrics; DAR visualizes)
- Real-time Meta/LinkedIn lead ingest mechanics — Leads Management (this module owns campaign objects and ROI)

## 3. Users

| Persona | Typical actions |
|---------|-----------------|
| Remote producer / sales representative | See my quota, today’s rank, forecast, campaigns, badges |
| Sales manager / agency principal | Team targets, D/W/M leaderboards, campaign ROI (Meta/LinkedIn) |
| RevOps / sales ops | KPI definitions, forecast categories, campaign types, leaderboard publish |
| Enablement | Gamification rules, badges, seasons |
| Executive | Company vs team vs individual attainment |

## 4. Business objectives

- Clear quotas at company, team, and individual levels
- Credible forecast (best / likely / worst)
- Measurable campaign effectiveness
- Healthy competition for **remote agents** via published D/W/M leaderboards (no office whiteboard required)
- Clear ROI on Meta and LinkedIn lead campaigns

---

## 5. Functional requirements

### 5.1 Goals management

**Source capability:** Goals Management  
**Priority:** P0  
**ID:** SPM-FR-001

The solution shall allow defining objectives and setting sales targets for a specific user or team with a particular time period, and tracking progress against goals.

**User story**  
As a sales manager, I want Q3 revenue and activity goals for each AE and for the West team.

**Detailed requirements**

1. Goal object: name, KPI (revenue, closed-won count, new logos, activities, custom), target value, unit, period (month/quarter/year/custom), owner (user or team), hierarchy roll-up flag.
2. Progress auto-calculated from CRM data (opportunities, activities, campaigns as applicable).
3. Status: on track / at risk / behind / achieved (threshold configurable).
4. Users see their goals on homepage widgets.
5. Manager can cascade: company → team → user with remaining allocation check.

**Acceptance criteria**

- A user revenue goal for a quarter updates as they close-won deals in that quarter.
- Team goal equals or independently tracks sum of members (configurable: roll-up vs independent).
- Period boundaries respect org timezone.
- Editing a target is audited.

---

### 5.2 Target achievement

**Source capability:** Target Achievement  
**Priority:** P0  
**ID:** SPM-FR-002

The solution shall set targets based on various KPIs and visualize how far the company is from objectives. Targets can be company-wide, team, or individual sales representative.

**User story**  
As a CRO, I want one screen showing company, team, and AE attainment against quota.

**Detailed requirements**

1. KPI catalog: revenue, bookings, pipeline coverage, win rate, activity KPIs, campaign-sourced revenue, custom KPI from reports.
2. Visualization: % to target, remaining, trend, pace vs expected (time elapsed).
3. Levels: organization, team, individual; drill-down from company to AE.
4. Multiple KPIs per person/team in the same period.
5. Export and dashboard embed.

**Acceptance criteria**

- Company attainment drill-down shows contributing teams and users.
- Visualization updates when a deal is marked won (near real time or ≤ 5 minutes).
- User without manager permission sees only their own targets, not peers’ (unless leaderboard explicitly shared).
- KPI definition is visible (tooltip/help) so numbers are trusted.

---

### 5.3 Sales forecasting

**Source capability:** Sales Forecasting  
**Priority:** P0  
**ID:** SPM-FR-003

The solution shall offer a real-time comparative view of assigned sales targets, achieved revenue, and revenue forecast. It shall provide insights through drill-down and filtering by sales representative, team, product, territory, or organization. Future revenue forecast shall be offered in **best-case, likely, and worst-case** scenarios based on pipeline stages.

**User story**  
As a sales manager, I want likely/best/worst forecast vs quota for my region, filterable by product.

**Detailed requirements**

1. Forecast grid/time buckets (month/quarter): Quota (target), Achieved (closed-won), Forecast scenarios.
2. Scenario logic based on opportunity stages / forecast categories:
   - **Worst-case:** commit / late stages only (configurable mapping)
   - **Likely:** commit + most-likely / default probability-weighted or category-based (configurable)
   - **Best-case:** includes upside / early qualified pipeline (configurable)
3. Filters: sales representative, team, product, territory, organization, pipeline.
4. Drill-down to opportunity list contributing to a cell.
5. Manager judgment overlay (adjustments) with reason, optional (P1).
6. Real-time or near-real-time as opportunity amount/stage/close date changes.

**Acceptance criteria**

- Changing a deal stage from Upside to Commit moves its amount between scenario buckets per mapping.
- Sum of drill-down opportunities equals the forecast cell (within rounding).
- Filter by product includes only line-item/product-matched revenue (documented attribution).
- Target, achieved, and three scenarios appear on one comparative view.

---

### 5.4 Sales campaigns

**Source capability:** Sales Campaigns  
**Priority:** P1  
**ID:** SPM-FR-004

The solution shall enable creating targeted sales campaigns of various types — email, telephonic, referrals, advertisement, webinars, social media, etc. — and analyzing effectiveness using reports and campaign statistics.

**User story**  
As a sales manager, I want a webinar campaign with members, activities, and ROI vs cost.

**Detailed requirements**

1. Campaign object: name, type (email, telephonic, referral, advertisement, webinar, social, **Meta ads**, **LinkedIn ads**, other), dates, status, owner, budget/cost, target KPI, description.
2. Members: leads, contacts, accounts (add from lists, reports, manual, import, or auto from Meta/LinkedIn ingest).
3. Member statuses: sent, responded, attended, converted, etc. (type-specific).
4. Execution hooks: mass email, call lists, SMS (Communication module); Meta/LinkedIn campaigns receive members in real time from Leads ingest.
5. Influence: related opportunities (primary campaign source + multi-touch influence P1).
6. Statistics: members, responses, conversion, pipeline created, revenue/premium won, cost, ROI — breakable by Meta vs LinkedIn vs other.
7. Hierarchy: parent/child campaigns (P1).
8. Map external Meta Ad / LinkedIn Campaign ids to the CRM campaign for attribution.

**Acceptance criteria**

- Adding 100 contacts as members is reflected in campaign counts.
- Email campaign can trigger mass email to members with consent checks.
- Report shows conversion % and revenue attributed for the date range.
- Telephonic campaign can generate a call list for members without email.
- A Meta or LinkedIn campaign shows members created from real-time ad leads and conversion/ROI.

---

### 5.5 Complete gamification

**Source capability:** Gamification  
**Priority:** P0  
**ID:** SPM-FR-005

The solution shall provide **complete gamification** of sales work: configurable points, milestone badges, trophies, streaks, challenges, and leaderboards so remote insurance producers stay engaged without an office floor.

**User story**  
As an agency principal, I want producers competing on quotes, binds, and speed-to-lead with badges and points, not only a static quota number.

**Detailed requirements**

1. Point rules: sales outcomes (quote issued, premium/policy bound, renewal retained, cross-sell, quota hit) and activity (calls, appointments, first-touch on Meta/LinkedIn leads). Optional collaboration points (post, share, comment, like).
2. Badges/trophies on milestones (first bind, 10 quotes in a week, 100% quota, fastest speed-to-lead of the day).
3. Streaks: consecutive days with a qualifying activity (remote-agent daily habit).
4. Challenges / seasons: time-boxed contests (e.g. “Auto bind week”) with prize notes.
5. Personal scorecard on homepage: points, rank, badges, streak, distance to next badge.
6. Notifications when rank changes, badge earned, or a teammate takes 1st (configurable, non-spammy).
7. Admin can pause gamification; user opt-out of public boards if policy requires (still see personal score).
8. Insurance KPIs from INS-FR-006 are first-class scoring metrics.

**Acceptance criteria**

- Binding a policy awards configured points and can grant a badge.
- First touch on a Meta lead within SLA can award speed-to-lead points.
- Personal scorecard is visible to a remote agent on mobile homepage.
- Pause stops new points without deleting history.

---

### 5.6 Daily, weekly, and monthly leaderboards

**Priority:** P0  
**ID:** SPM-FR-006

The solution shall **publish daily, weekly, and monthly leaderboards** so distributed teams can see who is winning on the metrics that matter.

**User story**  
As a remote producer, I want to open GVCRM in the morning and see yesterday’s close, this week’s standings, and month-to-date premium rank for my agency.

**Detailed requirements**

1. Three standing boards always available: **Daily**, **Weekly**, **Monthly** (org timezone; US agency default).
2. Each board supports one or more metrics: points, premium bound, policies bound, quotes, new leads, Meta leads worked, LinkedIn leads worked, calls, appointments, speed-to-lead, renewals retained (admin-selected defaults per org).
3. Scopes: whole org/agency, team/branch, LOB, and “me vs team” highlight.
4. **Publish**: boards are visible on homepage, a dedicated Leaderboards page, optional feed announcement, and optional scheduled email/Slack-style digest (start of next day / Monday / month).
5. Real-time or near-real-time rank for the **Daily** board (≤ 5 minutes); Weekly/Monthly can use the same snapshots.
6. Drill-down from a rank row to the underlying records the viewer is allowed to see (aggregates only if FLS/sharing blocks deal detail).
7. Historical archive: past days/weeks/months remain viewable (who won last week).
8. Ties: documented tie-break (e.g. earlier timestamp, then alphabetical).
9. Fairness: OOO days can be excluded from daily boards (configurable).
10. Assistant can answer “Where am I on this week’s leaderboard?” (AIA).

**Acceptance criteria**

- Switching Daily / Weekly / Monthly updates ranks and metrics without a full page reload.
- A bind today moves the producer on the Daily board within 5 minutes.
- Weekly board resets on the configured week start (e.g. Monday 00:00 org TZ).
- Monthly board matches month-to-date premium/policy totals in reports.
- Published digest email (if enabled) contains top N + recipient’s own rank.
- Peer cannot open another producer’s household PII from the leaderboard row unless they already have record access.

---

## 6. Data entities

| Entity | Purpose |
|--------|---------|
| KpiDefinition | Reusable performance metric |
| Goal / GoalProgress | Targets and attainment |
| ForecastScenario / ForecastCell | Best / likely / worst buckets |
| ForecastAdjustment | Manager overlay |
| Campaign / CampaignMember | Sales campaign execution |
| CampaignInfluence | Deal attribution |
| GamificationRule / PointEvent | Points engine |
| Badge / Trophy / Streak / Challenge | Recognition and seasons |
| LeaderboardDefinition / LeaderboardSnapshot | Daily / weekly / monthly published ranks |

## 7. Integrations

| ID | Integration | Purpose |
|----|-------------|---------|
| SPM-INT-001 | Opportunities | Revenue, stage, forecast category |
| SPM-INT-002 | Activities / Communication | Activity KPIs, email/call campaigns |
| SPM-INT-003 | Team Collaboration | Gamification engagement events |
| SPM-INT-004 | Dashboards and Reports | Visualization and scheduled packs |
| SPM-INT-005 | Products / Territories | Forecast filters |
| SPM-INT-006 | Meta / LinkedIn via Leads | Campaign members and ad ROI |
| SPM-INT-007 | Insurance KPIs (INS) | Premium, policies, LOB leaderboard metrics |

## 8. Permissions and security

| ID | Requirement |
|----|-------------|
| SPM-SEC-001 | Users see own goals by default; managers see team; executives see org. |
| SPM-SEC-002 | Forecast adjustments are permissioned and audited. |
| SPM-SEC-003 | Campaign member lists follow lead/contact sharing. |
| SPM-SEC-004 | Leaderboards must not expose deals a peer cannot otherwise see (show aggregates only). |
| SPM-SEC-005 | Quota numbers may be confidential; FLS applies. |

## 9. Non-functional requirements

| ID | Requirement |
|----|-------------|
| SPM-NFR-001 | Forecast view P95 < 3s for a team of 50 reps and 20k open opportunities (pre-aggregation allowed). |
| SPM-NFR-002 | Goal progress lag ≤ 5 minutes after a won deal or bind. |
| SPM-NFR-003 | Campaign stats consistent with member status counts. |
| SPM-NFR-004 | Gamification events are idempotent (no double points on retries). |
| SPM-NFR-005 | Daily leaderboard rank update P95 ≤ 5 minutes after a scoring event. |

## 10. Dependencies

| Module | Why |
|--------|-----|
| Opportunities / Deals | Amount, stage, probability, forecast category |
| Accounts and Contacts | Campaign members, territory |
| Leads | Campaign members, conversion |
| Customer Communication | Email/call/SMS campaign execution |
| Team Collaboration | Feed engagement gamification |
| Dashboards and Reports | Attainment and campaign dashboards |
| Platform | Homepage widgets, notifications, custom KPIs |
| Products | Product-filtered forecast |
| US Insurance Agency and Remote Sales | LOB/premium KPIs, remote producer motivation |
| AI Assistant and Central Chat | “My rank today / this week / this month” |

## 11. Traceability

| Source capability | Requirement IDs |
|-------------------|-----------------|
| Gamification (complete) | SPM-FR-005 |
| Daily / weekly / monthly leaderboards | SPM-FR-006 |
| Goals Management | SPM-FR-001 |
| Sales Campaigns | SPM-FR-004 |
| Sales Forecasting | SPM-FR-003 |
| Target Achievement | SPM-FR-002 |
