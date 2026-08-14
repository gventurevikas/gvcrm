# AI Assistant & Central Chat (AIA) — Spiral Plan

**Document ID:** GVCRM-PLAN-AIA  
**Requirement:** `docs/requirements/14-ai-assistant-and-central-chat.md`  
**Database:** `docs/database/15-aia-assistant.md` (`gvcrm_aia`)  
**Program wave:** S6 MVP; send/actions deepen in v1  
**Packages:** `@gvcrm/mod-assistant`, `gvcrm-aia-api`

---

## 1. Purpose

Always-available **ChatGPT-mini** central chat: help users, execute **permitted** business operations across modules, and build **custom reports** via DAR — always as the signed-in user (no privilege escalation).

---

## 2. Priority / phases

| Phase | Capabilities |
|-------|--------------|
| **MVP P0** | Global + record-aware shell, help + single-record ops, conversational reports, audit, kill switch |
| **P1** | Suggested prompts, trusted quick-actions, email/SMS from chat, usage dashboard |
| **P2** | Multi-step agents, marketplace skills, voice |

---

## 3. Spiral cycles

| Cycle | Focus |
|-------|-------|
| **AIA-S1** | Chat shell UI (every screen); threads/messages store |
| **AIA-S2** | Help / RAG over product docs; next-best-action suggestions (read-only) |
| **AIA-S3** | Tool registry + preview/confirm for single-record CRUD |
| **AIA-S4** | Conversational reports → DAR spec draft → run/save |
| **AIA-S5** | Governance: org settings, audit, kill switch, PII minimization |
| **AIA-S6** | Email/SMS tools via CCM + confirm (P1) |
| **AIA-S7** | Usage dashboard; prompt library (P1) |
| **AIA-S8** | Multi-step agents / marketplace skills (P2) |

---

## 4. Cycle AIA-S1 — Shell

### Objectives
- Central chat entry from layout chrome
- Record context chips when on detail pages
- First token &lt;2s NFR path (streaming)

### Evaluation
- [ ] Chat opens from any entitled module screen

---

## 5. Cycle AIA-S2 — Help (read-only)

### Objectives
- Answer “how do I…” using curated docs
- No writes yet

### Risks
| Risk | Mitigation |
|------|------------|
| Hallucinated product behavior | Ground in docs; cite module |

### Evaluation
- [ ] Help answers cite known capabilities only

---

## 6. Cycle AIA-S3 — Tools with confirm

### Objectives
- Tools mapped to Facades (create lead, update deal, log call, …)
- Always preview → explicit confirm for writes
- RBAC/FLS identical to UI

### Risks
| Risk | Mitigation |
|------|------------|
| Prompt injection → exfil/escalation | Tool allowlist; ignore instructions in untrusted text; confirm |
| Acting as admin | Bind tools to user JWT only |

### Evaluation
- [ ] User without create-lead perm cannot create via chat
- [ ] Risky action requires confirm + audit row

---

## 7. Cycle AIA-S4 — Conversational reports

### Objectives
- Collect required details (object, metrics, filters, range, grouping, chart)
- Promote draft to DAR; `report_runs` source=`assistant`

### Evaluation
- [ ] Incomplete ask returns structured missing-fields questions
- [ ] Completed flow saves real report

---

## 8. Cycle AIA-S5 — Governance

### Objectives
- Org enable/disable; kill switch; assistant audit trail
- Sandbox assistant must not mutate prod
- Minimize PII sent to model

### Evaluation
- [ ] Kill switch stops new tool calls within SLA

---

## 9. Cycles AIA-S6–S8 — Expand

### Objectives
- CCM send tools; usage metering UI; multi-step agents later

### Evaluation
- [ ] Email send from chat respects TCPA via CCM
- [ ] Usage visible to admin

---

## 10. Cross-cutting SDLC checklist

| Stage | AIA activity |
|-------|--------------|
| Requirements | AIA-FR MVP set |
| Design | Tool schema; confirm UX; threat model |
| Build | Orchestrator + Angular shell |
| Test | AuthZ fuzz; injection cases; report contract |
| Deploy | Model keys only in AIA service |
| Ops | Kill switch runbook; cost alerts |

---

## 11. Dependencies

| Needs | Provides |
|-------|----------|
| All module Facades especially DAR, CCM, LED/ACM/ODM, SPM, INS | Remote producer “ask & act” surface |

---

## 12. Exit criteria (module MVP)

Shell + help + confirmed single-record tools under RBAC + conversational reports via DAR + audit + kill switch.
