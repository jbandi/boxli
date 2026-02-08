#!/usr/bin/env bash
set -euo pipefail

ssh boxli 'docker exec minecraft rcon-cli whitelist list'
