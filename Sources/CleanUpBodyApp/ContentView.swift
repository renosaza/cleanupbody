import CleanUpBodyCore
import SwiftUI

struct ContentView: View {
    @StateObject private var model = AppModel()

    var body: some View {
        VStack(spacing: 0) {
            Header(model: model)
            Divider()
            if model.isBlocking {
                ActiveSession(model: model)
            } else {
                SetupPanel(model: model)
            }
        }
        .background(Color(nsColor: .windowBackgroundColor))
        .onAppear(perform: model.refreshPermission)
    }
}

private struct Header: View {
    @ObservedObject var model: AppModel

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: model.isBlocking ? "hand.raised.fill" : "sparkles")
                .font(.system(size: 30, weight: .semibold))
                .foregroundStyle(model.isBlocking ? .red : .teal)
                .frame(width: 44, height: 44)

            VStack(alignment: .leading, spacing: 3) {
                Text("CleanUpBody")
                    .font(.title2.weight(.semibold))
                Text(model.status)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            PermissionBadge(isGranted: model.permissionGranted)
        }
        .padding(24)
    }
}

private struct PermissionBadge: View {
    let isGranted: Bool

    var body: some View {
        Label(isGranted ? "Accessibility" : "Permission", systemImage: isGranted ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
            .foregroundStyle(isGranted ? .green : .orange)
            .font(.callout.weight(.medium))
    }
}

private struct SetupPanel: View {
    @ObservedObject var model: AppModel

    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Keyboard and trackpad lock")
                    .font(.largeTitle.weight(.semibold))
                Text("Start a timed wipe mode before cleaning the MacBook body, keyboard, or trackpad.")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            HStack(spacing: 18) {
                Picker("Duration", selection: $model.selectedDuration) {
                    ForEach(WipeDuration.allCases) { duration in
                        Text(duration.title).tag(duration)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 320)

                Button(action: model.startSession) {
                    Label("Start", systemImage: "play.fill")
                        .frame(width: 132)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }

            if !model.permissionGranted {
                HStack(spacing: 12) {
                    Button(action: model.requestPermission) {
                        Label("Request", systemImage: "lock.open")
                    }
                    Button(action: model.openAccessibilitySettings) {
                        Label("Settings", systemImage: "gearshape")
                    }
                    Text("Enable CleanUpBody in Privacy & Security.")
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()
        }
        .padding(32)
    }
}

private struct ActiveSession: View {
    @ObservedObject var model: AppModel

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Text(model.remainingText)
                .font(.system(size: 82, weight: .bold, design: .rounded))
                .monospacedDigit()

            Label("Input blocked", systemImage: "keyboard.badge.eye")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.red)

            UnlockProgress(progress: model.unlockHoldProgress)

            Text("Unlock: hold both Option keys for 5 seconds")
                .font(.callout)
                .foregroundStyle(.secondary)

            Button(role: .destructive, action: model.stopSession) {
                Label("Stop", systemImage: "stop.fill")
                    .frame(width: 132)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(32)
    }
}

private struct UnlockProgress: View {
    let progress: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(.quaternary, lineWidth: 10)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 0.1), value: progress)
            Image(systemName: "option")
                .font(.system(size: 26, weight: .semibold))
                .foregroundStyle(progress > 0 ? .blue : .secondary)
                .scaleEffect(progress > 0 ? 1.08 : 1)
                .animation(.easeInOut(duration: 0.2), value: progress > 0)
        }
        .frame(width: 74, height: 74)
        .accessibilityLabel("Unlock hold progress")
    }
}
