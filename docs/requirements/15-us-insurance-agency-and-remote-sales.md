# US Insurance Agency, Carrier, and Remote Sales

**Document ID:** GVCRM-REQ-INS  
**Version:** 1.0  
**Status:** Draft for implementation  
**Module:** US Insurance Agency and Remote Sales  
**This document is independent.** Related modules are listed only as dependencies.

---

## 1. Purpose

Orient GVCRM to **United States insurance agencies** and **insurance companies (carriers)**, with **remote, sales-first producers** as the primary users. Agents often work from home or the field, not a shared office. The product must help them win and keep book-of-business: fast inbound leads (including **Meta and LinkedIn**), insurance-aware pipelines, remote collaboration, and **daily / weekly / monthly leaderboards** so distributed teams stay motivated.

GVCRM is a **sales CRM for insurance**, not a full policy-administration or rating engine. Policies, renewals, and carrier appointments are tracked for sales and service; quoting/binding with carriers may be extended via Marketplace apps.

## 2. Scope

**In scope**

- Tenant modes: independent / captive **agency**, **MGA/IMO**, and **carrier** sales organizations in the USA
- Producer (agent), agency hierarchy, households, lines of business, book of business, renewals
- US-centric defaults: USD, state/ZIP, time zones, English
- Remote-agent workspace: homepage, mobile, notifications, central chat, check-in
- Insurance-oriented pipelines (new business, cross-sell, renewal)
- License / NPN / state appointment **tracking and reminders** (not a regulator system of record)
- Marketing and sales compliance hooks (TCPA, DNC, consent) for US insurance outreach
- Vertical KPIs that feed **daily, weekly, and monthly leaderboards**

**Out of scope**

- ISO/NCCI rating, underwriting workbenches, claims adjudication, billing/commission accounting ERPs
- State DOI license issuance (store NPN/license data and expiry alerts only)
- Building Meta Ads Manager or LinkedIn Campaign Manager UIs (ingest leads and attribute campaigns)

## 3. Users

| Persona | Typical US insurance context |
|---------|------------------------------|
| Remote producer / agent | Works from home or field; lives on mobile + chat; needs instant Meta/LinkedIn leads |
| Agency principal / sales manager | Book growth, producer leaderboards, renewals, carrier mix |
| Inside sales / ISA | Speed-to-lead on ad forms, call/SMS, appointment set for producers |
| Carrier sales / wholesaler | Appointed agencies, pipeline by LOB and state |
| Marketing ops | Meta + LinkedIn campaigns, consent, UTM, ROI |
| Compliance / ops | DNC, TCPA, license expiry, E&O reminders |

## 4. Business objectives

- Fit how **US insurance sales** actually works (LOB, household, renewal, carrier)
- Keep **remote agents** productive without an office floor
- Cut speed-to-lead on paid social (Meta, LinkedIn)
- Make performance visible with **published daily, weekly, and monthly leaderboards**
- Grow premium and policies, not only generic “deal amount”

---

## 5. Functional requirements

### 5.1 US insurance tenant orientation

**Priority:** P0  
**ID:** INS-FR-001

The solution shall ship with US insurance agency and carrier orientation: labels, default pipelines, LOBs, and USD/state defaults.

**Detailed requirements**

1. Org type: Independent agency, Captive agency, MGA/IMO, Carrier sales team, Other.
2. Default currency **USD**; address model includes US state and ZIP+4 optional.
3. Default language **en-US**; multi-language still available (Platform).
4. Pre-built pipelines: New Business, Cross-sell / Upsell, Renewal, and optional Carrier Appointment.
5. Pre-built LOBs (configurable): Personal Auto, Homeowners, Renters, Umbrella, Life, Health/Medicare, Disability, Commercial Auto, BOP, GL, Workers Comp, Cyber, Other.
6. Homepage widgets for remote agents: my new leads (esp. Meta/LinkedIn), today’s tasks/calls, rotting quotes, renewals due, **today’s leaderboard rank**.

**Acceptance criteria**

- A new US agency org sees insurance pipelines and LOBs without custom setup.
- Creating a contact/account captures state and ZIP.
- Agent homepage shows inbound ad leads and personal leaderboard position.

---

### 5.2 Agency, producer, and household model

**Priority:** P0  
**ID:** INS-FR-002

The solution shall model insurance selling structures on top of Accounts and Contacts.

**Detailed requirements**

1. **Agency** (Account subtype or record type): agency name, principal, states served, appointed carriers, book size.
2. **Producer / agent** (User + Contact optional): NPN, licensed states, lines authorized, remote vs office flag, timezone.
3. **Carrier** (Account subtype): NAIC code optional, appointment status, products/LOBs offered.
4. **Household / commercial insured** (Account): members as Contacts; primary named insured.
5. Agency hierarchy uses Account Hierarchy (parent agency / branches / writing agents).
6. Assignment of leads/deals can use licensed state + LOB + producer availability (remote/OOO).

**Acceptance criteria**

- A household account can have multiple contacts (spouse, driver) linked.
- Lead routing can require “licensed in lead’s state” + LOB = Auto.
- Carrier account lists appointed agencies without mixing them into household accounts.

---

### 5.3 Book of business, policies, and renewals (CRM, not PAS)

**Priority:** P0  
**ID:** INS-FR-003

The solution shall track policies and renewals for sales and service, using Products, Opportunities, and Quotes/Contracts as needed.

**Detailed requirements**

1. **Policy** record (custom module or standard object): policy number, LOB, carrier, insured account/contact, premium, effective/expiration dates, status (quoted, bound, in-force, cancelled, non-renewed), writing producer.
2. Policies attach to Account 360° as **book of business**.
3. **Renewal** opportunity auto-created N days before expiration (configurable, e.g. 60/90).
4. Cross-sell prompts: household with Auto but no Homeowners (playbook + assistant suggestion).
5. Premium and policy count roll into goals, forecasts, and leaderboards (not only generic amount).
6. Documents: declarations, applications, ACORD-style PDFs as attachments (storage only).

**Acceptance criteria**

- In-force policies appear on the insured’s account.
- A policy expiring in 90 days creates a Renewal opportunity for the writing producer.
- Leaderboard metric “Premium bound this week” uses policy/opportunity premium fields.

---

### 5.4 Remote sales workspace

**Priority:** P0  
**ID:** INS-FR-004

Because agents work in **remote spaces**, the solution shall optimize for distributed sales: mobile, notifications, chat, and no dependency on being in the office.

**Detailed requirements**

1. Mobile-friendly agent workspace: queue, dial/SMS, schedule, leaderboard, new ad leads.
2. Real-time push/in-app alerts for new Meta/LinkedIn leads, @mentions, rotting quotes, license expiry.
3. Central ChatGPT-mini assistant with insurance starter prompts (INS + AIA).
4. Availability / OOO for remote producers so round-robin skips offline agents.
5. Optional geo check-in for client visits (Team Collaboration) without requiring daily office presence.
6. Group scheduling URLs for agency ISAs vs producers.

**Acceptance criteria**

- A remote agent on mobile is notified of a new Meta lead and can call/SMS from the record.
- OOO producer is skipped in round-robin.
- Assistant prompt “Show my renewals this month” works for the logged-in producer.

---

### 5.5 US insurance sales compliance hooks

**Priority:** P0  
**ID:** INS-FR-005

The solution shall support common **US insurance marketing/sales** compliance needs at CRM level.

**Detailed requirements**

1. Consent fields: TCPA call/SMS, email opt-in, recording consent; source + timestamp.
2. Honour DNC / do-not-contact on Communication and Assistant sends.
3. Store lead source (Meta/LinkedIn/web) with campaign for advertising record-keeping.
4. License/appointment expiry reminders for producers (NPN, state, LOB).
5. Disclaimer: GVCRM does not replace legal/compliance review; orgs configure state-specific rules.

**Acceptance criteria**

- SMS to a number without TCPA consent is blocked with an explanation.
- Producer license expiring in 30 days creates a reminder for the producer and principal.
- Meta/LinkedIn lead retains original form consent flags when mapped.

---

### 5.6 Insurance KPIs for gamification and reporting

**Priority:** P0  
**ID:** INS-FR-006

The solution shall expose insurance-relevant KPIs used by **daily, weekly, and monthly leaderboards** and dashboards.

**Minimum KPI catalog**

| KPI | Typical use |
|-----|-------------|
| New leads (all / Meta / LinkedIn) | Daily hustle |
| Speed-to-lead (first touch) | Quality of remote response |
| Quotes issued | Activity |
| Premium bound / policies bound | Production |
| Bind ratio (quote → bind) | Effectiveness |
| Cross-sells | Book growth |
| Renewals retained | Retention |
| Calls / talk time / appointments set | Activity leaderboard |
| Points (gamification rules) | Overall game |

**Acceptance criteria**

- Each KPI is available for D/W/M leaderboards and custom reports.
- Meta vs LinkedIn lead counts are separable.
- Speed-to-lead uses first human activity after lead create.

---

### 5.7 Vertical packaging

**Priority:** P1  
**ID:** INS-FR-007

US insurance configuration (pipelines, LOBs, layouts, playbooks, leaderboard templates, Meta/LinkedIn mappings) shall be deliverable as a **Marketplace industry pack** installable into a new org.

**Acceptance criteria**

- Installing the “US Insurance Agency” pack creates default LOBs, pipelines, and leaderboard templates.
- Pack can be upgraded without deleting customer data.

---

## 6. Data entities

| Entity | Purpose |
|--------|---------|
| OrgInsuranceProfile | Agency vs carrier mode, states, defaults |
| LineOfBusiness | LOB catalog |
| ProducerProfile | NPN, licenses, states, remote flag |
| CarrierAppointment | Agency ↔ carrier + LOB + status |
| Policy | Book-of-business CRM record |
| HouseholdMember | Contact role on insured account |
| InsuranceKpiSnapshot | Pre-aggregated D/W/M metrics |

## 7. Integrations

| ID | Integration | Purpose |
|----|-------------|---------|
| INS-INT-001 | Accounts, Contacts, Users | Agency / household / producer |
| INS-INT-002 | Leads | Meta/LinkedIn + state/LOB routing |
| INS-INT-003 | Opportunities / Quotes | New business, cross-sell, renewal |
| INS-INT-004 | Sales Performance | Goals, campaigns, D/W/M leaderboards |
| INS-INT-005 | Communication | TCPA/DNC-aware outreach |
| INS-INT-006 | AI Assistant | Remote agent operations and reports |
| INS-INT-007 | Marketplace | Comparative rater / AMS / carrier apps; insurance pack |
| INS-INT-008 | Documents | Applications, dec pages, ACORD PDFs |

## 8. Permissions and security

| ID | Requirement |
|----|-------------|
| INS-SEC-001 | Producers see their book; principals see agency; carriers see appointed-agency data only as configured. |
| INS-SEC-002 | NPN and license documents are sensitive PII. |
| INS-SEC-003 | Policy numbers and insured PII follow US data-retention and access policies. |
| INS-SEC-004 | Consent and DNC apply to all outbound channels including Assistant. |

## 9. Non-functional requirements

| ID | Requirement |
|----|-------------|
| INS-NFR-001 | Remote agent homepage P95 < 2s on typical mobile network after first load cache. |
| INS-NFR-002 | Insurance pack install is idempotent. |
| INS-NFR-003 | KPI snapshots for leaderboards refresh at least every 5 minutes (near real time for today’s board). |

## 10. Dependencies

| Module | Why |
|--------|-----|
| Accounts and Contacts | Households, agencies, carriers, hierarchy |
| Leads | Meta/LinkedIn real-time capture and state/LOB assignment |
| Opportunities / Quotes / Products | New business, renewals, LOB products |
| Sales Performance | Campaigns + complete gamification leaderboards |
| Customer Communication | Calls/SMS/email with TCPA |
| Team Collaboration | Remote check-in, tags, groups |
| Platform | Record types, custom module Policy, USD, notifications |
| Dashboards and Reports | Insurance dashboards |
| AI Assistant | Remote “ask & act” |
| Marketplace | Industry pack and carrier/rater apps |
| Workflows | Renewal create, license expiry, assignment |

## 11. Traceability

| Capability | Requirement IDs |
|------------|-----------------|
| US agency / carrier orientation | INS-FR-001, INS-FR-002 |
| Book of business / renewals | INS-FR-003 |
| Remote sales workspace | INS-FR-004 |
| US compliance hooks | INS-FR-005 |
| Insurance KPIs + leaderboard metrics | INS-FR-006 |
| Industry pack | INS-FR-007 |
| Meta / LinkedIn real-time leads | LED-FR-008 (Leads spec) |
| Daily / weekly / monthly leaderboards | SPM-FR-005, SPM-FR-006 (Sales Performance spec) |
