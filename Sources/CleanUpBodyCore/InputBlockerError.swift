import Foundation

public enum InputBlockerError: LocalizedError, Equatable {
    case accessibilityPermissionRequired
    case eventTapCreationFailed

    public var errorDescription: String? {
        switch self {
        case .accessibilityPermissionRequired:
            "Accessibility permission is required to block keyboard and pointer input."
        case .eventTapCreationFailed:
            "Could not create the macOS input event tap."
        }
    }
}
