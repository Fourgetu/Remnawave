# custom-v0.2.0

## Component baseline

- Frontend source: `92768ccf307314c46a5ec2e4a02be96cc419c4a0`
- Frontend release ref: `aa34e2310f7f28d8cc9e09e95162f6ff0dca1d09`
- Backend source: `2df8f09b0955d9f999b9358dbef373f604e53817`
- Backend release ref: `305957df716a7a4c14da7c528b18e53013268280`
- Node source: `cb66ac718988df925bce6a9aacb6dbfec506f86a`
- Node release ref: `75927e76f7c34ec82cfc46b7a8ce77ecb7019e97`

## Added

- Visual Config Builder Phase 1-6.
- Graphical inbound management.
- Graphical outbound management.
- Graphical routing rules.
- Graphical DNS management.
- Advanced Reality / TLS / SNI editing.
- Share-link outbound import with an explicit preview and confirmation step.
- Mixed inbound support.
- Mixed Quick Protocol.
- Mixed Quick Deploy with optional Host creation.
- Concurrent Xray + sing-box Profile assignment.
- User Route / GOST speed limits.
- Hysteria2 Port Hopping.
- Chinese localization.

## Share-link import

Supported as appropriate for the target core:

- `vless://`
- `vmess://`
- `trojan://`
- `ss://`
- `hysteria2://`
- `hy2://`
- `tuic://`

## Mixed

Mixed inbound support is capability-driven for:

- Xray 26.7.28
- sing-box 1.13.14

Xray and sing-box keep their own native JSON structures.

## Fixed

- sing-box JSON incorrectly validated by Xray WASM.
- `coreType` lost after save/cache update.
- Visual Parser falling back to Xray.
- Visual Builder vertical scrolling.
- Untranslated Visual Builder UI.
- Untranslated User Route / speed-limit UI.
- Xray and sing-box Profile selections overwriting each other.
- Old frontend contract stripping `singBoxConfigProfile`.
- Asymmetric Xray/sing-box Node assignment.
- Create Node unnecessarily requiring an Xray Profile.

## Dual-core behavior

One Node can independently bind:

Xray:

- one Xray Profile;
- independently selected inbounds.

sing-box:

- one sing-box Profile;
- independently selected inbounds.

The two configurations are generated and dispatched separately. They are not merged into one JSON document.

## Validation

Frontend:

- typecheck passed;
- 131/131 tests passed;
- changed-file lint/format passed;
- production build passed;
- `git diff --check` passed.

Backend:

- 11/11 unit tests passed;
- Prisma generate passed;
- changed-file lint/format passed;
- production build passed;
- `git diff --check` passed.

Node:

- typecheck passed;
- 6/6 tests passed;
- production build passed.
