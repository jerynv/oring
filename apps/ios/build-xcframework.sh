#!/bin/bash
# Build the shared Rust core (oura-core) for iOS device + simulator and package the
# OuraCore.xcframework the app links. Re-run after changing any Rust core code.
#
# Builds device and simulator slices for Xcode and App Store archives.
set -euo pipefail
if ! command -v cargo >/dev/null 2>&1; then
  CARGO_BIN="$(rustup which cargo)"
  export PATH="$(dirname "$CARGO_BIN"):$PATH"
fi
cd "$(dirname "$0")/../.."
REPO="$PWD"
HEADERS="$REPO/apps/ios/generated/headers"   # UniFFI header + module.modulemap
OUT="$REPO/apps/ios/OuraCore.xcframework"
LIB="liboura_core.a"

for t in aarch64-apple-ios aarch64-apple-ios-sim; do
  rustup target list --installed | grep -qx "$t" || rustup target add "$t"
done

echo "==> regenerate matching Swift bindings and headers"
cargo build -p oura-core
cargo run -p oura-core --bin uniffi-bindgen -- generate \
  --library "$REPO/target/debug/liboura_core.dylib" --language swift --no-format \
  --out-dir "$REPO/apps/ios/generated"
cp "$REPO/apps/ios/generated/oura_coreFFI.h" "$HEADERS/oura_coreFFI.h"

echo "==> build oura-core (release) for device + simulator"
cargo build -p oura-core --release --target aarch64-apple-ios
cargo build -p oura-core --release --target aarch64-apple-ios-sim

rm -rf "$OUT"
echo "==> create xcframework"
xcodebuild -create-xcframework \
  -library "$REPO/target/aarch64-apple-ios/release/$LIB"     -headers "$HEADERS" \
  -library "$REPO/target/aarch64-apple-ios-sim/release/$LIB" -headers "$HEADERS" \
  -output "$OUT"
echo "✓ $OUT"
