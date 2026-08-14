# GVCRM Use-Case Mock Screens

**135** generated UI mock screens — one per product module use case (`ACM`–`INS`).

Generated with the image tool (not scripts). Visual language: navy chrome + teal accents, insurance CRM style.

---

## Counts by module

| Prefix | Use cases | Files |
|--------|----------:|------:|
| ACM | 7 | 7 |
| CCM | 15 | 15 |
| DAR | 15 | 15 |
| DOC | 7 | 7 |
| LED | 8 | 8 |
| ODM | 7 | 7 |
| PRD | 4 | 4 |
| QOC | 9 | 9 |
| PLT | 15 | 15 |
| SPM | 6 | 6 |
| TCL | 6 | 6 |
| WPA | 6 | 6 |
| MKT | 14 | 14 |
| AIA | 9 | 9 |
| INS | 7 | 7 |
| **Total** | **135** | **135** |

---

## Naming

```text
{PREFIX}-UC-{NNN}-{short-slug}.png
```

Example: `LED-UC-008-meta-linkedin-realtime.png` ↔ `LED-UC-008` in `docs/use-cases/05-leads-use-cases.md`.

---

## Index by module

### Accounts & Contacts (ACM)
- `ACM-UC-001-account-360.png`
- `ACM-UC-002-account-hierarchy.png`
- `ACM-UC-003-contact-management.png`
- `ACM-UC-004-org-chart.png`
- `ACM-UC-005-contacts-map.png`
- `ACM-UC-006-personal-scheduling.png`
- `ACM-UC-007-group-scheduling.png`

### Customer Communication (CCM)
- `CCM-UC-001` … `CCM-UC-015` (call, email, SMS flows)

### Dashboards & Reports (DAR)
- `DAR-UC-001` … `DAR-UC-015` (homepage through conversational engine)

### Documents (DOC)
- `DOC-UC-001` … `DOC-UC-007`

### Leads (LED)
- `LED-UC-001` … `LED-UC-008` (includes Meta/LinkedIn realtime)

### Opportunities (ODM)
- `ODM-UC-001` … `ODM-UC-007` (includes Kanban + rotting)

### Products (PRD)
- `PRD-UC-001` … `PRD-UC-004`

### Quotes / Orders / Contracts (QOC)
- `QOC-UC-001` … `QOC-UC-009`

### Platform (PLT)
- `PLT-UC-001` … `PLT-UC-015`

### Sales Performance (SPM)
- `SPM-UC-001` … `SPM-UC-006` (includes D/W/M leaderboards)

### Team Collaboration (TCL)
- `TCL-UC-001` … `TCL-UC-006`

### Workflows (WPA)
- `WPA-UC-001` … `WPA-UC-006`

### Marketplace (MKT)
- `MKT-UC-001` … `MKT-UC-014`

### AI Assistant (AIA)
- `AIA-UC-001` … `AIA-UC-009`

### US Insurance (INS)
- `INS-UC-001` … `INS-UC-007`

---

## Related

| Doc | Role |
|-----|------|
| `docs/use-cases/*.md` | Written use-case flows |
| `docs/requirements/*.md` | FR source |
| Access/IAM mocks | Not in this 135 set (foundation IAM UCs are separate) |

Open any PNG alongside its use-case markdown for design / QA reviews.
