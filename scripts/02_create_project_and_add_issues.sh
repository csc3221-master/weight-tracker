#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./scripts/02_create_project_and_add_issues.sh OWNER REPO "Project Title"
OWNER="${1:-}"
REPO="${2:-}"
PROJECT_TITLE="${3:-Weight Track Kanban}"

if [[ -z "$OWNER" || -z "$REPO" ]]; then
  echo "Usage: $0 OWNER REPO \"Project Title\""
  exit 1
fi

echo "==> Creating project: $PROJECT_TITLE"
PROJECT_NUMBER="$(gh project create --owner "$OWNER" --title "$PROJECT_TITLE" --format json --jq '.number')"
echo "Project number: $PROJECT_NUMBER"  # this is the project identifier you’ll use in gh project commands

echo "==> (Optional) Create a Sprint single-select field"
# This creates a custom field; you can skip if you only want the default Status column.
gh project field-create "$PROJECT_NUMBER" --owner "$OWNER" \
  --name "Sprint" --data-type "SINGLE_SELECT" \
  --single-select-options "Sprint 0,Sprint 1,Sprint 2,Sprint 3,Sprint 4,Sprint 5,Sprint 6" >/dev/null 2>&1 || true

echo "==> Adding all repo issues to project"
# List issues, get their URLs, add each to the project
mapfile -t ISSUE_URLS < <(gh issue list -R "$OWNER/$REPO" --limit 200 --json url --jq '.[].url')

for url in "${ISSUE_URLS[@]}"; do
  echo "Adding: $url"
  gh project item-add "$PROJECT_NUMBER" --owner "$OWNER" --url "$url" >/dev/null 2>&1 || true
done

echo "Done: project created and issues added."
echo "Tip: open the Project in GitHub UI to configure columns/views."
