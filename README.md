# CleanUpBody

CleanUpBody is an open-source macOS app for temporarily blocking keyboard and trackpad
input while wiping a MacBook.

## Features

- Timed wipe mode: 30 seconds, 1 minute, 2 minutes, or 5 minutes
- Blocks keyboard, mouse, trackpad pointer, click, drag, and scroll events
- Unlock gesture: hold both Option keys for 5 seconds
- Animated unlock progress while both Option keys are held
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

macOS may continue moving the cursor visually on some Macs, but pointer clicks, scrolling,
dragging, and keyboard input are suppressed for normal apps. Some hardware controls and
system-level gestures may remain outside the app's control. CleanUpBody is designed for
temporary wipe sessions, not kiosk security or unattended device locking.

## License

MIT
