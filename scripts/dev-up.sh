#!/usr/bin/env bash
set -Eeuo pipefail

docker compose \
  -f compose.yaml \
  -f compose.dev.yaml \
  up -d --build

docker compose \
  -f compose.yaml \
  -f compose.dev.yaml \
  ps
