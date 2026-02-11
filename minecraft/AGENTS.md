# AGENTS.md

## Project Overview
- This repository manages a Docker-based Minecraft deployment.
- Primary services are defined in `docker-compose.yml`.
- Operational scripts live in `dev/` for tasks like pull, deploy, and backup ...
- The target for this Minecraft deployment is a remote Raspberry Pi 5
- The remote Raspberry Pi 5 can be reached via `ssh boxli` and `ping boxli.local`

## Repository Layout
- `docker-compose.yml`: source of truth for runtime config.
- `dev/`: operational helper scripts for deployment, sync, backup, and maintenance workflows.
- `data/`, `logs/`, `backups/`: runtime/stateful directories. Treat as environment data, not code.

## Working Rules For Agents
- Keep changes minimal and targeted to the user request.
- Prefer editing `docker-compose.yml` and `dev/*.sh` instead of introducing new tooling.
- Never run project containers locally on the developer workstation. Use the remote Raspberry Pi target for `docker compose up`, restarts, and runtime operations.
- Never touch or delete the `.env` file on the remote Raspberry Pi 5
- Do not commit secrets. Keep credentials as placeholders or move to environment variables when requested.
- Do not modify `data*` directories unless explicitly asked (they contain world/server state).
- If changing ports, RCON settings, backup paths, or volume mounts, call out operational impact clearly.

## Common Commands
- Validate compose config:
- `docker compose -f docker-compose.yml config`
- Review available operational helpers:
- `ls -la dev`
- Run project-specific helper scripts from `dev/` as needed for deploy/sync/backup workflows.

## Change Checklist
- Confirm `docker-compose.yml` still renders with `docker compose ... config`.
- If scripts changed, check executable intent and shell compatibility.
- Highlight any required manual follow-up (e.g., rotated secrets, restart, first-time plugin download).
- Keep docs in sync when workflow or script behavior changes.
