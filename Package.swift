// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "CircularRevealKit",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "CircularRevealKit",
            targets: ["CircularRevealKit"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CircularRevealKit",
            dependencies: [],
            path: "CircularRevealKit/Classes"
        ),
        .testTarget(
            name: "CircularRevealKitTests",
            dependencies: ["CircularRevealKit"],
            path: "Tests"
        ),
    ],
    swiftLanguageVersions: [.v5]
)
