# ClickHouse analytics — `gvcrm_analytics`

**Engine:** ClickHouse  
**Writers:** reporting-api decorator, optional SPM/INS snapshot jobs, gateway telemetry  
**Must not store:** passwords, RBAC, live CRM records (leads/deals as SoR)

MySQL holds **definitions** (report SQL/config, leaderboard rules). ClickHouse holds **high-volume append facts**.

See also `docs/dev-docs/11-clickhouse-report-runs.md`.

---

## `report_runs`

Every report execution from UI, assistant, schedule, API, or Marketplace. Required for DAR API-usage dashboards and audit.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `run_id` | `UUID` | NO | | Same id returned in API `meta.runId` |
| `org_id` | `String` | NO | | IAM org ULID |
| `user_id` | `String` | NO | | Acting user (assistant runs still use the human actor) |
| `user_type` | `LowCardinality(String)` | NO | | `producer`, `isa`, … at run time |
| `app` | `LowCardinality(String)` | NO | `'dar'` | Usually `dar`; assistant-triggered still `dar` with `source=assistant` |
| `report_id` | `String` | NO | | MySQL `gvcrm_dar.reports.id` |
| `report_name` | `String` | NO | | Denormalized title for audit UI without MySQL join |
| `source` | `LowCardinality(String)` | NO | | `ui` \| `assistant` \| `schedule` \| `api` \| `marketplace` |
| `status` | `LowCardinality(String)` | NO | | `queued` \| `running` \| `succeeded` \| `failed` \| `cancelled` |
| `row_count` | `UInt64` | NO | 0 | Result rows (0 if failed/cancelled) |
| `duration_ms` | `UInt32` | NO | 0 | Execution time |
| `error_code` | `String` | NO | `''` | e.g. `DAR.REPORT_RUN_FAILED` |
| `request_id` | `String` | NO | | Gateway correlation id |
| `params_json` | `String` | NO | | Sanitized filters only — no secrets, no raw SQL, no extra PII |
| `started_at` | `DateTime64(3, 'UTC')` | NO | | |
| `finished_at` | `Nullable(DateTime64(3, 'UTC'))` | YES | | |
| `ingested_at` | `DateTime64(3, 'UTC')` | NO | `now64(3)` | Insert time |

**Engine:** `MergeTree`  
**Partition:** `toYYYYMM(started_at)`  
**ORDER BY:** `(org_id, started_at, report_id, run_id)`

Failed and cancelled runs **still insert**. Updates may be implemented as a second insert + `ReplacingMergeTree` or a finalize mutation; prefer append of a final row with same `run_id` if using `ReplacingMergeTree(ingested_at)`.

**Retention:** ≥ 13 months; drop old partitions. Legal hold = export before drop.

---

## `report_run_events` (optional)

Progress ticks for SSE/polling of long runs.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `run_id` | `UUID` | NO | | Parent run |
| `org_id` | `String` | NO | | |
| `seq` | `UInt32` | NO | | Monotonic per run |
| `phase` | `LowCardinality(String)` | NO | | `queued`, `querying`, `aggregating`, `exporting` |
| `message` | `String` | NO | `''` | Safe UI text |
| `pct` | `UInt8` | NO | 0 | 0–100 |
| `at` | `DateTime64(3, 'UTC')` | NO | | |

**ORDER BY:** `(org_id, run_id, seq)`

---

## `api_usage_hits` (optional)

If gateway volume is high, land request telemetry here instead of MySQL `api_usage_snapshots` only.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `org_id` | `String` | NO | | |
| `user_id` | `String` | NO | | |
| `app` | `LowCardinality(String)` | NO | | `led`, `dar`, … |
| `method` | `LowCardinality(String)` | NO | | `GET`, `POST`, … |
| `route_template` | `String` | NO | | `/v1/led/leads/:id` not raw URL with ids |
| `status_code` | `UInt16` | NO | | |
| `duration_ms` | `UInt32` | NO | | |
| `request_id` | `String` | NO | | |
| `at` | `DateTime64(3, 'UTC')` | NO | | |

**Partition:** `toYYYYMM(at)`  
**ORDER BY:** `(org_id, at, app)`

MySQL `gvcrm_dar.api_usage_snapshots` can store **hourly rollups** from this table.

---

## `leaderboard_snapshot_rows` (optional)

Published D/W/M ranks. MySQL `gvcrm_spm.leaderboard_snapshots` can store the snapshot **header**; rows can live here when org size is large.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `snapshot_id` | `String` | NO | | MySQL snapshot header id |
| `org_id` | `String` | NO | | |
| `period` | `LowCardinality(String)` | NO | | `daily` \| `weekly` \| `monthly` |
| `metric` | `LowCardinality(String)` | NO | | e.g. `premium_bound` |
| `scope` | `LowCardinality(String)` | NO | | `org`, `team`, `lob` |
| `rank` | `UInt32` | NO | | |
| `user_id` | `String` | NO | | |
| `display_name` | `String` | NO | | Denormalized at publish time |
| `value` | `Float64` | NO | | Metric value |
| `published_at` | `DateTime64(3, 'UTC')` | NO | | |

**ORDER BY:** `(org_id, period, published_at, metric, rank)`

Do not store deal-level PII; aggregates only (SPM-SEC-004).

---

## `insurance_kpi_facts` (optional)

Pre-aggregated INS metrics for remote producer dashboards / leaderboards.

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `org_id` | `String` | NO | | |
| `user_id` | `String` | NO | | Producer |
| `lob_code` | `LowCardinality(String)` | NO | | `auto`, `home`, … |
| `state` | `LowCardinality(String)` | NO | | `TX`, … |
| `period` | `LowCardinality(String)` | NO | | `daily` \| `weekly` \| `monthly` |
| `period_start` | `Date` | NO | | |
| `premium_bound` | `Float64` | NO | 0 | |
| `policies_bound` | `UInt32` | NO | 0 | |
| `quotes_issued` | `UInt32` | NO | 0 | |
| `leads_worked` | `UInt32` | NO | 0 | |
| `computed_at` | `DateTime64(3, 'UTC')` | NO | | |

**ORDER BY:** `(org_id, period, period_start, user_id, lob_code)`

Canonical snapshot header can still live in MySQL `gvcrm_ins.insurance_kpi_snapshots`.

---

## Write rules

1. Application never queries ClickHouse from the browser.
2. `params_json` / facts must be sanitized.
3. Singleton `ClickHouseClient` per API process.
4. Report runs: every client path (Angular, ChatGPT assistant, schedule, external API) writes `report_runs`.
