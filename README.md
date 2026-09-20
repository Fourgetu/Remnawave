<div align="center">
  <img src="https://cdn.docs.rw/logos/logo.svg" alt="Remnawave Logo" width="140" height="140">

  <h1>Remnawave Custom</h1>

  <p><strong>Fourgetu 维护的 Remnawave 增强发行版</strong></p>
  <p>双内核 · 一键搭建节点 · 一键中转落地 · User Route / GOST 限速 · Hysteria2 端口跳跃</p>

  <p>
    <a href="https://github.com/Fourgetu/Remnawave/releases/tag/custom-v0.2.8">
      <img src="https://img.shields.io/badge/release-custom--v0.2.8-0969da?style=flat-square" alt="custom-v0.2.8">
    </a>
    <a href="https://github.com/Fourgetu/Remnawave/pkgs/container/remnawave-backend">
      <img src="https://img.shields.io/badge/GHCR-amd64%20%7C%20arm64-2496ED?style=flat-square&logo=docker&logoColor=white" alt="GHCR multi-arch">
    </a>
    <a href="./LICENCE">
      <img src="https://img.shields.io/badge/license-AGPL--3.0-green?style=flat-square" alt="AGPL-3.0">
    </a>
  </p>
</div>

> [!IMPORTANT]
> 这是基于 [Remnawave](https://github.com/remnawave/panel) 的非官方自定义发行版，不属于 Remnawave 官方项目。请勿混用官方镜像、`latest` 镜像与本仓库的 custom 镜像。生产升级前请先备份数据库。

## 这是什么

本项目在保留 Remnawave 原有用户、订阅、节点、Host、流量统计等能力的基础上，加入了 Xray + sing-box 双内核、Visual Config Builder、用户线路、GOST 限速、Hysteria2 Port Hopping、Panel 托管证书及完整中文化等功能。

当前正式版本：[`custom-v0.2.8`](https://github.com/Fourgetu/Remnawave/releases/tag/custom-v0.2.8)

| 组件 | 正式版本 / 镜像 |
| --- | --- |
| Panel / Backend | `ghcr.io/fourgetu/remnawave-backend:custom-v0.2.8` |
| Frontend | `Fourgetu/frontend:custom-v0.2.8`，已内嵌到 Backend 镜像 |
| Node | `ghcr.io/fourgetu/remnawave-node:custom-v0.2.1` |
| 架构 | `linux/amd64`、`linux/arm64` |

Node 在本次版本没有源码变化，因此继续使用已经验证的 `custom-v0.2.1`，这不是版本遗漏。

## 魔改功能

### Xray + sing-box 双内核

- 同一个 Node 可以同时运行 Xray 与 sing-box。
- 每个 Node 最多绑定一个 Xray Profile 和一个 sing-box Profile。
- 两个 Profile 可以独立选择入站，互不覆盖、互不清除。
- Xray JSON 只交给 Xray，sing-box JSON 只交给 sing-box，不会合并成一个配置。
- `coreType` 全链路 fail-closed，缺失时不会默认当作 Xray 处理。
- 保存后 Query Cache、Visual Parser、Schema 校验均保留正确的 `coreType`。

### Visual Config Builder

- 图形化 / JSON 双模式编辑。
- 图形化管理入站、出站、路由规则和 DNS。
- 支持 Reality、TLS、SNI 等高级参数。
- 支持 Xray 与 sing-box 的独立 Adapter、Schema 和校验流程。
- sing-box 使用 `singbox.schema.json` 与 `singbox-config://` URI，不再进入 Xray WASM validator。
- targeted patch、unknown-field preservation 和 snippet protection，尽量保留图形化编辑器尚未识别的原始字段。
- 支持导入 `vless://`、`vmess://`、`trojan://`、`ss://`、`hysteria2://`、`hy2://`、`tuic://` 分享链接，并在写入前预览确认。
- 配置文件列表可直接进入“图形化”页面；图形化页面可以直接校验并保存，无需切换回 JSON。

### 一键搭建节点（Quick Deploy）

在“节点”页面选择“一键搭建节点”，即可通过向导为现有在线 Node 生成并应用代理入站：

- 选择目标 Node、Xray / sing-box 核心及对应 Config Profile。
- Node 尚未绑定该核心 Profile 时，可以在部署流程中自动创建或完成绑定，不会覆盖另一个核心的 Profile。
- 支持一次选择多个推荐协议，并自动生成不冲突的 Inbound tag、监听端口和必要的协议参数。
- Xray 正式可用预设：VLESS Reality Vision、VLESS Reality gRPC、Trojan TCP TLS、Hysteria2、Mixed。
- sing-box 正式可用预设：Hysteria2、Mixed。
- Reality 自动生成 X25519 密钥和 serviceName，并提供 Mihomo / sing-box 客户端兼容策略。
- TLS 协议可以使用 Panel 托管证书，或指定容器内已有证书路径。
- 可按需创建订阅 Host；Mixed 等工具型协议默认不会自动暴露到订阅。
- 部署前显示 Profile、Inbound、端口、Host 和兼容设置预览；匹配的现有资源会复用或跳过，避免重复创建。
- 写入时保留已有 Inbound 和未知 JSON 字段；检测到并发修改时停止写入并要求重新确认。
- 部署结果分别显示 Profile 更新、Node Inbound 启用、Host 创建、Node 配置应用及回滚状态。

> [!NOTE]
> “一键搭建节点”用于配置已经安装并连接到 Panel 的 Node，不负责给一台全新的 Linux 服务器安装 Docker 或 Node。全新服务器请先使用下方的 Node 一键安装命令。

### 一键中转 / 落地（Relay）

在“节点”页面选择“一键中转”，可以把入口 Node 的指定 Inbound 快速接到已有落地节点：

```text
客户端 → 入口 Node → 入口 Inbound → Relay Outbound → 落地节点 → Internet
```

- 选择接收客户端流量的入口 Node 和当前启用的入口 Inbound。
- 直接粘贴落地节点 URI，自动解析为 Xray Relay Outbound。
- 支持 VLESS、VMess、Trojan、Shadowsocks、SOCKS 和 HTTP / HTTPS Proxy URI。
- 自动生成稳定且不泄露凭据的 Outbound tag。
- 自动创建对应 Routing Rule，将选中的入口 Inbound 精确路由到落地 Outbound。
- 路由规则会放在兜底规则之前，并保留已有 BLOCK 等高优先级规则。
- 已存在相同 Outbound 或 Routing Rule 时自动复用，不重复添加。
- 部署预览会隐藏 UUID、用户名和密码，相关凭据不会写入日志。
- 写入前重新检查 Config Profile；如果预览后配置已变化，本次不会覆盖服务器内容。
- 结果页分别显示 Outbound、Routing Rule、Profile 保存、Node reload、runtime 与 connectivity 状态。

> [!WARNING]
> 一键中转不会替你安装或维护落地服务器，粘贴的落地 URI 必须已经可用。JSON 保存和 Node reload 成功也不等于真实流量一定从落地节点出网；部署后仍应通过客户端访问 `https://www.cloudflare.com/cdn-cgi/trace` 或 `ipinfo.io` 核对出口 IP。

### User Route / GOST 用户线路

- 为指定用户、Node、Profile、Inbound 创建独立公网线路。
- 支持自动分配或手动指定外部端口。
- 支持 TCP / UDP 转发及运行状态验证。
- 支持按线路绑定上传、下载限速策略。
- 已有线路可以直接编辑限速策略、绑定/更换/关闭 Hysteria2 Port Hopping，无需删除重建。
- Host 会按 Node、`coreType`、Profile 和 Inbound 精确匹配；未限制 Node 的 Host 也可以正确使用。
- Backend 与 Node 使用严格 mTLS 通信，Node CA、客户端证书与 JWT 不会回退到默认 HTTPS transport。
- 创建、同步或运行时验证失败时，Frontend 会显示明确错误，不再静默结束。

### Xray 公开入站兼容模式

Xray 入站监听 `0.0.0.0` 时，可在显式开启兼容模式并确认风险后创建 GOST User Route：

- GOST 仍转发至 `127.0.0.1`。
- 不修改原 Xray Profile。
- 不修改防火墙。
- 不自动隐藏原公网核心端口。

> [!WARNING]
> 原公网核心端口仍然可以直接访问，因此可能绕过 GOST 限速。公开入站兼容模式不是“强制限速”模式。

### Hysteria2 Port Hopping

- 为 sing-box Hysteria2 用户线路分配稳定的 UDP 端口范围。
- 使用 `nftables → GOST → 127.0.0.1 上的 sing-box HY2 入站` 完成转发。
- Port Hopping 是可选增强；未启用时仍可使用标准单 UDP 端口。
- 支持创建、编辑、关闭和删除，并保持数据库、GOST 与 Node desired state 一致。
- 订阅为兼容客户端输出标准外部端口和跳跃端口范围，不泄露内部回环监听地址。

> [!NOTE]
> 客户端和订阅转换工具必须保留 Hysteria2 的 `ports` 字段。Node 主机需要 `NET_ADMIN`，并需要在云防火墙/系统防火墙中放行相应 UDP 端口范围。

### Panel 托管证书

- Panel 可以读取并校验证书元数据。
- Backend 可通过内部 Contract 将证书安全传递给 Node。
- sing-box Hysteria2 可以使用 Panel-managed certificate。
- Node Contract 使用仓库内 vendored package，不依赖 `@remnawave` 或其他 npm scope 的发布权限。
- 私钥只用于 Backend → Node 内部请求，不进入公开订阅。

### 其他增强

- Quick Protocol 与 Mixed 入站支持。
- VLESS / VMess / Trojan / Shadowsocks / SOCKS / Hysteria2 / TUIC 等配置能力。
- SOCKS credentials / UDP 与 traffic accounting。
- 用户线路、GOST、Port Hopping、Visual Builder 等相关界面中文化。
- Node GOST 同步、启动 reconcile、API/jobs/scheduler 使用统一且并发安全的 mTLS transport 初始化。

## 一键安装

### 前置条件

- 一台用于 Panel 的 Linux 服务器。
- 一台或多台用于 Node 的 Linux 服务器；也可以按自身环境部署在同一台服务器。
- 已安装 Docker Engine 与 Docker Compose v2。
- 建议使用 `root`，或者使用具备 Docker 权限的账户。
- Panel 域名已经解析到 Panel 服务器。
- Panel 到 Node 的 API 端口可达，默认端口为 `2222`。
- GHCR 镜像为公开镜像，不需要 npm 登录或 npm token。

### 1. 安装 Panel

在 Panel 服务器执行：

```bash
bash <(curl -fsSL https://github.com/Fourgetu/Remnawave/releases/download/custom-v0.2.8/install-panel.sh | sed 's/\r$//')
```

安装脚本会：

1. 询问 Panel 域名；
2. 自动生成 `APP_SECRET`、PostgreSQL 密码和 Metrics 密码；
3. 下载固定版本的 Compose 与环境变量模板；
4. 拉取 `custom-v0.2.8` Backend 镜像并启动 Panel、PostgreSQL 和 Valkey。

默认安装目录：

```text
~/remnawave-custom
```

查看状态与日志：

```bash
cd ~/remnawave-custom
docker compose -f docker-compose.custom.yml ps
docker compose -f docker-compose.custom.yml logs -f remnawave
```

Panel 默认只监听 `127.0.0.1:3000`，请使用 Caddy、Nginx 等反向代理为 Panel 域名提供 HTTPS：

```text
https://panel.example.com → http://127.0.0.1:3000
```

不要把 PostgreSQL `6767` 或 Metrics `3001` 直接暴露到公网。

### 2. 在 Panel 中创建 Node

登录 Panel，添加 Node，并复制该 Node 对应的 `Secret Key`。每台 Node 使用自己的 Secret。

### 3. 安装 Node

在 Node 服务器执行：

```bash
bash <(curl -fsSL https://github.com/Fourgetu/Remnawave/releases/download/custom-v0.2.8/install-node.sh | sed 's/\r$//')
```

脚本会要求输入刚才复制的 Node Secret，然后下载固定版本 Compose、启用 `NET_ADMIN` / `nftables` Port Hopping 支持，并启动 Node。

默认安装目录：

```text
~/remnawave-custom-node
```

查看状态与日志：

```bash
cd ~/remnawave-custom-node
docker compose --env-file .env.node -f docker-compose.custom-node.yml ps
docker compose --env-file .env.node -f docker-compose.custom-node.yml logs -f remnanode
```

Node 使用 host network，API 默认直接监听主机的 `2222` 端口。请根据实际使用情况放行：

- Node API：TCP `2222`
- 代理核心入站端口
- User Route 外部 TCP / UDP 端口
- Hysteria2 Port Hopping UDP 范围

### 自定义安装目录

```bash
INSTALL_DIR=/opt/remnawave-custom \
  bash <(curl -fsSL https://github.com/Fourgetu/Remnawave/releases/download/custom-v0.2.8/install-panel.sh | sed 's/\r$//')
```

Node 同样可以通过 `INSTALL_DIR` 指定目录。

## 升级与备份

升级前务必先备份 PostgreSQL。不要直接修改旧 tag，也不要使用 `latest` 替换固定版本镜像。

完整的手动部署、备份、升级和故障排查说明请查看：

- [自定义部署文档](./CUSTOM_DEPLOYMENT.md)
- [custom-v0.2.8 Release Notes](./RELEASE_NOTES_custom-v0.2.8.md)
- [全部 GitHub Releases](https://github.com/Fourgetu/Remnawave/releases)

## 安全说明

- 不要提交 `.env`、Node Secret、JWT、CA 私钥、客户端私钥或真实证书私钥。
- 不要通过 `rejectUnauthorized=false` 等方式绕过 Node mTLS。
- GOST 限速桶按外部线路端口选择，是线路级限速，不是互不信任用户之间的加密级配额边界。
- User Route 外部端口属于敏感分配信息，请不要公开传播。
- 使用 Xray 公开入站兼容模式时，应自行限制原核心公网端口，否则客户端可以绕过 GOST。
- Hysteria2 Port Hopping 依赖 `nftables`、`NET_ADMIN` 和正确的 UDP 防火墙策略。

## 项目与组件仓库

- 顶层发布与部署模板：[Fourgetu/Remnawave](https://github.com/Fourgetu/Remnawave)
- Frontend：[Fourgetu/frontend](https://github.com/Fourgetu/frontend)
- Backend：[Fourgetu/backend](https://github.com/Fourgetu/backend)
- Node：[Fourgetu/node](https://github.com/Fourgetu/node)
- 上游项目：[remnawave/panel](https://github.com/remnawave/panel)

## License 与致谢

本项目遵循仓库中的 [AGPL-3.0 License](./LICENCE)。感谢 Remnawave 及其上游贡献者。本仓库的 custom 功能、镜像和 Release 由 Fourgetu 自行维护；遇到 custom 功能问题时，请优先在 Fourgetu 仓库反馈，不要向上游项目提交与本魔改版本有关的故障。
