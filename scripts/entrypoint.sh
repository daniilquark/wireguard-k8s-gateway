#!/bin/bash
set -e

# Поднимаем интерфейс, если он ещё не поднят
if ! ip link show server &> /dev/null; then
    echo "[+] Starting WireGuard interface 'server'"
    wg-quick up server
else
    echo "[!] WireGuard interface 'server' already exists"
fi

# Оставляем контейнер живым
echo "[+] WireGuard is running. Keeping container alive..."
tail -f /dev/null
