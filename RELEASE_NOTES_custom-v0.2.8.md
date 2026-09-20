# custom-v0.2.8

## Fixed

- Backend 启动/升级时按 Profile `coreType` 重建入站投影，不再使用 Xray 解析器处理 sing-box Profile。
- 已有 Xray 与 sing-box 入站投影在启动 reconcile 后保持可见，现有入站 UUID、Host、Node 与 User Route 关联不再被错误清理。
- 修复 Hysteria2 Port Hopping 分配事务中 PostgreSQL advisory lock 的 `void` 返回值无法被 Prisma 反序列化，导致 User Route 保存返回 `A266` 的问题。
- Port Hopping 创建、编辑、关闭和删除继续保持 GOST、数据库和 Node desired state 一致；Node 拒绝 nftables 应用时保留补偿处理。
- Frontend 对端口跳跃范围分配失败、配置不兼容和 Node nftables 应用失败显示明确的本地化错误，不再静默结束。
- sing-box/Mihomo Hysteria2 订阅继续使用公网 Host、标准外部端口和用户跳跃范围，不泄露内部 `127.0.0.1` 监听地址。

## Components

- Backend: `ghcr.io/fourgetu/remnawave-backend:custom-v0.2.8`
- Backend platforms: `linux/amd64`, `linux/arm64`
- Backend multi-arch digest: `sha256:4eec1b8ad439912526c2e86995dada673990b5a72f97d0f835af9b49d4c6781b`
- Frontend: `Fourgetu/frontend` Release `custom-v0.2.8` 的全新 `remnawave-frontend.zip`，由 Backend 正式镜像下载并嵌入。
- Node: `ghcr.io/fourgetu/remnawave-node:custom-v0.2.1`，本次没有源码变化且未重新构建。

## Source and verification

- Frontend commit: `cf7e04f2b472af4cb9a7d38bf631d117314db571`
- Backend commit: `cae5fc268ea9c381d25f55dd1db2db1894b3bcba`
- Reused Node commit: `e22af77b921a60bc01fc5e05f0defb6f3edaf83e`
- Frontend: 180/180 tests、typecheck、lint/format、production build、`git diff --check` 通过。
- Backend: 50/50 tests、typecheck、lint/format、contract check、production build、`git diff --check` 通过。
- Frontend asset size: `13597925` bytes。
- Frontend asset SHA256: `578d6c9f1db804b00d7373896aac7e4de607d212f6f52a857beb0c0da5551ff7`。
- 本次发布没有连接 VPS、没有修改生产数据库、没有执行 Docker smoke test。
- `custom-v0.2.0` 至 `custom-v0.2.7` 的既有 tag、Release 和镜像保持不变。
