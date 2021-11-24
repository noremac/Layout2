// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Layout",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "Layout",
            targets: ["Layout"]
        ),
    ],
    targets: [
        .target(
            name: "Layout"
        ),
        .testTarget(
            name: "LayoutTests",
            dependencies: ["Layout"]
        ),
    ]
)
