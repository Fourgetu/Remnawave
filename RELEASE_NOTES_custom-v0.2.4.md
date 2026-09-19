# custom-v0.2.4

User Route / GOST Host selector compatibility release.

## Fixed

- Fixed the User Route Host selector showing no candidates when a matching Host had an empty visual-only Node assignment.
- Matching Hosts now remain available when their Profile UUID and Inbound UUID match the selected Node inbound and their optional Node assignment is empty.
- Hosts explicitly assigned to another Node, another Profile, another Inbound, or the other core remain excluded.
- Backend User Route validation now applies the same compatibility rule as the Frontend, preventing a Host shown by the UI from being rejected during save.

## Production Evidence

- The affected sing-box Host and Hysteria2 inbound had matching Profile and Inbound UUIDs, port `35371`, and the correct `singbox` core type.
- The Host's `hosts_to_nodes` relation was empty. Remnawave documents that Host-to-Node assignment as visual-only, but the User Route implementation previously treated it as mandatory.

## Verification

- Frontend typecheck passed.
- Frontend tests: 134/134 passed.
- Frontend changed-file lint/format and production build passed.
- Backend typecheck passed.
- Backend tests: 21/21 passed.
- Backend lint/format, vendored contract check, and production build passed.
- No VPS SSH or Docker smoke test was performed for this release.

## Images

- Backend: `ghcr.io/fourgetu/remnawave-backend:custom-v0.2.4`
- Node: `ghcr.io/fourgetu/remnawave-node:custom-v0.2.1` (no Node source changes)
- Frontend: `remnawave-frontend.zip` attached to the Frontend GitHub Release `custom-v0.2.4`

## Preserved

- `custom-v0.2.0`, `custom-v0.2.1`, `custom-v0.2.2`, and `custom-v0.2.3` remain immutable.
