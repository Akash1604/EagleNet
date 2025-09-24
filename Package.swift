// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EagleNet",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15)
    ],
    products: [
        .library(
            name: "EagleNet",
            targets: ["EagleNet"]
        )
    ],
    targets: [
        .target(
            name: "EagleNet",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
                .enableUpcomingFeature("ExistentialAny")
            ]
        ),
        .testTarget(
            name: "EagleNetTests",
            dependencies: ["EagleNet"]
        )
    ]
)
