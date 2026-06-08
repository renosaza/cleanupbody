import ApplicationServices
import CleanUpBodyCore
import Foundation

@main
struct CleanUpBodyCoreChecks {
    static func main() throws {
        try eventMaskContainsBlockedEvents()
        try emergencyStopRequiresFullChord()
        try optionUnlockConstantsAreValid()
        try durationsArePositive()
        print("CleanUpBodyCore checks passed")
    }

    private static func eventMaskContainsBlockedEvents() throws {
        let mask = InputEventBlocker.blockedEventMask
        try expect(mask != 0, "blocked event mask must not be empty")

        for type in InputEventBlocker.blockedEventTypes {
            let bit = CGEventMask(1) << CGEventMask(type.rawValue)
            try expect((mask & bit) != 0, "missing event type \(type.rawValue)")
        }

        try expect(InputEventBlocker.blockedEventTypes.contains(.keyDown), "missing key down")
        try expect(InputEventBlocker.blockedEventTypes.contains(.leftMouseDown), "missing mouse down")
        try expect(InputEventBlocker.blockedEventTypes.contains(.scrollWheel), "missing scroll wheel")
    }

    private static func emergencyStopRequiresFullChord() throws {
        let fullFlags: CGEventFlags = [.maskControl, .maskAlternate, .maskCommand]

        try expect(
            InputEventBlocker.isEmergencyStop(type: .keyDown, keyCode: 53, flags: fullFlags),
            "expected emergency chord"
        )
        try expect(
            !InputEventBlocker.isEmergencyStop(type: .keyUp, keyCode: 53, flags: fullFlags),
            "key up must not trigger emergency"
        )
        try expect(
            !InputEventBlocker.isEmergencyStop(type: .keyDown, keyCode: 53, flags: [.maskCommand]),
            "partial chord must not trigger emergency"
        )
        try expect(
            !InputEventBlocker.isEmergencyStop(type: .keyDown, keyCode: 36, flags: fullFlags),
            "non-escape key must not trigger emergency"
        )
    }

    private static func durationsArePositive() throws {
        for duration in WipeDuration.allCases {
            try expect(duration.seconds > 0, "duration must be positive")
            try expect(!duration.title.isEmpty, "duration title must not be empty")
        }
    }

    private static func optionUnlockConstantsAreValid() throws {
        try expect(InputEventBlocker.isOptionKey(58), "left option key code must be recognized")
        try expect(InputEventBlocker.isOptionKey(61), "right option key code must be recognized")
        try expect(!InputEventBlocker.isOptionKey(53), "escape must not be option")
        try expect(InputEventBlocker.unlockHoldDuration == 5, "unlock hold must be 5 seconds")
    }

    private static func expect(_ condition: @autoclosure () -> Bool, _ message: String) throws {
        if !condition() {
            throw CheckError.failed(message)
        }
    }
}

private enum CheckError: Error, CustomStringConvertible {
    case failed(String)

    var description: String {
        switch self {
        case let .failed(message): message
        }
    }
}
