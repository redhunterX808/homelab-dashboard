#!/usr/bin/env bash
set -Eeuo pipefail

SMOKE_URL="${SMOKE_URL:-http://localhost:8080}"
SMOKE_TIMEOUT="${SMOKE_TIMEOUT:-30}"

cleanup() {
    echo
    echo "== Cleanup =="
    docker compose down --remove-orphans >/dev/null 2>&1 || true
}

trap cleanup EXIT

echo "== Pre-commit =="
pre-commit run --all-files

echo
echo "== Docker Compose =="
docker compose config --quiet

echo
echo "== Docker Build =="
docker compose build

echo
echo "== Runtime Smoke Test =="

# Guarantee that this test starts from a known state.
docker compose down --remove-orphans >/dev/null 2>&1 || true
docker compose up -d

echo "Waiting for application..."

elapsed=0

while [ "$elapsed" -lt "$SMOKE_TIMEOUT" ]; do
    # A container that exited or entered a restart loop must fail validation.
    if docker compose ps --status exited -q | grep -q .; then
        echo "ERROR: one or more containers exited."
        docker compose ps
        docker compose logs --tail=100
        exit 1
    fi

    if docker compose ps --status restarting -q | grep -q .; then
        echo "ERROR: one or more containers are restarting."
        docker compose ps
        docker compose logs --tail=100
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

docker compose ps

echo
echo "== Container logs =="
docker compose logs --tail=100

exit 1
