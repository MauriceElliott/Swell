// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Swell",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .executable(
            name: "swell",
            targets: ["Swell"]
        ),
    ],
    targets: [
        .executableTarget(
            name: "Swell",
            dependencies: [],
            path: "Sources",
        ),
    ]
)
