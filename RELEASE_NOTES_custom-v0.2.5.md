# custom-v0.2.5

GOST User Route submission readiness release.

## Fixed

- Valid sing-box Hysteria2 User Routes can now be submitted with automatic external-port allocation.
- Port Hopping remains optional for standard single-port UDP routes.
- Host compatibility, loopback listener, confirmation, required selections, and manual port validation now use one shared Frontend readiness rule.
- If a denormalized inbound record omits `listen`, the Frontend resolves it from the same Config Profile by inbound tag while still requiring `127.0.0.1` or `::1`.

## Components

- Backend: `ghcr.io/fourgetu/remnawave-backend:custom-v0.2.5`
- Backend platforms: `linux/amd64`, `linux/arm64`
- Node: `ghcr.io/fourgetu/remnawave-node:custom-v0.2.1` (no Node source changes)
- Frontend: `remnawave-frontend.zip` from the Frontend `custom-v0.2.5` Release, embedded into the Backend image

## Verification

- Frontend commit: `1bf5e65e05a82a9166111af88470727da445e909`
- Backend commit: `02080c3801488a7bcbce289adf792db2dae63133`
- Frontend typecheck, 141/141 tests, Oxfmt, Oxlint, and production build passed.
- Backend vendored contract check and multi-architecture GitHub Actions build passed.
- No VPS SSH or Docker smoke test was performed for this release.

## Preserved

- `custom-v0.2.0`, `custom-v0.2.1`, `custom-v0.2.2`, `custom-v0.2.3`, and `custom-v0.2.4` remain immutable.
