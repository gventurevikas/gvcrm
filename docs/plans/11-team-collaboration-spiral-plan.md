# Team Collaboration (TCL) — Spiral Plan

**Document ID:** GVCRM-PLAN-TCL  
**Requirement:** `docs/requirements/11-team-collaboration.md`  
**Database:** `docs/database/12-tcl-collaboration.md` (`gvcrm_tcl`)  
**Program wave:** S6 (user_groups earlier if sharing needs them — S1/S2)  
**Packages:** `@gvcrm/mod-collab`, `gvcrm-tcl-api`

---

## 1. Purpose

In-CRM teamwork: feeds, mentions, tags, user groups, geo check-in, and private chat — always respecting record sharing (never a bypass). Distinct from AIA assistant chat.

---

## 2. Priority slices

| Priority | Capabilities |
|----------|--------------|
| **P0** | Feeds, mentions, tags, user groups |
| **P1** | Geo check-in, private 1:1/group chat |
| **P2** | Advanced chat bots / export polish |

---

## 3. Spiral cycles

| Cycle | Focus |
|-------|-------|
| **TCL-S1** | User groups + memberships (share grantee primitive) |
| **TCL-S2** | Record/team/org feeds + likes + attachments via DOC |
| **TCL-S3** | @mentions + safe notification snippets |
| **TCL-S4** | Tags (manual + auto rules) |
| **TCL-S5** | Private chat + permission-aware record cards (P1) |
| **TCL-S6** | Field geo check-in + retention (P1) |

---

## 4. Cycle TCL-S1 — Groups

### Objectives
- `user_groups` / memberships APIs
- Consumed by PLT shares, DAR shares, ACM scheduling, SPM goals

### Evaluation
- [ ] Group usable as share target on an account

---

## 5. Cycle TCL-S2 — Feeds

### Objectives
- Posts on org/team/record; visibility = record ACL ∩ membership
- Attachments via DOC links

### Risks
| Risk | Mitigation |
|------|------------|
| Feed leaks private records | Visibility check on every post read |

### Evaluation
- [ ] User without record access cannot see record feed post

---

## 6. Cycle TCL-S3 — Mentions

### Objectives
- @user / @group; notifications without restricted field leakage

### Evaluation
- [ ] Mention email/snippet redacts FLS-blocked fields

---

## 7. Cycle TCL-S4 — Tags

### Objectives
- Manual tags; auto-tag rules; filter in lists via Facades

### Evaluation
- [ ] Tag filter on leads list works

---

## 8. Cycle TCL-S5 — Private chat

### Objectives
- 1:1 and group chat; record cards only if viewer has access
- Admin-only export

### Evaluation
- [ ] Record card hidden when ACL denies

---

## 9. Cycle TCL-S6 — Check-in

### Objectives
- Geo check-in; sensitive location retention policy

### Evaluation
- [ ] Check-in stored; retention job deletes per policy

---

## 10. Cross-cutting SDLC checklist

| Stage | TCL activity |
|-------|--------------|
| Requirements | TCL-FR / SEC visibility |
| Design | Feed visibility algorithm |
| Build | Realtime (WS/SSE) optional after poll MVP |
| Test | ACL matrix on feed/chat/cards |
| Deploy | Entitle `tcl` |
| Ops | Chat retention / export audit |

---

## 11. Dependencies

| Needs | Provides |
|-------|----------|
| IAM; PLT shares; DOC; ACM/LED/ODM | Groups for platform-wide sharing; INS remote presence |

---

## 12. Exit criteria (module MVP)

Groups + feeds + mentions + tags ship with strict ACL; chat/check-in as P1 follow-on.
