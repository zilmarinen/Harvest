// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Harvest",
    platforms: [.macOS(.v10_15),
                .iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Harvest",
            targets: ["Harvest"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(path: "../Meadow")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Harvest",
            dependencies: ["Meadow"],
            resources: [.process("Shaders/Graph2D.fsh"),
                        .process("Shaders/Grid2D.fsh"),
                        .process("Shaders/Surface2D.fsh")]),
        .testTarget(
            name: "HarvestTests",
            dependencies: ["Harvest", "Meadow"]),
    ]
)
