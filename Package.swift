// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NekoCommandLineInterface",
    platforms: [.macOS(.v15)],
    products: [
        .library(name: "NekoCore", targets: ["NekoCore"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.5.0")
    ],
    targets: [
        .target(
            name: "NekoCore",
            dependencies: [],
            path: "Sources/NekoCore"
        ),
        .testTarget(
            name: "NekoCoreTests",
            dependencies: ["NekoCore"],
            path: "Tests/NekoCoreTests"
        ),
        .executableTarget(
            name: "neko",
            dependencies: [
                "NekoCore",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            path: "Sources/NekoCommandLineInterface"
        ),
    ]
)
