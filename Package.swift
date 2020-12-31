// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VirtualMansion",
    platforms: [
       .macOS(.v11),
    ],
    products: [
        .executable(name: "VirtualMansion", targets: ["VirtualMansion"]),
        .library(name: "VirtualMansionLib", targets: ["VirtualMansionLib"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Azoy/Sword", .branch("master")),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.3.0"),
        .package(url: "https://github.com/stephencelis/SQLite.swift.git", from: "0.12.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "VirtualMansion",
            dependencies: [
                "VirtualMansionLib",
                "Sword",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]),
        .target(
            name: "VirtualMansionLib",
            dependencies: [
                "Sword",
                .product(name: "SQLite", package: "SQLite.swift"),
            ]),
        .testTarget(
            name: "VirtualMansionTests",
            dependencies: ["VirtualMansionLib", "Sword"]),
    ]
)
