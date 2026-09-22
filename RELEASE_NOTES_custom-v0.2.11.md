# custom-v0.2.11

## Fixed

- Fixed a fatal Frontend 500 error caused by applying Zod `.omit()` to an object schema containing `superRefine()`.
- `custom-v0.2.10` is affected: opening the create-user modal can trigger `.omit() cannot be used on object schemas containing refinements`.
- The form schema is now reconstructed from the base shape, `.omit()` is applied first, and the custom traffic-reset refinement is added afterwards.

Backend behavior and the database migration are unchanged.

## Custom monthly traffic reset day

- `MONTH_CUSTOM_DAY` remains supported.
- Users can select day `1` through `31`.
- End-of-month fallback remains unchanged: day 31 falls back to the last day of shorter months; day 30 falls back in February; day 29 falls back to February 28 in non-leap years.
- Changing the strategy does not immediately clear current traffic.

## Database migration

No new migration is added in `custom-v0.2.11`.

The Backend still contains the existing migration:

`20260922120000_add_custom_user_traffic_reset_day`

Databases that already applied it are recognized as up to date by Prisma. Direct upgrades from `custom-v0.2.9` still apply it through the existing Panel startup migration mechanism. This release did not connect to a production database or run a production migration.

## Components

- Frontend: `Fourgetu/frontend@custom-v0.2.11`
- Frontend asset: `remnawave-frontend.zip`
- Frontend asset size: `13602393` bytes
- Frontend asset SHA256: `ceee066f2d90b907d9e77eaa68dfbeacefc399e4c4b41f26f680b50546eb7b92`
- Backend source commit: `493017280a7c7c58bdd99cfbdf8c91dc40e36ac4`（与 `custom-v0.2.10` 相同）
- Backend image: `ghcr.io/fourgetu/remnawave-backend:custom-v0.2.11`
- Backend platforms: `linux/amd64`, `linux/arm64`
- Backend multi-arch digest: `sha256:ecd63ced0653e78580aa0d71d5308b6a8146d1b5623f5fb898fc0ca6d6254011`
- Node: `ghcr.io/fourgetu/remnawave-node:custom-v0.2.9`
- Node was intentionally not rebuilt or retagged.

## Validation

- Frontend commit: `1087d70eec04cd2207a2a4a355aceb9a5616c34b`
- Frontend: 206/206 tests, typecheck, lint/format, production build, and `git diff --check` passed.
- The Backend image downloads and embeds the Frontend `custom-v0.2.11` release asset during its multi-architecture build.
- This release did not SSH to Panel/Node VPS hosts and did not run a production smoke test.
- Existing `custom-v0.2.10` tags, Releases, assets, and images remain unchanged.
