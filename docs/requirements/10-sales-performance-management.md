# Sales Performance Management

**Document ID:** GVCRM-REQ-SPM  
**Version:** 1.0  
**Status:** Draft for implementation  
**Source:** CRM Requirement sheet — Sales Performance Management  
**This document is independent.** Related modules are listed only as dependencies.

---

## 1. Purpose

Drive **quota attainment and predictable revenue** through goals/targets, forecasting, sales campaigns, KPI visualization, and optional gamification that keeps teams engaged.

## 2. Scope

**In scope**

- Gamification (badges, trophies, points, leaderboards)
- Goals management (user/team, time-bound)
- Sales campaigns (multi-type) with effectiveness analytics
- Sales forecasting (target vs actual vs forecast; scenarios)
- Target achievement visualization across KPIs and org levels

**Out of scope**

- Building email/SMS execution engines — Customer Communication
- Pipeline stage design — Opportunities / Deals
- Report rendering engine — Dashboards and Reports (this module defines metrics; DAR visualizes)

## 3. Users

| Persona | Typical actions |
|---------|-----------------|
| Sales representative | See my quota, forecast my deals, run/participate in campaigns, earn badges |
| Sales manager | Set team targets, inspect forecast roll-up, campaign ROI |
| RevOps / sales ops | KPI definitions, forecast categories, campaign types |
| Enablement | Gamification rules |
| Executive | Company vs team vs individual attainment |

## 4. Business objectives

- Clear quotas at company, team, and individual levels
- Credible forecast (best / likely / worst)
- Measurable campaign effectiveness
- Healthy competition without shadow spreadsheets

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

1. Campaign object: name, type (email, telephonic, referral, advertisement, webinar, social, other), dates, status, owner, budget/cost, target KPI, description.
2. Members: leads, contacts, accounts (add from lists, reports, manual, import).
3. Member statuses: sent, responded, attended, converted, etc. (type-specific).
4. Execution hooks: mass email, call lists, SMS (Communication module); not all types auto-execute (ads/social may be tracking-only).
5. Influence: related opportunities (primary campaign source + multi-touch influence P1).
6. Statistics: members, responses, conversion, pipeline created, revenue won, cost, ROI.
7. Hierarchy: parent/child campaigns (P1).

**Acceptance criteria**

- Adding 100 contacts as members is reflected in campaign counts.
- Email campaign can trigger mass email to members with consent checks.
- Report shows conversion % and revenue attributed for the date range.
- Telephonic campaign can generate a call list for members without email.

---

### 5.5 Gamification

**Source capability:** Gamification  
**Priority:** P2  
**ID:** SPM-FR-005

The solution shall allow configuring milestone-based badges, trophies, points, or leaderboards to encourage healthy competition to achieve sales targets and to increase engagement activities such as posting, sharing, commenting, and liking.

**User story**  
As enablement, I want points for closed-won and for feed engagement, with a monthly leaderboard and badges at milestones.

**Detailed requirements**

1. Configurable point rules: sales outcomes (won deal, quota hit) and collaboration events (post, share, comment, like from Team Collaboration).
2. Badges/trophies on milestones (first win, 10 activities in a week, 100% quota).
3. Leaderboards: period, team or org, metric (points, revenue, activities); privacy controls.
4. Opt-out of public leaderboards per user if policy requires.
5. Admin can pause gamification.

**Acceptance criteria**

- Closing a won deal awards the configured points and can grant a badge.
- Liking a feed post awards collaboration points if enabled.
- Leaderboard ranks update within a few minutes.
- User opt-out hides them from public boards but still tracks personal badges if enabled.

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
| Badge / Trophy / LeaderboardSnapshot | Recognition |

## 7. Integrations

| ID | Integration | Purpose |
|----|-------------|---------|
| SPM-INT-001 | Opportunities | Revenue, stage, forecast category |
| SPM-INT-002 | Activities / Communication | Activity KPIs, email/call campaigns |
| SPM-INT-003 | Team Collaboration | Gamification engagement events |
| SPM-INT-004 | Dashboards and Reports | Visualization and scheduled packs |
| SPM-INT-005 | Products / Territories | Forecast filters |

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
| SPM-NFR-002 | Goal progress lag ≤ 5 minutes after a won deal. |
| SPM-NFR-003 | Campaign stats consistent with member status counts. |
| SPM-NFR-004 | Gamification events are idempotent (no double points on retries). |

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

## 11. Traceability

| Source capability | Requirement IDs |
|-------------------|-----------------|
| Gamification | SPM-FR-005 |
| Goals Management | SPM-FR-001 |
| Sales Campaigns | SPM-FR-004 |
| Sales Forecasting | SPM-FR-003 |
| Target Achievement | SPM-FR-002 |
