// swift-tools-version:5.7

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

// for target in package.targets {
//  target.swiftSettings = target.swiftSettings ?? []
//  target.swiftSettings?.append(
//    .unsafeFlags([
//      "-Xfrontend", "-strict-concurrency=complete",
//    ])
//  )
// }
