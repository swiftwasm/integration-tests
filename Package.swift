// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "IntegrationTests",
    platforms: [.macOS(.v10_12)],
    products: [
        .executable(name: "run-test", targets: ["run-test"]),
    ],
    targets: [
        .target(name: "run-test", dependencies: ["IntegrationTests"]),
        .target(name: "IntegrationTests"),
    ]
)
