# Team Collaboration

**Document ID:** GVCRM-REQ-TCL  
**Version:** 1.0  
**Status:** Draft for implementation  
**Module:** Team Collaboration  
**This document is independent.** Related modules are listed only as dependencies.

---

## 1. Purpose

Help sales teams **work together inside the CRM**: share updates in a feed, mention colleagues, chat privately, tag records, check in from the field, and organize user groups for sharing.

## 2. Scope

**In scope**

- Collaboration feed (announcements, groups, attachments, comments, likes, multi-channel updates)
- Geo-tagging / field check-in
- Mentions in notes and posts
- Private chat with ability to share records
- Tags (manual and automatic) for search, sort, filter, segment
- User groups for shared characteristics and shared CRM records

**Out of scope**

- Full Slack replacement for the whole company — private chat is CRM-contextual
- Document repository ACLs — Documents Management (feed can share links/files)
- Gamification points for likes/comments — Sales Performance consumes events from here

## 3. Users

| Persona | Typical actions |
|---------|-----------------|
| Sales representative | Post updates, chat, tag records, mention AE/SE |
| Field representative | Check in at client site |
| Sales manager | Announcements, group membership, shared records |
| Sales ops | Auto-tag rules, group definitions |
| Cross-functional stakeholder | Invited to private chat / record share |

## 4. Business objectives

- Reduce “what happened on this account?” questions in email
- Keep field location awareness for safety and coordination
- Faster routing via tags and groups
- Secure internal collaboration without leaking CRM data to consumer chat apps by default

---

## 5. Functional requirements

### 5.1 Feeds

**Source capability:** Feeds  
**Priority:** P0  
**ID:** TCL-FR-001

The solution shall provide a feed forum for sales representatives to share announcements, follow updates, create team groups, share attachments and collateral, and stay notified of changes in real time. Users shall get updates from various channels and be able to comment and like posts.

**User story**  
As a sales representative, I want a team feed where my manager posts announcements and I can comment, like, and attach a deck.

**Detailed requirements**

1. Feed types: org-wide (permissioned), team/group feeds, record feeds (account/opportunity/lead/contact auto-posts for followed records).
2. Post types: text, announcement (pinned), attachment/collateral, record link, system update from channels (e.g. stage change, case opened) if user follows that record.
3. Comment and like on posts; comment threads.
4. Follow/unfollow users, groups, and records.
5. Real-time updates (new posts/comments/likes) for online users; notifications per Platform preferences.
6. Create collaboration groups (distinct from or linked to User Groups in TCL-FR-006).
7. Moderation: delete/edit own posts; managers/admins can moderate announcements; audit.
8. Search feed posts the user is allowed to see.

**Acceptance criteria**

- A group announcement appears at the top of that group’s feed for members.
- Liking and commenting update counts in real time for open feed views.
- Sharing an attachment from Documents respects document permissions for viewers.
- System channel update (e.g. deal stage change) can appear on the record feed when enabled.
- Non-members cannot see a private group feed.

---

### 5.2 Geo-tagging

**Source capability:** GeoTagging  
**Priority:** P1  
**ID:** TCL-FR-002

The solution shall enable field representatives to check in their locations for client meetings so other team members stay informed.

**User story**  
As a field AE, I want to check in at the customer office so my manager knows I arrived.

**Detailed requirements**

1. Check-in action from mobile (and desktop if location available): capture lat/long, timestamp, accuracy, optional note, related account/contact/appointment.
2. Visibility: owner, manager, account team, and configured groups — not the whole org by default.
3. Check-in appears on the record timeline and optionally on the team feed.
4. Map of today’s team check-ins for managers (respect sharing).
5. User consent for location access; works only when permission granted.
6. Manual check-out optional; stale check-ins auto-expire.

**Acceptance criteria**

- Successful check-in stores coordinates and related record and notifies configured teammates.
- Manager map shows only permitted reps.
- Denying OS location permission shows a clear fallback (manual address note) rather than a silent failure.
- Check-in cannot be edited to a fake past time without audit (if time override allowed, it is logged).

---

### 5.3 Mention

**Source capability:** Mention  
**Priority:** P0  
**ID:** TCL-FR-003

The solution shall provide the ability to mention team members in notes and posts.

**User story**  
As an AE, I want to type @Priya in a deal note so she is notified and can jump to the record.

**Detailed requirements**

1. @mention autocomplete in notes, feed posts, comments, and (optional) chat.
2. Only users the author is allowed to mention (org users; external portal users out of scope unless later enabled).
3. Mention creates a notification with deep link to the note/post and parent record.
4. Mentioned user gains no extra record access automatically (optional “request access” prompt if they cannot open the record).
5. Display mentioned names as chips linking to the user profile.

**Acceptance criteria**

- Mentioning a user sends them a real-time notification.
- If they lack record access, they see a restricted message + optional access request, not the note body in the email teaser.
- Autocomplete filters by name/email and active users.

---

### 5.4 Private chat

**Source capability:** Private Chat  
**Priority:** P1  
**ID:** TCL-FR-004

The solution shall provide private chat to collaborate and share sales updates and records with internal stakeholders.

**User story**  
As an AE, I want a 1:1 or small-group chat with SE and manager where I can drop the opportunity link and discuss privately.

**Detailed requirements**

1. 1:1 and small group chats (internal users only for MVP).
2. Messages: text, emoji, record cards (lead/contact/account/opportunity/quote), file/share links.
3. Record card preview respects each viewer’s CRM permissions (no preview leakage).
4. Unread counts, mute, search within a thread.
5. Optional: create a task from a chat message.
6. Retention policy configurable; export for compliance (admin).
7. Not a public channel list — chats are invitation-only.

**Acceptance criteria**

- Two users can exchange messages in real time when both online; offline messages deliver on reconnect.
- Sharing an opportunity card shows title/amount only if the recipient can read the opportunity; otherwise a “no access” card.
- Leaving a group chat stops new messages for that user.
- Admin can export a chat for a legal hold case.

---

### 5.5 Tags

**Source capability:** Tags  
**Priority:** P0  
**ID:** TCL-FR-005

The solution shall allow adding tags automatically or manually to categorize records with specific keywords that help identify, search, sort, filter, and segment those records.

**User story**  
As sales ops, I want to auto-tag inbound leads as “enterprise” when revenue > X, and let AEs add “hot” manually for filtering.

**Detailed requirements**

1. Manual tags on major objects and custom modules: add/remove, autocomplete, create new if permitted.
2. Automatic tags via rules (field criteria, source, score, product, workflow action).
3. Tags used in search, list sort/filter, reports, campaigns, and segments.
4. Admin tag governance: rename, merge, restrict creation, color.
5. Personal vs shared tag namespaces optional (default: org-shared taxonomy + personal labels P2).

**Acceptance criteria**

- Filtering contacts by tag “VIP” returns only tagged records.
- Auto-tag rule applies on create/update when criteria match.
- Merging tags “VIP” and “vip-customer” updates all records.
- Search by tag keyword finds records.

---

### 5.6 User groups

**Source capability:** User Groups  
**Priority:** P0  
**ID:** TCL-FR-006

The solution shall allow creating multiple user groups based on shared characteristics and facilitate sharing common CRM records.

**User story**  
As an admin, I want a “West Enterprise AEs” group to share a set of accounts and use it in assignment and group scheduling.

**Detailed requirements**

1. User group: name, description, members (static and/or rule-based: role, territory, profile).
2. Use groups for: record sharing (read/write), feed membership, assignment queues, group appointment scheduling, report folders, dashboard share, chat @group mention (P1).
3. Nested groups optional (P2); MVP is flat groups.
4. Membership changes are audited; rule-based membership recalculates on user attribute change.
5. A user may belong to many groups.

**Acceptance criteria**

- Sharing an account with a group grants all current members access per the share reason.
- Adding a user to the group grants them access to group-shared records without re-sharing each record.
- Removing a user revokes group-based access but not access they have via other reasons (owner/role).
- Rule-based group “territory = West” auto-includes a newly tagged West user.

---

## 6. Data entities

| Entity | Purpose |
|--------|---------|
| Feed / FeedPost / FeedComment / FeedLike | Collaboration stream |
| FeedFollow | Follow relationship |
| CheckIn | Field geo event |
| Mention | Reference + notification |
| ChatThread / ChatMessage | Private messaging |
| Tag / TagAssignment / AutoTagRule | Taxonomy |
| UserGroup / UserGroupMembership | Sharing and collaboration sets |

## 7. Integrations

| ID | Integration | Purpose |
|----|-------------|---------|
| TCL-INT-001 | Device location services | Check-in |
| TCL-INT-002 | Maps | Manager check-in map |
| TCL-INT-003 | Platform notifications | Mentions, feed, chat |
| TCL-INT-004 | Documents | Attachments and share links in feed/chat |
| TCL-INT-005 | Record sharing engine | Group-based shares |
| TCL-INT-006 | Optional Slack/Teams connectors (Marketplace) | Mirror notifications |

## 8. Permissions and security

| ID | Requirement |
|----|-------------|
| TCL-SEC-001 | Feed, chat, and check-in visibility never bypass CRM record sharing. |
| TCL-SEC-002 | Location data is sensitive; retention and access are limited and documented. |
| TCL-SEC-003 | Chat export is admin + audit only. |
| TCL-SEC-004 | @mention email/push snippets must not include record fields the recipient cannot see. |
| TCL-SEC-005 | Group membership admin is permissioned separately from being a member. |

## 9. Non-functional requirements

| ID | Requirement |
|----|-------------|
| TCL-NFR-001 | Chat/feed message P95 delivery < 2s for online users in the same region. |
| TCL-NFR-002 | Check-in save P95 < 1s plus location acquire time. |
| TCL-NFR-003 | Tag filter on 1M records uses indexes; P95 < 1s for common tags. |
| TCL-NFR-004 | Group share recalculation for +1 member on 10k shared records completes asynchronously with progress if needed. |

## 10. Dependencies

| Module | Why |
|--------|-----|
| Accounts, Contacts, Leads, Opportunities | Record feeds, tags, shares, check-in targets |
| Documents | Attachments/collateral |
| Platform | Notifications, notes, custom modules tagging |
| Accounts (scheduling) | User groups for group appointment URLs |
| Sales Performance | Gamification events from likes/comments/posts |
| Workflows | Auto-tag actions |
| Marketplace | Chat/feed connector apps |

## 11. Traceability

| Source capability | Requirement IDs |
|-------------------|-----------------|
| Feeds | TCL-FR-001 |
| GeoTagging | TCL-FR-002 |
| Mention | TCL-FR-003 |
| Private Chat | TCL-FR-004 |
| Tags | TCL-FR-005 |
| User Groups | TCL-FR-006 |
