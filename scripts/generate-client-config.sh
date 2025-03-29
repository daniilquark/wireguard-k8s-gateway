#!/bin/bash
set -e

CLIENT_NAME="$1"

if [ -z "$CLIENT_NAME" ]; then
  echo "❌ Укажи имя клиента: ./scripts/generate-client-config.sh client2"
  exit 1
fi

# Выделяем IP-окончание
CLIENT_IP_SUFFIX=$(echo "$CLIENT_NAME" | grep -o '[0-9]*$')
if [ -z "$CLIENT_IP_SUFFIX" ]; then
  echo "❌ Имя клиента должно содержать номер (например: client2)"
  exit 1
fi

PEER_DIR="wireguard/peers/$CLIENT_NAME"
mkdir -p "$PEER_DIR"
cd "$PEER_DIR"

# Генерация ключей
if [ ! -f privatekey ] || [ ! -f publickey ]; then
  echo "[+] Генерация ключей для $CLIENT_NAME..."
  umask 077
  wg genkey | tee privatekey | wg pubkey > publickey
fi

# Переменные
CLIENT_PRIVATE_KEY=$(cat privatekey)
CLIENT_PUBLIC_KEY=$(cat publickey)
SERVER_PUBLIC_KEY=$(cat ../../publickey)
#SERVER_IP=$(curl -s ifconfig.me)
CLIENT_IP="11.0.0.$CLIENT_IP_SUFFIX"

# Загрузка .env
set -a
source ../../../.env
set +a

# Генерация client.conf
cat > "$CLIENT_NAME.conf" <<EOF
[Interface]
PrivateKey = $CLIENT_PRIVATE_KEY
Address = $CLIENT_IP/24
DNS = 1.1.1.1

[Peer]
PublicKey = $SERVER_PUBLIC_KEY
Endpoint = $SERVER_IP:$VPN_PORT
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
EOF

echo "✅ Сконфигурирован: $CLIENT_NAME.conf ($CLIENT_IP)"

# Добавление в server.conf
cat >> ../../server.conf <<EOF

[Peer]
PublicKey = $CLIENT_PUBLIC_KEY
AllowedIPs = $CLIENT_IP/32
EOF

echo "➕ Peer $CLIENT_NAME ($CLIENT_IP) добавлен в server.conf"
