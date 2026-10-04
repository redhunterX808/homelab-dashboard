#!/usr/bin/env bash

set -euo pipefail

echo "=== Repository validation ==="

echo
echo "[1/3] Git status"
git status --short

echo
echo "[2/3] Docker Compose validation"
docker compose config --quiet

echo
echo "[3/3] Searching for obvious secrets"

if grep -RniE \
    --exclude-dir=.git \
    --exclude-dir=.venv \
    --exclude-dir=node_modules \
    '(password|passwd|api[_-]?key|private[_-]?key|secret|token)[[:space:]]*=' .; then

    echo
    echo "WARNING: possible secrets detected."
    exit 1
fi

echo
echo "Validation completed successfully."
