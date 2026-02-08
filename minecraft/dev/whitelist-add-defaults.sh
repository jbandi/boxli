#!/usr/bin/env bash
set -euo pipefail

bedrock_players=(
  ".Archenoa123" 
  ".LoRabbit111"
  ".tl5671"
  ".Astronik123"
  ".KingNoelA" #Noel
  "00000000-0000-0000-0009-01F049831C0E" # Noel nach lookup auf https://cxkes.me/xbox/xuid
  ".PrimalEwe" #Diago
  "00000000-0000-0000-0009-000004B6F3D6" # Diago nach lookup auf https://cxkes.me/xbox/xuid
)

for player in "${bedrock_players[@]}"; do
  echo "Adding ${player} to whitelist..."
  ssh boxli "docker exec minecraft rcon-cli fwhitelist add ${player}"
done

echo "Done."
