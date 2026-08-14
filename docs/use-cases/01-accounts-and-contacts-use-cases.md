# Accounts and Contacts — Use Cases

**Document ID:** GVCRM-UC-ACM  
**Requirements:** `docs/requirements/01-accounts-and-contacts-management.md`  
**Actors:** see `00-actors-and-conventions.md`

---

## ACM-UC-001 — Manage company accounts (360°)

| Field | Value |
|-------|-------|
| **Requirement** | ACM-FR-001 |
| **Priority** | P0 |
| **Primary actor** | A-AE / A-AM |
| **Goal** | Create and maintain company accounts with a unified 360° view |

### Preconditions
- User entitled to ACM; create/edit permission on Account.

### Main flow
1. User opens Accounts → **New**.
2. Enters name, type, address, phone, owner; saves.
3. System creates account (`org_id` scoped); opens detail.
4. User opens **360°** tabs: contacts, opportunities, documents, communications, cases (as modules available).
5. User edits fields; optionally **merges** duplicate into survivor (preview → confirm).
6. User **archives** inactive account (soft delete / status).

### Alternate flows
- **A1 Quick create** from lead convert or assistant tool.
- **A2 Merge:** Survivor retains history; loser soft-deleted; ACM-SEC-004 audit.

### Exceptions
- **E1 Validation / required fields:** Save blocked with messages (WPA rules may apply).
- **E2 No access:** Record hidden; deep links fail closed.

### Postconditions
- Account persisted; audit on merge/export; related lists respect sharing.

### Business rules
- Access = role + owner + sharing (ACM-SEC-001).
- Search P95 targets per NFR.

### UI / API
- `@gvcrm/mod-accounts` list/detail; `gvcrm-acm-api` CRUD/merge.

---

## ACM-UC-002 — Maintain account hierarchy

| Field | Value |
|-------|-------|
| **Requirement** | ACM-FR-002 |
| **Priority** | P0 |
| **Primary actor** | A-AM / A-OPS |
| **Goal** | Link parent/child accounts and view roll-up context |

### Preconditions
- Two or more accounts in same org.

### Main flow
1. User opens child account → sets **Parent Account**.
2. System validates no cycle and depth ≤ 10.
3. User opens parent → **Hierarchy** tree with child metrics (deals, contacts counts).
4. User navigates to child for upsell/cross-sell.

### Exceptions
- **E1 Cycle detected:** Reject with error.
- **E2 Depth exceeded:** Reject.

### Business rules
- Hierarchy is org-scoped; no cross-tenant parents.

---

## ACM-UC-003 — Manage contacts

| Field | Value |
|-------|-------|
| **Requirement** | ACM-FR-003 |
| **Priority** | P0 |
| **Primary actor** | A-AE |
| **Goal** | Maintain people records with multi-account roles and DNC |

### Main flow
1. User creates contact (name, email, phone, mailing address).
2. Links contact to one or more accounts with roles (decision maker, billing, etc.).
3. Sets DNC / do-not-email flags as needed.
4. Opens contact 360°: accounts, deals, activities, engagement.
5. Merges duplicates when required (audited).

### Alternate
- **A1 Created from lead convert** (LED-UC-007).

### Business rules
- DNC flags must be visible to CCM before outbound (CCM consent SoR still authoritative for channel consent).

---

## ACM-UC-004 — View and edit organization chart

| Field | Value |
|-------|-------|
| **Requirement** | ACM-FR-004 |
| **Priority** | P1 |
| **Primary actor** | A-AE / A-AM |
| **Goal** | Map buying committee via reports-to and influence |

### Main flow
1. User opens Account → **Org chart**.
2. System renders interactive chart from contacts’ reports-to + influence types.
3. User drag-links reports-to; sets influence (champion, blocker, etc.).
4. Chart saves; used for deal planning.

### Exceptions
- **E1 Contact not readable:** Node omitted (sharing).

---

## ACM-UC-005 — Explore contacts and accounts on a map

| Field | Value |
|-------|-------|
| **Requirement** | ACM-FR-005 |
| **Priority** | P1 |
| **Primary actor** | A-PROD (field) / A-AE |
| **Integrations** | ACM-INT-001 |

### Main flow
1. User opens **Map** view; applies filters (owner, type, radius).
2. System geocodes readable records only (ACM-SEC-003).
3. User selects pin → opens record; plans visit.

### Exceptions
- **E1 Geocode failure:** Pin omitted; address still on record.

---

## ACM-UC-006 — Publish personal appointment scheduling page

| Field | Value |
|-------|-------|
| **Requirement** | ACM-FR-006 |
| **Priority** | P0 |
| **Primary actors** | A-AE (host), A-EXT (invitee) |
| **Integrations** | ACM-INT-002, ACM-INT-003, ACM-INT-004 |

### Preconditions
- Host connected calendar; scheduling page enabled; appointment types defined.

### Main flow
1. Host creates personal booking page (duration, buffers, locations/video).
2. Host copies link into email (CCM) or shares URL.
3. Invitee opens page; sees **free/busy only** (ACM-SEC-002) — no titles/notes.
4. Invitee picks slot; enters name/email; confirms.
5. System creates appointment + calendar event + optional Meet/Teams/Zoom link.
6. Host and invitee receive confirmations; CRM shows appointment on contact/account if matched.

### Alternate
- **A1 Reschedule / cancel** by host or invitee via tokenized links.

### Exceptions
- **E1 Slot taken (race):** Offer next slots.
- **E2 Revoked page:** Token invalid.

### Business rules
- Scheduling URLs are unguessable and revocable (ACM-SEC-005 for group; same pattern for personal).

---

## ACM-UC-007 — Publish group appointment scheduling

| Field | Value |
|-------|-------|
| **Requirement** | ACM-FR-007 |
| **Priority** | P1 |
| **Primary actors** | A-MGR / A-OPS (config), A-EXT (book), A-AE (host) |
| **Depends on** | TCL user groups (optional) |

### Main flow
1. Admin defines team pool (round-robin or any-available) and shared URL.
2. Prospect books; system assigns first eligible host.
3. Appointment appears on assignee’s calendar and CRM.

### Exceptions
- **E1 No host available:** Show next open day / waitlist message.

---

## Traceability matrix

| UC | FR | Priority |
|----|-----|----------|
| ACM-UC-001 | ACM-FR-001 | P0 |
| ACM-UC-002 | ACM-FR-002 | P0 |
| ACM-UC-003 | ACM-FR-003 | P0 |
| ACM-UC-004 | ACM-FR-004 | P1 |
| ACM-UC-005 | ACM-FR-005 | P1 |
| ACM-UC-006 | ACM-FR-006 | P0 |
| ACM-UC-007 | ACM-FR-007 | P1 |
