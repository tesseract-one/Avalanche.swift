// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Avalanche",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "Avalanche",
            targets: ["Avalanche"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/tesseract-one/WebSocket.swift.git", from: "0.0.6"),
        .package(url: "https://github.com/attaswift/BigInt.git", from: "5.2.0"),
        .package(url: "https://github.com/tesseract-one/Serializable.swift.git", from: "0.1.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Avalanche",
            dependencies: ["RPC", "BigInt", "Bech32", "Serializable"]),
        .target(
            name: "Bech32",
            dependencies: []),
        .target(
            name: "RPC",
            dependencies: ["WebSocket"]),
        .testTarget(
            name: "AvalancheTests",
            dependencies: ["Avalanche"]),
        .testTarget(
            name: "Bech32Tests",
            dependencies: ["Bech32"]),
        .testTarget(
            name: "RPCTests",
            dependencies: ["RPC", "Serializable"]),
    ]
)


