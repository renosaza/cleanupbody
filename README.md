# CleanUpBody

CleanUpBody is an open-source macOS app for temporarily blocking keyboard and trackpad
input while wiping a MacBook.

## Features

- Timed wipe mode: 30 seconds, 1 minute, 2 minutes, or 5 minutes
- Blocks keyboard, mouse, trackpad pointer, click, drag, and scroll events
- Emergency stop chord: `Control + Option + Command + Escape`
- Accessibility permission prompt and settings shortcut
- Native SwiftUI app with a small auditable Swift core

## Requirements

- macOS 13 or newer
- Swift 6 toolchain for building from source
- Accessibility permission for input blocking

## Build

```sh
swift build
```

## Run

```sh
swift run CleanUpBody
```

## Check

```sh
swift run CleanUpBodyCoreChecks
```

## Release

Build a local `.app` release:

```sh
Scripts/package-app.sh
```

Push a tag such as `v0.1.0`. The release workflow builds `CleanUpBody.app` and uploads
`CleanUpBody-macos.zip` to the GitHub release.

## Limitations

macOS may reserve some hardware controls and system-level gestures. CleanUpBody is designed
for temporary wipe sessions, not kiosk security or unattended device locking.

## License

MIT
