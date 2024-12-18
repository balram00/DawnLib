// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "DawnLib",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "DawnLib",
            targets: ["DawnLib"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "DawnLib",
            dependencies: [],
            path: "Sources",
            resources: [
                .process("Resources/Storyboards/Main.storyboard"),
                .process("Resources/Assets.xcassets"),
                .process("Resources/Fonts")
            ]
        ),
        .testTarget(
            name: "DawnLibTests",
            dependencies: ["DawnLib"],
            path: "Tests"
        ),
    ]
)
