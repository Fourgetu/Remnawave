#!/usr/bin/env bash
set -Eeuo pipefail

VERSION="custom-v0.2.8"
BASE_URL="https://raw.githubusercontent.com/Fourgetu/Remnawave/${VERSION}"
TARGET_DIR="${INSTALL_DIR:-${HOME}/remnawave-custom-node}"

command -v curl >/dev/null 2>&1 || { echo "错误：缺少 curl" >&2; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "错误：缺少 docker" >&2; exit 1; }
docker compose version >/dev/null 2>&1 || {
  echo "错误：需要 Docker Compose v2" >&2
  exit 1
}

read -r -s -p "Node Secret（从 Panel 添加 Node 时复制）：" NODE_SECRET
echo
if [[ -z "$NODE_SECRET" ]]; then
  echo "错误：Node Secret 不能为空" >&2
  exit 1
fi

if [[ -e "$TARGET_DIR/.env.node" ]]; then
  echo "错误：$TARGET_DIR/.env.node 已存在，为避免覆盖现有配置而停止。" >&2
  exit 1
fi

mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"

curl -fsSL "$BASE_URL/docker-compose.custom-node.yml" -o docker-compose.custom-node.yml
curl -fsSL "$BASE_URL/.env.custom-node.example" -o .env.node
{
  while IFS= read -r line; do
    case "$line" in
      SECRET_KEY=*) printf 'SECRET_KEY=%s\n' "$NODE_SECRET" ;;
      *) printf '%s\n' "$line" ;;
    esac
  done < .env.node
} > .env.node.tmp
mv .env.node.tmp .env.node

docker compose --env-file .env.node -f docker-compose.custom-node.yml pull
docker compose --env-file .env.node -f docker-compose.custom-node.yml up -d

echo
echo "Node 已启动。"
echo "目录：$TARGET_DIR"
echo "查看日志：cd $TARGET_DIR && docker compose --env-file .env.node -f docker-compose.custom-node.yml logs -f remnanode"
