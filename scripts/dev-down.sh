#!/usr/bin/env bash
set -Eeuo pipefail

docker compose \
  -f compose.yaml \
  -f compose.dev.yaml \
  down --remove-orphans
