# custom-v0.2.10

## Added

- 新增 **Custom monthly traffic reset day（每月指定日期重置）**。
- 每个用户可独立选择每月 `1`～`31` 日重置流量。
- 新增策略：`MONTH_CUSTOM_DAY`。
- 新建用户、编辑用户、批量编辑、用户详情、用户列表和 Subscription metadata 均支持新策略。

## Calendar behavior

- `31` 日在二月回退到二月最后一天，在四月回退到 4 月 30 日。
- `30` 日在二月回退到二月最后一天。
- `29` 日在非闰年二月回退到 2 月 28 日，闰年使用 2 月 29 日。
- 修改策略或重置日期不会立即清零当前流量。
- 创建时间或修改时间作为调度 anchor；如果本月指定日期已经过去，首次重置从下个月开始。
- `lastTrafficResetAt` 只记录真实流量重置，不会因编辑设置而伪更新。

## Database migration

Database migration included:

`20260922120000_add_custom_user_traffic_reset_day`

新增 nullable 字段：

- `traffic_limit_reset_day`
- `traffic_limit_reset_anchor_at`

Migration 包含 `1 <= traffic_limit_reset_day <= 31` 范围约束，以及 `MONTH_CUSTOM_DAY` 与日期字段的配对约束。旧用户升级后两个字段均为 `NULL`，既有 reset strategy 行为保持不变。

正式 migration 继续由 Panel 容器启动时通过项目现有机制执行。本次发布没有连接生产数据库，也没有执行生产 migration。升级前建议备份 PostgreSQL。

## Components

- Frontend: `Fourgetu/frontend@custom-v0.2.10`
- Frontend asset: `remnawave-frontend.zip`
- Frontend asset size: `13602231` bytes
- Frontend asset SHA256: `d9f89f417b2da55a3a3d7c3064c5be70e5f317b5c40f7b140d06972d15c5dfb7`
- Backend: `ghcr.io/fourgetu/remnawave-backend:custom-v0.2.10`
- Backend platforms: `linux/amd64`, `linux/arm64`
- Backend multi-arch digest: `sha256:7ac95ce20cb68d3676579aec36f7db541a8bf5b8d3f4cd7095d61c7468624467`
- Node: `ghcr.io/fourgetu/remnawave-node:custom-v0.2.9`
- Node was intentionally not rebuilt or retagged because this feature is implemented entirely in the Panel/database layer.

## Source and validation

- Frontend commit: `ba525f803290362fd6551bd3b5d68938c25c336f`
- Backend commit: `493017280a7c7c58bdd99cfbdf8c91dc40e36ac4`
- Node commit: `3a6f31e11ae9fa0dd592ec10969f8a4efc867b69`（无新修改）
- Frontend: 205/205 tests、typecheck、lint/format、production build、`git diff --check` 通过。
- Backend: 83/83 tests、typecheck、lint/format、contract check、production build、Prisma validate、Prisma generate、`git diff --check` 通过。
- 本次发布没有 SSH Panel/Node VPS，没有执行生产 migration，也没有执行 Docker smoke test。
- `custom-v0.2.0` 至 `custom-v0.2.9` 的既有 tag、Release 和镜像保持不变。
