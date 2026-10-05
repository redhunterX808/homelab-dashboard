#!/usr/bin/env bash
set -Eeuo pipefail

COMPOSE=(
  docker compose
  -f compose.yaml
  -f compose.dev.yaml
)

SMOKE_URL="${SMOKE_URL:-http://localhost:8080}"
SMOKE_TIMEOUT="${SMOKE_TIMEOUT:-30}"

cleanup() {
    echo
    echo "== Cleanup =="
    "${COMPOSE[@]}" down --remove-orphans >/dev/null 2>&1 || true
}

trap cleanup EXIT

echo "== Pre-commit =="
pre-commit run --all-files

echo
echo "== Docker Compose =="
"${COMPOSE[@]}" config --quiet

echo
echo "== Docker Build =="
"${COMPOSE[@]}" build

echo
echo "== Runtime Smoke Test =="

# Guarantee that this test starts from a known state.
"${COMPOSE[@]}" down --remove-orphans >/dev/null 2>&1 || true
"${COMPOSE[@]}" up -d

echo "Waiting for application..."

elapsed=0

while [ "$elapsed" -lt "$SMOKE_TIMEOUT" ]; do
    # A container that exited or entered a restart loop must fail validation.
    if "${COMPOSE[@]}" ps --status exited -q | grep -q .; then
        echo "ERROR: one or more containers exited."
        "${COMPOSE[@]}" ps
        "${COMPOSE[@]}" logs --tail=100
        exit 1
    fi

    if "${COMPOSE[@]}" ps --status restarting -q | grep -q .; then
        echo "ERROR: one or more containers are restarting."
        "${COMPOSE[@]}" ps
        "${COMPOSE[@]}" logs --tail=100
        exit 1
    fi

    if curl --fail --silent --show-error \
        --max-time 3 \
        "$SMOKE_URL" \
        >/dev/null 2>&1; then

        echo "HTTP smoke test passed: $SMOKE_URL"
        echo
        echo "Validation completed successfully."
        exit 0
    fi

    sleep 2
    elapsed=$((elapsed + 2))
done

echo "ERROR: application did not become ready within ${SMOKE_TIMEOUT}s."

"${COMPOSE[@]}" ps

echo
echo "== Container logs =="
"${COMPOSE[@]}" logs --tail=100

exit 1
