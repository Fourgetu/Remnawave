# custom-v0.2.12

## Added

- Mixed inbound SOCKS5 / HTTP quick copy in the graphical inbound editor.
- SOCKS5 example: `socks5://username:password@host:port`
- HTTP example: `http://username:password@host:port`
- The links include a URL-encoded inbound tag and encode any special characters in the saved username/password.
- The public address and port are entered separately from the core listen address and port, so NAT/port forwarding can be represented without changing the inbound.
- Password mode uses saved credentials. Copying is disabled while relevant credentials or port edits are unsaved.
- Noauth mode warns about an open proxy and requires explicit risk acknowledgment before copying.

These are single-proxy share links, not Remnawave per-user subscription URLs. Mixed is still not automatically included in ordinary user subscriptions. SOCKS5/HTTP connections themselves are not encrypted.

## Components

- Frontend source commit: `a51b3b5d3f008558f0d20a6478a3cfa60114cf15`
- Frontend asset: `remnawave-frontend.zip`
- Frontend asset size: `13561039` bytes
- Frontend asset SHA256: `8eb3829acfc0bf2f910d612520573db417a88a54adb5bd6c12dfd1c06cf9d11a`
- Backend source commit: `493017280a7c7c58bdd99cfbdf8c91dc40e36ac4` (unchanged)
- Backend image: `ghcr.io/fourgetu/remnawave-backend:custom-v0.2.12` (rebuild with the new Frontend asset)
- Backend platforms: `linux/amd64`, `linux/arm64`
- Node: `ghcr.io/fourgetu/remnawave-node:custom-v0.2.9` (unchanged)

## Validation and database

- Frontend: 210/210 tests, typecheck, modified-file lint/format, production build, and `git diff --check` passed.
- No Backend or Node source changes.
- No new database migration. The existing `20260922120000_add_custom_user_traffic_reset_day` remains in the Backend source.
- No production deployment, SSH to Panel/Node, or production migration was performed.
- Previous tags, Releases, assets and images remain unchanged.
