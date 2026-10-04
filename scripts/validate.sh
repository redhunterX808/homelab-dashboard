#!/usr/bin/env bash
set -Eeuo pipefail

echo "== Pre-commit =="
pre-commit run --all-files

echo
echo "== Docker Compose =="
docker compose config --quiet

echo
echo "== Docker Build =="
docker compose build

echo
echo "Validation completed successfully."
