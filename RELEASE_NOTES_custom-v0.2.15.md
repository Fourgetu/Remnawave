# custom-v0.2.15

本版按 2026-10-23 审计结果同步上游安全维护，保留定制双内核、NAT/GOST、用户限速与端口跳跃能力。Backend 与 Node 同步升级，Frontend 复用 custom-v0.2.14。

## 更新内容

- Backend 与 Node 的构建及运行镜像固定使用 Node.js 24.22.1，跟进该版本的运行时安全修复。
- X25519 公钥派生改用已有的 `@noble/curves`，避免新 OpenSSL 对空 JWK 公钥字段的校验导致 REALITY 订阅公钥缺失。保留 Xray `privateKey` 与 sing-box `private_key` 两种配置格式，同时覆盖 VLESS encryption 派生。
- 按状态批量删除用户改为 Kysely 参数化查询，保留默认每批 30000 个、实际删除数量返回及数据库级联清理。
- Node 定制标签改走专用发布流水线，先创建草稿，运行验证完成后再发布正式版。
- 安装脚本和 Compose 默认使用本版 Backend/Node；部署文档的交互式安装命令与 README 保持一致。

## 同步范围

- 上游 Backend `6863f61990eb9fd6a92ccaf5832dccac772cb35a`：X25519 公钥修复，已适配定制双内核。
- 上游 Backend `b5551e979eff63368598b45ab3122349211b48b7`：按状态批量删除。
- 同步上游运行时安全升级；不合并整套 npm 依赖更新、SNI 策略、postStart 或 rabbit UA 行为改动。
- 无新增数据库 migration，npm 锁定依赖与 Node Contract 不变；不是完整升级到上游 3.4.7。

## 组件与可追溯信息

- Backend 源码：`f96fab76ccc59f0dd933fa26b17694f250624fe6`
- Backend 镜像：`ghcr.io/fourgetu/remnawave-backend:custom-v0.2.15`
- Backend 多架构 digest：`sha256:39716e663c1d99814651e788f21bf428381e105ae5f1947ea75625ab5bff0c54`
- Node 源码：`89049ca93f172c094abc9ae1c27b914693c47cff`
- Node 镜像：`ghcr.io/fourgetu/remnawave-node:custom-v0.2.15`
- Node 多架构 digest：`sha256:8c83356b4079780264b2ab7292c4910a279177387875652ec4ddd66e297c99ba`
- Frontend 源码：`0eb24377726919a20aef2a0e12094b5981e2ee09`
- Frontend 资产：`Fourgetu/frontend@custom-v0.2.14` 的 `remnawave-frontend.zip`，13543006 bytes。
- Frontend SHA256：`d7fae84c4d9fe1c2a61af35dc0131f9c8e2557b21dc8c6403324e61b470e5232`
- Xray `26.7.28`、sing-box `1.13.14`、GOST `3.3.0` 保持不变。

## 验证

- Backend 在 Node.js 24.22.1 下通过 105 项单元测试、10 项 PostgreSQL 集成测试、类型检查及生产构建。集成测试覆盖 Host 克隆事务、批量删除参数绑定、批次限制、关联清理、共享配置保留、端口重新分配与事务回滚。
- Node 通过 15 项单元测试、类型检查和生产构建；GitHub Actions 使用 Node.js 24.22.1 与 `npm ci`。
- 安装脚本语法、Panel/Node Compose 配置检查通过。
- Backend amd64 容器在隔离 PostgreSQL 18.4 / Valkey 9 中通过 migration/seed、健康检查、内嵌前端资源、管理员注册/登录、双内核 Host 克隆与未认证拒绝检查；通过真实 API 创建用户并确认 Xray/sing-box REALITY 订阅公钥及 Xray VLESS encryption 正确。
- Node amd64 最终镜像通过 mTLS API、GOST TCP/UDP 转发、无效配置回滚、双内核 SOCKS 数据传输与错误密码拒绝检查；真实 HY2 客户端在重启前后保留跳跃范围和独立 20/100 Mbps 聚合限速。
- Backend/Node 的 amd64、arm64 产物均已构建；arm64 未执行完整运行测试，amd64 检查不代表所有生产网络环境。

## 升级说明

- Panel 和 Node 均使用 `custom-v0.2.15`；前端已内嵌，无需单独部署。
- 运行时更新必须与本版 X25519 修复配套，避免单独替换旧 Backend 的基础镜像。
- 已有部署修改镜像版本后执行 Compose pull/up；一键安装脚本适用于新安装，不覆盖已有环境文件。
- 升级前备份 PostgreSQL。无新增 migration，已有 migration 仍由容器启动流程处理。
- 本次发布不自动更新 VPS，也未连接生产节点；生产环境的 NAT/LXC、UDP、防火墙和客户端组合仍需部署后验证。
- 既有限制仍在：有效内核凭据没有与某个 UserRoute 端口做密码学绑定；本版不改变这一行为。
