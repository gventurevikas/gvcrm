# Platform Capabilities — Use Cases

**Document ID:** GVCRM-UC-PLT  
**Requirements:** `docs/requirements/09-platform-capabilities.md`

---

## PLT-UC-001 — Bulk-edit records in a grid

| Field | Value |
|-------|-------|
| **Requirement** | PLT-FR-001 |
| **Priority** | P0 |
| **Primary actor** | A-OPS / A-AE |

### Main flow
1. User opens list → **Bulk edit** spreadsheet grid.
2. Edits multiple cells; validation runs per row (WPA).
3. Saves; per-row success/error report shown.

---

## PLT-UC-002 — Manage cases

| Field | Value |
|-------|-------|
| **Requirement** | PLT-FR-002 |
| **Priority** | P0 |
| **Primary actor** | A-SUP |

### Main flow
1. User creates case linked to account/contact (or email-to-case).
2. Assigns owner; tracks status/priority.
3. Resolves case; history retained.

---

## PLT-UC-003 — See color-coded activity icons

| Field | Value |
|-------|-------|
| **Requirement** | PLT-FR-003 |
| **Priority** | P1 |

### Main flow
1. On lists/Kanban, user sees green/amber/red icons for next activity health.
2. Clicks icon → opens activity or creates follow-up.

---

## PLT-UC-004 — Create and refresh sandbox

| Field | Value |
|-------|-------|
| **Requirement** | PLT-FR-004 |
| **Priority** | P0 |
| **Primary actor** | A-ADM / A-DEV |
| **Security** | PLT-SEC-002 |

### Main flow
1. Admin creates sandbox from production (clone options).
2. Optionally masks PII.
3. Users log into sandbox URL; test safely.
4. Admin refreshes sandbox on schedule/policy.

---

## PLT-UC-005 — Deploy configuration to production

| Field | Value |
|-------|-------|
| **Requirement** | PLT-FR-005 |
| **Priority** | P0 |
| **Security** | PLT-SEC-003 |

### Main flow
1. Admin builds metadata package in sandbox (fields, layouts, apps, automations).
2. Reviews diff; optional dual-control approval.
3. Deploys to production; rollback package retained.
4. Passwords/secrets never copied from sandbox incorrectly.

---

## PLT-UC-006 — Add custom fields

| Field | Value |
|-------|-------|
| **Requirement** | PLT-FR-006 |
| **Priority** | P0 |
| **Primary actor** | A-ADM |
| **Security** | PLT-SEC-001 |

### Main flow
1. Admin adds typed custom field on extendable object.
2. Sets FLS by profile.
3. Field appears on layouts/API/reports per configuration.

---

## PLT-UC-007 — Design custom page layouts

| Field | Value |
|-------|-------|
| **Requirement** | PLT-FR-007 |
| **Priority** | P0 |

### Main flow
1. Admin arranges sections, fields, related lists.
2. Assigns layout by profile/record type.
3. End users see assigned layout on detail pages.

---

## PLT-UC-008 — Create custom modules

| Field | Value |
|-------|-------|
| **Requirement** | PLT-FR-008 |
| **Priority** | P0 |
| **Security** | PLT-SEC-004 |

### Main flow
1. Admin creates custom object (fields, CRUD, API, reports).
2. Sharing defaults to private.
3. Packages module for export/import / Marketplace.

---

## PLT-UC-009 — Build custom apps

| Field | Value |
|-------|-------|
| **Requirement** | PLT-FR-009 |
| **Priority** | P0 |
| **Primary actor** | A-DEV / A-ADM |

### Main flow
1. Builder composes app: nav, objects, validations, workflows, dashboards.
2. Assigns app to users/profiles.
3. Users open app from module switcher when entitled.

---

## PLT-UC-010 — Create custom views and filters

| Field | Value |
|-------|-------|
| **Requirement** | PLT-FR-010 |
| **Priority** | P0 |
| **Primary actor** | A-AE |

### Main flow
1. User builds list view with advanced filters.
2. Saves; optionally pins as default.
3. Shares view definition (not record access) as permitted.

---

## PLT-UC-011 — Set follow-up reminders

| Field | Value |
|-------|-------|
| **Requirement** | PLT-FR-011 |
| **Priority** | P0 |

### Main flow
1. On a record, user sets reminder or scheduled follow-up email.
2. At due time, notification fires; optional email send via CCM with consent.

---

## PLT-UC-012 — Switch UI language

| Field | Value |
|-------|-------|
| **Requirement** | PLT-FR-012 |
| **Priority** | P0 |

### Main flow
1. User/admin selects language pack.
2. Labels/templates translate; RTL when pack supports (P1 polish).
3. User session reflects language.

---

## PLT-UC-013 — Work in multiple currencies

| Field | Value |
|-------|-------|
| **Requirement** | PLT-FR-013 |
| **Priority** | P0 |

### Main flow
1. Admin sets corporate currency and FX rates (manual or feed).
2. Users create commercial records in preferred currency.
3. Reports convert/display per settings.

---

## PLT-UC-014 — Add text or audio notes

| Field | Value |
|-------|-------|
| **Requirement** | PLT-FR-014 |
| **Priority** | P0 |

### Main flow
1. User adds text note (private or shared) on record.
2. Optionally records audio note; transcription optional (P2).
3. Note appears on timeline per sharing.

---

## PLT-UC-015 — Receive real-time notifications

| Field | Value |
|-------|-------|
| **Requirement** | PLT-FR-015 |
| **Priority** | P0 |
| **Security** | PLT-SEC-005 |

### Main flow
1. Events occur (assignment, mention, approval, activity).
2. User receives in-app / push / email per preferences.
3. Notification preview **does not leak** inaccessible record fields.
4. User filters/mark-reads notification center.

---

## Traceability matrix

| UC | FR | Priority |
|----|-----|----------|
| PLT-UC-001…015 | PLT-FR-001…015 | as above |
