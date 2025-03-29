CLIENT_IP=$(grep '^Address' "$CLIENT_NAME.conf" | cut -d' ' -f3 | cut -d/ -f1)

if ! grep -q "$CLIENT_PUBLIC_KEY" ../../server.conf; then
  echo "➕ Добавляю [Peer] в server.conf..."

  cat >> ../../server.conf <<EOF

[Peer]
PublicKey = $CLIENT_PUBLIC_KEY
AllowedIPs = $CLIENT_IP/32
EOF

  echo "✅ Peer добавлен в server.conf: $CLIENT_NAME ($CLIENT_IP)"
else
  echo "🔁 Peer уже есть в server.conf, пропускаю"
fi
