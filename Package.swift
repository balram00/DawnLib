// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DawnLib",
    platforms: [
        .iOS(.v12),  // Minimum iOS version
        .macOS(.v10_15)
    ],
    products: [
        // The library product to be used in other projects
        .library(
            name: "DawnLib",
            targets: ["DawnLib"]
        )
    ],
    dependencies: [
        // Add any external dependencies here if needed
    ],
    targets: [
        // Main target containing the login logic
        .target(
            name: "DawnLib",
            dependencies: []
        ),
        // Test target for unit testing the login module
        .testTarget(
            name: "DawnLibTests",
            dependencies: ["DawnLib"]
        )
    ]
)
