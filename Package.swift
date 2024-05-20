// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MpcProviderSwift",
    platforms: [.iOS(.v14), .macOS(.v11)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MpcProviderSwift",
            targets: ["MpcProviderSwift"]),
        
    ],
    dependencies: [
        .package(url: "https://github.com/argentlabs/web3.swift", from:"1.6.0"),
        .package(url: "https://github.com/tkey/curvelib.swift", exact: "1.0.1"),
//        .package(url: "https://github.com/tkey/mpc-core-kit-swift", from: "1.0.0-alpha"),
        .package(url: "https://github.com/vapor/jwt-kit.git", from: "4.0.0"),
        .package(url: "https://github.com/tkey/mpc-core-kit-swift", branch: "main"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MpcProviderSwift",
            dependencies: ["web3.swift",
                           .product(name: "curveSecp256k1", package: "curvelib.swift"),
                          ],
            path: "Sources/"
        ),
        .testTarget(
            name: "MpcProviderSwiftTests",
            dependencies: ["MpcProviderSwift",
             .product(name: "mpc-core-kit-swift", package: "mpc-core-kit-swift"),
             .product(name: "JWTKit", package: "jwt-kit")
        ]),
    ]
)
