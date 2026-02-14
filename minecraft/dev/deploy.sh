#!/usr/bin/env bash
set -euo pipefail

PI_HOST="boxli"
DEST="./minecraft"
DRY_RUN=true
RESTART_MC=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --apply)
      DRY_RUN=false
      ;;
    --restart-mc)
      RESTART_MC=true
      ;;
    *)
      echo "Unknown argument: $1"
      echo "Usage: $0 [--apply] [--restart-mc]"
      exit 1
      ;;
  esac
  shift
done

if [[ "${DRY_RUN}" == "true" ]]; then
  RSYNC_DRY_RUN_FLAG="--dry-run"
  echo "Dry run mode: no remote changes will be made. Use --apply to deploy."
else
  RSYNC_DRY_RUN_FLAG=""
fi

RSYNC_SCOPE_ARGS=(
  --exclude='.git/'
  --exclude='.claude/'
  --exclude='.DS_Store'
  --exclude='.env'
  --exclude='data/'
  --exclude='data_*/'
  --exclude='logs/'
  --exclude='backups/'
  --exclude='dyndns/'
  --exclude='boxli-www/'
)

SERVICES="backup dyndns prometheus grafana loki alloy node-exporter cadvisor blackbox-exporter file-metrics lametric-writer boxli-http"
if [[ "${RESTART_MC}" == "true" ]]; then
  SERVICES="mc ${SERVICES}"
fi
REMOTE_CMD="mkdir -p ${DEST}/dyndns ${DEST}/boxli-www && touch ${DEST}/boxli-www/lametric && chmod 666 ${DEST}/boxli-www/lametric && cd ${DEST} && docker compose pull ${SERVICES} && docker compose up -d --no-deps --force-recreate --remove-orphans ${SERVICES}"

rsync -avz --delete \
  ${RSYNC_DRY_RUN_FLAG} \
  --filter='P .env' \
  "${RSYNC_SCOPE_ARGS[@]}" \
  ./ "${PI_HOST}:${DEST}/"

if [[ "${DRY_RUN}" == "true" ]]; then
  echo "Would run: ssh \"${PI_HOST}\" \"${REMOTE_CMD}\""
else
  ssh "${PI_HOST}" "${REMOTE_CMD}"
fi
