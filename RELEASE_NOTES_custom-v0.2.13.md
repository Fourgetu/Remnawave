# custom-v0.2.13

## Fixed

- Xray VLESS outbounds with direct `settings.address`, `port`, `id`, and `flow` now appear in the visual outbound list and Basic editor.
- Basic edits keep the original flat settings structure, REALITY configuration, and unknown fields such as `testseed`.
- Existing `settings.vnext` and `settings.servers` outbounds continue to use their original paths.

## Components

- Frontend source commit: `6f357ddef298cf4be0c6885ca470f8d332469fe9`
- Frontend asset: `remnawave-frontend.zip`
- Frontend asset size: `13598655` bytes
- Frontend asset SHA256: `3377ac8e7b6f3651d31385353bac53fcd48d5efeaa3ee808b75ab9c1adf4b32c`
- Backend source commit: `493017280a7c7c58bdd99cfbdf8c91dc40e36ac4` (unchanged)
- Backend image: `ghcr.io/fourgetu/remnawave-backend:custom-v0.2.13`
- Backend multi-architecture digest: `sha256:b1637c2427d07742cb33d18f676ffcc949caace16e00c0a7642d5899b503279e`
- Backend platforms: `linux/amd64`, `linux/arm64`
- Node: `ghcr.io/fourgetu/remnawave-node:custom-v0.2.9` (unchanged)

## Validation and database

- Frontend: 211/211 tests, typecheck, modified-file lint/format, production build, and `git diff --check` passed.
- No Backend or Node source changes, and no new database migration.
- Previous tags, Releases, assets, and images remain unchanged.
