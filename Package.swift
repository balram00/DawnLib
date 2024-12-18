// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DawnLib",
    platforms: [
        .iOS(.v13) // Specify the minimum iOS version
    ],
    products: [
        // The library your app exports
        .library(
            name: "DawnLib",
            targets: ["DawnLib"]
        ),
    ],
    dependencies: [
        // Add dependencies here if your library uses any third-party packages
    ],
    targets: [
        .target(
            name: "DawnLib",
            dependencies: [],
            path: "Sources",
            resources: [
                // Include fonts, storyboards, or any other bundled resources
//                .process("Resources/Fonts"),
                .process("Resources/Storyboards/Main.storyboard"),
//                .process("Resources/Assets.xcassets"),
            ]
        ),
        .testTarget(
            name: "DawnLibTests",
            dependencies: ["DawnLib"],
            path: "Tests"
        ),
    ]
)
