#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

# Ensure env file exists
if [[ ! -f .env && -f .env.example ]]; then
  cp .env.example .env
  echo "Created .env from .env.example"
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker belum terinstall. Install dulu atau jalankan scripts/setup-docker-ubuntu.sh"
  exit 1
fi

echo "Building & starting containers..."
docker compose up -d --build

echo ""
echo "OtakluDesu running ✅"
echo "Health: http://localhost:7501/"
echo "Logs  : docker logs -f otakludesu-api"
