// swift-tools-version: 5.8.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VLNotificationServiceLib",
    platforms: [
        .iOS(.v14),
        .tvOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "VLNotificationServiceLib",
            targets: ["VLNotificationServiceLib"]),
    ],
    dependencies: [
        .package(url: "https://github.com/farazvl/VLBeaconSwift.git", from: "1.0.3")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "VLNotificationServiceLib"),
        .testTarget(
            name: "VLNotificationServiceLibTests",
            dependencies: ["VLNotificationServiceLib"]),
    ]
)
