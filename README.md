# Weight Track — Development Plan

## Tech Stack

- Frontend: React (Vite)
- Backend: Vercel Serverless API (Express-style structure)
- Database: MongoDB Atlas
- Deployment: Vercel
- UI Framework: Bootstrap (optional polish)

---

# Sprint 0 — Project Setup & Environment

## Issue 0.1 — Initialize Monorepo Structure
- Create root repo `weight-track`
- Create folder `apps/web`
- Create folder `api`
- Configure root `package.json` with workspaces
- Add `.gitignore`
- Add README scaffold

Acceptance Criteria:
- Repo builds without errors
- Folder structure matches architecture plan

---

## Issue 0.2 — Setup React (Vite) App
- Create Vite React app in `apps/web`
- Install React Router
- Configure basic routing
- Verify local dev server works

Acceptance Criteria:
- App runs at localhost:5173
- Basic page renders

---

## Issue 0.3 — Setup API
- Create `/api/health`
- Implement Mongo connection utility
- Setup environment variables
- Install MongoDB driver or Mongoose
- Test API locally

Acceptance Criteria:
- `/api/health` returns JSON
- Mongo connection successful

---

## Issue 0.4 — Setup MongoDB Atlas
- Create Atlas cluster
- Create DB user
- Add IP access rules
- Add `MONGODB_URI` to `.env.local`

Acceptance Criteria:
- API connects successfully

---

# Sprint 1 — Core Weight Logging

## Issue 1.1 — Create WeighIn Model
Fields:
- value (stored in pounds)
- unit (lb | kg)
- comment
- recordedAt
- createdAt

Tasks:
- Create schema
- Add validation
- Unit conversion helper

Acceptance Criteria:
- Data stored consistently in pounds

---

## Issue 1.2 — POST /api/weighins
- Validate input
- Convert kg → lb
- Save document
- Return saved entry

Acceptance Criteria:
- Valid submission creates entry
- Invalid input returns 400

---

## Issue 1.3 — GET /api/weighins
- Support date filters
- Support pagination
- Sort descending

Acceptance Criteria:
- Filters work correctly

---

## Issue 1.4 — Log Weight UI
- Weight input
- Unit selector
- Comment field
- Submit handler
- Success/error states

Acceptance Criteria:
- Entry saved and visible

---

## Issue 1.5 — History Page
- Fetch weigh-ins
- Display table
- Date filter UI

Acceptance Criteria:
- Entries list correctly

---

# Sprint 2 — Text Reports

## Issue 2.1 — Summary Report Service
Metrics:
- count
- min
- max
- average
- start weight
- end weight
- net change
- adherence %

Acceptance Criteria:
- Report accurate

---

## Issue 2.2 — GET /api/reports/summary
- Accept range param
- Accept custom range
- Return structured JSON

Acceptance Criteria:
- Endpoint returns correct metrics

---

## Issue 2.3 — Reports Page
- Preset buttons
- Custom date picker
- Render formatted report

Acceptance Criteria:
- Report readable and accurate

---

# Sprint 3 — Graphs & Trend Detection

## Issue 3.1 — Add Chart Library
- Install chart lib
- Create line chart
- Add tooltips

Acceptance Criteria:
- Chart renders properly

---

## Issue 3.2 — Add Moving Average
- Compute 7-day moving average
- Overlay on chart

Acceptance Criteria:
- Moving average accurate

---

## Issue 3.3 — Implement Trend Detection
- Compute slope
- Classify Up/Down/Flat
- Display badge

Acceptance Criteria:
- Trend classification correct

---

# Sprint 4 — UX & Bootstrap Polish

## Issue 4.1 — Integrate Bootstrap
- Install Bootstrap
- Create layout container
- Create navbar

Acceptance Criteria:
- UI responsive and clean

---

## Issue 4.2 — Improve UX States
- Loading spinners
- Error toasts
- Empty states

Acceptance Criteria:
- No raw errors shown

---

## Issue 4.3 — Edit/Delete
- Implement PATCH endpoint
- Implement DELETE endpoint
- Add edit modal

Acceptance Criteria:
- User can modify entries

---

# Sprint 5 — Deployment

## Issue 5.1 — Configure Vercel
- Connect GitHub
- Configure environment variables
- Verify preview deploys

Acceptance Criteria:
- Public URL working

---

## Issue 5.2 — Optimize Mongo for Serverless
- Implement connection caching
- Avoid connection per request

Acceptance Criteria:
- No connection exhaustion

---

## Issue 5.3 — Production Health Check
- Improve `/api/health`
- Add DB ping

Acceptance Criteria:
- Health endpoint confirms DB status

---

# Sprint 6 — Photo OCR (Stretch)

## Issue 6.1 — Camera Capture
- Implement camera input
- Preview
- Retake option

---

## Issue 6.2 — OCR Integration
- Integrate OCR provider
- Parse weight
- Return confidence

---

## Issue 6.3 — Confirmation UX
- Show suggested value
- Allow correction
- Save confirmed value

---

# Future Enhancements
- Authentication
- CSV export
- Goal weight tracking
- Streaks
- PWA offline mode
