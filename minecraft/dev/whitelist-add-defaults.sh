#!/usr/bin/env bash
set -euo pipefail

bedrock_players=(
  ".Archenoa123" 
  ".LoRabbit111"
  ".tl5671"
  ".Astronik123"
  ".ynbbb8" #Yaro
  ".KingNoelA" #Noel
  "00000000-0000-0000-0009-01F049831C0E" # Noel nach lookup auf https://cxkes.me/xbox/xuid
  ".PrimalEwe" #Diago
  "00000000-0000-0000-0009-000004B6F3D6" # Diago nach lookup auf https://cxkes.me/xbox/xuid
  ".DonaldGuck" #Illan
  "00000000-0000-0000-0009-01F06C1D5DA2" # Illan nach lookup auf https://cxkes.me/xbox/xuid,
  "QuAKi2373" # Nuria
  "00000000-0000-0000-0009-01F7ADB28381" # Nuria nach lookup auf https://cxkes.me/xbox/xuid,
  "RamGaming" #Ramon
  "00000000-0000-0000-0009-0000044AD79D" # Ramon nach lookup auf https://cxkes.me/xbox/xuid,
)

for player in "${bedrock_players[@]}"; do
  echo "Adding ${player} to whitelist..."
  ssh boxli "docker exec minecraft rcon-cli fwhitelist add ${player}"
done

echo "Done."

# Alternative Lookup: https://geysermc.org/wiki/api/api.geysermc.org/global-api-web-api-xbox-controller-get-xuid-v-2/
# Convert
# printf "%016x\n" 2535417733617252
# printf "%d\n" 0x000901f2f15e9664

# Convert to decimal:
# xuid=2535417733617252
# hex=$(printf "%016x" "$xuid")
# echo "00000000-0000-0000-${hex:0:4}-${hex:4}