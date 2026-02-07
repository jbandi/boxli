#!/usr/bin/env bash
set -euo pipefail

PI_HOST="pi@raspberrypi"
DEST="/opt/homelab"

rsync -avz --delete \
  --exclude '.git' \
  --exclude 'data*' \
  ./ "${PI_HOST}:${DEST}/"

ssh "${PI_HOST}" "cd ${DEST} && docker compose pull && docker compose up -d"
