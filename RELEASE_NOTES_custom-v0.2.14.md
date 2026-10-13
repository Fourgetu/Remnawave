# custom-v0.2.14

本版将三批已审计的上游改进适配到定制分支，保留双内核、NAT/GOST、端口跳跃、自定义重置日期和扁平 VLESS 编辑等功能。前后端配套发布，Node 继续使用 `custom-v0.2.9`。

## 更新内容

- 修复 Xray gRPC 订阅的 `multiMode` 输出；数字 ID 筛选使用 BigInt 精确匹配。
- 修正订阅 Redis Stream 字段拼写；相关节点任务历史保留为 12 小时，成功/失败各最多 500 条。
- 节点编辑只提交变化字段；名称、备注和计费等修改不再触发不必要的内核启动，保留双内核独立绑定及解除绑定语义。
- 增加上次/下次流量重置日期模板变量，与订阅 refill header 共用计算；兼容定制的每月指定日期和短月边界。
- Host 克隆改用后端事务：复制 Host 字段、节点和内部组关联，新 Host 默认禁用；支持写入失败回滚及并发排序。独立用户路由及资源分配记录不随 Host 克隆复制。
- 新增 traceroute 展示，旧报告或字段异常时回退到图片/JSON；同步服务商链接、YAML 编辑器设置、状态按钮颜色和 8 项中文翻译。
- 定制标签使用专用发布流程，在锁定依赖和受支持的 Node.js 上测试后构建，避免同时触发旧上游发行流程。

## 组件

- Frontend 源码：`0eb24377726919a20aef2a0e12094b5981e2ee09`
- Frontend 资产：`Fourgetu/frontend@custom-v0.2.14` 的 `remnawave-frontend.zip`
- Frontend 资产大小：`13543006` bytes
- Frontend SHA256：`d7fae84c4d9fe1c2a61af35dc0131f9c8e2557b21dc8c6403324e61b470e5232`
- Backend 源码：`2b2b9521573d9fbe30c07a4940566ed71ee228de`
- Backend 镜像：`ghcr.io/fourgetu/remnawave-backend:custom-v0.2.14`
- Backend 多架构 digest：`sha256:da9cce9a3dd3bb3225b0a7e5d02507198222d50372f2ef65799cc710157a147b`
- Backend 架构：`linux/amd64`、`linux/arm64`
- Node 镜像：`ghcr.io/fourgetu/remnawave-node:custom-v0.2.9`

## 验证

- GitHub Actions 使用 Node.js 24.20.0 与 `npm ci` 安装锁定依赖：前端 219 项测试、TypeScript 和生产构建通过；后端 101 项单元测试、类型检查及 6 项 PostgreSQL 集成测试通过。
- 本地浏览器检查覆盖桌面、390×844 窄屏和旧/异常报告回退。
- Panel/Node Compose 配置及两个安装脚本语法检查通过。
- GHCR 双架构镜像构建成功；拉取最终 amd64 镜像，在隔离 PostgreSQL 18.4 / Valkey 9 中通过 migration/seed、数据库健康、内嵌前端资源、管理员注册/登录、Xray 与 sing-box 的 Host 创建/克隆/回读以及未认证拒绝检查。arm64 已构建，未执行运行烟测。

## 升级说明

- 无新增数据库 migration，不升级 npm 依赖版本。已有 migration 仍由容器启动脚本处理，升级前备份数据库。
- 前后端须配套更新；受限 API token 调用克隆接口需要 `hosts:clone` 写权限。
- 数字 ID 搜索改为精确匹配。外部 Redis Stream 消费程序应读取 `srrResponseType`；读取历史积压记录时兼容旧拼写 `ssrResponseType`。
- Node 无需随本版升级。本次 GitHub 发布不自动更新现有 VPS；未验证真实节点的代理流量或所有生产网络组合。
