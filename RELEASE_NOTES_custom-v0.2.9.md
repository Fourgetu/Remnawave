# custom-v0.2.9

## Added

- VLESS Reality Vision Quick Protocol 与 Quick Deploy 正式支持 Xray 和 sing-box 双内核，并按 `coreType` 生成各核心原生配置。
- SS2022 `2022-blake3-aes-128-gcm` 与 `2022-blake3-aes-256-gcm` 正式支持 Xray / sing-box Managed Users、Host、订阅和 GOST 用户线路。
- capability matrix 区分核心原生协议支持、Managed Users、Quick Protocol 与 Quick Deploy 能力。
- Visual Builder 可识别和编辑原生 sing-box Reality 与 SS2022 字段，同时保留 unknown fields。

## Safety and compatibility

- `2022-blake3-chacha20-poly1305` 在 UI 中保留但禁用；Backend 同样拒绝 Managed Users，不会降级为共享密码或静默切换 AES method。
- SS2022 server key 与 per-user key 分离，订阅按 SS2022 多用户规则输出 `serverKey:userKey`。
- Reality 订阅只输出 public key、short ID 与标准客户端字段，不输出 `private_key`、服务端私钥或内部监听地址。
- SS2022 最后一个用户删除或禁用后，Node 不会保留可被共享 server key 认证的 zero-user listener；恢复用户时可从 desired template 重建。
- SS2022 TCP+UDP User Route 使用一个外部端口和两个 GOST forward，共享同一个 limiter。
- Hysteria2 新建模板继续保持 sing-box-only；Trojan TCP TLS、传统 Shadowsocks AEAD 与 VMess 未在缺少完整无损链路验收时扩大双内核范围。

## Components

- Frontend: `Fourgetu/frontend@custom-v0.2.9`
- Frontend asset: `remnawave-frontend.zip`
- Frontend asset size: `13600974` bytes
- Frontend asset SHA256: `48efec830554885d6cd5a81abf21e76d9ef0db6d8b52cff63424aae10f8754e6`
- Backend: `ghcr.io/fourgetu/remnawave-backend:custom-v0.2.9`
- Backend platforms: `linux/amd64`, `linux/arm64`
- Backend multi-arch digest: `sha256:a8994f6ededd6dda94377cfe3e4a97aa52602b14a9dd4ffc4fc4f4365266d39c`
- Node: `ghcr.io/fourgetu/remnawave-node:custom-v0.2.9`
- Node platforms: `linux/amd64`, `linux/arm64`
- Node multi-arch digest: `sha256:d4324b477c10636722a48f316201122163faf5e4ae16be4dfdcad62639d7f12b`

## Source and validation

- Frontend commit: `bf772bbfbadb650c01bcc9338bfa847624004c9b`
- Backend commit: `45a7f3c3da6440e608bf2b0233bd474e4305e1cc`
- Node commit: `3a6f31e11ae9fa0dd592ec10969f8a4efc867b69`
- Frontend: 199/199 tests、typecheck、lint/format、production build、`git diff --check` 通过。
- Backend: 74/74 tests、typecheck、bootstrap/integration、contract check、lint/format、production build、`git diff --check` 通过。
- Node: 15/15 tests、typecheck、lint/format、production build、`git diff --check` 通过。
- Unit/build validation passed. Runtime core acceptance pending production/test-node verification.
- 当前本地环境未安装 Xray 26.7.28 与 sing-box 1.13.14，因此没有声称 native core config check 已通过。
- 本次发布没有连接 VPS、没有修改生产数据库、没有执行 Docker smoke test。
- `custom-v0.2.0` 至 `custom-v0.2.8` 的既有 tag、Release 和镜像保持不变。
