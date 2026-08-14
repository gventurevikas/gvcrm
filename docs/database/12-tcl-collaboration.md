# Team Collaboration — `gvcrm_tcl`

**Module:** TCL  
**Rules:** Feed/chat/check-in visibility never bypasses CRM record sharing (TCL-SEC-001). Location data is sensitive (TCL-SEC-002).

---

## `feed_posts`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `subject_type` | `VARCHAR(32)` | YES | NULL | Record feed; NULL = user/org wall |
| `subject_id` | `CHAR(26)` | YES | NULL | |
| `author_user_id` | `CHAR(26)` | NO | | |
| `body` | `MEDIUMTEXT` | NO | | |
| `visibility` | `ENUM('record','internal','group')` | NO | `record` | |
| `group_id` | `CHAR(26)` | YES | NULL | When visibility=group |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**Indexes:** `INDEX idx_tcl_feed_subject (org_id, subject_type, subject_id, created_at)`, `INDEX idx_tcl_feed_author (org_id, author_user_id, created_at)`

---

## `feed_comments`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `post_id` | `CHAR(26)` | NO | | |
| `author_user_id` | `CHAR(26)` | NO | | |
| `body` | `TEXT` | NO | | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**FK:** `post_id` → `feed_posts` CASCADE

---

## `feed_likes`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `org_id` | `CHAR(26)` | NO | | |
| `target_type` | `ENUM('post','comment')` | NO | | |
| `target_id` | `CHAR(26)` | NO | | |
| `user_id` | `CHAR(26)` | NO | | |
| `created_at` | `DATETIME(3)` | NO | | |

**PK:** `(target_type, target_id, user_id)`

---

## `feed_follows`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `org_id` | `CHAR(26)` | NO | | |
| `user_id` | `CHAR(26)` | NO | | Follower |
| `subject_type` | `VARCHAR(32)` | NO | | `user`, `account`, `opportunity`, … |
| `subject_id` | `CHAR(26)` | NO | | |
| `created_at` | `DATETIME(3)` | NO | | |

**PK:** `(org_id, user_id, subject_type, subject_id)`

---

## `check_ins`

Field geo event (remote producers).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `user_id` | `CHAR(26)` | NO | | |
| `account_id` | `CHAR(26)` | YES | NULL | ACM |
| `contact_id` | `CHAR(26)` | YES | NULL | |
| `lead_id` | `CHAR(26)` | YES | NULL | |
| `latitude` | `DECIMAL(10,7)` | NO | | |
| `longitude` | `DECIMAL(10,7)` | NO | | |
| `accuracy_m` | `INT` | YES | NULL | |
| `note` | `VARCHAR(512)` | YES | NULL | |
| `checked_in_at` | `DATETIME(3)` | NO | | |
| `created_at` | `DATETIME(3)` | NO | | |

**Indexes:** `INDEX idx_tcl_checkin_user (org_id, user_id, checked_in_at)`, `INDEX idx_tcl_checkin_geo (org_id, latitude, longitude)`  
Retention: shorter than CRM records (document in ops; e.g. 24 months).

---

## `mentions`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `source_type` | `ENUM('feed_post','feed_comment','note','chat_message')` | NO | | |
| `source_id` | `CHAR(26)` | NO | | |
| `mentioned_user_id` | `CHAR(26)` | NO | | |
| `created_at` | `DATETIME(3)` | NO | | |

**Indexes:** `INDEX idx_tcl_mention_user (org_id, mentioned_user_id, created_at)`  
Notification snippet must not include fields the recipient cannot see (TCL-SEC-004).

---

## `chat_threads`

Private messaging (not the AIA assistant).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `title` | `VARCHAR(128)` | YES | NULL | Optional group chat title |
| `kind` | `ENUM('direct','group')` | NO | `direct` | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

---

## `chat_thread_members`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `thread_id` | `CHAR(26)` | NO | | |
| `user_id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `joined_at` | `DATETIME(3)` | NO | | |
| `last_read_at` | `DATETIME(3)` | YES | NULL | |

**PK:** `(thread_id, user_id)`  
**FK:** `thread_id` → `chat_threads` CASCADE

---

## `chat_messages`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `thread_id` | `CHAR(26)` | NO | | |
| `author_user_id` | `CHAR(26)` | NO | | |
| `body` | `MEDIUMTEXT` | YES | NULL | |
| `document_id` | `CHAR(26)` | YES | NULL | Attachment / share link target |
| `created_at` | `DATETIME(3)` | NO | | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

**FK:** `thread_id` → `chat_threads` CASCADE  
**Indexes:** `INDEX idx_tcl_chat_thread_time (thread_id, created_at)`  
Export is admin + audit only (TCL-SEC-003).

---

## `tags`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `name` | `VARCHAR(64)` | NO | | |
| `color` | `VARCHAR(16)` | YES | NULL | Design-system token name, not hex |
| `created_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |

**UNIQUE:** `(org_id, name)`

---

## `tag_assignments`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `org_id` | `CHAR(26)` | NO | | |
| `tag_id` | `CHAR(26)` | NO | | |
| `subject_type` | `VARCHAR(32)` | NO | | |
| `subject_id` | `CHAR(26)` | NO | | |
| `created_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |

**PK:** `(tag_id, subject_type, subject_id)`  
**FK:** `tag_id` → `tags` CASCADE  
**Indexes:** `INDEX idx_tcl_tag_subject (org_id, subject_type, subject_id)`

---

## `auto_tag_rules`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `tag_id` | `CHAR(26)` | NO | | |
| `object_api_name` | `VARCHAR(64)` | NO | | |
| `criteria_json` | `JSON` | NO | | |
| `is_active` | `TINYINT(1)` | NO | 1 | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |

**FK:** `tag_id` → `tags` CASCADE

---

## `user_groups`

Sharing and collaboration sets (also used by PLT `record_shares` grantee_type=group).

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `id` | `CHAR(26)` | NO | | |
| `org_id` | `CHAR(26)` | NO | | |
| `name` | `VARCHAR(128)` | NO | | |
| `description` | `VARCHAR(512)` | YES | NULL | |
| `created_at` | `DATETIME(3)` | NO | | |
| `updated_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |
| `deleted_at` | `DATETIME(3)` | YES | NULL | |

---

## `user_group_memberships`

| Column | Type | Null | Default | Description |
|--------|------|------|---------|-------------|
| `org_id` | `CHAR(26)` | NO | | |
| `group_id` | `CHAR(26)` | NO | | |
| `user_id` | `CHAR(26)` | NO | | IAM user |
| `role_in_group` | `ENUM('member','admin')` | NO | `member` | Membership admin ≠ being a member (TCL-SEC-005) |
| `created_at` | `DATETIME(3)` | NO | | |
| `created_by_user_id` | `CHAR(26)` | YES | NULL | |

**PK:** `(group_id, user_id)`  
**FK:** `group_id` → `user_groups` CASCADE  
**Indexes:** `INDEX idx_tcl_gm_user (org_id, user_id)`
