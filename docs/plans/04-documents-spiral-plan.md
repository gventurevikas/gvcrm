# Documents (DOC) — Spiral Plan

**Document ID:** GVCRM-PLAN-DOC  
**Requirement:** `docs/requirements/04-documents-management.md`  
**Database:** `docs/database/05-doc-documents.md` (`gvcrm_doc`)  
**Program wave:** S3 thin; P1 search/playbooks later  
**Packages:** `@gvcrm/mod-documents`, `gvcrm-doc-api`

---

## 1. Purpose

Permissioned document repository: folders, attachments to CRM records, encrypted share links, versions, and later playbooks/conversion.

---

## 2. Priority slices

| Priority | Capabilities |
|----------|--------------|
| **P0** | Repository, attachments, sharing, versioning, malware scan, quotas |
| **P1** | Advanced/NL search, Office→web conversion, interactive playbooks |
| **P2** | OCR |

---

## 3. Spiral cycles

| Cycle | Focus |
|-------|-------|
| **DOC-S1** | Object storage + folders + upload + ACLs |
| **DOC-S2** | `document_links` to ACM/LED/ODM/QOC + versions |
| **DOC-S3** | Encrypted share links (expiry, password, revoke, log) |
| **DOC-S4** | Search + conversion + playbooks (P1) |

---

## 4. Cycle DOC-S1 — Repository

### Objectives
- Folders, documents, blob storage, malware scan hook, quotas
- Encryption at rest/in transit

### Risks
| Risk | Mitigation |
|------|------------|
| Public bucket exposure | Private buckets + signed URLs |
| Malware | Async scan; quarantine state |

### Evaluation
- [ ] Upload visible only to permitted roles

---

## 5. Cycle DOC-S2 — Attach & version

### Objectives
- Content-addressed links to CRM subjects (ULID + type)
- Version history; most-restrictive ACL wins

### Evaluation
- [ ] Attach file to opportunity; new version supersedes preview

---

## 6. Cycle DOC-S3 — External share

### Objectives
- Share links with expiry/password/revoke/access log
- External viewers get **no** CRM session

### Risks
| Risk | Mitigation |
|------|------------|
| Link = CRM login | Separate viewer token scope |

### Evaluation
- [ ] Revoked link 404s; access logged

---

## 7. Cycle DOC-S4 — P1 intelligence

### Objectives
- Full-text + attribute search; conversion; playbooks

### Evaluation
- [ ] Search finds by content; playbook steps render

---

## 8. Cross-cutting SDLC checklist

| Stage | DOC activity |
|-------|--------------|
| Requirements | DOC-FR / SEC / NFR |
| Design | Storage key layout; ACL model |
| Build | API + Angular library UI |
| Test | ACL matrix; share revoke |
| Deploy | Object storage + virus scanner |
| Ops | Quota alerts |

---

## 9. Dependencies

| Needs | Provides |
|-------|----------|
| IAM; PLT shares optional | QOC PDFs, INS licenses, CCM recordings, TCL attachments |

---

## 10. Exit criteria (module MVP)

Upload, attach, version, secure share links; encryption and malware path live.
