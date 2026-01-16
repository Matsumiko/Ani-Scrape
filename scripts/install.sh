#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

print_header() {
  echo ""
  echo "======================================="
  echo "  OtakluDesu - Installer / Deployer"
  echo "======================================="
  echo "Project: ${ROOT_DIR}"
  echo ""
}

print_menu() {
  echo "Pilih metode install / run:" 
  echo "  1) Docker (install Docker di Ubuntu/Debian + run via Compose)"
  echo "  2) Docker (run via Compose saja)"
  echo "  3) PM2 (Node process manager)"
  echo "  4) systemd service (native Linux service)"
  echo "  5) Keluar"
  echo ""
}

print_header
print_menu

read -r -p "Masukkan pilihan [1-5]: " CHOICE

case "${CHOICE}" in
  1)
    bash "${ROOT_DIR}/scripts/setup-docker-ubuntu.sh"
    bash "${ROOT_DIR}/scripts/deploy-docker.sh"
    ;;
  2)
    bash "${ROOT_DIR}/scripts/deploy-docker.sh"
    ;;
  3)
    bash "${ROOT_DIR}/scripts/deploy-pm2.sh"
    ;;
  4)
    bash "${ROOT_DIR}/scripts/deploy-systemd.sh"
    ;;
  5)
    echo "Bye!"
    exit 0
    ;;
  *)
    echo "Pilihan tidak valid."
    exit 1
    ;;
esac
