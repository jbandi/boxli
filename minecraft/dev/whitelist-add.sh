#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <player-name>" >&2
  exit 1
fi

player_name="$1"
ssh boxli "docker exec minecraft rcon-cli whitelist add ${player_name}"
