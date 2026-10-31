# custom-v0.2.16 — GOST 用户线路多选创建

## 新功能

- 「新建用户 GOST 线路」支持多选用户和服务端用户名搜索，搜索可找到前 100 条以外的用户。
- 多选时为每位用户自动分配独立外部端口，单选继续支持手填端口。
- 逐个创建并等待节点运行状态验证，显示每位用户的状态、端口及失败原因。
- 部分失败后只保留失败用户供重试，避免再次提交已经成功的用户。
- 创建过程中锁定表单和弹窗关闭，防止重复提交。
- 更新中文、英文文案和窄屏布局。

## 组件版本

| 组件 | 版本 |
| --- | --- |
| Panel / Backend 镜像 | `ghcr.io/fourgetu/remnawave-backend:custom-v0.2.16` |
| 内嵌 Frontend | `custom-v0.2.16` |
| Node 镜像 | `ghcr.io/fourgetu/remnawave-node:custom-v0.2.15`，保持不变 |

本版只更新前端功能及发布配置。Backend 业务代码、数据库 schema/migration、Node Contract、npm 锁定依赖不变。沿用 `custom-v0.2.15` 的运行时与安全修复；已有该版本的 Node 无需升级。

## 使用与升级

- 已有安装只更新 Panel 的 `CUSTOM_BACKEND_IMAGE` 至本版镜像，然后执行 Compose pull/up；前端已内嵌，无需另外部署。
- 从 `remnawave-backend:gost-multi-user-86225d30` 本地镜像切换时，同样需要先修改 Panel `.env` 的镜像变量。
- 更新后强制刷新浏览器，进入「用户线路限速 → 新建线路 → 用户（可多选）」。
- 所选用户共用节点、入站、Host、限速策略及跳跃配置，每人单独分配线路和端口。
- 遇到请求中断，先检查线路列表，确认服务器是否已经创建线路，再重试。
- 升级前备份 PostgreSQL 和部署配置。安装脚本面向新安装，不覆盖已有环境文件。
- 完整操作说明见本 Release 附件 `CUSTOM_DEPLOYMENT.md`。

## 可追溯信息

- Frontend 源码：`86225d30669d99a340623fbd28c086a71989a377`
- Backend 发布配置源码：`50d14e25d793b9f925ba0136bb133a79ac815ba6`
- Node 沿用源码：`89049ca93f172c094abc9ae1c27b914693c47cff`
- Backend 多架构 digest：`sha256:ef3ef7daf0a0e1c9c378ba80e2af2534dfafa32d02d862c5ad5af472ade97930`
- Node 多架构 digest：`sha256:8c83356b4079780264b2ab7292c4910a279177387875652ec4ddd66e297c99ba`
- Frontend asset SHA256：`e012ba733b44a5e4be1384dcaac6e954726c5b75e7d3897841fcd530a96ca9b5`

## 验证

- Frontend GitHub Actions：锁定依赖安装、223 项测试、类型检查和生产构建全部通过。
- 本地真实浏览器覆盖多选、逐项进度、部分失败只重试失败用户、搜索第 105 位用户、单人手工端口、处理中禁用表单，以及桌面和 390px 窄屏布局；API 使用本地模拟数据。
- amd64 发布候选容器通过数据库健康、内嵌前端资源、管理员注册/登录、用户搜索、UserRoute API、双内核 Host 克隆、REALITY 公钥和 VLESS encryption 订阅检查。
- arm64 镜像构建通过，并在 QEMU 下验证 Node.js 24.22.1 启动、版本元数据和新版前端资源；未执行完整 arm64 实机功能测试。
- GHCR 镜像包含 amd64/arm64，匿名读取成功；远端 amd64 manifest 与经过实际容器测试的候选完全一致。
- 安装脚本 Bash 语法、Panel/Node Compose 解析和 Node Secret 配置检查通过。
- 本版继续使用既有 GOST 线路安全模型，内核凭据与 UserRoute 端口没有密码学绑定。

## 构建方式

Frontend 使用 GitHub Actions 发布（run 41191170114）。Backend Actions dispatch 返回 HTTP 422（仓库 Actions 禁用），因此使用本地 Docker Buildx、已提交 Dockerfile、锁定依赖和同一源码归档完成双架构构建及推送。部署模板固定组件版本，不使用浮动 latest 标签。
