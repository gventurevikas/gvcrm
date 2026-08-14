# Marketplace & App Publishing (MKT) — Spiral Plan

**Document ID:** GVCRM-PLAN-MKT  
**Requirement:** `docs/requirements/13-marketplace-and-app-publishing.md`  
**Database:** `docs/database/14-mkt-marketplace.md` (`gvcrm_mkt`)  
**Program wave:** S7 (MVP free apps); paid/external in v1 cycles  
**Packages:** `@gvcrm/mod-marketplace`, `gvcrm-mkt-api`

---

## 1. Purpose

In-product marketplace to discover/install/publish apps built on Platform, plus an **external marketplace hub** to list GVCRM or connectors on AppExchange, HubSpot, AppSource, Google, Slack, etc.

---

## 2. Priority / delivery phases (from requirements)

| Phase | Capabilities |
|-------|--------------|
| **MVP P0** | Private/public catalog, free apps, OAuth, sandbox then prod install, submit + operator review |
| **P1** | Paid/trial licensing, reviews, UI extensions, external export for Google/MS/HubSpot |
| **P2** | Usage billing, ISV payouts, auto-submit APIs |

---

## 3. Spiral cycles

| Cycle | Focus |
|-------|-------|
| **MKT-S1** | Catalog browse/search; listing metadata |
| **MKT-S2** | Package format from PLT; signed packages; install to sandbox |
| **MKT-S3** | Promote install to prod with consent; uninstall safe |
| **MKT-S4** | Publisher portal submit + operator review queue |
| **MKT-S5** | OAuth clients, scopes, webhooks, rate limits → DAR API usage |
| **MKT-S6** | Kill switch; security review checklist automation |
| **MKT-S7** | Paid/trial plans + subscriptions (P1) |
| **MKT-S8** | External listing workspace + artifact packs (P1) |
| **MKT-S9** | Usage billing / ISV payouts (P2) |

---

## 4. Cycle MKT-S1 — Catalog

### Objectives
- Listings visible by entitlement; categories; search

### Evaluation
- [ ] User browses free apps in-product

---

## 5. Cycle MKT-S2 — Sandbox install

### Objectives
- Install PLT package into sandbox; entitle modules via IAM `org_modules`
- Signed package verification

### Risks
| Risk | Mitigation |
|------|------------|
| Unsigned malware | Require signature; reject otherwise |

### Evaluation
- [ ] Install fails on bad signature; succeeds on good

---

## 6. Cycle MKT-S3 — Production install

### Objectives
- Explicit consent; uninstall without corrupting core CRM data

### Evaluation
- [ ] Uninstall removes app metadata; core accounts remain

---

## 7. Cycle MKT-S4 — Publisher portal

### Objectives
- Package, version, submit; operator review states Draft→Review→Live

### Evaluation
- [ ] Rejected listing cannot install publicly

---

## 8. Cycle MKT-S5 — App runtime APIs

### Objectives
- OAuth apps; scoped tokens; webhooks; rate limits
- Usage visible in DAR

### Evaluation
- [ ] Over-scope consent blocked; rate limit enforced

---

## 9. Cycle MKT-S6 — Safety

### Objectives
- Operator kill switch for malicious apps
- Security review gate before Live

### Evaluation
- [ ] Kill switch disables app org-wide within SLA

---

## 10. Cycles MKT-S7–S9 — Monetization & external

### Objectives
- Plans/subscriptions; reviews/ratings
- Per-store checklist export (screenshots, privacy URL, scopes)
- Later: usage billing, payouts

### Evaluation
- [ ] Trial converts; external pack ZIP/checklist complete for one store

---

## 11. Cross-cutting SDLC checklist

| Stage | MKT activity |
|-------|--------------|
| Requirements | MKT phases in §14 of req doc |
| Design | Package manifest; OAuth scope catalog |
| Build | Store UI + publisher + operator tools |
| Test | Install/uninstall; signature; kill switch |
| Deploy | Operator admin role in IAM |
| Ops | Incident runbook for compromised apps |

---

## 12. Dependencies

| Needs | Provides |
|-------|----------|
| PLT packages, IAM entitlements, DAR usage, WPA/DOC as needed | Ecosystem distribution; INS industry pack delivery |

---

## 13. Exit criteria (module MVP)

Free app catalog + signed package + sandbox→prod install + review + OAuth + kill switch.
