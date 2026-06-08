import ApplicationServices
import Foundation

public final class InputEventBlocker: @unchecked Sendable {
    public static let emergencyKeyCode: Int64 = 53

    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?

    public private(set) var isBlocking = false

    public init() {}

    deinit {
        stop()
    }

    public func start() throws {
        guard !isBlocking else { return }
        guard AccessibilityPermission.isTrusted else {
            throw InputBlockerError.accessibilityPermissionRequired
        }

        let refcon = Unmanaged.passUnretained(self).toOpaque()
        guard let tap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: Self.blockedEventMask,
            callback: inputEventCallback,
            userInfo: refcon
        ) else {
            throw InputBlockerError.eventTapCreationFailed
        }

        let source = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
        CFRunLoopAddSource(CFRunLoopGetMain(), source, .commonModes)
        CGEvent.tapEnable(tap: tap, enable: true)

        eventTap = tap
        runLoopSource = source
        isBlocking = true
    }

    public func stop() {
        if let eventTap {
            CGEvent.tapEnable(tap: eventTap, enable: false)
        }
        if let runLoopSource {
            CFRunLoopRemoveSource(CFRunLoopGetMain(), runLoopSource, .commonModes)
        }
        eventTap = nil
        runLoopSource = nil
        isBlocking = false
    }

    public static var blockedEventTypes: [CGEventType] {
        [
            .keyDown,
            .keyUp,
            .flagsChanged,
            .leftMouseDown,
            .leftMouseUp,
            .rightMouseDown,
            .rightMouseUp,
            .mouseMoved,
            .leftMouseDragged,
            .rightMouseDragged,
            .scrollWheel,
            .otherMouseDown,
            .otherMouseUp,
            .otherMouseDragged,
            .tabletPointer,
            .tabletProximity
        ]
    }

    public static var blockedEventMask: CGEventMask {
        eventMask(for: blockedEventTypes)
    }

    public static func eventMask(for types: [CGEventType]) -> CGEventMask {
        types.reduce(CGEventMask(0)) { mask, type in
            mask | (CGEventMask(1) << CGEventMask(type.rawValue))
        }
    }

    public static func isEmergencyStop(type: CGEventType, keyCode: Int64, flags: CGEventFlags) -> Bool {
        type == .keyDown
            && keyCode == emergencyKeyCode
            && flags.contains(.maskCommand)
            && flags.contains(.maskAlternate)
            && flags.contains(.maskControl)
    }

    fileprivate func handleTapDisabled() {
        if let eventTap {
            CGEvent.tapEnable(tap: eventTap, enable: true)
        }
    }

    fileprivate func handleEmergencyStop() {
        stop()
    }
}

private let inputEventCallback: CGEventTapCallBack = { _, type, event, refcon in
    guard let refcon else { return nil }
    let blocker = Unmanaged<InputEventBlocker>.fromOpaque(refcon).takeUnretainedValue()

    if type == .tapDisabledByTimeout || type == .tapDisabledByUserInput {
        blocker.handleTapDisabled()
        return Unmanaged.passUnretained(event)
    }

    let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
    if InputEventBlocker.isEmergencyStop(type: type, keyCode: keyCode, flags: event.flags) {
        blocker.handleEmergencyStop()
        return Unmanaged.passUnretained(event)
    }

    return nil
}
