// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LocationDatabase",
    platforms: [
        .iOS(.v15), .macOS(.v13),
    ],
    products: [
        .library(
            name: "LocationDatabase",
            targets: ["LocationDatabase"]),
    ],
    dependencies: [
        .package(path: "../DataTransferObjects"),
    ],
    targets: [
        .target(
            name: "LocationDatabase",
            dependencies: ["DataTransferObjects"]),
        .testTarget(
            name: "LocationDatabaseTests",
            dependencies: ["LocationDatabase"]),
    ]
)
