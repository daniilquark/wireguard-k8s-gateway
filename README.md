# WireGuard K8s Gateway

VPN-сервер на основе WireGuard с автоматической генерацией конфигов и поддержкой клиентов. Готов к запуску через Docker.

## Возможности

- Генерация ключей и server.conf из шаблона
- Поддержка IPv4 Endpoint
- Автоматическое добавление клиентов
- Структурированная архитектура и скрипты

## Структура проекта

```
wireguard-k8s-gateway/
├── .env
├── docker-compose.yml
├── Dockerfile
├── wireguard/
│   ├── server.conf.template
│   ├── server.conf
│   ├── publickey
│   ├── privatekey
│   └── peers/
│       └── clientX/
│           ├── privatekey
│           ├── publickey
│           ├── clientX.conf
│           └── client1.conf.template
├── scripts/
│   ├── generate-server.sh
│   ├── generate-client-config.sh
│   └── entrypoint.sh
└── kuber/
    ├── daemonset.yaml
    └── ...
```

## Переменные `.env`

VPN_ADDRESS
VPN_PORT
VPN_INTERFACE
VPN_ETH_INTERFACE
SERVER_IP


## Быстрый старт (Docker)

# Генерация server.conf и ключей
./scripts/generate-server.sh

# Старт WireGuard
docker-compose up --build -d

# Проверка:
docker exec -it wireguard-server wg show


## Генерация клиента

./scripts/generate-client-config.sh client2

- создается client2.conf
- ключи клиента
- peer добавляется в server.conf

## Подключение с устройства

1. Установи WireGuard
2. Импортируй clientX.conf
3. Активируй VPN

## ⚡ Kubernetes (WIP)

Будет добавлено:

- `DaemonSet` c `hostNetwork`
- `ConfigMap` c server.conf
- `Secrets` для ключей
- Автогенерация peerов

## Makefile (опционально)

gen-server:
	scripts/generate-server.sh

gen-client:
	scripts/generate-client-config.sh clientX

up:
	docker-compose up -d

down:
	docker-compose down

## Автор

**Daniil Quark**\
[github.com/daniilquark](https://github.com/daniilquark)
