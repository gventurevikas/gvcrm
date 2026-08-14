# US Insurance Agency & Remote Sales (INS) — Spiral Plan

**Document ID:** GVCRM-PLAN-INS  
**Requirement:** `docs/requirements/15-us-insurance-agency-and-remote-sales.md`  
**Database:** `docs/database/16-ins-insurance.md` (`gvcrm_ins`)  
**Program wave:** S4 (orientation can start configuring earlier)  
**Packages:** `@gvcrm/mod-insurance`, `gvcrm-ins-api`

---

## 1. Purpose

Vertical orientation for US agencies/MGAs/carriers and remote producers: LOBs, households, book of business (CRM-level policies), renewals, remote workspace hooks, TCPA/DNC enforcement flags, and insurance KPIs for leaderboards. **Not** a policy admin / rating / DOI system of record.

---

## 2. Priority slices

| Priority | Capabilities |
|----------|--------------|
| **P0** | Org types/defaults, household model, policies/renewals, remote workspace, compliance hooks, insurance KPIs |
| **P1** | “US Insurance” industry pack packaging for MKT |
| **P2** | Deeper carrier appointment workflows |

---

## 3. Spiral cycles

| Cycle | Focus |
|-------|-------|
| **INS-S1** | Org insurance profile, LOB seed catalog, USD/state defaults |
| **INS-S2** | Producer profiles, NPN/license tracking, carrier appointments |
| **INS-S3** | Household members on ACM household accounts |
| **INS-S4** | Policies + renewal opportunity creation via ODM |
| **INS-S5** | Remote workspace: mobile queue hooks, push, OOO routing flags |
| **INS-S6** | `tcpa_strict` + consent enforcement with CCM/LED |
| **INS-S7** | Insurance KPI snapshots for SPM boards (+ optional CH facts) |
| **INS-S8** | Industry pack for Marketplace (P1) |

---

## 4. Cycle INS-S1 — Orientation

### Objectives
- `operating_mode` aligned with IAM `org_kind`
- Seed LOBs (auto, home, life, health, commercial, …)
- Default currency USD; state/ZIP emphasis in UX

### Evaluation
- [ ] New agency org gets LOB defaults and insurance pipelines entitled

---

## 5. Cycle INS-S2 — Producers & appointments

### Objectives
- Producer profile; license/NPN records (DOC for attachments)
- Carrier appointments

### Risks
| Risk | Mitigation |
|------|------------|
| Treating CRM as DOI SoR | Label fields “CRM tracking only” |

### Evaluation
- [ ] License expiry visible; reminder via PLT (v1 polish)

---

## 6. Cycle INS-S3 — Households

### Objectives
- ACM `accounts.type=household`; INS `household_members`
- Cross-sell prompts data model

### Evaluation
- [ ] Household 360 shows members + related policies

---

## 7. Cycle INS-S4 — Book of business

### Objectives
- Policies linked to household, ODM opp, optional QOC quote
- Renewal opportunity generation job

### Evaluation
- [ ] Policy nearing term creates renewal opp on renewal pipeline

---

## 8. Cycle INS-S5 — Remote workspace

### Objectives
- Producer mobile queue preferences; push notification hooks
- OOO-aware routing flags consumed by LED assignment

### Evaluation
- [ ] OOO producer skipped in round-robin

---

## 9. Cycle INS-S6 — Compliance hooks

### Objectives
- Org `tcpa_strict`; block CCM outbound without consent
- Do not duplicate consent tables (CCM SoR)

### Evaluation
- [ ] Call/SMS blocked when consent missing under strict mode

---

## 10. Cycle INS-S7 — KPIs

### Objectives
- Premium bound, quotes, speed-to-lead insurance metrics
- Feed SPM D/W/M boards; snapshot freshness ≤5 min
- Homepage usable on mobile &lt;2s

### Evaluation
- [ ] Insurance metrics appear on monthly leaderboard

---

## 11. Cycle INS-S8 — Industry pack

### Objectives
- Package LOB pipelines, layouts, dashboards, workflows for MKT

### Evaluation
- [ ] Pack installs into sandbox via MKT

---

## 12. Cross-cutting SDLC checklist

| Stage | INS activity |
|-------|--------------|
| Requirements | INS-FR P0; note LED owns Meta/LinkedIn; SPM owns boards |
| Design | Household/policy ER; compliance sequence |
| Build | INS API + Angular insurance UX |
| Test | TCPA matrix; renewal job; KPI freshness |
| Deploy | Entitle insurance pack per org |
| Ops | NPN reminder jobs (v1) |

---

## 13. Dependencies

| Needs | Provides |
|-------|----------|
| ACM, LED, ODM, QOC, CCM, SPM, PLT, DAR, AIA, MKT, WPA | Differentiating US remote insurance story for MVP |

---

## 14. Exit criteria (module MVP)

Agency orientation + households + policies/renewals + remote/OOO hooks + TCPA strict mode + insurance KPIs on boards; pack packaging can trail to P1.
