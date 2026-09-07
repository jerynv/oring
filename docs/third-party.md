# Third-party source

Oring's BLE sync, decoding, local store, and initial iOS report code derive from [open_health](https://github.com/Th0rgal/open_health) at commit `5569be1`, Copyright (c) 2026 Thomas Marchand, under the MIT license included at the repository root. The Rust workspace pins crates from [open_oura](https://github.com/Th0rgal/open_oura) at commit `99e0f4c4`; its workspace declares the MIT license, and its license file is present in the pinned checkout. Inspect `Cargo.lock` for all other resolved dependencies and their license notices before distribution. Oring's icon is drawn by `tools/generate-icon.swift`.

These projects are independent of Oura Health. Protocol behavior may change with firmware updates.
