// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Swell",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .executable(
            name: "swell",
            targets: ["Swell"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "Swell",
            dependencies: [],
            path: "Swell",
            sources: [
                "main.swift",
                "core/readInput.swift",
                "core/spawnProcess.swift", 
                "core/session.swift",
                "core/getPrompt.swift",
                "core/getAvailableCommands.swift",
                "core/sanitiseInput.swift",
                "core/getAlias.swift",
                "core/mainHistory.swift",
                "core/readHistory.swift",
                "core/tabComplete.swift",
                "core/updateHistory.swift",
                "core/mainSwitch.swift",
                "commands/changeDirectory.swift",
                "commands/addAlias.swift",
                "config/readConfig.swift"
            ],
            linkerSettings: [
                .linkedLibrary("Kernel32")
            ],
        ),
        .testTarget(
            name: "SwellTests",
            dependencies: ["Swell"]
        ),
    ]
)
