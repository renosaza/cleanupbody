import SwiftUI

@main
struct CleanUpBodyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 720, minHeight: 460)
        }
        .windowStyle(.titleBar)
    }
}
