import AppKit
import CleanUpBodyCore
import Foundation

@MainActor
final class AppModel: ObservableObject {
    @Published var permissionGranted = AccessibilityPermission.isTrusted
    @Published var selectedDuration: WipeDuration = .oneMinute
    @Published var remainingSeconds = 0
    @Published var isBlocking = false
    @Published var status = "Ready"

    private let blocker = InputEventBlocker()
    private var timer: Timer?

    var remainingText: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func refreshPermission() {
        permissionGranted = AccessibilityPermission.isTrusted
    }

    func requestPermission() {
        permissionGranted = AccessibilityPermission.request()
        status = permissionGranted ? "Ready" : "Permission needed"
    }

    func openAccessibilitySettings() {
        guard let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") else {
            return
        }
        NSWorkspace.shared.open(url)
    }

    func startSession() {
        refreshPermission()
        guard permissionGranted else {
            requestPermission()
            return
        }

        do {
            try blocker.start()
            remainingSeconds = selectedDuration.seconds
            isBlocking = true
            status = "Wipe mode active"
            startTimer()
        } catch {
            status = error.localizedDescription
            isBlocking = false
        }
    }

    func stopSession() {
        blocker.stop()
        finishSession(status: "Stopped")
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.tick()
            }
        }
        RunLoop.main.add(timer!, forMode: .common)
    }

    private func tick() {
        if isBlocking && !blocker.isBlocking {
            finishSession(status: "Emergency stopped")
            return
        }
        guard isBlocking else { return }
        if remainingSeconds <= 1 {
            blocker.stop()
            finishSession(status: "Done")
        } else {
            remainingSeconds -= 1
        }
    }

    private func finishSession(status: String) {
        timer?.invalidate()
        timer = nil
        isBlocking = false
        remainingSeconds = 0
        self.status = status
    }
}
