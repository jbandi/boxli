#!/usr/bin/env bash
set -euo pipefail

ssh boxli 'docker compose -f /home/mc/minecraft/docker-compose.yml exec backup backup now'
