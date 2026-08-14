#!/usr/bin/env bash
# Rebuild E2E videos with human-like neural TTS (edge-tts) + detailed narration.
set -euo pipefail
export PATH="/opt/homebrew/bin:$PATH"

ROOT="/Users/gyanti/Documents/project/gvcrm/docs/use-cases/e2e-videos"
MOCK="/Users/gyanti/Documents/project/gvcrm/docs/use-cases/mock-screens"
ASSETS="/Users/gyanti/.cursor/projects/Users-gyanti-Documents-project-gvcrm/assets"
VENV="$ROOT/.tts-venv"
EDGE="$VENV/bin/edge-tts"
# Warm, conversational US English neural voice
VOICE="${VOICE:-en-US-AvaNeural}"
RATE="${RATE:--12%}"

OUT="$ROOT"
TITLES="$ROOT/titles"
WORK_ROOT="$ROOT/narrated-build"

if [[ ! -x "$EDGE" ]]; then
  python3 -m venv "$VENV"
  "$VENV/bin/pip" install -q edge-tts
fi

mkdir -p "$TITLES" "$WORK_ROOT"
cp -f "$ASSETS"/E2E-UC-*-title.png "$ASSETS"/E2E-end-card.png "$TITLES/" 2>/dev/null || true
cp -f "$ASSETS"/IAM-UC-*.png "$MOCK/" 2>/dev/null || true

speak() {
  local text="$1" mp3="$2"
  "$EDGE" --voice "$VOICE" --rate="${RATE}" --text "$text" --write-media "$mp3"
}

normalize_jpg() {
  ffmpeg -y -i "$1" \
    -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2:color=0x0f172a" \
    -q:v 2 -frames:v 1 "$2" </dev/null 2>/dev/null
}

make_step() {
  local work="$1" idx="$2" img="$3" text="$4"
  local base jpg mp3 wav mp4 hold
  base=$(printf '%03d' "$idx")
  jpg="$work/${base}.jpg"
  mp3="$work/${base}.mp3"
  wav="$work/${base}.wav"
  mp4="$work/${base}.mp4"

  normalize_jpg "$img" "$jpg"
  speak "$text" "$mp3"
  ffmpeg -y -i "$mp3" -acodec pcm_s16le -ar 44100 -ac 1 "$wav" </dev/null 2>/dev/null
  local dur
  dur=$(ffprobe -v error -show_entries format=duration -of default=nw=1:nk=1 "$wav")
  # Small breath after speech so transitions feel smooth
  hold=$(python3 -c "print(max(3.0, float('$dur') + 0.55))")

  ffmpeg -y -loop 1 -i "$jpg" -i "$wav" \
    -c:v libx264 -tune stillimage -pix_fmt yuv420p -preset veryfast -crf 22 \
    -c:a aac -b:a 192k \
    -af "afade=t=in:st=0:d=0.08,afade=t=out:st=$(python3 -c "print(max(0.1, float('$dur')-0.12))"):d=0.12" \
    -t "$hold" \
    -movflags +faststart \
    "$mp4" </dev/null 2>/dev/null
}

concat_steps() {
  local work="$1" out_mp4="$2"
  local list="$work/concat.txt"
  : > "$list"
  local f
  for f in "$work"/[0-9][0-9][0-9].mp4; do
    printf "file '%s'\n" "$f" >> "$list"
  done
  ffmpeg -y -f concat -safe 0 -i "$list" -c copy "$out_mp4" </dev/null 2>"$work/concat.log"
}

build_journey() {
  local id="$1"; shift
  local work="$WORK_ROOT/$id"
  rm -rf "$work"
  mkdir -p "$work"
  local i=0
  local img text
  while [[ $# -gt 0 ]]; do
    img="$1"; text="$2"; shift 2
    if [[ ! -f "$img" ]]; then
      echo "MISSING image for $id: $img" >&2
      continue
    fi
    echo "  [$id] step $i"
    make_step "$work" "$i" "$img" "$text"
    # save transcript
    printf 'STEP %s\n%s\n\n' "$i" "$text" >> "$work/transcript.txt"
    i=$((i+1))
  done
  local out="$OUT/${id}.mp4"
  concat_steps "$work" "$out"
  cp "$work/transcript.txt" "$OUT/${id}-transcript.txt"
  local dur sz
  dur=$(ffprobe -v error -show_entries format=duration -of default=nw=1:nk=1 "$out")
  sz=$(wc -c < "$out" | tr -d ' ')
  echo "OK $id duration=${dur}s bytes=$sz steps=$i voice=$VOICE"
}

M="$MOCK"
T="$TITLES"
E="$T/E2E-end-card.png"

echo "Neural voice=$VOICE rate=$RATE"
echo "Rebuilding human-like narrated E2E videos..."

# ---------------------------------------------------------------------------
# E2E-UC-001
# ---------------------------------------------------------------------------
build_journey E2E-UC-001 \
  "$T/E2E-UC-001-title.png" "Welcome to GVCRM. This walkthrough is end-to-end journey one: Meta lead to first touch — how a remote insurance producer responds the moment a paid-social lead arrives." \
  "$M/LED-UC-008-meta-linkedin-realtime.png" "It starts on Meta. A prospect submits an Instant Form for auto insurance in Texas. Within seconds, GVCRM ingests the lead with campaign attribution, and the consent snapshot is stored so outreach stays compliant." \
  "$M/LED-UC-002-lead-distribution.png" "Next, assignment takes over. Routing rules look at state, line of business, and license. Round-robin sends the lead to an eligible Texas producer — or to an inside sales agent if producers are unavailable." \
  "$M/INS-UC-004-remote-workspace.png" "Our remote producer is not in an office. Their remote workspace queue lights up with the new Meta lead, ready for immediate first touch." \
  "$M/PLT-UC-015-notifications.png" "At the same time, a push and in-app notification fire. Speed-to-lead is the goal here — ideally under fifteen seconds from form submit to awareness." \
  "$M/INS-UC-005-compliance-hooks.png" "Before any call or text, GVCRM checks TCPA and consent. If the org runs in strict mode and consent is missing, outbound contact is blocked — no shortcuts." \
  "$M/CCM-UC-001-call-reminders.png" "Consent is good, so the producer places the first-touch call directly from CRM. Reminders and call context stay attached to the lead." \
  "$M/CCM-UC-003-call-tagging.png" "After the conversation, the call is logged and tagged — discovery, transfer, appointment set — so managers can coach from a clean timeline." \
  "$M/SPM-UC-005-gamification.png" "That fast response also feeds gamification. Points and streaks reward the behaviors that win remote teams: speed, activity, and follow-through." \
  "$M/SPM-UC-006-leaderboards.png" "Finally, daily leaderboards update. Even without an office floor, the team can see who is winning today on speed-to-lead and related insurance metrics." \
  "$E" "That’s journey one complete: real-time Meta lead, smart assignment, compliant first touch, and motivation on the board."

# ---------------------------------------------------------------------------
# E2E-UC-002
# ---------------------------------------------------------------------------
build_journey E2E-UC-002 \
  "$T/E2E-UC-002-title.png" "Journey two walks the full sell path: convert a qualified lead into a household, build the opportunity, and issue a quote." \
  "$M/LED-UC-007-lead-lifecycle-convert.png" "The producer marks the lead qualified and runs convert. GVCRM creates the account, contact, and a new-business opportunity in one guided step — keeping source lineage intact." \
  "$M/ACM-UC-001-account-360.png" "We land on the account three-sixty. For insurance, this is typically a household view — people, policies, communications, and deals in one place." \
  "$M/INS-UC-002-agency-producer-household.png" "Household members are confirmed, and homeowners is selected as the line of business. Producer license and state context stay visible for routing quality." \
  "$M/PRD-UC-002-product-catalog.png" "From the product catalog, the producer adds the right coverage using the agency price book. List price and product name are snapshotted onto the opportunity lines." \
  "$M/ODM-UC-003-kanban.png" "On the Kanban board, the deal moves through discovery stages. Column totals and swimlanes keep pipeline health obvious at a glance." \
  "$M/CCM-UC-002-call-scheduling.png" "A discovery call is scheduled and logged against the opportunity, so the activity timeline stays complete." \
  "$M/QOC-UC-001-quote-generation.png" "When ready, a quote is generated from the opportunity. Totals are calculated server-side — no client-side tampering — and discounts respect approval thresholds." \
  "$M/DOC-UC-002-file-attachments.png" "The quote PDF is filed on the record as a document attachment, ready for versioning and secure sharing." \
  "$M/CCM-UC-009-email-status.png" "The producer emails the quote. Open and click tracking confirm engagement, and follow-ups can be scheduled from the same thread." \
  "$M/QOC-UC-002-order-generation.png" "When the prospect accepts, GVCRM creates the order or contract draft according to quote-to-cash rules — continuing the path toward bind." \
  "$E" "Journey two complete: lead to household to pipeline to quote — the core insurance sell path."

# ---------------------------------------------------------------------------
# E2E-UC-003
# ---------------------------------------------------------------------------
build_journey E2E-UC-003 \
  "$T/E2E-UC-003-title.png" "Journey three is about protecting the book: renewals, rotting alerts, automated outreach, and leaderboard impact." \
  "$M/INS-UC-003-book-policies-renewals.png" "A policy is approaching term. GVCRM automatically opens a renewal opportunity on the renewal pipeline and links it back to the household and policy record." \
  "$M/ODM-UC-001-opportunity-management.png" "The account manager reviews premium, term dates, and carrier context on that renewal opportunity." \
  "$M/ODM-UC-005-rotting.png" "If nobody works it, rotting rules highlight the deal. Managers get a clear signal before the renewal slips away." \
  "$M/WPA-UC-002-workflow-rules.png" "Workflow automation kicks in — time-based actions can prepare tasks or emails so renewals do not depend on memory alone." \
  "$M/CCM-UC-010-email-templates.png" "A branded renewal template goes out, still consent-checked through Communication, so TCPA and unsubscribe rules are honored." \
  "$M/SPM-UC-006-leaderboards.png" "When the renewal binds, premium and retention metrics flow into the monthly leaderboard for the agency." \
  "$M/INS-UC-006-insurance-kpis.png" "Insurance KPIs — renewals retained, premium bound, bind ratio — stay first-class for coaching and remote motivation." \
  "$E" "Journey three complete: the book of business stays warm, visible, and competitive."

# ---------------------------------------------------------------------------
# E2E-UC-004
# ---------------------------------------------------------------------------
build_journey E2E-UC-004 \
  "$T/E2E-UC-004-title.png" "Journey four covers commercial guardrails: what happens when a quote discount needs approval." \
  "$M/QOC-UC-001-quote-generation.png" "A sales rep is finishing a quote and applies a discount above the agency threshold. The commercial intent is clear — but policy says this needs a second set of eyes." \
  "$M/WPA-UC-004-validation-rules.png" "Save is blocked. Validation and approval rules fire together, so the quote cannot skip governance on the UI or the API." \
  "$M/PLT-UC-015-notifications.png" "The designated approver — manager or finance — gets a real-time notification with a deep link to the request." \
  "$M/WPA-UC-005-approvals.png" "In Approvals, they review the discount, amount, and customer context, then approve or reject with comments. Multi-step chains are supported when needed." \
  "$M/QOC-UC-001-quote-generation.png" "On approval, the quote unlocks for send. The audit trail remains — who asked, who approved, and when." \
  "$E" "Journey four complete: discounts move fast, but never without control."

# ---------------------------------------------------------------------------
# E2E-UC-005
# ---------------------------------------------------------------------------
build_journey E2E-UC-005 \
  "$T/E2E-UC-005-title.png" "Journey five is the morning ritual for remote teams: homepage, conversational reporting, and leaderboards." \
  "$M/IAM-UC-001-login.png" "The producer signs in through Access. Session, roles, and entitled modules come from identity — not from each CRM screen reinventing security." \
  "$M/DAR-UC-001-user-homepage.png" "Homepage loads with what matters today: open leads, renewals due, tasks, alerts, and a leaderboard widget." \
  "$M/SPM-UC-006-leaderboards.png" "Daily, weekly, and monthly boards are published for the agency. Ranks show aggregates — not peer deal details the viewer should not see." \
  "$M/AIA-UC-001-central-chat-shell.png" "From any screen, they open the central ChatGPT-mini assistant — always available, always running as themselves." \
  "$M/AIA-UC-005-conversational-reports.png" "They ask, naturally: show premium bound by producer this month as a bar chart. If details are missing, the assistant asks follow-ups instead of guessing." \
  "$M/DAR-UC-015-conversational-report-engine.png" "Dashboards and Reports executes the structured spec under the user’s security model, and every run is audited in analytics." \
  "$M/DAR-UC-006-charts.png" "The chart appears. They can drill in, export, or save the report for the team." \
  "$M/INS-UC-006-insurance-kpis.png" "Insurance KPIs stay aligned across reporting and gamification, so the morning view matches how the agency actually sells." \
  "$E" "Journey five complete: see the day, ask for insight, act with confidence."

# ---------------------------------------------------------------------------
# E2E-UC-006
# ---------------------------------------------------------------------------
build_journey E2E-UC-006 \
  "$T/E2E-UC-006-title.png" "Journey six shows how teams unstick a deal together — rotting signals, feeds, mentions, and secure document sharing." \
  "$M/ODM-UC-005-rotting.png" "A deal has gone quiet. Rotting criteria flag it: too many days in stage, or no recent activity." \
  "$M/ODM-UC-003-kanban.png" "On the Kanban board, that card stands out so the problem is visible without opening a spreadsheet." \
  "$M/TCL-UC-001-feeds.png" "The rep posts on the opportunity feed — context for anyone who already has access to the record." \
  "$M/TCL-UC-003-mention.png" "They mention their manager. The notification carries a safe snippet — restricted fields stay hidden — and a deep link back to the deal." \
  "$M/PLT-UC-015-notifications.png" "The manager opens the notification center and jumps straight into the conversation." \
  "$M/DOC-UC-003-document-sharing.png" "Meanwhile, the rep shares a proposal with the customer using an encrypted link — expiry, optional password, and revoke anytime. No CRM session for the external viewer." \
  "$M/ODM-UC-006-activity-timeline.png" "Everything lands on the activity timeline. Followers stay in sync as the deal moves again." \
  "$E" "Journey six complete: visibility, collaboration, and secure customer sharing in one flow."

# ---------------------------------------------------------------------------
# E2E-UC-007
# ---------------------------------------------------------------------------
build_journey E2E-UC-007 \
  "$T/E2E-UC-007-title.png" "Journey seven is ask-and-act: the assistant runs business operations as the signed-in user — never as a superuser." \
  "$M/AIA-UC-001-central-chat-shell.png" "Central chat opens with optional record context chips, so the assistant already knows where the producer is working." \
  "$M/AIA-UC-004-business-operations.png" "The producer says: add a homeowners cross-sell on the Smith household. The assistant previews the exact fields and waits for an explicit confirm." \
  "$M/ODM-UC-001-opportunity-management.png" "After confirm, the opportunity is created under that producer’s ownership and permissions. If they could not create it in the UI, chat cannot either." \
  "$M/AIA-UC-004-business-operations.png" "Next request: email them the quote. Risky actions need a clearer confirmation — send is not silent." \
  "$M/CCM-UC-005-direct-email.png" "Communication prepares the message through the normal email path, still attributed to the same user." \
  "$M/INS-UC-005-compliance-hooks.png" "Consent and do-not-contact rules still apply. The assistant cannot bypass TCPA any more than a human screen can." \
  "$M/AIA-UC-009-audit-explainability.png" "Finally, audit and explainability: the user can ask what changed, and admins can review every assistant-initiated write." \
  "$E" "Journey seven complete: helpful, powerful, and safely bounded by the user’s own access."

# ---------------------------------------------------------------------------
# E2E-UC-008
# ---------------------------------------------------------------------------
build_journey E2E-UC-008 \
  "$T/E2E-UC-008-title.png" "Journey eight covers the platform economy: install a free Marketplace app safely — sandbox first, then production." \
  "$M/MKT-UC-001-marketplace-discovery.png" "An admin opens the in-product Marketplace and browses trusted listings — connectors, industry packs, and extensions." \
  "$M/MKT-UC-002-listing-detail.png" "On the listing page they review screenshots, scopes, and publisher details before committing." \
  "$M/PLT-UC-004-sandbox.png" "Install begins in sandbox. Production data and passwords stay untouched while the team evaluates the app." \
  "$M/MKT-UC-003-install-configure.png" "Scopes are consented explicitly. The admin configures the app, tests critical flows, and confirms the package signature is valid." \
  "$M/PLT-UC-005-config-deploy.png" "When ready, they promote to production with a clear consent step. Entitlements update so the right modules appear for users." \
  "$M/MKT-UC-014-platform-apis.png" "Installed apps use scoped OAuth and rate limits. Operators keep a kill switch if something ever looks wrong." \
  "$E" "Journey eight complete: extend GVCRM without compromising the tenant."

# ---------------------------------------------------------------------------
# E2E-UC-009
# ---------------------------------------------------------------------------
build_journey E2E-UC-009 \
  "$T/E2E-UC-009-title.png" "Journey nine is platform craft: customize in sandbox, enforce with validation, and promote cleanly to production." \
  "$M/PLT-UC-004-sandbox.png" "Everything starts in sandbox — an isolated twin of production where experiments are safe." \
  "$M/PLT-UC-006-custom-fields.png" "The admin adds a custom field the insurance process needs, with field-level security set by profile." \
  "$M/PLT-UC-007-custom-layouts.png" "Layouts are updated so the field appears in the right section for the right roles — not a cluttered dump on every page." \
  "$M/WPA-UC-004-validation-rules.png" "A validation rule requires line of business on insurance opportunities. The same rule protects UI saves, API calls, and bulk edits." \
  "$M/PLT-UC-005-config-deploy.png" "A metadata package is reviewed — diff, optional dual control — then deployed to production with rollback retained." \
  "$M/ODM-UC-001-opportunity-management.png" "Reps see the new field immediately. Invalid records cannot save, so process quality improves on day one." \
  "$E" "Journey nine complete: change safely, enforce consistently, ship with confidence."

# ---------------------------------------------------------------------------
# E2E-UC-010
# ---------------------------------------------------------------------------
build_journey E2E-UC-010 \
  "$T/E2E-UC-010-title.png" "Journey ten is the carrier lens: wholesalers see appointed agencies only — pipeline and reports stay inside that boundary." \
  "$M/IAM-UC-001-login.png" "A carrier sales user signs in. Access issues a session scoped to the carrier organization and their entitlements." \
  "$M/INS-UC-001-tenant-orientation.png" "The tenant is oriented for carrier operations — United States defaults, lines of business, and insurance pipelines." \
  "$M/INS-UC-002-agency-producer-household.png" "Appointments define which agencies this wholesaler may see. Producer and agency context stay within that appointed set." \
  "$M/ODM-UC-003-kanban.png" "Pipeline views filter by line of business and state for appointed partners — not the entire market." \
  "$M/DAR-UC-008-deal-reports.png" "Deal reports respect the same sharing model. Non-appointed agency data simply never appears." \
  "$E" "Journey ten complete: carrier visibility without oversharing."

# ---------------------------------------------------------------------------
# E2E-UC-011
# ---------------------------------------------------------------------------
build_journey E2E-UC-011 \
  "$T/E2E-UC-011-title.png" "Journey eleven hardens the front door: verified registration, SMS codes, and Google Authenticator for a more secure way of working." \
  "$M/IAM-UC-007-register-verify.png" "The user activates from invite and verifies email first. Until email is proven, product modules stay closed." \
  "$M/IAM-UC-008-mfa-sms.png" "They verify a mobile number, then enable SMS one-time codes as a second factor — useful for producers in the field." \
  "$M/IAM-UC-012-enroll-authenticator.png" "For a stronger factor, they enroll Google Authenticator: scan the QR once, confirm a live code, and download recovery codes for break-glass access." \
  "$M/IAM-UC-014-security-center.png" "Security Center now shows the healthier posture — verified email, verified phone, SMS and authenticator on, recovery codes ready." \
  "$M/IAM-UC-001-login.png" "Next sign-in starts with email and password as usual — but that is only the first factor when MFA is required." \
  "$M/IAM-UC-009-mfa-totp.png" "The challenge screen asks for the authenticator code — or SMS if that method is enrolled. Password alone never opens the CRM." \
  "$M/DAR-UC-001-user-homepage.png" "Only after every required factor succeeds does the homepage appear. Admins can require this path org-wide so producers cannot skip it." \
  "$E" "Journey eleven complete: human-friendly security that still feels smooth to use every day."

echo ""
echo "==== Human-like narrated videos ===="
ls -lh "$OUT"/E2E-UC-*.mp4
echo "Transcripts:"
ls -1 "$OUT"/E2E-UC-*-transcript.txt | wc -l
