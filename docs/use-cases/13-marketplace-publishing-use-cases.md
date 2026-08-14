# Marketplace and App Publishing — Use Cases

**Document ID:** GVCRM-UC-MKT  
**Requirements:** `docs/requirements/13-marketplace-and-app-publishing.md`

---

## MKT-UC-001 — Discover apps in the Marketplace

| Field | Value |
|-------|-------|
| **Requirement** | MKT-FR-001 |
| **Priority** | P0 |
| **Primary actor** | A-ADM / A-AE |

### Main flow
1. User opens in-product Marketplace.
2. Browses categories; searches/filters (free, industry, connector).
3. Opens listing cards.

---

## MKT-UC-002 — Review listing detail before install

| Field | Value |
|-------|-------|
| **Requirement** | MKT-FR-002 |
| **Priority** | P0 |

### Main flow
1. User opens listing: description, screenshots, scopes, pricing, reviews, publisher.
2. Decides to install or cancel.

---

## MKT-UC-003 — Install, configure, update, uninstall

| Field | Value |
|-------|-------|
| **Requirement** | MKT-FR-003 |
| **Priority** | P0 |
| **Primary actor** | A-ADM |
| **Security** | MKT-SEC-001, MKT-SEC-002, MKT-SEC-003 |

### Main flow
1. Admin installs to **sandbox** first; consents to scopes.
2. Configures app; tests.
3. Installs/promotes to **production** with explicit consent.
4. Updates when new version available.
5. Uninstalls; core CRM data remains intact; app metadata removed.

### Exceptions
- **E1 Bad signature:** Install blocked.
- **E2 Insufficient admin rights:** Denied.

---

## MKT-UC-004 — Use licensing and commercial models

| Field | Value |
|-------|-------|
| **Requirement** | MKT-FR-004 |
| **Priority** | P1 |
| **Primary actor** | A-ADM / billing admin |

### Main flow
1. Org starts free/trial or purchases subscription/usage plan.
2. Entitlements gate app features.
3. Billing admin views invoices via billing provider.

---

## MKT-UC-005 — Rate and review apps

| Field | Value |
|-------|-------|
| **Requirement** | MKT-FR-005 |
| **Priority** | P1 |

### Main flow
1. Verified installer leaves rating/review.
2. Trust badges display; operator may unlist abusive listings.

---

## MKT-UC-006 — Onboard as a publisher

| Field | Value |
|-------|-------|
| **Requirement** | MKT-FR-006 |
| **Priority** | P0 |
| **Primary actor** | A-DEV / ISV |
| **Security** | MKT-SEC-004 |

### Main flow
1. Publisher registers legal profile, contacts, payout details (encrypted).
2. Invites publisher roles.
3. Gains access to publisher portal.

---

## MKT-UC-007 — Package and submit an app

| Field | Value |
|-------|-------|
| **Requirement** | MKT-FR-007 |
| **Priority** | P0 |
| **Primary actor** | A-DEV |

### Main flow
1. Publisher packages Platform app/modules/workflows into versioned package.
2. Signs package; uploads; submits for review.
3. Package appears in Review queue.

---

## MKT-UC-008 — Review, certify, and publish

| Field | Value |
|-------|-------|
| **Requirement** | MKT-FR-008 |
| **Priority** | P0 |
| **Primary actor** | A-OPR |
| **Security** | MKT-SEC-006 |

### Main flow
1. Operator reviews security, scopes, UX, listing quality.
2. Approves → **Live**, or rejects with comments.
3. Live apps installable per visibility (private/public).

---

## MKT-UC-009 — Version apps and communicate releases

| Field | Value |
|-------|-------|
| **Requirement** | MKT-FR-009 |
| **Priority** | P1 |

### Main flow
1. Publisher uploads new version + release notes.
2. Tenants see update available; security upgrades may be forced.
3. Installers update per MKT-UC-003.

---

## MKT-UC-010 — Maintain external marketplace target profiles

| Field | Value |
|-------|-------|
| **Requirement** | MKT-FR-010 |
| **Priority** | P0 |
| **Primary actor** | A-OPR / GTM |

### Main flow
1. Operator maintains schemas for AppExchange, HubSpot, AppSource, Google, Slack, etc.
2. Each target defines required artifacts (screenshots, privacy URL, scopes).

---

## MKT-UC-011 — Track external listing submissions

| Field | Value |
|-------|-------|
| **Requirement** | MKT-FR-011 |
| **Priority** | P0 |
| **Primary actor** | A-DEV / GTM |
| **Security** | MKT-SEC-005 |

### Main flow
1. User opens listing workspace for a target store.
2. Completes checklist; exports package/artifacts.
3. Tracks Draft → Submitted → Certification → Live.
4. Store credentials encrypted and rotatable.

---

## MKT-UC-012 — Publish GVCRM product vs connectors

| Field | Value |
|-------|-------|
| **Requirement** | MKT-FR-012 |
| **Priority** | P0 |

### Main flow
1. GTM chooses listing type: platform connector vs industry solution.
2. Applies per-store overrides (title, screenshots, scopes).
3. Proceeds with MKT-UC-011.

---

## MKT-UC-013 — Attach compliance artifacts

| Field | Value |
|-------|-------|
| **Requirement** | MKT-FR-013 |
| **Priority** | P1 |

### Main flow
1. Publisher/operator attaches DPA, SOC, pen-test, checklists.
2. Artifacts required before certain external targets go Live.

---

## MKT-UC-014 — Use platform APIs as an installed app

| Field | Value |
|-------|-------|
| **Requirement** | MKT-FR-014 |
| **Priority** | P0 |
| **Primary actor** | A-SYS (app) / A-ADM |
| **Security** | MKT-SEC-007, MKT-SEC-008 |

### Main flow
1. Installed app obtains scoped OAuth token after consent.
2. Calls APIs / receives webhooks within rate limits.
3. Usage visible in DAR API dashboard.
4. Operator **kill switch** revokes all tokens for compromised app.

---

## Traceability matrix

| UC | FR | Priority |
|----|-----|----------|
| MKT-UC-001…014 | MKT-FR-001…014 | as above |
