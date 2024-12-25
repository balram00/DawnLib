// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "DawnLib",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "DawnLib",
            targets: ["DawnLib"]
        ),
    ],
    dependencies: [],
    targets: [
        // Target for the core library
        .target(
            name: "DawnLib",
            dependencies: [],
            path: "Sources",
            resources: [
                // Add resources like storyboards, XIBs, images, etc.
                .process("Resources/Storyboards/Main.storyboard"),
                .process("Resources/Nibs/ChatHeaderCell.xib"),
                .process("Resources/Nibs/ChatFooterCell.xib"),
                .process("Resources/Nibs/AnswerTableViewCell.xib"),
                .process("Resources/Nibs/QuestionTableViewCell.xib"),
                .process("Resources/Nibs/FeedbackTableViewCell.xib"),
                .process("Resources/Nibs/LoaderTableViewCell.xib")
//                .process("Resources/Images/logo.png"),              // Images
//                .process("Resources/Fonts/CustomFont.ttf"),         // Fonts (if any)
//                .process("Resources/XIBs/CustomView.xib")           // XIB files
            ]
        ),
        
        // Test target
        .testTarget(
            name: "DawnLibTests",
            dependencies: ["DawnLib"],
            path: "Tests"
        ),
    ]
)
