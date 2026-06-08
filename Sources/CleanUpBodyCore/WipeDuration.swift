import Foundation

public enum WipeDuration: Int, CaseIterable, Identifiable, Sendable {
    case thirtySeconds = 30
    case oneMinute = 60
    case twoMinutes = 120
    case fiveMinutes = 300

    public var id: Int { rawValue }
    public var seconds: Int { rawValue }

    public var title: String {
        switch self {
        case .thirtySeconds: "30s"
        case .oneMinute: "1m"
        case .twoMinutes: "2m"
        case .fiveMinutes: "5m"
        }
    }
}
