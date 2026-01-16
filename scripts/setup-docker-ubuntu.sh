#!/usr/bin/env bash
set -euo pipefail

# Installs Docker Engine + Docker Compose plugin on Ubuntu/Debian.
# Ref: https://docs.docker.com/engine/install/

if [[ "${EUID}" -ne 0 ]]; then
  echo "Script ini butuh sudo/root. Jalankan: sudo bash scripts/setup-docker-ubuntu.sh"
  exit 1
fi

if command -v docker >/dev/null 2>&1; then
  echo "Docker sudah terinstall: $(docker --version)"
  exit 0
fi

echo "[1/6] Install dependencies..."
apt-get update -y
apt-get install -y ca-certificates curl gnupg

echo "[2/6] Add Docker GPG key..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | \
  gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo "[3/6] Add Docker repository..."
ARCH="$(dpkg --print-architecture)"
CODENAME="$(. /etc/os-release; echo "$VERSION_CODENAME")"
ID="$(. /etc/os-release; echo "$ID")"

# For Debian derivatives that don't have VERSION_CODENAME properly set
if [[ -z "${CODENAME}" ]]; then
  CODENAME="$(lsb_release -cs 2>/dev/null || true)"
fi

echo \
  "deb [arch=${ARCH} signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/${ID} ${CODENAME} stable" \
  > /etc/apt/sources.list.d/docker.list

echo "[4/6] Install Docker Engine + Compose plugin..."
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "[5/6] Enable Docker service..."
systemctl enable --now docker

echo "[6/6] Add current user to docker group (optional)..."
if [[ -n "${SUDO_USER:-}" ]]; then
  usermod -aG docker "${SUDO_USER}" || true
  echo "User '${SUDO_USER}' sudah ditambah ke group docker. Logout/login agar efeknya aktif."
else
  echo "Tidak bisa detect SUDO_USER. Kalau perlu: sudo usermod -aG docker <username>"
fi

echo "Selesai ✅"
