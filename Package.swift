// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Harvest",
    platforms: [.macOS(.v15)],
    products: [
        .library(name: "Harvest",
                 targets: ["Harvest"]),
    ],
    dependencies: [
        .package(url: "git@github.com:nicklockwood/Euclid.git",
                 branch: "main"),
        .package(path: "../Alluvium"),
        .package(path: "../Bivouac"),
        .package(path: "../Cobble"),
        .package(path: "../Deltille"),
        .package(path: "../Lattice"),
        .package(path: "../Lintel"),
        .package(path: "../Newel"),
        .package(path: "../Regolith"),
        .package(path: "../Verdure"),
        .package(path: "../Yield")
    ],
    targets: [
        .target(name: "Harvest",
                dependencies: ["Alluvium",
                               "Bivouac",
                               "Cobble",
                               "Deltille",
                               "Euclid",
                               "Lattice",
                               "Lintel",
                               "Newel",
                               "Regolith",
                               "Verdure",
                               "Yield"],
                resources: [.process("Shaders")])
    ]
)
