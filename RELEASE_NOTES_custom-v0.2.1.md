# custom-v0.2.1

Fourgetu Remnawave custom release.

## Added

- Repository-vendored Node Contract 3.4.2 with optional managed-certificate fields.
- Visual Config Builder Phase 1-5: graphical/JSON editing for inbounds, outbounds, routing rules, and DNS.
- Core-aware Xray and sing-box editing with sing-box schema validation.
- User Route / GOST speed-limit UI localization.
- Hysteria2 Port Hopping management.
- Chinese localization across the custom management surfaces.

## Fixed

- sing-box JSON no longer enters the Xray WASM validator.
- `coreType` remains available after save and Query Cache updates.
- Visual Parser no longer defaults to Xray when `coreType` is missing.
- Visual Builder long-page vertical scrolling and sticky action-bar layout.
- Missing Chinese translations in Visual Builder and User Route/speed-limit surfaces.
- Managed TLS certificates are carried to Node without requiring an npm-published custom contract.

## Runtime and compatibility

- Xray and sing-box configurations remain separate native JSON documents.
- Legacy Xray requests without `certificates` remain valid.
- sing-box requests without managed certificates remain valid.
- Managed Hysteria2 profiles may include certificates.
- Backend and Node use the same repository-vendored Contract source from `Fourgetu/node` commit `43861f01257beea919c5177826904a972a25db13`.

## Known Issues

- Xray and sing-box profile selections on the same Node are currently still mutually exclusive in the node configuration assignment UI.
- Concurrent dual-core profile assignment UI will be corrected in a subsequent release.

## Artifacts

- Backend: `ghcr.io/fourgetu/remnawave-backend:custom-v0.2.1`
- Node: `ghcr.io/fourgetu/remnawave-node:custom-v0.2.1`
- Frontend: `remnawave-frontend.zip` attached to the Frontend GitHub Release.
