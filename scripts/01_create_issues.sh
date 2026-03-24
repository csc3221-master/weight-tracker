#!/usr/bin/env bash
set -euo pipefail

# scripts/01_create_issues.sh
# Usage:
#   ./scripts/01_create_issues.sh OWNER REPO
# Example:
#   ./scripts/01_create_issues.sh carlosarias weight-track

OWNER="${1:-}"
REPO="${2:-}"
if [[ -z "$OWNER" || -z "$REPO" ]]; then
  echo "Usage: $0 OWNER REPO"
  exit 1
fi

# Helper: create one issue
create_issue () {
  local title="$1"
  local body="$2"
  local milestone="$3"
  local labels_csv="$4"   # comma-separated (gh accepts comma-separated list)

  # If issue already exists with same title, skip (simple guard)
  if gh issue list -R "$OWNER/$REPO" --search "\"$title\" in:title" --json title --jq '.[].title' | grep -Fxq "$title"; then
    echo "SKIP (exists): $title"
    return
  fi

  echo "CREATE: $title"
  gh issue create -R "$OWNER/$REPO" \
    --title "$title" \
    --body "$body" \
    --milestone "$milestone" \
    --label "$labels_csv" >/dev/null
}

# --------------------
# Sprint 0 — Project Setup & Environment
# --------------------

create_issue \
"Sprint 0.1 — Initialize Monorepo Structure" \
$'**Description**\nCreate project structure for frontend (React) and backend (Vercel serverless API).\n\n**Tasks**\n- [ ] Create root repo `weight-track`\n- [ ] Create folder `apps/web`\n- [ ] Create folder `api`\n- [ ] Configure root `package.json` with workspaces\n- [ ] Add `.gitignore`\n- [ ] Add README scaffold\n\n**Acceptance Criteria**\n- Repo builds without errors\n- Folder structure matches architecture plan' \
"Sprint 0" \
"planning,sprint-0"

create_issue \
"Sprint 0.2 — Setup React (Vite) App" \
$'**Tasks**\n- [ ] Create Vite React app in `apps/web`\n- [ ] Install React Router\n- [ ] Configure basic routing\n- [ ] Verify local dev server works\n\n**Acceptance Criteria**\n- App runs at `localhost:5173`\n- Basic “Hello Weight Track” page renders' \
"Sprint 0" \
"frontend,sprint-0"

create_issue \
"Sprint 0.3 — Setup API (Serverless Express-Style)" \
$'**Tasks**\n- [ ] Create `api/health` (ts or js)\n- [ ] Implement Mongo connection utility\n- [ ] Setup environment variables\n- [ ] Install MongoDB driver or Mongoose\n- [ ] Test API route locally via `vercel dev`\n\n**Acceptance Criteria**\n- `/api/health` returns JSON\n- Mongo connection successful' \
"Sprint 0" \
"backend,sprint-0"

create_issue \
"Sprint 0.4 — Setup MongoDB Atlas" \
$'**Tasks**\n- [ ] Create Atlas cluster\n- [ ] Create DB user\n- [ ] Add IP access rules\n- [ ] Add `MONGODB_URI` to `.env.local`\n\n**Acceptance Criteria**\n- API connects to Atlas successfully' \
"Sprint 0" \
"backend,sprint-0"

# --------------------
# Sprint 1 — Core Weight Logging
# --------------------

create_issue \
"Sprint 1.1 — Create WeighIn Data Model" \
$'**Schema Fields**\n- value (number, stored canonical in **pounds**)\n- unit (input unit: `lb | kg`)\n- comment (optional string)\n- recordedAt (date-time, default now)\n- createdAt/updatedAt (timestamps)\n\n**Tasks**\n- [ ] Create schema/model\n- [ ] Add validation (range checks)\n- [ ] Unit conversion helper (kg → lb)\n\n**Acceptance Criteria**\n- Data stored consistently in pounds\n- Invalid values rejected with 400' \
"Sprint 1" \
"backend,sprint-1"

create_issue \
"Sprint 1.2 — Create POST /api/weighins" \
$'**Tasks**\n- [ ] Implement route\n- [ ] Validate input\n- [ ] Convert kg to lb\n- [ ] Save document\n- [ ] Return saved entry\n\n**Acceptance Criteria**\n- Valid submission creates entry\n- Invalid input returns 400' \
"Sprint 1" \
"backend,sprint-1"

create_issue \
"Sprint 1.3 — Create GET /api/weighins" \
$'**Tasks**\n- [ ] Support date range filters (`from`, `to`)\n- [ ] Support `limit` & `offset`\n- [ ] Sort descending by `recordedAt`\n\n**Acceptance Criteria**\n- Returns expected entries\n- Filters/pagination work correctly' \
"Sprint 1" \
"backend,sprint-1"

create_issue \
"Sprint 1.4 — Build “Log Weight” UI" \
$'**Tasks**\n- [ ] Page: “Log Weight”\n- [ ] Weight input\n- [ ] Unit selector (default lb)\n- [ ] Optional comment\n- [ ] Submit handler\n- [ ] Success/error UI states\n\n**Acceptance Criteria**\n- Form saves entry via API\n- UX shows success/failure clearly' \
"Sprint 1" \
"frontend,sprint-1"

create_issue \
"Sprint 1.5 — Build “History” UI" \
$'**Tasks**\n- [ ] Page: “History”\n- [ ] Fetch recent weigh-ins\n- [ ] Display list/table\n- [ ] Date range filter UI\n\n**Acceptance Criteria**\n- Entries list correctly\n- Date filter works' \
"Sprint 1" \
"frontend,sprint-1"

# --------------------
# Sprint 2 — Text Reports
# --------------------

create_issue \
"Sprint 2.1 — Create Summary Report Service" \
$'**Metrics**\n- count of weigh-ins\n- start weight / end weight\n- min / max / average\n- net change (end - start)\n- adherence: days logged vs days in range\n\n**Tasks**\n- [ ] Create report utility/service\n- [ ] Implement weekly calculation\n- [ ] Implement monthly calculation\n- [ ] Implement “since start”\n- [ ] Implement custom date range\n\n**Acceptance Criteria**\n- Metrics correct for each range\n- Handles empty/no-data ranges gracefully' \
"Sprint 2" \
"backend,reporting,sprint-2"

create_issue \
"Sprint 2.2 — Create GET /api/reports/summary" \
$'**Tasks**\n- [ ] Implement endpoint\n- [ ] Accept `range=week|month|all|custom`\n- [ ] Accept `from`/`to` for custom\n- [ ] Return structured JSON\n\n**Acceptance Criteria**\n- Endpoint returns correct metrics across ranges\n- Invalid params return 400' \
"Sprint 2" \
"backend,reporting,sprint-2"

create_issue \
"Sprint 2.3 — Build Reports Page (Text)" \
$'**Tasks**\n- [ ] Page: “Reports”\n- [ ] Preset buttons (Week / Month / Since Start)\n- [ ] Custom date range picker\n- [ ] Render readable text report (copy/paste friendly)\n\n**Acceptance Criteria**\n- Reports render correctly for all ranges\n- Custom range works' \
"Sprint 2" \
"frontend,reporting,sprint-2"

# --------------------
# Sprint 3 — Graphs & Trend Detection
# --------------------

create_issue \
"Sprint 3.1 — Add Chart Library + Basic Weight Chart" \
$'**Tasks**\n- [ ] Choose chart library (Chart.js or Recharts)\n- [ ] Line chart of weight over time\n- [ ] Tooltips & readable axes\n- [ ] Range selection integrates with reports page filters\n\n**Acceptance Criteria**\n- Chart renders for week/month/all/custom\n- Handles no-data ranges gracefully' \
"Sprint 3" \
"frontend,charts,sprint-3"

create_issue \
"Sprint 3.2 — Add Moving Average Overlay" \
$'**Tasks**\n- [ ] Compute 7-day moving average (or last N weigh-ins)\n- [ ] Overlay moving average on chart\n- [ ] Legend/label for clarity\n\n**Acceptance Criteria**\n- Moving average correct\n- Overlay toggles or displays clearly' \
"Sprint 3" \
"frontend,charts,sprint-3"

create_issue \
"Sprint 3.3 — Implement Trend Detection + Highlighting" \
$'**Approach (simple + useful)**\n- Linear regression slope over last N points (e.g., 7 or 14) OR\n- Compare moving average windows\n\n**Tasks**\n- [ ] Compute trend signal (Up/Down/Flat)\n- [ ] Add badge (“Trending Up/Down/Flat”)\n- [ ] Add small explanation (slope value or delta)\n\n**Acceptance Criteria**\n- Trend classification matches data\n- UI clearly communicates trend' \
"Sprint 3" \
"frontend,charts,sprint-3"

# --------------------
# Sprint 4 — UX Polish + Bootstrap
# --------------------

create_issue \
"Sprint 4.1 — Integrate Bootstrap & Layout" \
$'**Tasks**\n- [ ] Add Bootstrap (or React-Bootstrap)\n- [ ] App layout container\n- [ ] Navbar with routes: Log, History, Reports\n- [ ] Responsive spacing/typography\n\n**Acceptance Criteria**\n- UI is responsive\n- Navigation works cleanly' \
"Sprint 4" \
"frontend,sprint-4"

create_issue \
"Sprint 4.2 — UX Improvements (Loading/Errors/Empty States)" \
$'**Tasks**\n- [ ] Loading indicators for API calls\n- [ ] Error toasts/messages\n- [ ] Empty states (no weigh-ins yet)\n- [ ] Basic form validation UX\n\n**Acceptance Criteria**\n- No raw errors displayed\n- App feels smooth and robust' \
"Sprint 4" \
"frontend,sprint-4"

create_issue \
"Sprint 4.3 — Edit/Delete Weigh-Ins" \
$'**Tasks**\n- [ ] Backend: PATCH /api/weighins/:id\n- [ ] Backend: DELETE /api/weighins/:id\n- [ ] Frontend: edit modal/form\n- [ ] Frontend: delete confirmation\n\n**Acceptance Criteria**\n- User can edit and delete entries\n- History view updates immediately after changes' \
"Sprint 4" \
"frontend,backend,sprint-4"

# --------------------
# Sprint 5 — Deployment on Vercel
# --------------------

create_issue \
"Sprint 5.1 — Configure Vercel Project & Environments" \
$'**Tasks**\n- [ ] Connect GitHub repo to Vercel\n- [ ] Configure environment variables (MONGODB_URI)\n- [ ] Confirm Preview Deployments on PRs\n- [ ] Confirm Production deploy from main\n\n**Acceptance Criteria**\n- App accessible via Vercel URL\n- API + UI both functional in production' \
"Sprint 5" \
"deployment,sprint-5"

create_issue \
"Sprint 5.2 — Optimize Mongo Connection for Serverless" \
$'**Tasks**\n- [ ] Implement connection caching (reuse client between invocations)\n- [ ] Avoid opening new connection per request\n- [ ] Add simple DB ping utility\n\n**Acceptance Criteria**\n- No connection exhaustion/timeouts under normal use\n- Stable API response times' \
"Sprint 5" \
"backend,deployment,sprint-5"

create_issue \
"Sprint 5.3 — Production Health Check & Smoke Tests" \
$'**Tasks**\n- [ ] Expand /api/health to include DB connectivity\n- [ ] Smoke test key flows in production:\n  - [ ] Create weigh-in\n  - [ ] View history\n  - [ ] Run report\n  - [ ] View chart\n\n**Acceptance Criteria**\n- Health endpoint reflects DB status\n- All core flows verified in production' \
"Sprint 5" \
"deployment,backend,frontend,sprint-5"

# --------------------
# Sprint 6 — Photo OCR (Stretch)
# --------------------

create_issue \
"Sprint 6.1 — Camera Capture UI (Mobile-Friendly)" \
$'**Tasks**\n- [ ] Add “Capture photo” input (mobile-friendly)\n- [ ] Show preview\n- [ ] Retake option\n- [ ] Prepare image for upload\n\n**Acceptance Criteria**\n- User can capture/attach image and preview it' \
"Sprint 6" \
"frontend,stretch,sprint-6"

create_issue \
"Sprint 6.2 — OCR/Vision Integration (Extract Weight)" \
$'**Tasks**\n- [ ] Choose OCR provider (cloud vision / OCR API)\n- [ ] API route to accept image and call OCR\n- [ ] Parse likely weight value (e.g., ###.#)\n- [ ] Return candidates + confidence\n\n**Acceptance Criteria**\n- Endpoint returns a reasonable suggested weight for clear images\n- Handles failures gracefully' \
"Sprint 6" \
"backend,stretch,sprint-6"

create_issue \
"Sprint 6.3 — Confirmation UX (Suggest → User Confirms → Save)" \
$'**Tasks**\n- [ ] Show suggested value + confidence\n- [ ] Allow user edit/correct\n- [ ] Save confirmed value as weigh-in\n\n**Acceptance Criteria**\n- User always confirms before saving\n- Saved entry matches confirmed value' \
"Sprint 6" \
"frontend,stretch,sprint-6"

echo "Done creating issues (Sprints 0–6)."
