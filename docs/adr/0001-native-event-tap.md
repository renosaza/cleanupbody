# ADR 0001: Native SwiftUI App With CoreGraphics Event Tap

## Status

Accepted

## Context

CleanUpBody needs to temporarily suppress keyboard and trackpad input on macOS while the
user wipes the physical device. The app should be small, open-source, and auditable.

## Decision

Use Swift Package Manager with a SwiftUI executable target and a separate
`CleanUpBodyCore` library. Input blocking is implemented with a CoreGraphics session event
tap and requires macOS Accessibility permission.

## Consequences

- The implementation remains native and dependency-free.
- Core behavior can be checked without starting a live event tap.
- macOS-reserved hardware controls and some system-level gestures may remain outside the
  app's control.
