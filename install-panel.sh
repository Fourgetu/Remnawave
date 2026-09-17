#!/usr/bin/env bash
set -Eeuo pipefail

VERSION="custom-v0.1.0-rc.1"
BASE_URL="https://raw.githubusercontent.com/Fourgetu/Remnawave/${VERSION}"
TARGET_DIR="${INSTALL_DIR:-${HOME}/remnawave-custom}"

require_command() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "错误：缺少命令 $1" >&2
    exit 1
  }
}

require_command curl
require_command openssl
require_command docker
docker compose version >/dev/null 2>&1 || {
  echo "错误：需要 Docker Compose v2" >&2
  exit 1
}

read -r -p "Panel 域名（例如 panel.example.com）：" PANEL_DOMAIN
case "$PANEL_DOMAIN" in
  ""|*[!A-Za-z0-9.-]*)
    echo "错误：域名格式不正确" >&2
    exit 1
    ;;
esac

if [[ -e "$TARGET_DIR/.env" ]]; then
  echo "错误：$TARGET_DIR/.env 已存在，为避免覆盖现有配置而停止。" >&2
  exit 1
fi

mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"

curl -fsSL "$BASE_URL/docker-compose.custom.yml" -o docker-compose.custom.yml
curl -fsSL "$BASE_URL/.env.custom.example" -o .env

APP_SECRET="$(openssl rand -hex 32)"
POSTGRES_PASSWORD="$(openssl rand -hex 24)"
METRICS_PASS="$(openssl rand -hex 16)"

sed -i \
  -e "s|^APP_SECRET=.*|APP_SECRET=$APP_SECRET|" \
  -e "s|^PANEL_DOMAIN=.*|PANEL_DOMAIN=$PANEL_DOMAIN|" \
  -e "s|^FRONT_END_DOMAIN=.*|FRONT_END_DOMAIN=https://$PANEL_DOMAIN|" \
  -e "s|^SUB_PUBLIC_DOMAIN=.*|SUB_PUBLIC_DOMAIN=$PANEL_DOMAIN/api/sub|" \
  -e "s|^POSTGRES_PASSWORD=.*|POSTGRES_PASSWORD=$POSTGRES_PASSWORD|" \
  -e "s|^DATABASE_URL=.*|DATABASE_URL=postgresql://postgres:$POSTGRES_PASSWORD@remnawave-db:5432/postgres|" \
  -e "s|^METRICS_PASS=.*|METRICS_PASS=$METRICS_PASS|" \
  .env

docker compose -f docker-compose.custom.yml pull
docker compose -f docker-compose.custom.yml up -d

echo
echo "Panel 已启动。"
echo "目录：$TARGET_DIR"
echo "访问地址：https://$PANEL_DOMAIN"
echo "查看日志：cd $TARGET_DIR && docker compose -f docker-compose.custom.yml logs -f remnawave"
