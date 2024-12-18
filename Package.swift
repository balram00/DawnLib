// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "DawnLib",
    platforms: [
        .iOS(.v13) // Specify the minimum iOS version
    ],
    products: [
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
                .process("Resources/Storyboards/Main.storyboard"),
                // Add any additional resource directories here
                // .process("Resources/Fonts"),
                // .process("Resources/Assets.xcassets"),
            ]
        ),
        .testTarget(
            name: "DawnLibTests",
            dependencies: ["DawnLib"],
            path: "Tests"
        ),
    ]
)
