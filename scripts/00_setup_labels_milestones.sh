#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./scripts/00_setup_labels_milestones.sh OWNER REPO
# Example:
#   ./scripts/00_setup_labels_milestones.sh carlosarias weight-track

OWNER="${1:-}"
REPO="${2:-}"
if [[ -z "$OWNER" || -z "$REPO" ]]; then
  echo "Usage: $0 OWNER REPO"
  exit 1
fi

echo "==> Creating labels (idempotent with --force)"
gh label create "backend"     -R "$OWNER/$REPO" -d "API / database work" --force || true
gh label create "frontend"    -R "$OWNER/$REPO" -d "React UI work" --force || true
gh label create "reporting"   -R "$OWNER/$REPO" -d "Text reports and summaries" --force || true
gh label create "charts"      -R "$OWNER/$REPO" -d "Graphs and trend detection" --force || true
gh label create "deployment"  -R "$OWNER/$REPO" -d "Vercel, environments, prod" --force || true
gh label create "stretch"     -R "$OWNER/$REPO" -d "Nice-to-have / OCR sprint" --force || true
gh label create "planning"    -R "$OWNER/$REPO" -d "Roadmap / planning" --force || true

# Sprint labels (optional but nice)
for i in {0..6}; do
  gh label create "sprint-$i" -R "$OWNER/$REPO" -d "Sprint $i" --force || true
done

echo "==> Creating milestones via REST API (idempotent-ish)"
# We'll try to create; if it already exists, GitHub returns validation error; we ignore.
for i in {0..6}; do
  TITLE="Sprint $i"
  gh api -X POST "repos/$OWNER/$REPO/milestones" \
    -f title="$TITLE" >/dev/null 2>&1 || true
done

echo "Done: labels + milestones set up."

