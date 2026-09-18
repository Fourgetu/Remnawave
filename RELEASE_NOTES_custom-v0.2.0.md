# custom-v0.2.0

## Added

- Visual Config Builder with graphical and JSON editing modes.
- Graphical inbound, outbound, routing rule, and DNS management.
- Targeted patching, unknown-field preservation, snippet protection, and Xray / sing-box adapters.
- Xray / sing-box core-aware editing with dedicated sing-box schema validation.
- Chinese localization for the Visual Config Builder.
- Chinese localization for User Route, GOST speed limit, and Hysteria2 Port Hopping management.
- Existing custom capabilities remain available: Quick Protocol, Quick Deploy, User Route / NAT, Speed Limits, GOST, Xray + sing-box runtime, Hysteria2 Port Hopping, SOCKS credentials / UDP, relay, and traffic accounting.

## Fixed

- sing-box JSON was incorrectly validated by Xray WASM.
- `coreType` could be lost after saving and updating the query cache.
- Visual Builder long pages could not scroll to all configuration sections.
- Missing Chinese translations in the Visual Builder and speed-limit management UI.

## Known Issues

- Xray and sing-box profile selections on the same Node are currently still mutually exclusive in the node configuration assignment UI.
- Concurrent dual-core profile assignment UI will be corrected in a subsequent release.
