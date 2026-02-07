#!/usr/bin/env bash
set -euo pipefail

PI_HOST="boxli"
DEST="./minecraft"
DRY_RUN=true

if [[ "${1:-}" == "--apply" ]]; then
  DRY_RUN=false
fi

if [[ "${DRY_RUN}" == "true" ]]; then
  RSYNC_DRY_RUN_FLAG="--dry-run"
  echo "Dry run mode: no remote changes will be made. Use --apply to deploy."
else
  RSYNC_DRY_RUN_FLAG=""
fi

rsync -avz --delete \
  ${RSYNC_DRY_RUN_FLAG} \
  --exclude '.git' \
  --exclude '.gitignore' \
  --exclude '.env' \
  --exclude 'data*' \
  --exclude 'dev' \
  ./ "${PI_HOST}:${DEST}/"

if [[ "${DRY_RUN}" == "true" ]]; then
  echo "Would run: ssh \"${PI_HOST}\" \"cd ${DEST} && docker compose pull && docker compose up -d\""
else
  ssh "${PI_HOST}" "cd ${DEST} && docker compose pull && docker compose up -d"
fi
