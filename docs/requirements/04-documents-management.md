# Documents Management

**Document ID:** GVCRM-REQ-DOC  
**Version:** 1.0  
**Status:** Draft for implementation  
**Source:** CRM Requirement sheet — Documents Management  
**This document is independent.** Related modules are listed only as dependencies.

---

## 1. Purpose

Provide a **central, permissioned repository** for sales collateral, attachments, and playbooks; support search, sharing, conversion to web-viewable formats, record attachments, and version history.

## 2. Scope

**In scope**

- Central document repository with role-based access
- Attach files to CRM records
- Encrypted share links for internal and external users
- Advanced search (tree, full-text, attributes, NL queries, refine)
- Offline document conversion to web preview
- Interactive playbooks on contact/account/opportunity
- Automatic version history

**Out of scope**

- Full CLM redlining workflow beyond attaching contract files — Quotes, Orders, and Contracts
- Email attachment send mechanics — Customer Communication (this module stores/serves files)
- Marketplace app packages — Marketplace

## 3. Users

| Persona | Typical actions |
|---------|-----------------|
| Sales representative | Attach files to deals, share collateral, open playbooks |
| Sales enablement | Publish playbooks and collateral in the repository |
| Account manager | Share encrypted links with customers |
| Legal / ops | Versioned contract PDFs on records |
| External recipient | View/download a shared link (time-limited) |

## 4. Business objectives

- One place for approved collateral instead of email attachments chaos
- Faster on-record guidance via playbooks
- Secure external sharing without creating full CRM users
- Traceable versions so teams never present an outdated file

---

## 5. Functional requirements

### 5.1 Document repository

**Source capability:** Document Repository  
**Priority:** P0  
**ID:** DOC-FR-001

The solution shall provide a centralized repository to store documents, attachments, and sales collateral that can be accessed based on the appropriate role within the organization.

**User story**  
As a sales enablement lead, I want a foldered library of approved decks that only certain roles can edit.

**Detailed requirements**

1. Folder tree (or equivalent collection hierarchy) with role- and group-based ACLs: view, download, edit, manage.
2. Store sales collateral independent of any single CRM record, plus “record attachments” that also appear in the repository when policy allows.
3. Metadata: title, description, type, language, product, tags, owner, review date, status (draft/approved/archived).
4. Preview in-browser for common types (PDF, images, Office where converted).
5. Quota per org and optional per-user; virus/malware scan on upload.
6. Recycle bin with restore window.

**Acceptance criteria**

- A user without view permission on a folder cannot see it in search or tree.
- Uploading a PDF to “Collateral / Pricing” makes it available to roles granted access.
- Approved vs draft status is visible; draft collateral can be restricted from general sales roles.
- Malware-positive uploads are rejected and logged.

---

### 5.2 File attachments

**Source capability:** File Attachments  
**Priority:** P0  
**ID:** DOC-FR-002

The solution shall enable attaching files to CRM records such as leads, accounts, contacts, deals, products, and others.

**User story**  
As a sales representative, I want to attach a signed NDA to the opportunity so anyone on the account team can find it.

**Detailed requirements**

1. Attach one or many files to: Lead, Account, Contact, Opportunity/Deal, Product, Quote, Order, Contract, Case, Campaign, and custom modules.
2. Drag-and-drop on the record; max size configurable.
3. Attachments inherit record sharing plus optional tighter ACL.
4. Same file can be linked to multiple records without duplicating bytes (content-addressed or explicit link).
5. Activity timeline shows “file attached/removed”.

**Acceptance criteria**

- Attaching a file on a deal shows it on the deal’s Files tab and in timeline.
- A user who cannot read the deal cannot read its attachments.
- Removing the link from one record does not delete the file if still linked elsewhere (unless last link and user confirms delete).

---

### 5.3 Document sharing

**Source capability:** Document Sharing  
**Priority:** P0  
**ID:** DOC-FR-003

The solution shall allow sharing a file with internal and external users by generating an encrypted link and sending it through email or chat.

**User story**  
As an account manager, I want to send a customer a secure link to a proposal that expires in 7 days.

**Detailed requirements**

1. Generate share link: internal user/group or external (email-gated or token-only).
2. Link is unguessable; payload encrypted in transit; optional encryption at rest with org keys.
3. Controls: expiry, max downloads, password, watermark, view-only vs download, revoke anytime.
4. Send via email (Communication) or chat (Team Collaboration) from the share dialog.
5. Access log: who (or which email), when, IP, view vs download.

**Acceptance criteria**

- Expired or revoked links return a safe error page, not the file.
- External recipient without a CRM login can view if the link policy allows.
- Access log is visible to the sharer and auditors.
- Password-protected links require the password before preview.

---

### 5.4 Advanced search capabilities

**Source capability:** Advanced Search Capabilities  
**Priority:** P1  
**ID:** DOC-FR-004

The solution shall provide advanced search including tree-based search, full-text search, search on document attributes, natural language queries, and refining existing searches.

**User story**  
As a sales representative, I want to type “latest pricing sheet for Product X” and find the approved file quickly.

**Detailed requirements**

1. Tree-based browse + search within a folder.
2. Full-text search over extracted text (PDF, Office, text) and filenames.
3. Attribute filters: type, owner, tags, product, dates, status, related record.
4. Natural language query interpretation for common intents (latest, approved, by product, by account).
5. Refine: add/remove facets on an existing result set without losing the query.
6. Ranking: recency, approval status, exact title match, permission still applied.

**Acceptance criteria**

- Full-text query finds a phrase inside a PDF the user is allowed to read.
- NL query “approved playbooks for enterprise” returns matching approved playbooks.
- Refining by file type narrows results without resetting other filters.
- Documents the user cannot access never appear.

---

### 5.5 Document conversion

**Source capability:** Document Conversion  
**Priority:** P1  
**ID:** DOC-FR-005

The solution shall convert offline documents into a web-based version for online viewing.

**User story**  
As a sales representative on a client site, I want to preview a Word playbook in the browser without downloading Office.

**Detailed requirements**

1. Convert common offline formats (DOC/DOCX, PPT/PPTX, XLS/XLSX, images, TXT) to a web-viewable representation.
2. Conversion is asynchronous; UI shows processing state.
3. Converted preview is used for in-app viewer and external view-only share links.
4. Original file remains the system of record; conversion failure falls back to download if permitted.
5. Optional OCR for scanned PDFs (P2).

**Acceptance criteria**

- Uploading DOCX produces a browser preview without requiring Microsoft Office on the client.
- View-only share does not expose a download button if policy forbids download.
- Failed conversion is visible and retryable.

---

### 5.6 Playbooks

**Source capability:** Playbooks  
**Priority:** P1  
**ID:** DOC-FR-006

The solution shall allow users to generate interactive content or playbooks outlining how products operate and the policies/procedures to support them. Playbooks shall be accessible directly from a contact, account, or opportunity record.

**User story**  
As a new AE opening an opportunity, I want the product playbook beside the deal so I know discovery questions and objection handling.

**Detailed requirements**

1. Playbook authoring: rich/interactive content (sections, checklists, embedded media, branching tips).
2. Association rules: show playbook on Contact, Account, and/or Opportunity based on product, segment, stage, or manual pin.
3. Launch playbook from the record sidebar or tab without leaving the record.
4. Checklist progress can be saved per record (who completed which step).
5. Playbooks are versioned like documents; sales sees the published version.

**Acceptance criteria**

- Opening an opportunity linked to Product X surfaces the Product X playbook.
- Completing a checklist step persists for that opportunity.
- Unpublished draft playbooks are not visible to general sales roles.
- Playbook content is searchable via DOC-FR-004.

---

### 5.7 Version history

**Source capability:** Version History  
**Priority:** P0  
**ID:** DOC-FR-007

The solution shall automatically save multiple versions of documents based on their revision history.

**User story**  
As sales enablement, I want to restore last week’s pricing PDF if today’s upload was wrong.

**Detailed requirements**

1. Every replace/update creates a new immutable version (number, author, timestamp, comment).
2. Users with permission can preview, download, compare (where feasible), and restore a prior version (restore = new current version, not delete history).
3. Record attachments and repository items both version.
4. Retention policy configurable (count or time).
5. Current version is what shares and playbooks use unless a user explicitly opens history.

**Acceptance criteria**

- Updating a file increments version and keeps previous downloadable.
- Restore creates a new latest version identical to the selected old one.
- External share links can be pinned to a version or always-latest (sharer choice).
- History is not visible to users without view permission on the document.

---

## 6. Data entities

| Entity | Purpose |
|--------|---------|
| Folder | Hierarchy and ACL container |
| Document | Metadata, status, owner |
| DocumentVersion | Immutable bytes + converter output |
| DocumentLink | Attachment to a CRM record |
| ShareLink | Encrypted external/internal access token + policy |
| ShareAccessLog | Audit of link use |
| Playbook | Interactive content definition |
| PlaybookProgress | Per-record checklist state |

## 7. Integrations

| ID | Integration | Purpose |
|----|-------------|---------|
| DOC-INT-001 | Object storage | Encrypted blob storage |
| DOC-INT-002 | Content conversion / preview service | Web viewing |
| DOC-INT-003 | Antivirus / malware scanning | Upload gate |
| DOC-INT-004 | Search indexer (full-text + attributes + NL) | Advanced search |
| DOC-INT-005 | Email and Chat modules | Send share links |

## 8. Permissions and security

| ID | Requirement |
|----|-------------|
| DOC-SEC-001 | Repository ACLs and record sharing both apply; most restrictive wins for attachments. |
| DOC-SEC-002 | Share tokens are unguessable, revocable, and rate-limited against brute force. |
| DOC-SEC-003 | Files encrypted at rest and in transit. |
| DOC-SEC-004 | External viewers never receive CRM session rights. |
| DOC-SEC-005 | Download, print, and copy controls honor share policy where technically enforceable. |

## 9. Non-functional requirements

| ID | Requirement |
|----|-------------|
| DOC-NFR-001 | Upload of 25 MB P95 < 5s on a standard connection excluding client bandwidth. |
| DOC-NFR-002 | Full-text search P95 < 2s. |
| DOC-NFR-003 | Preview conversion of typical Office files < 60s; large files queued with progress. |
| DOC-NFR-004 | Version restore is atomic. |
| DOC-NFR-005 | Storage usage visible to admins; soft quota warnings before hard stop. |

## 10. Dependencies

| Module | Why |
|--------|-----|
| Accounts, Contacts, Leads, Opportunities, Products | Attachment targets |
| Quotes, Orders, and Contracts | Contract file storage and versions |
| Customer Communication | Send share links by email |
| Team Collaboration | Send share links by chat; tags |
| Platform Capabilities | Roles, custom modules as attachment targets |
| Workflows | Approval of documents / playbook publish |
| Marketplace | Apps may store or render documents via APIs |

## 11. Traceability

| Source capability | Requirement IDs |
|-------------------|-----------------|
| Advanced Search Capabilities | DOC-FR-004 |
| Document Conversion | DOC-FR-005 |
| Document Repository | DOC-FR-001 |
| Document Sharing | DOC-FR-003 |
| File Attachments | DOC-FR-002 |
| Playbooks | DOC-FR-006 |
| Version History | DOC-FR-007 |
