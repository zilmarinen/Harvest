// swift-tools-version: 6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Harvest",
    platforms: [.macOS(.v15)],
    products: [
        .library(name: "Harvest",
                 targets: ["Harvest"])
    ],
    dependencies: [
        .package(url: "https://github.com/nicklockwood/Euclid.git",
                 branch: "main"),
        .package(path: "../Alluvium"),
        .package(path: "../Bivouac"),
        .package(path: "../Deltille"),
        .package(path: "../Lattice"),
    ],
    targets: [
        .target(name: "Harvest",
                dependencies: ["Alluvium",
                               "Bivouac",
                               "Deltille",
                               "Euclid",
                               "Lattice"])
    ]
)
