#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SERVICE_NAME="otakludesu"

if ! command -v node >/dev/null 2>&1; then
  echo "Node.js belum terinstall. Install Node 20+ dulu."
  exit 1
fi

if ! command -v npm >/dev/null 2>&1; then
  echo "npm tidak ditemukan. Install Node.js yang include npm."
  exit 1
fi

# Ensure env file exists
if [[ ! -f "${ROOT_DIR}/.env" && -f "${ROOT_DIR}/.env.example" ]]; then
  cp "${ROOT_DIR}/.env.example" "${ROOT_DIR}/.env"
  echo "Created .env from .env.example"
fi

cd "${ROOT_DIR}"

echo "Install dependencies..."
npm install

echo "Build..."
npm run build

NODE_PATH="$(command -v node)"
USER_NAME="$(id -un)"

SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"

cat <<SERVICE | sudo tee "${SERVICE_FILE}" >/dev/null
[Unit]
Description=OtakluDesu API
After=network.target

[Service]
Type=simple
WorkingDirectory=${ROOT_DIR}
ExecStart=${NODE_PATH} ${ROOT_DIR}/dist/index.js
Environment=NODE_ENV=production
# Load PORT and SOURCE_URL from .env (optional)
EnvironmentFile=${ROOT_DIR}/.env
Restart=always
RestartSec=3
User=${USER_NAME}

[Install]
WantedBy=multi-user.target
SERVICE

echo "Reload systemd & enable service..."
sudo systemctl daemon-reload
sudo systemctl enable --now "${SERVICE_NAME}"

echo "\nSelesai ✅"
echo "Status : sudo systemctl status ${SERVICE_NAME}"
echo "Logs   : sudo journalctl -u ${SERVICE_NAME} -f"
echo "Test   : curl http://localhost:7501/"
