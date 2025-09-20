// swift-tools-version: 6.1
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
//        .package(url: "git@github.com:zilmarinen/Deltille.git",
//                 branch: "develop"),
        .package(url: "git@github.com:nicklockwood/Euclid.git",
                 branch: "main"),
        .package(path: "../Deltille"),
        .package(path: "../Lattice"),
        .package(path: "../Regolith")
    ],
    targets: [
        .target(name: "Harvest",
                dependencies: ["Deltille",
                               "Euclid",
                               "Lattice",
                               "Regolith"])
    ]
)
