# Documents — Use Cases

**Document ID:** GVCRM-UC-DOC  
**Requirements:** `docs/requirements/04-documents-management.md`

---

## DOC-UC-001 — Store and browse documents in repository

| Field | Value |
|-------|-------|
| **Requirement** | DOC-FR-001 |
| **Priority** | P0 |
| **Primary actor** | A-AE / enablement |

### Main flow
1. User opens Documents library; navigates folders.
2. Uploads file; malware scan runs (DOC-INT-003); quarantine if dirty.
3. Role ACL determines visibility; quota enforced.
4. User downloads or previews when allowed.

### Business rules
- Encrypted at rest/in transit (DOC-SEC-003).
- Most restrictive ACL wins with record links (DOC-SEC-001).

---

## DOC-UC-002 — Attach files to CRM records

| Field | Value |
|-------|-------|
| **Requirement** | DOC-FR-002 |
| **Priority** | P0 |

### Main flow
1. On lead/deal/account/quote, user **Attach**.
2. Selects existing doc or uploads new.
3. `document_links` created; timeline shows attach event.
4. User can remove link (history retained per policy).

---

## DOC-UC-003 — Share document via encrypted link

| Field | Value |
|-------|-------|
| **Requirement** | DOC-FR-003 |
| **Priority** | P0 |
| **Primary actors** | A-AM (sharer), A-EXT (viewer) |

### Main flow
1. User creates share link: expiry, optional password, download/print policy.
2. Sends link via email/chat.
3. External opens link; authenticates with password if set; **no CRM session** (DOC-SEC-004).
4. Access logged; user may revoke anytime.

### Exceptions
- **E1 Expired/revoked:** Access denied.
- **E2 Rate limit:** DOC-SEC-002.

---

## DOC-UC-004 — Search documents

| Field | Value |
|-------|-------|
| **Requirement** | DOC-FR-004 |
| **Priority** | P1 |

### Main flow
1. User searches by folder tree, full-text, attributes, or natural language.
2. Facets refine results.
3. Only ACL-visible docs returned.

---

## DOC-UC-005 — Preview converted Office/PDF documents

| Field | Value |
|-------|-------|
| **Requirement** | DOC-FR-005 |
| **Priority** | P1 |

### Main flow
1. User opens document; conversion job runs async if needed.
2. In-browser preview displayed.
3. Failure shows download fallback.

---

## DOC-UC-006 — Follow an interactive playbook

| Field | Value |
|-------|-------|
| **Requirement** | DOC-FR-006 |
| **Priority** | P1 |
| **Primary actor** | A-PROD / A-AE |

### Main flow
1. From contact/account/opportunity, user opens playbook.
2. Completes checklist steps; progress saved.
3. Enablement views completion analytics.

---

## DOC-UC-007 — Manage version history

| Field | Value |
|-------|-------|
| **Requirement** | DOC-FR-007 |
| **Priority** | P0 |

### Main flow
1. User uploads new version of existing document.
2. Views version list; restores prior version if permitted.
3. Share links pin specific version or track latest per setting.

---

## Traceability matrix

| UC | FR | Priority |
|----|-----|----------|
| DOC-UC-001…007 | DOC-FR-001…007 | P0/P1 as above |
