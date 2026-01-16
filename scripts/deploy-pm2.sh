#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

if ! command -v node >/dev/null 2>&1; then
  echo "Node.js belum terinstall. Install Node 20+ dulu."
  exit 1
fi

NODE_MAJOR="$(node -p 'parseInt(process.versions.node.split(".")[0],10)')"
if (( NODE_MAJOR < 20 )); then
  echo "Node versi kamu: $(node -v). Minimal Node 20."
  exit 1
fi

# Ensure env file exists
if [[ ! -f .env && -f .env.example ]]; then
  cp .env.example .env
  echo "Created .env from .env.example"
fi

echo "Install dependencies..."
npm install

echo "Build..."
npm run build

if ! command -v pm2 >/dev/null 2>&1; then
  echo "Install PM2..."
  npm install -g pm2
fi

echo "Start/Reload via PM2..."
pm2 start ecosystem.config.cjs
pm2 save

echo ""
echo "Supaya auto-start setelah reboot:"
echo "  pm2 startup"
echo "Lalu jalankan command yang keluar (butuh sudo)."
echo ""
echo "Status:"
pm2 status
