# Contributing

Run these checks before opening a pull request:

```sh
swift build
swift run CleanUpBodyCoreChecks
```

Keep input-blocking changes small and easy to review. Include manual macOS verification
notes for changes touching event taps, Accessibility permission, timers, or release
packaging.
