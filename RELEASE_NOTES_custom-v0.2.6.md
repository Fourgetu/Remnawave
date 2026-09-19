# custom-v0.2.6

Node mTLS transport initialization and GOST User Route error feedback release.

## Fixed

- All Backend Node HTTP requests await one shared, concurrency-safe transport initialization per process, including API requests, jobs, and startup/reconnect GOST reconciliation.
- API-originated GOST synchronization now loads the managed Node CA, client certificate/private key, JWT, and HTTPS Agent instead of falling back to the default trust store.
- Initialization failure blocks the request. Explicit credential refresh preserves consistent Agent/JWT snapshots and refreshes SOCKS transport caches without mixing credentials.
- Failed User Route creation now displays localized A271 connection/TLS guidance or a safe generic error instead of silently ending the loading spinner.

## Components

- Backend: `ghcr.io/fourgetu/remnawave-backend:custom-v0.2.6`
- Backend platforms: `linux/amd64`, `linux/arm64`
- Node: `ghcr.io/fourgetu/remnawave-node:custom-v0.2.1` (unchanged; not rebuilt)
- Frontend: newly built `remnawave-frontend.zip` from the Frontend `custom-v0.2.6` Release, embedded into the Backend image
- Installation scripts download this release's templates; the Node template still pins the unchanged `custom-v0.2.1` image.

## Verification

- Frontend commit: `e97499dec7ffef22ff3cd8d47de60911313bcab8`
- Backend commit: `56da25add9e957254b550001c56e2b800ed21e7b`
- Node commit for the reused `custom-v0.2.1` image: `e22af77b921a60bc01fc5e05f0defb6f3edaf83e`
- Backend: 35/35 tests, typecheck, Nest/CQRS bootstrap integration, local ephemeral-certificate mTLS integration, vendored contract check, lint/format, and production build passed before release.
- Frontend: 147/147 tests, typecheck, modified-file lint/format, and production build passed before release.
- Frontend asset size: `13594008` bytes.
- Frontend asset SHA256: `3938f040faaf8683fcab0519c1054824b9c4705e8d9332801e75bcff65dc595d`.
- No VPS SSH, production database changes, or Docker smoke tests were performed for this release.

## Security and preserved behavior

- Managed Node CA verification and mTLS remain enabled with `rejectUnauthorized: true`; this release adds no TLS bypass.
- No real private keys, JWTs, Node secrets, or temporary SSH keys are included.
- Tests use non-secret placeholders or certificates generated only in memory.
- User Route validation, automatic port allocation, database insert, runtime synchronization, and failure compensation remain intact.
- No Node source changes or database schema changes are introduced.
- `custom-v0.2.0` through `custom-v0.2.5` remain immutable.
