# Marketplace and App Publishing

**Document ID:** GVCRM-REQ-MKT  
**Version:** 1.0  
**Status:** Draft for implementation  
**Source:** Additional product requirement (not in the original CRM sheet). Complements Platform Capabilities — Custom Apps / Custom Modules / Packages.  
**This document is independent.** Related modules are listed only as dependencies.

---

## 1. Purpose

Create a **first-party Marketplace inside GVCRM** where customers can discover, install, and license apps, and where ISVs/admins can **publish apps**. Also provide a structured way to **publish GVCRM itself (or GVCRM-built apps) to external marketplaces** (Salesforce AppExchange, HubSpot Marketplace, Microsoft AppSource, Google Workspace Marketplace, Slack, Zoho, cloud marketplaces, etc.) using marketplace-specific listing and compliance profiles.

This is how GVCRM becomes a platform, not only a CRM: custom apps built in Platform Capabilities can be packaged once and distributed through the right storefront.

## 2. Scope

**In scope**

- In-product GVCRM Marketplace (browse, search, install, uninstall, license)
- Publisher portal to submit, version, price, and publish apps
- Security, privacy scopes, review, and listing lifecycle
- Installation into sandbox then production
- Billing/entitlement for free, paid, trial, and subscription apps
- Packaging of Platform custom apps/modules/workflows/dashboards as Marketplace listings
- External marketplace publishing hub: manage listings “according to” each target store’s rules
- Partner/ISV accounts, reviews/ratings, and API usage attribution

**Out of scope**

- Building third-party storefronts we do not own (we produce listing packages and submission checklists)
- Product/service customer portals (that is Products Management — Custom Portals)
- Implementing every external marketplace’s certification program automatically (we track status and artifacts)

## 3. Users

| Persona | Typical actions |
|---------|-----------------|
| CRM end user / admin | Browse marketplace, install apps, grant scopes, configure |
| Org billing admin | Purchase subscriptions, see invoices for paid apps |
| Internal developer / admin | Package a custom app and publish privately or publicly |
| External ISV / partner | Create publisher account, submit app, respond to reviews |
| GVCRM marketplace operator | Review, certify, list/unlist, take down, payouts |
| Product/GTM | Publish GVCRM connectors to Salesforce, HubSpot, Microsoft, Google, etc. |

## 4. Business objectives

- Extend CRM capabilities via ecosystem instead of building every connector in core
- Give customers a safe install path (scopes, sandbox, uninstall)
- Let customers and partners monetize or share apps
- Enable GVCRM GTM via **external** marketplaces with repeatable listing ops
- Tie installed apps to API usage dashboards (Platform/DAR)

---

## 5. Marketplace model (how it fits)

There are **two complementary storefronts**:

| Storefront | Who lists | Who installs | Example |
|------------|-----------|--------------|---------|
| **A. GVCRM Marketplace** (in product) | GVCRM, ISVs, customers (private) | GVCRM tenants | eSign connector, industry pack, WhatsApp, tax calc |
| **B. External marketplaces** | GVCRM (and optionally ISVs building on GVCRM) | Users of those platforms | GVCRM app on HubSpot Marketplace or Microsoft AppSource |

Publishing “according to” a marketplace means: select a target, complete that target’s required metadata, artifacts, OAuth scopes, screenshots, privacy policy, support URL, and certification checklist, then submit and track status.

---

## 6. Functional requirements — GVCRM Marketplace (in product)

### 6.1 Marketplace discovery

**Priority:** P0  
**ID:** MKT-FR-001

The solution shall provide an in-app Marketplace where users can browse, search, and filter apps.

**Detailed requirements**

1. Catalog UI in app launcher: featured, categories (integrations, productivity, analytics, industry, communication, commerce, developer tools), collections.
2. Search by name, publisher, capability, object (e.g. “works with Quotes”).
3. Filters: free/paid, rating, installed, verified publisher, language, region.
4. Listing card: icon, name, short description, rating, price badge, publisher.
5. Only apps allowed for the tenant’s edition/region appear.

**Acceptance criteria**

- Admin can open Marketplace and see featured + searchable catalog.
- Filter “free + communication” returns only matching listings.
- Installed apps are badged Installed.
- Apps not licensed for the tenant’s region are hidden or marked unavailable.

---

### 6.2 Listing detail page

**Priority:** P0  
**ID:** MKT-FR-002

Each app shall have a public listing page with enough information to decide on install.

**Detailed requirements**

1. Long description, highlights, screenshots/video, version, last updated, languages, categories.
2. Pricing: free, one-time, subscription (monthly/annual), usage-based, trial length.
3. Permissions/scopes the app will request (objects, APIs, outbound callouts).
4. Publisher identity, support contacts, privacy policy, terms, DPA link.
5. Ratings and written reviews (verified installer optional).
6. Changelog / versions.
7. Compatibility: min GVCRM edition, required modules.

**Acceptance criteria**

- User can see every scope before clicking Install.
- Reviews are visible and sortable.
- Incompatible edition shows why Install is disabled.

---

### 6.3 Install, configure, uninstall

**Priority:** P0  
**ID:** MKT-FR-003

Tenants shall install apps into sandbox and/or production, grant scopes, configure, update, and uninstall cleanly.

**User story**  
As a CRM admin, I want to try an eSign app in sandbox, then install the same version in production, and uninstall later without corrupting core data.

**Detailed requirements**

1. Install wizard: target environment (sandbox/prod), scope consent, optional license key / checkout, post-install configuration.
2. Install creates OAuth client / API consumer identity visible on API Usage Dashboard.
3. Version updates: patch vs major; major may require re-consent.
4. Uninstall: remove app UI, revoke tokens, keep or delete app data per policy (prompt user).
5. Private install: install from a shared package URL or org-to-org without public listing.
6. Rollback to previous app version if publisher supports it (P1).

**Acceptance criteria**

- Sandbox install does not affect production.
- Production install requires admin permission and scope consent.
- Uninstall revokes API tokens; subsequent API calls from the app fail.
- API Usage Dashboard shows the app as a named consumer after install.

---

### 6.4 Licensing and commercial models

**Priority:** P1  
**ID:** MKT-FR-004

The marketplace shall support free, trial, paid one-time, subscription, and usage-based apps, with entitlements enforced.

**Detailed requirements**

1. Entitlement service: org + app + plan + seats/usage + expiry.
2. Trial clocks; convert to paid; grace period.
3. Seat-based apps can map to CRM user licenses or a subset.
4. Usage-based: meter API calls or business events; show usage to admin.
5. Invoices/receipts for marketplace purchases (or via billing provider).
6. Publisher payout reports for operator (P1).

**Acceptance criteria**

- Trial expiry disables paid features but does not delete tenant CRM data.
- Seat overage blocks additional assignments with a clear upgrade CTA.
- Free apps install without checkout.
- Admin can see active marketplace subscriptions in one billing page.

---

### 6.5 Ratings, reviews, and trust

**Priority:** P1  
**ID:** MKT-FR-005

**Detailed requirements**

1. Verified reviews from orgs that installed the app.
2. Flag inappropriate reviews; operator moderation.
3. Publisher response to reviews.
4. Trust badges: Verified publisher, Security reviewed, Built by GVCRM.
5. Automatic unlisting if critical security issue (operator).

**Acceptance criteria**

- Only installing orgs can leave a star rating.
- Badge “Security reviewed” appears only after operator checklist is complete.
- Operator can unlist immediately; installed copies get a security bulletin notification.

---

## 7. Functional requirements — Publisher portal (publish an app)

### 7.1 Publisher onboarding

**Priority:** P0  
**ID:** MKT-FR-006

Partners and internal teams shall create a publisher profile and submit apps.

**Detailed requirements**

1. Publisher account: legal name, contacts, website, logo, payout details (if commercial), tax info as required.
2. Agreement: marketplace terms, security addendum.
3. Roles: publisher admin, developer, support, billing.
4. Internal GVCRM teams use the same portal with an “first-party” flag.

**Acceptance criteria**

- A partner can register, complete profile, and reach “able to create listing” state.
- Incomplete legal/tax profile blocks paid listings but can allow free/private listings if policy allows.

---

### 7.2 Package and submit

**Priority:** P0  
**ID:** MKT-FR-007

Publishers shall package Platform custom apps, modules, fields, layouts, workflows, dashboards, connectors (OAuth + webhooks), and static assets into a versioned Marketplace package and submit for review.

**User story**  
As an ISV, I want to take my sandbox custom app “Field Service Lite”, package it, and submit it to the GVCRM Marketplace.

**Detailed requirements**

1. Package contents (selected): custom app, custom modules, fields, layouts, validation rules, workflow rules/templates, dashboards/reports, email templates, permission sets, connected app (OAuth scopes), webhook subscriptions, language packs, sample data optional.
2. Semantic version (major.minor.patch); immutable artifacts per version.
3. Install/uninstall scripts and post-install instructions.
4. Automated validation: missing dependencies, namespace collisions, disallowed APIs, overly broad scopes warning.
5. Submit for: Private (named orgs), Unlisted (link only), Public (marketplace review).
6. Source org is typically a sandbox or partner dev org.

**Acceptance criteria**

- Packaging a custom app with two custom modules produces a downloadable/installable package.
- Validation fails clearly if a workflow references an unpackaged field.
- Private listing is installable by invited org IDs only.
- Public submit creates a review ticket for the operator.

---

### 7.3 Review, certify, publish

**Priority:** P0  
**ID:** MKT-FR-008

The operator shall review submissions (security, UX, listing quality) and publish or reject with comments.

**Detailed requirements**

1. Review queue: automated checks + human checklist (data access, external callouts, malware scan of assets, privacy policy present).
2. Reviewer can request changes; publisher uploads a new version.
3. Publish goes live in catalog; unpublish/hide without deleting historical installs.
4. SLA targets for review (configurable, e.g. 5 business days).
5. Security recertification on major version (P1).

**Acceptance criteria**

- Rejected listing is not visible in public catalog; publisher sees reasons.
- Approved public listing appears in Marketplace search.
- Unpublish hides from new installs; existing installs continue until admin uninstalls or a security kill switch is used.

---

### 7.4 Versioning and release notes

**Priority:** P1  
**ID:** MKT-FR-009

**Detailed requirements**

1. Each version has release notes, breaking-change flag, min platform version.
2. Tenants get “Update available” on installed apps.
3. Forced upgrade only for critical security (operator flag).
4. Deprecation timeline for old versions.

**Acceptance criteria**

- Publishing 1.2.0 notifies admins of orgs on 1.1.x.
- Breaking-change flag requires extra confirmation on update.
- Forced security upgrade cannot be deferred beyond the stated deadline.

---

## 8. Functional requirements — External marketplace publishing hub

### 8.1 Target marketplace profiles

**Priority:** P0  
**ID:** MKT-FR-010

The solution shall maintain a catalog of **external marketplace targets**, each with the metadata, artifacts, and policies required to publish “according to” that marketplace.

**Initial targets (configurable; not all required for MVP)**

| Target | Typical artifact |
|--------|------------------|
| Salesforce AppExchange | Managed package / connected app, security review docs |
| HubSpot Marketplace | App + OAuth scopes + listing copy |
| Microsoft AppSource / Teams | Azure AD app, Teams manifest, listing |
| Google Workspace Marketplace | OAuth app + Gmail/add-on manifest |
| Slack App Directory | Slack app manifest |
| Zoho Marketplace | Extension package |
| AWS Marketplace / Azure Marketplace | Product listing + pricing dimensions (later) |
| Apple App Store / Google Play | Mobile companion apps (if applicable) |

**Detailed requirements**

1. Each target has a required-field schema: name, short/long description, categories, screenshots (sizes), support URL, privacy URL, EULA, video, regions, pricing model, OAuth scopes, webhook URLs, support email, company profile.
2. Validation: “Ready to submit” vs missing items per target.
3. Mapping from one GVCRM app/connector to many external listings (same product, different storefronts).
4. Store-specific credentials stored encrypted (partner consoles / developer accounts) — or export-only mode if credentials cannot be stored.

**Acceptance criteria**

- Selecting “HubSpot Marketplace” shows HubSpot-specific required assets, not Salesforce’s.
- A listing missing screenshots is not “Ready to submit”.
- One internal connector (e.g. GVCRM Gmail add-on) can have both Google Workspace and GVCRM Marketplace listings.

---

### 8.2 Listing workspace and submission tracking

**Priority:** P0  
**ID:** MKT-FR-011

GTM and product teams shall manage external listing drafts, generate submission packages, and track certification status per marketplace.

**User story**  
As a product marketer, I want to prepare the Microsoft AppSource listing from the same app record we use internally, then track “In certification” vs “Live”.

**Detailed requirements**

1. Listing workspace per target: draft copy, assets, version pinning, contacts.
2. Export package: zip/manifest in the format expected by that marketplace (where documented and automatable); otherwise a checklist + asset bundle.
3. Status pipeline: Draft → Internal review → Submitted → In certification → Changes requested → Live → Suspended → Sunset.
4. Dates: submitted, live, recertification due.
5. Assignment to owner; comments/activity.
6. Optional deep-link/API submit where the external marketplace provides APIs (P1); MVP may be export + manual upload with status tracked in GVCRM.

**Acceptance criteria**

- Status changes are audited with actor and timestamp.
- Export for a target produces the documented file set (e.g. manifest + icons + screenshots).
- “Changes requested” stores reviewer notes and blocks Live until addressed.
- Recertification due date creates a reminder (Platform reminders / workflow).

---

### 8.3 Publish GVCRM as the product vs publish connectors

**Priority:** P0  
**ID:** MKT-FR-012

The hub shall support at least two product types:

1. **Platform app / connector** — GVCRM appears inside another ecosystem (e.g. “GVCRM for Gmail”, “GVCRM for HubSpot”).
2. **Solution / industry listing** — packaged CRM configuration (custom apps, dashboards, processes) offered to GVCRM customers via our marketplace and, where allowed, as a solution on external stores.

**Detailed requirements**

1. Product type field drives which targets are applicable.
2. Shared marketing source of truth (name, value prop) with per-marketplace overrides (character limits).
3. Technical endpoints (OAuth callback, install URL) differ per target and are versioned.

**Acceptance criteria**

- Character-limit override for AppSource title does not change the HubSpot listing title.
- Switching product type updates the applicable target list.
- Install URL for Google is distinct from install URL for Microsoft.

---

### 8.4 Compliance and security artifacts

**Priority:** P1  
**ID:** MKT-FR-013

External marketplaces typically require security questionnaires, penetration test summaries, SOC/ISO links, GDPR/DPA, and data-flow diagrams.

**Detailed requirements**

1. Artifact library: reusable PDFs/URLs attached to publisher/org, then selected per listing.
2. Per-target compliance checklist (operator-maintained templates).
3. Expiry dates on certs (SOC report year, pen-test date) with alerts.
4. Data-flow: which CRM objects the connector reads/writes.

**Acceptance criteria**

- A listing cannot reach Submitted if required compliance artifacts are missing or expired.
- Reusable DPA URL can be attached to multiple listings.
- Alert fires 30 days before a certificate expiry.

---

## 9. Platform APIs for apps (enabling ecosystem)

**Priority:** P0  
**ID:** MKT-FR-014

Installed apps shall use documented, scoped APIs.

**Detailed requirements**

1. OAuth 2.0 (authorization code + refresh) and/or API keys for server apps.
2. Scopes: granular per object and action (read/write leads, read invoices, etc.).
3. Webhooks: subscribe to record events with signed payloads.
4. Rate limits per app per org; visible on API Usage Dashboard.
5. App events: install, uninstall, license change.
6. UI extension points (P1): record sidebar widgets, custom tabs, composer actions, portal widgets — declared in the package manifest.

**Acceptance criteria**

- An app granted only `leads.read` cannot write opportunities.
- Invalid webhook signature is rejected.
- Hitting rate limit returns 429 with retry-after; usage appears on DAR API dashboard.
- Uninstall fires app-uninstall event once.

---

## 10. Data entities

| Entity | Purpose |
|--------|---------|
| MarketplaceListing | Public/private catalog entry |
| AppPackage / AppVersion | Immutable install artifact |
| PublisherAccount | ISV or internal publisher |
| ListingReview | Operator certification |
| InstallRecord | Tenant + app + version + env |
| Entitlement / Plan / Subscription | Commercial rights |
| ReviewRating | Customer feedback |
| ExternalMarketplaceTarget | Store definition + schema |
| ExternalListing | GVCRM product on an external store |
| ComplianceArtifact | Reusable security/legal file |
| OauthClient / WebhookSubscription | Runtime integration |

## 11. Integrations

| ID | Integration | Purpose |
|----|-------------|---------|
| MKT-INT-001 | Platform metadata packages | What gets installed |
| MKT-INT-002 | Identity / OAuth | App access |
| MKT-INT-003 | Billing provider (Stripe or equivalent) | Paid apps |
| MKT-INT-004 | Sandbox + deploy | Safe install path |
| MKT-INT-005 | API gateway telemetry | Usage dashboard |
| MKT-INT-006 | Email / notifications | Review, install, update alerts |
| MKT-INT-007 | External marketplace consoles/APIs | Submit where available |
| MKT-INT-008 | Malware scan / static analysis | Package review |

## 12. Permissions and security

| ID | Requirement |
|----|-------------|
| MKT-SEC-001 | Only org admins (or delegated app-admin role) can install/uninstall production apps. |
| MKT-SEC-002 | Scopes are displayed and consented before tokens are issued; least privilege by default. |
| MKT-SEC-003 | Packages are signed; tampered artifacts cannot install. |
| MKT-SEC-004 | Publisher payout and tax data is restricted and encrypted. |
| MKT-SEC-005 | External marketplace developer credentials are encrypted; rotation supported. |
| MKT-SEC-006 | Public listings undergo security review before Live. |
| MKT-SEC-007 | Kill switch revokes all tokens for an app globally. |
| MKT-SEC-008 | Customer data accessed by apps remains in the tenant; ISV access only via granted scopes. |

## 13. Non-functional requirements

| ID | Requirement |
|----|-------------|
| MKT-NFR-001 | Marketplace catalog P95 < 2s. |
| MKT-NFR-002 | Install of a typical metadata package P95 < 5 minutes with progress UI. |
| MKT-NFR-003 | Token revoke on uninstall P95 < 30s globally. |
| MKT-NFR-004 | Package validation is deterministic in CI. |
| MKT-NFR-005 | External listing workspace supports at least 10 concurrent targets per product. |

## 14. Suggested delivery phases

| Phase | Deliver |
|-------|---------|
| MVP | Private + public GVCRM Marketplace, free apps, OAuth scopes, sandbox/prod install, publisher submit + operator review, package from Custom Apps |
| P1 | Paid/trial licensing, reviews, UI extension points, update channel, external listing workspace + export/checklists for Google, Microsoft, HubSpot |
| P2 | Usage-based billing, ISV payouts, automated submit APIs, AWS/Azure listings, forced recertification workflows |

## 15. Dependencies

| Module | Why |
|--------|-----|
| Platform Capabilities | Custom apps, modules, fields, layouts, sandbox, deploy, language packs |
| Workflows | Packaged automation + approval of listing/deploy |
| Dashboards and Reports | API usage dashboard; app analytics |
| Customer Communication | Email/Gmail/Outlook connector apps; notification of installs |
| Documents | Publisher artifacts, screenshots, compliance PDFs |
| Products / Quotes | Commerce connectors; not the same as product portals |
| Team Collaboration | Optional Slack/Teams apps via marketplace |
| Accounts and Contacts | Group scheduling and map connector apps |

## 16. Traceability

| Capability (new) | Requirement IDs |
|------------------|-----------------|
| In-app marketplace discovery | MKT-FR-001, MKT-FR-002 |
| Install / sandbox / uninstall | MKT-FR-003 |
| Licensing | MKT-FR-004 |
| Trust & reviews | MKT-FR-005 |
| Publisher onboarding | MKT-FR-006 |
| Package & submit apps | MKT-FR-007, MKT-FR-008, MKT-FR-009 |
| External marketplace hub | MKT-FR-010, MKT-FR-011, MKT-FR-012, MKT-FR-013 |
| App runtime APIs | MKT-FR-014 |
| Source sheet — Custom Apps / Custom Modules / Packages | PLT-FR-008, PLT-FR-009 (Platform doc) + this module |
