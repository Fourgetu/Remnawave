# custom-v0.2.3

Backend-only hotfix release.

## Fixed

- Fixed a Backend API startup failure: the panel TLS certificate metadata endpoint reused the `system:configuration` API token scope, so `ScopeCatalogService` aborted bootstrap with `Duplicate API token scope "system:configuration" - endpoint scope slugs must be unique within a resource`. The API process could not come up while `/health` on port 3001 still answered, which produced `Connection reset by peer` on port 3000.
- `GET /api/system/tls-certificate` now exposes its own unique scope `system:tls-certificate`. The existing `system:configuration` scope on `GET /api/system/configuration` is unchanged, so existing API tokens keep working.
- Added a scope catalog regression test that registers every scope-decorated controller, rebuilds the API token scope catalog exactly like application bootstrap does, and fails when an endpoint scope slug is duplicated within a resource. The test reproduces the exact `system:configuration` failure on the `custom-v0.2.2` code.

## Preserved

- CertificateProfileService DI wiring, panel certificate metadata API and validation, Backend to Node certificate payloads, Node CertificateService, managed sing-box Hysteria2 certificates, the repository-vendored Node Contract, and the custom-node Compose `SECRET_KEY` fix are unchanged.
- `custom-v0.2.0`, `custom-v0.2.1`, and `custom-v0.2.2` remain immutable.

## Verification

- Backend unit tests: 18/18 passed, including the new scope catalog regression test.
- Backend typecheck, formatter/linter on the changed files, and production build passed.
- GitHub Actions `Custom Release - Backend Image` built and pushed the multi-architecture image successfully.
- No VPS or container smoke test was executed for this hotfix; runtime verification is done on the operator's own test node.

## Images

- Backend: `ghcr.io/fourgetu/remnawave-backend:custom-v0.2.3`
- Node: `ghcr.io/fourgetu/remnawave-node:custom-v0.2.1` (no Node changes in this hotfix)
- Frontend: `remnawave-frontend.zip` attached to the Frontend GitHub Release `custom-v0.2.3`, byte-identical to `custom-v0.2.2` (sha256 `3c64f5a9a7a229345ba1d5bcb89610e639ef706f409f37ed38744a2c10171093`)