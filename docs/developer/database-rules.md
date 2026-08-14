# Database development rules

**Catalog:** [docs/database/README.md](../database/README.md)  
**Conventions:** [docs/database/00-conventions.md](../database/00-conventions.md)

---

## 1. Topology (do not invent a fourth store)

| Store | Use |
|-------|-----|
| MySQL `gvcrm_iam` | Users, passwords, RBAC, custom roles, entitlements, sessions |
| MySQL `gvcrm_{app}` | Module system of record (`gvcrm_led`, `gvcrm_dar`, …) |
| ClickHouse `gvcrm_analytics` | `report_runs`, optional high-volume snapshots |

Domain fact tables (leads, deals) do **not** go in `gvcrm_iam`.  
Passwords / roles do **not** go in module DBs.

---

## 2. Hard rules

| # | Rule |
|---|------|
| D1 | Public ids are **ULID `CHAR(26)`** (or documented UUID for ClickHouse `run_id`). No auto-increment as API ids. |
| D2 | Every tenant row has **`org_id`**. Every query filters by it. |
| D3 | **No foreign keys across databases.** Store the other module’s id; call its API. |
| D4 | Soft delete via `deleted_at` unless the table is append-only / token / audit. |
| D5 | Money: `DECIMAL(18,4)` + `currency_code`. Timestamps: UTC `DATETIME(3)`. |
| D6 | Schema change ⇒ update `docs/database/{module}.md` in the **same PR**. |
| D7 | Migrations are forward-only, reviewed, and idempotent where possible. |
| D8 | Secrets in `*_encrypted` / hashes — never plaintext tokens in JSON columns meant for UI. |

---

## 3. Standard columns

Business tables include (unless junction / log):

`id`, `org_id`, `created_at`, `updated_at`, `created_by_user_id`, `updated_by_user_id`, `deleted_at`

See conventions doc for nullability and meaning.

---

## 4. Sharing and audit

| Concern | Where |
|---------|--------|
| Module entitlement | IAM `org_modules` / `user_modules` |
| Action permission | IAM roles + permissions (incl. custom roles) |
| Record visibility | Owner + `gvcrm_plt.record_shares` |
| Auth/RBAC audit | `gvcrm_iam.iam_audit_events` |
| Record CRUD audit | `gvcrm_plt.record_audit_events` |
| Report execution | ClickHouse `report_runs` |

---

## 5. ClickHouse

- Browser never queries ClickHouse.  
- `params_json` sanitized (no secrets, no raw SQL).  
- Failed/cancelled report runs still insert a row.  
- Retention ≥ 13 months for `report_runs` partitions.

---

## 6. When you add a table

1. Add to the correct `gvcrm_*` database doc with **every column explained**.  
2. Write migration.  
3. Update repositories + Facade — not controllers.  
4. Consider indexes for list screens (`org_id`, owner, status, created_at).  
5. Note PII / encryption needs in the table notes.

---

## 7. Database PR checklist

```text
## Database
- [ ] Correct gvcrm_* database
- [ ] org_id + ULID conventions
- [ ] docs/database updated (all new columns documented)
- [ ] No cross-DB FK
- [ ] Indexes for tenant list filters
- [ ] Migration included
```
