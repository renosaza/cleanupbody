#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="$ROOT_DIR/.build/release"
DIST_DIR="$ROOT_DIR/dist"
APP_DIR="$DIST_DIR/CleanUpBody.app"
CONTENTS_DIR="$APP_DIR/Contents"

swift build -c release --product CleanUpBody

rm -rf "$DIST_DIR"
mkdir -p "$CONTENTS_DIR/MacOS" "$CONTENTS_DIR/Resources"

cp "$ROOT_DIR/Packaging/Info.plist" "$CONTENTS_DIR/Info.plist"
cp "$BUILD_DIR/CleanUpBody" "$CONTENTS_DIR/MacOS/CleanUpBody"
chmod 755 "$CONTENTS_DIR/MacOS/CleanUpBody"
codesign --force --deep --sign - "$APP_DIR"

(
    cd "$DIST_DIR"
    ditto -c -k --sequesterRsrc --keepParent CleanUpBody.app CleanUpBody-macos.zip
)

echo "$DIST_DIR/CleanUpBody-macos.zip"
