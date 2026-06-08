// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "CleanUpBody",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "CleanUpBody", targets: ["CleanUpBodyApp"]),
        .executable(name: "CleanUpBodyCoreChecks", targets: ["CleanUpBodyCoreChecks"]),
        .library(name: "CleanUpBodyCore", targets: ["CleanUpBodyCore"])
    ],
    targets: [
        .target(name: "CleanUpBodyCore"),
        .executableTarget(
            name: "CleanUpBodyApp",
            dependencies: ["CleanUpBodyCore"]
        ),
        .executableTarget(
            name: "CleanUpBodyCoreChecks",
            dependencies: ["CleanUpBodyCore"]
        )
    ]
)
