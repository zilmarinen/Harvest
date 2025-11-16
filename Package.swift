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
        .package(path: "../Deltille"),
        .package(path: "../Lattice"),
        .package(path: "../Newel"),
        .package(path: "../Regolith"),
        .package(path: "../Verdure")
    ],
    targets: [
        .target(name: "Harvest",
                dependencies: ["Alluvium",
                               "Deltille",
                               "Euclid",
                               "Lattice",
                               "Newel",
                               "Regolith",
                               "Verdure"],
                resources: [.process("Shaders")])
    ]
)
