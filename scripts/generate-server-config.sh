#!/bin/bash
set -e

cd "$(dirname "$0")/../wireguard"

# Генерация ключей, если ещё нет
if [ ! -f privatekey ] || [ ! -f publickey ]; then
  echo "[+] Генерация серверных ключей..."
  umask 077
  wg genkey | tee privatekey | wg pubkey > publickey
fi

# Читаем ключ и переменные
VPN_PRIVATE_KEY=$(cat privatekey)

# Загружаем остальные переменные из .env
set -a
source ../.env
set +a

# Генерация server.conf
envsubst < server.conf.template > server.conf
echo "✅ Сконфигурирован: wireguard/server.conf"
