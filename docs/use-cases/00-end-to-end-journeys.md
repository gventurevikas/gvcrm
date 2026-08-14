# End-to-End Journeys

**Document ID:** GVCRM-UC-E2E  
**Purpose:** Multi-module scenarios that prove the US insurance remote-sales MVP story. Atomic module use cases are in `01`–`15`.

**Walkthrough videos:** [e2e-videos/README.md](./e2e-videos/README.md) — one MP4 per journey below.

---

## E2E-UC-001 — Meta lead to first touch (remote producer)

| Field | Value |
|-------|-------|
| **Actors** | A-SYS (Meta webhook), A-PROD, A-ISA |
| **Priority** | P0 |
| **Traces** | LED-FR-008, LED-FR-002, CCM-FR-001/005/012, INS-FR-004/005, AIA-FR-004 (optional) |

### Preconditions
- Agency org with INS orientation; Meta Lead Ads connected; assignment queue configured; CCM consent store ready.

### Main flow
1. Prospect submits Meta Instant Form (auto insurance, TX).
2. Webhook creates lead ≤15s with source Meta; consent snapshot written to CCM.
3. Round-robin assigns licensed TX producer (or ISA); push + in-app notify.
4. Producer opens lead from mobile queue (or asks assistant “show my new Meta leads”).
5. System blocks call/SMS if consent missing under `tcpa_strict`; else allows.
6. Producer places first-touch call; CCM logs activity on lead timeline.
7. Speed-to-lead metric feeds SPM gamification / daily board.

### Exceptions
- **E1 Duplicate webhook:** Idempotency key prevents second lead.
- **E2 Producer OOO:** Assignment skips to next eligible producer (INS-FR-004).

### Success criteria
- Lead owned, notified, first-touch logged, consent honored.

---

## E2E-UC-002 — Lead convert → household policy path → quote

| Field | Value |
|-------|-------|
| **Actors** | A-PROD, A-EXT (prospect) |
| **Priority** | P0 |
| **Traces** | LED-FR-007, ACM-FR-001/003, INS-FR-002/003, ODM-FR-001/002, PRD-FR-001, QOC-FR-001, DOC-FR-002 |

### Main flow
1. Producer qualifies lead; converts to Account (household), Contact(s), Opportunity on **new business** pipeline.
2. Adds household members; selects LOB (homeowners).
3. Adds product line items from catalog (price book snapshot).
4. Moves Kanban stage; logs discovery call (CCM).
5. Generates quote PDF; stores in DOC; emails via CCM with tracking.
6. Prospect accepts quote link; order/contract draft created per QOC rules.

### Alternate
- **A1 Cross-sell:** From existing household policy, create cross-sell opportunity (INS-FR-003).

---

## E2E-UC-003 — Renewal book management

| Field | Value |
|-------|-------|
| **Actors** | A-SYS, A-AM, A-MGR |
| **Priority** | P0 |
| **Traces** | INS-FR-003, ODM-FR-001/005, WPA-FR-002, SPM-FR-006, CCM-FR-010 |

### Main flow
1. Policy approaches term; job creates **renewal** opportunity.
2. If unworked past rotting threshold, deal highlights; manager alerted.
3. Workflow sends renewal email template to insured (consent-checked).
4. Producer binds renewal; premium KPI updates monthly leaderboard.

---

## E2E-UC-004 — Discount approval on quote

| Field | Value |
|-------|-------|
| **Actors** | A-AE, A-MGR / A-FIN |
| **Priority** | P0 |
| **Traces** | QOC-FR-001, WPA-FR-005, QOC-SEC-001 |

### Main flow
1. Rep applies discount above threshold on quote.
2. Save blocked until approval request created.
3. Approver receives notification; approves.
4. Quote becomes sendable; audit trail retained.

### Exceptions
- **E1 Reject:** Quote remains draft; rep notified with reason.

---

## E2E-UC-005 — Homepage, report, and leaderboard morning ritual

| Field | Value |
|-------|-------|
| **Actors** | A-PROD, A-MGR |
| **Priority** | P0 |
| **Traces** | DAR-FR-001/005/015, SPM-FR-002/006, AIA-FR-005, INS-FR-006 |

### Main flow
1. Producer logs in; homepage shows open leads, renewals due, **today’s leaderboard** widget.
2. Asks assistant: “Premium bound by producer this month, bar chart.”
3. Assistant collects missing filters; DAR runs report under user’s security; writes `report_runs`.
4. Manager opens team weekly board; sees ranks without peer deal PII leak.

---

## E2E-UC-006 — Collaborate on a stuck deal

| Field | Value |
|-------|-------|
| **Actors** | A-AE, A-MGR |
| **Priority** | P0 |
| **Traces** | ODM-FR-005/006, TCL-FR-001/003, DOC-FR-003, PLT-FR-015 |

### Main flow
1. Rotting deal highlighted on Kanban.
2. Rep posts feed update on opportunity; @mentions manager.
3. Manager opens deep link (already has access or requests share).
4. Rep shares proposal via encrypted DOC link to customer.
5. Activity timeline updates; followers notified.

---

## E2E-UC-007 — Assistant operates as the user

| Field | Value |
|-------|-------|
| **Actors** | A-PROD |
| **Priority** | P0 |
| **Traces** | AIA-FR-001/004/009, LED-FR-001, CCM-SEC-005 |

### Main flow
1. Producer: “Create a homeowners cross-sell on the Smith household.”
2. Assistant previews account match + opportunity fields.
3. Producer confirms; opportunity created under producer’s ownership/permissions.
4. Producer: “Email them the quote.”
5. Assistant requires explicit confirm; CCM send checks consent; audit shows assistant-initiated write.

### Exceptions
- **E1 No permission:** Tool refused; help suggests who to ask.
- **E2 Kill switch:** Admin disables assistant; chat read-only or offline.

---

## E2E-UC-008 — Install free Marketplace app in sandbox then production

| Field | Value |
|-------|-------|
| **Actors** | A-ADM, A-OPR (prior review) |
| **Priority** | P0 |
| **Traces** | MKT-FR-001/003/007/008, PLT-FR-004/005, IAM-UC-004 |

### Main flow
1. Admin browses Marketplace; opens listing; reviews scopes.
2. Installs into sandbox; configures; tests.
3. Deploys/installs to production with explicit consent.
4. Org modules/entitlements updated; users see new nav if assigned.

### Exceptions
- **E1 Tampered package:** Signature fails; install blocked.
- **E2 Kill switch:** Operator revokes app tokens globally.

---

## E2E-UC-009 — Platform customize and promote

| Field | Value |
|-------|-------|
| **Actors** | A-ADM, A-DEV |
| **Priority** | P0 |
| **Traces** | PLT-FR-004/005/006/007/010, WPA-FR-004 |

### Main flow
1. Admin adds custom field and layout in sandbox.
2. Adds validation rule requiring LOB on insurance opportunities.
3. Runs deploy package to production with diff review.
4. Reps see new field; invalid saves blocked on UI and API.

---

## E2E-UC-010 — Carrier wholesaler view of appointed agencies

| Field | Value |
|-------|-------|
| **Actors** | A-CAR |
| **Priority** | P1 |
| **Traces** | INS-FR-001/002, ODM-FR-001, DAR-FR-008, INS-SEC-001 |

### Main flow
1. Carrier user logs into carrier-mode tenant.
2. Sees only appointed agencies’ pipeline by LOB/state.
3. Runs deal report; cannot see non-appointed agency data.

---

## E2E-UC-011 — Secure account upgrade (SMS + Google Authenticator)

| Field | Value |
|-------|-------|
| **Actors** | A-PROD (or any user), A-ADM (policy) |
| **Priority** | P0 |
| **Traces** | IAM-FR-007…015, IAM-UC-007…015 |

### Preconditions
- Org may set `require_mfa`; user has verified email.

### Main flow
1. User activates account and verifies email.
2. Verifies mobile via SMS OTP.
3. Enables **SMS** as login MFA and/or enrolls **Google Authenticator** (QR + confirm code).
4. Saves recovery codes.
5. Next login: password → SMS or Authenticator challenge → CRM homepage.
6. Admin can require MFA org-wide so producers cannot skip.

### Success criteria
- Password alone never opens product modules when MFA required/enrolled.
- User can use either SMS or Authenticator when both enrolled.

---

## Journey ↔ module map

| Journey | Modules touched |
|---------|-----------------|
| E2E-UC-001 | LED, CCM, INS, SPM, AIA |
| E2E-UC-002 | LED, ACM, INS, ODM, PRD, QOC, DOC, CCM |
| E2E-UC-003 | INS, ODM, WPA, SPM, CCM |
| E2E-UC-004 | QOC, WPA |
| E2E-UC-005 | DAR, SPM, AIA, INS |
| E2E-UC-006 | ODM, TCL, DOC, PLT |
| E2E-UC-007 | AIA, LED, CCM, ODM |
| E2E-UC-008 | MKT, PLT, IAM |
| E2E-UC-009 | PLT, WPA |
| E2E-UC-010 | INS, ODM, DAR |
| E2E-UC-011 | IAM (SMS OTP + Google Authenticator) |
