# custom-v0.2.7

## Added

- 用户线路新增“编辑”：修改限速策略，绑定、更换或关闭 Hysteria2 Port Hopping，无需删除重建线路。仅修改限速策略不会重新分配现有端口跳跃范围。
- Xray `0.0.0.0` 公开入站兼容模式：必须显式开启并单独确认风险，GOST 始终转发到 `127.0.0.1`。
- 配置文件列表增加“图形化”按钮，直接进入独立图形化编辑页。
- 图形化编辑页底部增加“保存”：按内核校验通过才保存；校验或请求失败时保留草稿并显示错误，无需切换 JSON 模式。

## Security and limitations

- 公开入站兼容模式不修改原 Xray Profile、不修改防火墙、不自动隐藏原公开端口。
- **原公网核心端口仍可直接访问，因此可能绕过 GOST 限速。这不是强制限速模式。**
- 保留严格 Node mTLS 校验、Panel-managed certificates、coreType fail-closed、独立 Xray/sing-box 校验及未知字段保护。
- 未引入数据库迁移、Node 源码变更、npm publish 或私有 registry 依赖。
- 基础 HY2 协议已由用户完成生产实机验证；本版新增功能发布后由用户实机验证，未声称已通过生产 smoke test。

## Components

- Backend: `ghcr.io/fourgetu/remnawave-backend:custom-v0.2.7`
- Backend platforms: `linux/amd64`, `linux/arm64`
- Frontend: 本次重新构建的 `custom-v0.2.7/remnawave-frontend.zip`，由 Backend 正式构建下载并嵌入，未复用旧版本前端包。
- Node: `ghcr.io/fourgetu/remnawave-node:custom-v0.2.1`，保持不变，未重新构建。
- 安装脚本使用本版部署模板；Node 模板仍固定上述 `custom-v0.2.1` 镜像。

## Source and verification

- Frontend commit: `7c4d963aa558e5c6a6dbbc5d0a2ca35fc78814fc`
- Backend commit: `4a6987da9e73702dab915199585824a61c2c4c96`
- Reused Node commit: `e22af77b921a60bc01fc5e05f0defb6f3edaf83e`
- 发布前 Frontend：176/176 tests、typecheck、修改文件 lint/format、production build、本地浏览器交互验证通过。
- 发布前 Backend：41/41 tests、typecheck、修改文件 lint/format、contract check、production build 通过。
- Frontend asset size: `13554669` bytes.
- Frontend asset SHA256: `673cfe59102cca597fab6d1fd38374fd7c113e014371e896ad2e798855ea25c4`.
- 本次发布未 SSH VPS、未修改生产数据库、未进行 Docker smoke test。
- 本次提交不包含真实证书私钥、Node secrets、JWT 或临时 SSH key。
- `custom-v0.2.0` 至 `custom-v0.2.6` 的既有 tag、Release 和镜像保持不变。
