# Team Collaboration — Use Cases

**Document ID:** GVCRM-UC-TCL  
**Requirements:** `docs/requirements/11-team-collaboration.md`

---

## TCL-UC-001 — Post and follow feeds

| Field | Value |
|-------|-------|
| **Requirement** | TCL-FR-001 |
| **Priority** | P0 |
| **Primary actor** | A-AE |
| **Security** | TCL-SEC-001 |

### Main flow
1. User posts to org, team, or **record** feed; attaches DOC file if needed.
2. Colleagues comment/like; followers of record see updates.
3. Users without record access **cannot** see record feed posts.

---

## TCL-UC-002 — Check in at a client location

| Field | Value |
|-------|-------|
| **Requirement** | TCL-FR-002 |
| **Priority** | P1 |
| **Primary actor** | A-PROD (field) |
| **Security** | TCL-SEC-002 |

### Main flow
1. On mobile at client site, user **Check in**; device shares location.
2. Check-in linked to account/appointment.
3. Manager views permitted check-in map.
4. Retention job deletes location per policy.

---

## TCL-UC-003 — @Mention a colleague

| Field | Value |
|-------|-------|
| **Requirement** | TCL-FR-003 |
| **Priority** | P0 |
| **Security** | TCL-SEC-004 |

### Main flow
1. User @mentions colleague in note/post.
2. Colleague gets notification with deep link.
3. Snippet **omits** fields the recipient cannot see.
4. Mention does **not** auto-grant record access.

---

## TCL-UC-004 — Chat privately with record cards

| Field | Value |
|-------|-------|
| **Requirement** | TCL-FR-004 |
| **Priority** | P1 |
| **Security** | TCL-SEC-001, TCL-SEC-003 |

### Main flow
1. User starts 1:1 or small-group chat (distinct from AIA).
2. Shares a record card; each viewer sees only what their CRM permissions allow.
3. Admin may export chat with audit only.

---

## TCL-UC-005 — Tag records

| Field | Value |
|-------|-------|
| **Requirement** | TCL-FR-005 |
| **Priority** | P0 |
| **Primary actor** | A-AE / A-OPS |

### Main flow
1. User applies manual tags to leads/deals/accounts.
2. Ops configures auto-tag rules.
3. Tags used in search, list filters, segments, campaigns.

---

## TCL-UC-006 — Manage user groups

| Field | Value |
|-------|-------|
| **Requirement** | TCL-FR-006 |
| **Priority** | P0 |
| **Primary actor** | A-MGR / A-OPS |
| **Security** | TCL-SEC-005 |

### Main flow
1. Admin creates group; adds members (membership admin permission).
2. Group used for record sharing, feeds, assignment, SPM goals, ACM group scheduling.
3. Removing member revokes group-based access accordingly.

---

## Traceability matrix

| UC | FR | Priority |
|----|-----|----------|
| TCL-UC-001…006 | TCL-FR-001…006 | as above |
