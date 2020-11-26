// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

#if os(macOS) || os(iOS)
let package = Package(
    name: "Troublemail",
    products: [
        .library(
            name: "Troublemail",
            targets: ["Troublemail"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Troublemail",
            dependencies: [],
            resources: [.process("Database/blocklist.json")]),
        .testTarget(
            name: "TroublemailTests",
            dependencies: ["Troublemail"]),
    ]
)
#else
fatalError("Unsupported OS")
#endif
