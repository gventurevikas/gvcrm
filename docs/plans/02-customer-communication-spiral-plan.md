# Customer Communication (CCM) — Spiral Plan

**Document ID:** GVCRM-PLAN-CCM  
**Requirement:** `docs/requirements/02-customer-communication-management.md`  
**Database:** `docs/database/03-ccm-communications.md` (`gvcrm_ccm`)  
**Program wave:** S3 (P0); SMS/analytics in later cycles  
**Packages:** `@gvcrm/mod-comms`, `gvcrm-ccm-api`

---

## 1. Purpose

Provide call, email, and SMS from CRM with templates, tracking, and automatic association — with **consent/TCPA/DNC as system of record**.

---

## 2. Priority slices

| Priority | Capabilities |
|----------|--------------|
| **P0** | Call reminders/scheduling, canned responses, direct email, thread association, Gmail/Outlook client path, templates |
| **P1** | Tagging, email schedule/status, mass email, SMS send/receive/templates/timezone |
| **P2** | SMS analytics |

---

## 3. Spiral cycles

| Cycle | Focus |
|-------|-------|
| **CCM-S1** | `communication_consents` + DNC enforcement API |
| **CCM-S2** | Email mailbox, templates, send, associate to ACM/LED/ODM |
| **CCM-S3** | Calls: reminders, logging, team calendar hooks |
| **CCM-S4** | Gmail/Outlook OAuth add-in / sync |
| **CCM-S5** | Mass email + SMS (P1) |
| **CCM-S6** | Tracking analytics + SMS analytics (P1/P2) |

---

## 4. Cycle CCM-S1 — Consent SoR

### Objectives
- Tables for consent channels; APIs used by LED ads, INS `tcpa_strict`, AIA sends
- Block outbound when consent missing

### Risks
| Risk | Mitigation |
|------|------------|
| Duplicate consent stores | Document CCM as only SoR; others snapshot |
| Silent send bypass | Single send gateway checks consent |

### Evaluation
- [ ] Outbound email/SMS/call API rejects without consent when required

---

## 5. Cycle CCM-S2 — Email core

### Objectives
- Mailboxes (encrypted secrets), threads, messages, templates
- Associate to lead/contact/account/opportunity via ULID + Facade
- Association &lt;30s NFR

### Risks
| Risk | Mitigation |
|------|------------|
| OAuth secret leak | Encrypted columns; never log |
| Wrong-record association | Explicit user confirm + rules |

### Evaluation
- [ ] Send template email to contact; thread appears on 360°

---

## 6. Cycle CCM-S3 — Calls

### Objectives
- Call tasks/reminders; logging; optional recording metadata (retention policy)

### Evaluation
- [ ] Reminder fires; call logged on lead within SLA

---

## 7. Cycle CCM-S4 — Client integrations

### Objectives
- Gmail/Outlook integration path (add-in or sync) per INT requirements

### Risks
| Risk | Mitigation |
|------|------------|
| Scope creep on add-in UX | MVP: sync sent/received + associate |

### Evaluation
- [ ] External email appears associated in CRM

---

## 8. Cycle CCM-S5 — Mass email & SMS

### Objectives
- Mass email with throttling, unsubscribe, permission
- SMS send/receive, templates, timezone scheduling

### Evaluation
- [ ] Mass send respects DNC; SMS scheduled in recipient TZ

---

## 9. Cycle CCM-S6 — Analytics

### Objectives
- Open/click status (&lt;10s); SMS analytics P2
- Optional feed to DAR/SPM

### Evaluation
- [ ] Open/click visible; reports can query aggregates via Facade

---

## 10. Cross-cutting SDLC checklist

| Stage | CCM activity |
|-------|--------------|
| Requirements | CCM-FR / INT / SEC / NFR tickets |
| Design | Consent state machine; provider adapters |
| Build | Provider-agnostic ports + Meta/Twilio/etc adapters |
| Test | Consent matrix tests; webhook idempotency |
| Deploy | Entitle `ccm`; secret rotation runbook |
| Ops | Bounce/complaint handling |

---

## 11. Dependencies

| Needs | Provides |
|-------|----------|
| ACM/LED/ODM Facades; IAM; thin PLT | INS compliance, WPA email actions, AIA send, SPM campaign ROI |

---

## 12. Exit criteria (module MVP)

Consent SoR live; P0 email + calls + templates + association; Gmail/Outlook path usable; no outbound without consent when TCPA mode on.
