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
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.5.0"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "5.3.1"),
        .package(url: "https://github.com/dduan/TOMLDecoder", from: "0.3.1"),
        .package(url: "https://github.com/yaslab/CSV.swift.git", from: "2.5.2"),
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "4.0.0"),
        .package(url: "https://github.com/groue/GRMustache.swift", from: "6.0.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "NekoCore",
            dependencies: [
                "Yams",
                "TOMLDecoder",
                .product(name: "CSV", package: "CSV.swift"),
                "SwiftyJSON",
                .product(name: "Mustache", package: "GRMustache.swift"),
                .product(name: "Logging", package: "swift-log"),
            ],
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
                .product(name: "Logging", package: "swift-log"),
            ],
            path: "Sources/NekoCommandLineInterface"
        ),
    ]
)
