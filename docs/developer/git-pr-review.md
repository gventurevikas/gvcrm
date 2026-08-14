# Git, branches, and PR review

---

## 1. Branching

| Branch | Purpose |
|--------|---------|
| `main` | Protected; production-ready |
| `feature/{app}-{short-desc}` | e.g. `feature/led-meta-ingest` |
| `fix/{app}-{short-desc}` | Bug fixes |
| `chore/…` | Tooling, docs-only |

Prefer small PRs: one feature slice, one module when possible.

---

## 2. Commits

- Imperative mood: `Add lead assignment rule API`, not `Added…` / `Fixed stuff`.  
- Prefer **why** in the body when non-obvious.  
- Do not commit secrets (`.env`, keys, `*_encrypted` plaintext dumps).  
- Do not commit `html/` showcase or gitignored `docs/dev-docs/` unless policy changes.  
- `docs/developer/`, `docs/database/`, `docs/requirements/` **are** committed when you change them.

Follow the repo’s existing commit style when one exists.

---

## 3. Pull request description

Include:

1. **Summary** — what and why (1–3 bullets)  
2. **Module / app code** — `led`, `dar`, `iam`, …  
3. **Requirement IDs** — e.g. `LED-FR-008` if applicable  
4. **Test plan** — checklist of what you ran  
5. **Screenshots** — for UI changes  
6. **Checklist** — paste from Angular / API / DB / Security sections below  

---

## 4. Review expectations

**Author**

- Self-review the diff first.  
- Keep PR focused; split schema + huge UI when review would suffer.  
- Respond to comments; do not force-merge over open blockers.

**Reviewer**

- Block on broken hard rules (inline templates, missing RBAC, cross-DB queries, envelope missing).  
- Prefer questions over vague “nit” without preference.  
- Approve when DoD from [01-getting-started.md](./01-getting-started.md) is met.

---

## 5. Combined PR checklist

```text
## Summary
- 

## App code
- [ ] iam / led / dar / … 

## Requirements
- [ ] IDs: 

## Test plan
- [ ] 
- [ ] 

## Angular (if UI)
- [ ] Separate .ts / .html / .scss
- [ ] No chrome copy-paste
- [ ] No HttpClient in component
- [ ] Guards + *gvcrmCan
- [ ] @gvcrm/styles only (no hex)
- [ ] Facade for cross-module

## API (if backend)
- [ ] Application JSON envelope
- [ ] auth + rbac
- [ ] Facade only from controller
- [ ] org_id enforced
- [ ] contracts updated

## Database (if schema)
- [ ] docs/database updated
- [ ] Migration included
- [ ] No cross-DB FK

## Security
- [ ] No secrets committed / logged
- [ ] Permissions registered both sides
```

---

## 6. Docs that must stay in sync

| Change | Also update |
|--------|-------------|
| New table/column | `docs/database/…` |
| New permission | Access seed + module manifest + this folder if process changes |
| New public Facade method | Module README / contracts |
| New developer rule | `docs/developer/…` |
