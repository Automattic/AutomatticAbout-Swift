// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AutomatticAbout",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "AutomatticAbout",
            targets: ["AutomatticAbout"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "AutomatticAbout",
            dependencies: [],
            path: "Sources/AutomatticAbout"),
        .testTarget(
            name: "AutomatticAboutTests",
            dependencies: ["AutomatticAbout"]),
    ]
)
