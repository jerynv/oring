# Oring

Oring is a free, independent iPhone app that reads compatible Oura rings directly over Bluetooth. It displays the ring's own deep, light, REM, and awake sleep-stage stream, with a detailed hypnogram and aligned overnight signals. It has no account, subscription, ads, or server. Apple Health is not used.

The Bluetooth protocol is reverse engineered and is not supported by Oura. Pairing and syncing must be checked on a physical ring before release. The native app builds on the MIT-licensed [open_health](https://github.com/Th0rgal/open_health) and [open_oura](https://github.com/Th0rgal/open_oura) projects; see [LICENSE](LICENSE) and [third-party notes](docs/third-party.md).

## Build and run

Install Xcode, [XcodeGen](https://github.com/yonaskolb/XcodeGen), and Rust with the `aarch64-apple-ios` and `aarch64-apple-ios-sim` targets. This build was tested with Xcode 27.0. From the repository root:

```sh
bash apps/ios/build-xcframework.sh
cd apps/ios/OuraApp
xcodegen generate
open OuraApp.xcodeproj
```

In Xcode, set your Apple Developer team and run the `OuraApp` scheme on an iPhone. The installed app is named **Oring**. The simulator can show the first-run flow and **Explore a sample night**; it cannot connect to a physical ring.

Find an available simulator ID with `xcrun simctl list devices available`, then run the simulator tests with that ID:

```sh
xcodebuild -project apps/ios/OuraApp/OuraApp.xcodeproj -scheme OuraApp \
  -destination 'platform=iOS Simulator,id=YOUR_SIMULATOR_ID' \
  -parallel-testing-enabled NO CODE_SIGNING_ALLOWED=NO test
```

## Pair and sync

Place the ring on its charger near the iPhone and disconnect it from other phones. A ring already paired elsewhere needs its existing 32-character pairing key. Oring can create a key for a **factory-reset** ring. Resetting a ring erases any unsynced data; Oring never performs that reset automatically. Once paired, **Connect & sync** downloads ring events into a local SQLite database, and the sleep report shows data the ring actually provided.

The app stores the pairing key in iOS Keychain. If a key is lost, it cannot be read back from the ring. The ring's event stream includes on-device stage epochs, so the app does not need a cloud account to draw REM patterns. It does not reproduce Oura's proprietary scores.

## Release

See the [App Store handoff](docs/app-store.md) and [privacy policy](docs/privacy-policy.md). The source builds an unsigned device archive; signing, a real-ring sync check, a public privacy URL, screenshots from a signed build, and App Store Connect submission still require the owner's Apple Developer account and hardware.
