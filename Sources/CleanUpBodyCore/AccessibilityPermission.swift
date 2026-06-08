import ApplicationServices
import Foundation

public enum AccessibilityPermission {
    public static var isTrusted: Bool {
        AXIsProcessTrusted()
    }

    @discardableResult
    public static func request() -> Bool {
        let options = ["AXTrustedCheckOptionPrompt": true] as CFDictionary
        return AXIsProcessTrustedWithOptions(options)
    }
}
