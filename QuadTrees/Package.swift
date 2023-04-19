// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "QuadTrees",
    products: [
        .library(
            name: "QuadTrees",
            targets: ["QuadTrees"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "QuadTrees",
            dependencies: []),
        .testTarget(
            name: "QuadTreesTests",
            dependencies: ["QuadTrees"]),
    ]
)
