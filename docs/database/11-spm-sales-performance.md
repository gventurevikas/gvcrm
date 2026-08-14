# Sales Performance — `gvcrm_spm`

**Module:** SPM  
**Cross-refs:** ODM amounts/stages; INS premium KPIs; LED/Meta campaigns; DAR widgets; ClickHouse optional snapshot rows ([17](./17-clickhouse-analytics.md)).

Gamification events must be **idempotent** (SPM-NFR-004).

---

## `kpi_definitions`

Org/system KPIs used by goals and leaderboards. May reference DAR `kpi_definitions.code` or live only here.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | YES | NULL | NULL = system |
| `code` | `VARCHAR(64)` | NO | | `premium_bound`, `quotes_issued`, `activities` |
| `name` | `VARCHAR(128)` | NO | | |
| `source` | `VARCHAR(32)` | NO | | `odm`, `ins`, `led`, `ccm`, `formula` |
| `formula_json` | `JSON` | YES | NULL | |
| `unit` | `VARCHAR(32)` | YES | NULL | |
| `is_system` | `TINYINT(1)` | NO | 0 | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |

**UNIQUE:** `(org_id, code)`

---

## `goals`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `name` | `VARCHAR(128)` | NO | | |
| `kpi_code` | `VARCHAR(64)` | NO | | |
| `owner_user_id` | `CHAR(26)` | YES | NULL | Rep goal; NULL = team/org |
| `team_group_id` | `CHAR(26)` | YES | NULL | TCL group |
| `period` | `ENUM('daily','weekly','monthly','quarterly','yearly')` | NO | `monthly` | |
| `period_start` | `DATE` | NO | | |
| `period_end` | `DATE` | NO | | |
| `target_value` | `DECIMAL(18,4)` | NO | | |
| `currency_code` | `CHAR(3)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**Indexes:** `INDEX idx_spm_goals_owner (org_id, owner_user_id, period_start)`

---

## `goal_progress`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `goal_id` | `CHAR(26)` | NO | | |
| `as_of` | `DATETIME(3)` | NO | | |
| `actual_value` | `DECIMAL(18,4)` | NO | | |
| `attainment_pct` | `DECIMAL(8,2)` | YES | NULL | |

**FK:** `goal_id` → `goals` CASCADE  
**Indexes:** `INDEX idx_spm_gp (goal_id, as_of)`

Lag ≤ 5 minutes after won/bind (SPM-NFR-002) via job.

---

## `forecast_scenarios`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `name` | `VARCHAR(128)` | NO | | |
| `period_start` | `DATE` | NO | | |
| `period_end` | `DATE` | NO | | |
| `status` | `ENUM('open','locked')` | NO | `open` | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |

---

## `forecast_cells`

Best / likely / worst buckets per owner.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `scenario_id` | `CHAR(26)` | NO | | |
| `owner_user_id` | `CHAR(26)` | NO | | |
| `category` | `ENUM('best','likely','worst')` | NO | | |
| `amount` | `DECIMAL(18,4)` | NO | 0 | Rollup from ODM + adjustments |
| `updated_at` | `DATETIME(3)` | NO | | |

**FK:** `scenario_id` → `forecast_scenarios` CASCADE  
**UNIQUE:** `(scenario_id, owner_user_id, category)`

---

## `forecast_adjustments`

Manager overlay (permissioned + audited).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `scenario_id` | `CHAR(26)` | NO | | |
| `owner_user_id` | `CHAR(26)` | NO | | Target rep |
| `category` | `ENUM('best','likely','worst')` | NO | | |
| `delta_amount` | `DECIMAL(18,4)` | NO | | |
| `reason` | `VARCHAR(512)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | NO | | Manager |

**FK:** `scenario_id` → `forecast_scenarios` CASCADE

---

## `campaigns`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `name` | `VARCHAR(255)` | NO | | |
| `status` | `ENUM('draft','active','completed','cancelled')` | NO | `draft` | |
| `channel` | `VARCHAR(32)` | YES | NULL | `email`, `meta`, `linkedin`, `mixed` |
| `start_on` | `DATE` | YES | NULL | |
| `end_on` | `DATE` | YES | NULL | |
| `budget` | `DECIMAL(18,4)` | YES | NULL | |
| `currency_code` | `CHAR(3)` | NO | `USD` | |
| `owner_user_id` | `CHAR(26)` | YES | NULL | |
| `external_meta_campaign_id` | `VARCHAR(128)` | YES | NULL | Ad ROI |
| `external_linkedin_campaign_id` | `VARCHAR(128)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

---

## `campaign_members`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `campaign_id` | `CHAR(26)` | NO | | |
| `member_type` | `ENUM('lead','contact')` | NO | | |
| `member_id` | `CHAR(26)` | NO | | LED or ACM id |
| `status` | `VARCHAR(32)` | NO | `sent` | |
| `created_at` | `DATETIME(3)` | NO | | |

**FK:** `campaign_id` → `campaigns` CASCADE  
**UNIQUE:** `(campaign_id, member_type, member_id)`  
Member lists follow lead/contact sharing (SPM-SEC-003).

---

## `campaign_influences`

Deal attribution.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `campaign_id` | `CHAR(26)` | NO | | |
| `opportunity_id` | `CHAR(26)` | NO | | ODM |
| `influence_pct` | `DECIMAL(5,2)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |

**UNIQUE:** `(campaign_id, opportunity_id)`

---

## `gamification_rules`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `name` | `VARCHAR(128)` | NO | | |
| `event_type` | `VARCHAR(64)` | NO | | `lead_converted`, `policy_bound`, `call_logged`, `feed_post` |
| `points` | `INT` | NO | | |
| `is_active` | `TINYINT(1)` | NO | 1 | |
| `config_json` | `JSON` | YES | NULL | Caps, multipliers |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |

---

## `point_events`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `user_id` | `CHAR(26)` | NO | | |
| `rule_id` | `CHAR(26)` | YES | NULL | |
| `event_type` | `VARCHAR(64)` | NO | | |
| `points` | `INT` | NO | | |
| `idempotency_key` | `VARCHAR(191)` | NO | | `{event_type}:{source_id}` — no double points |
| `source_type` | `VARCHAR(32)` | YES | NULL | |
| `source_id` | `CHAR(26)` | YES | NULL | |
| `occurred_at` | `DATETIME(3)` | NO | | |
| `created_at` | `DATETIME(3)` | NO | | |

**UNIQUE:** `(org_id, idempotency_key)`  
**Indexes:** `INDEX idx_spm_pts_user_time (org_id, user_id, occurred_at)`  
**FK:** `rule_id` → `gamification_rules` SET NULL

---

## `badges` / `user_badges` / `trophies` / `streaks` / `challenges`

### `badges`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | YES | NULL | NULL = system badge |
| `code` | `VARCHAR(64)` | NO | | |
| `name` | `VARCHAR(128)` | NO | | |
| `description` | `VARCHAR(512)` | YES | NULL | |
| `criteria_json` | `JSON` | YES | NULL | |
| `icon_key` | `VARCHAR(64)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |

### `user_badges`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `org_id` | `CHAR(26)` | NO | | |
| `user_id` | `CHAR(26)` | NO | | |
| `badge_id` | `CHAR(26)` | NO | | |
| `earned_at` | `DATETIME(3)` | NO | | |

**PK:** `(org_id, user_id, badge_id)`

### `trophies`

Season / contest awards (same idea as badges with `season_code`, `rank`).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `season_code` | `VARCHAR(32)` | NO | | e.g. `2026-Q3` |
| `user_id` | `CHAR(26)` | NO | | |
| `title` | `VARCHAR(128)` | NO | | |
| `rank` | `INT` | YES | NULL | |
| `awarded_at` | `DATETIME(3)` | NO | | |

### `streaks`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `user_id` | `CHAR(26)` | NO | | |
| `streak_type` | `VARCHAR(32)` | NO | | `daily_activity`, `weekly_bind` |
| `current_count` | `INT` | NO | 0 | |
| `best_count` | `INT` | NO | 0 | |
| `last_event_on` | `DATE` | YES | NULL | |
| `updated_at` | `DATETIME(3)` | NO | | |

**UNIQUE:** `(org_id, user_id, streak_type)`

### `challenges` / `challenge_participants`

| `challenges` column | Type | Description |
|---------------------|------|-------------|
| `id` | `CHAR(26)` | PK |
| `org_id` | `CHAR(26)` | |
| `name` | `VARCHAR(128)` | |
| `kpi_code` | `VARCHAR(64)` | |
| `starts_on` / `ends_on` | `DATE` | |
| `target_value` | `DECIMAL(18,4)` | |
| `status` | `ENUM('draft','live','closed')` | |

| `challenge_participants` | Type | Description |
|--------------------------|------|-------------|
| `challenge_id` | `CHAR(26)` | FK CASCADE |
| `user_id` | `CHAR(26)` | |
| `org_id` | `CHAR(26)` | |
| `joined_at` | `DATETIME(3)` | |

**PK:** `(challenge_id, user_id)`

---

## `leaderboard_definitions`

Daily / weekly / monthly published ranks (SPM-FR-006).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `name` | `VARCHAR(128)` | NO | | |
| `period` | `ENUM('daily','weekly','monthly')` | NO | | |
| `kpi_code` | `VARCHAR(64)` | NO | | |
| `scope` | `ENUM('org','team','lob','state')` | NO | `org` | |
| `is_active` | `TINYINT(1)` | NO | 1 | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |

---

## `leaderboard_snapshots`

Header for a published board. Rows: `leaderboard_snapshot_entries` and/or ClickHouse.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `definition_id` | `CHAR(26)` | NO | | |
| `period` | `ENUM('daily','weekly','monthly')` | NO | | |
| `period_start` | `DATE` | NO | | |
| `period_end` | `DATE` | NO | | |
| `published_at` | `DATETIME(3)` | NO | | |
| `row_count` | `INT` | NO | 0 | |
| `created_at` | `DATETIME(3)` | NO | | |

**FK:** `definition_id` → `leaderboard_definitions` CASCADE  
**UNIQUE:** `(definition_id, period_start)`

---

## `leaderboard_snapshot_entries`

Aggregates only — no deal PII (SPM-SEC-004).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `snapshot_id` | `CHAR(26)` | NO | | |
| `rank` | `INT` | NO | | |
| `user_id` | `CHAR(26)` | NO | | |
| `display_name` | `VARCHAR(255)` | NO | | Snapshot at publish |
| `value` | `DECIMAL(18,4)` | NO | | |

**FK:** `snapshot_id` → `leaderboard_snapshots` CASCADE  
**UNIQUE:** `(snapshot_id, rank)`, `UNIQUE (snapshot_id, user_id)`
