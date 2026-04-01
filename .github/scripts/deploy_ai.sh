#!/usr/bin/env bash
set -euo pipefail

: "${OWNER:?OWNER is required}"
: "${TARGET_REPO:?TARGET_REPO is required}"
: "${TARGET_WORKFLOW:?TARGET_WORKFLOW is required}"
: "${TARGET_REF:=main}"

token="${WORKFLOW_TOKEN:-${GITHUB_TOKEN:-}}"
if [[ -z "$token" ]]; then
  echo "WORKFLOW_TOKEN or GITHUB_TOKEN is required" >&2
  exit 1
fi

api_url="https://api.github.com/repos/${OWNER}/${TARGET_REPO}/actions/workflows/${TARGET_WORKFLOW}/dispatches"
payload="$(printf '{"ref":"%s"}' "$TARGET_REF")"

curl --fail --silent --show-error \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${token}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "$api_url" \
  -d "$payload"

echo "Triggered ${TARGET_REPO}/${TARGET_WORKFLOW} on ${TARGET_REF}"
