# custom-v0.2.2

## Fixed

- Fixed NestJS dependency injection for `CertificateProfileService` in the node queue module. `StartNodeProcessor` and the related node-start processors now resolve the owning certificate module explicitly.
- Added a Nest bootstrap regression test covering `StartNodeProcessor` resolution.
- Fixed `docker-compose.custom-node.yml` so `SECRET_KEY` is provided only by `.env.node`; Compose interpolation can no longer overwrite it with an empty value.
- Added a custom-node Compose regression check.

## Preserved

- Panel Certificate metadata, validation, Backend → Node certificate payloads, Node certificate storage, managed certificate markers, and managed sing-box Hysteria2 certificates are unchanged.
- `custom-v0.2.0` and `custom-v0.2.1` remain immutable.

## Verification

- Backend clean `npm ci`, Prisma generation, unit tests (17/17), Nest bootstrap regression, and production build passed.
- Node clean `npm ci`, typecheck, unit tests (12/12), and production build passed.
- Compose regression check passed with a non-empty `SECRET_KEY` loaded from `.env.node`.
- Local Docker clean build was attempted but blocked by the local Docker daemon's inability to reach Debian/Alpine package mirrors; the release workflow performs the authoritative clean multi-architecture build in GitHub Actions.

## Images

- Backend: `ghcr.io/fourgetu/remnawave-backend:custom-v0.2.2`
- Node: `ghcr.io/fourgetu/remnawave-node:custom-v0.2.1` (no Node binary/source changes in this hotfix)
