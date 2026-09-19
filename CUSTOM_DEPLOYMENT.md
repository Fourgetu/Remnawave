# Fourgetu Remnawave Custom Release

本文档对应正式版本 `custom-v0.2.1`。这是 Fourgetu Remnawave 自定义发行版，不是官方 `main` 的原版发行版。

## 版本清单

| 组件       | Git tag         | 产物                                                                  |
| ---------- | --------------- | --------------------------------------------------------------------- |
| Backend    | `custom-v0.2.1` | `ghcr.io/fourgetu/remnawave-backend:custom-v0.2.1`                    |
| Node       | `custom-v0.2.1` | `ghcr.io/fourgetu/remnawave-node:custom-v0.2.1`                       |
| Frontend   | `custom-v0.2.1` | GitHub Release asset `remnawave-frontend.zip`；已内嵌到 Backend image |
| Panel/docs | `custom-v0.2.1` | 本文档、Compose 模板和部署说明                                        |

Backend image 会在构建时下载同 tag 的 Frontend release asset，因此部署时不需要额外运行 Frontend 容器。

## 前置条件

- Docker Engine 和 Docker Compose v2。
- Panel 主机有持久化磁盘；数据库时区必须保持 UTC。
- Panel 域名已经反向代理到 `127.0.0.1:3000`。
- Node 主机能被 Panel 访问到 Node API 端口，默认是 `2222`。
- 要使用 NAT route、GOST 限速或 HY2 Port Hopping，Node 主机必须允许所需 TCP/UDP 端口，且 Node 容器需要 `NET_ADMIN`。
- GHCR 镜像必须设为 public，或者部署机使用有 `read:packages` 权限的 GitHub PAT 登录。

## Panel 主机部署

### 一键安装

确认脚本内容后，可以执行：

```bash
curl -fsSL https://github.com/Fourgetu/Remnawave/releases/download/custom-v0.2.1/install-panel.sh | bash
```

脚本会询问 Panel 域名，自动生成 `APP_SECRET`、数据库密码和 metrics 密码，然后下载固定版本 Compose 并启动服务。默认安装目录为 `~/remnawave-custom`，已存在的 `.env` 不会被覆盖。

```bash
mkdir -p remnawave-custom
cd remnawave-custom

curl -fL -o docker-compose.custom.yml \
  https://raw.githubusercontent.com/Fourgetu/Remnawave/custom-v0.2.1/docker-compose.custom.yml
curl -fL -o .env.example \
  https://raw.githubusercontent.com/Fourgetu/Remnawave/custom-v0.2.1/.env.custom.example
cp .env.example .env
```

编辑 `.env`，至少修改：

```dotenv
APP_SECRET=请使用至少32字节的随机值
PANEL_DOMAIN=panel.example.com
PANEL_CERTIFICATE_HOST_DIR=/opt/remnawave/nginx
PANEL_CERTIFICATE_PATH=/var/lib/remnawave/panel-certificate/fullchain.pem
PANEL_PRIVATE_KEY_PATH=/var/lib/remnawave/panel-certificate/privkey.key
FRONT_END_DOMAIN=https://panel.example.com
SUB_PUBLIC_DOMAIN=panel.example.com/api/sub
POSTGRES_PASSWORD=请修改为随机密码
DATABASE_URL=postgresql://postgres:请修改为随机密码@remnawave-db:5432/postgres
```

如果使用 GHCR 私有包，先登录：

```bash
echo "$GHCR_READ_TOKEN" | docker login ghcr.io -u Fourgetu --password-stdin
```

启动：

```bash
docker compose -f docker-compose.custom.yml pull
docker compose -f docker-compose.custom.yml up -d
docker compose -f docker-compose.custom.yml ps
docker compose -f docker-compose.custom.yml logs -f remnawave
```

Backend entrypoint 会执行 Prisma migration 和 seed，然后启动 API。第一次启动应确认日志包含 `Migrations deployed successfully`。

### 反向代理

将 `panel.example.com` 的 HTTP/HTTPS 流量反代到：

```text
http://127.0.0.1:3000
```

不要把 PostgreSQL 的 `6767` 或 metrics 的 `3001` 暴露到公网。Compose 模板默认只绑定到本机。

## Node 主机部署

### 一键安装

先在 Panel 中创建 Node 并复制 Secret，然后执行：

```bash
curl -fsSL https://github.com/Fourgetu/Remnawave/releases/download/custom-v0.2.1/install-node.sh | bash
```

脚本会安全地询问 Node Secret，下载固定版本 Node Compose，启用 `NET_ADMIN` 和 `nftables` Port Hopping，并启动 Node。默认安装目录为 `~/remnawave-custom-node`，已存在的 `.env.node` 不会被覆盖。

在每台 Node 主机上下载模板：

```bash
mkdir -p remnawave-custom-node
cd remnawave-custom-node

curl -fL -o docker-compose.custom-node.yml \
  https://raw.githubusercontent.com/Fourgetu/Remnawave/custom-v0.2.1/docker-compose.custom-node.yml
curl -fL -o .env.node.example \
  https://raw.githubusercontent.com/Fourgetu/Remnawave/custom-v0.2.1/.env.custom-node.example
cp .env.node.example .env.node
```

编辑 `.env.node`：

```dotenv
NODE_PORT=2222
SECRET_KEY=从 Panel 添加 Node 时生成/复制的密钥
PORT_HOPPING_INGRESS=nftables
```

启动：

```bash
docker compose --env-file .env.node -f docker-compose.custom-node.yml pull
docker compose --env-file .env.node -f docker-compose.custom-node.yml up -d
docker compose --env-file .env.node -f docker-compose.custom-node.yml logs -f remnanode
```

该容器使用 host network，Node API 直接监听主机的 `NODE_PORT`。不要再通过 Compose `ports` 做重复映射。`NET_ADMIN` 是 HY2 Port Hopping 的 nftables 入口所需权限；如果不使用 Port Hopping，也可以将该变量设为空并移除不必要的能力，但要保留 GOST route 所需的端口权限。

## NAT、限速和 HY2 使用要求

- UserRoute 的外部端口由 Panel 分配，默认池为 `32000–32999`，例如 `32001 → 127.0.0.1:443`。
- Node 主机/云防火墙必须放行分配到的 TCP 或 UDP 外部端口。
- HY2 Port Hopping 需要 UDP 放行端口范围、`PORT_HOPPING_INGRESS=nftables` 和 `NET_ADMIN`。
- Port Hopping 的实际链路是 `client udpHop → nftables redirect → GOST → sing-box HY2`，不是 Xray 或 sing-box 原生跳跃。
- 限速发生在 Node 的 GOST forward limiter；每条 UserRoute 可绑定不同上下行速率。

## 升级

先备份数据库：

```bash
docker compose -f docker-compose.custom.yml exec -T remnawave-db \
  pg_dump -U "$POSTGRES_USER" -d "$POSTGRES_DB" > backup-$(date +%Y%m%d-%H%M%S).sql
```

将两个 Compose 文件中的 image tag 一起改成目标版本，再执行：

```bash
docker compose -f docker-compose.custom.yml pull
docker compose -f docker-compose.custom.yml up -d
docker compose -f docker-compose.custom.yml logs -f remnawave
```

不要在没有数据库备份和 migration 回滚方案的情况下直接降级。每个 Release 必须同时固定 Backend、Frontend、Node 三个 tag；不要混用 `latest`、官方镜像和 custom 镜像。

## 故障排查

```bash
docker compose -f docker-compose.custom.yml ps
docker compose -f docker-compose.custom.yml logs --tail=200 remnawave
docker compose --env-file .env.node -f docker-compose.custom-node.yml ps
docker compose --env-file .env.node -f docker-compose.custom-node.yml logs --tail=200 remnanode
```

- migration 失败：检查 `DATABASE_URL`、PostgreSQL 密码、数据库健康状态和磁盘空间。
- Node 离线：检查 `SECRET_KEY`、Panel 到 Node 的网络、防火墙和 `NODE_PORT`。
- HY2 hopping 不生效：确认 UDP 端口范围已放行、Node 具备 `NET_ADMIN`，并检查 nftables 规则和 `PORT_HOPPING_INGRESS`。
- 订阅端口异常：确认用户对应的 UserRoute、Host、inbound 和 Node 均处于启用状态。

## 安全与正式版限制

- 立即更换 `APP_SECRET`、数据库密码、metrics 密码和 Node secret；不要把 `.env` 提交到 Git。
- 这是自定义发行版。请在升级前备份数据库，并在真实 NAT VPS/LXC、UDP、nftables、GOST reload、双 core 和客户端组合上按自身网络环境验证。
- 当前 `main` 不包含这些魔改；本部署文档只适用于同一 `custom-v0.2.1` 版本清单。
