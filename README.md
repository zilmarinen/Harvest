# Introduction
Harvest is a SpriteKit based Swift library specifically designed to facilitate the rapid development of 3D games on both macOS and tv/iOS. Written collaboratively alongside [Meadow](https://github.com/zilmarinen/Meadow) and [Orchard](https://github.com/zilmarinen/Orchard), Harvest is a 2D scene graph used to create the underlying meshes and data of a 3D scene wrapped up in a single `SKNode`.

# Installation

To install using Swift Package Manager, add the following to the `dependencies:` section in your `Package.swift` file:

```swift
.package(url: "https://github.com/zilmarinen/Harvest.git", .upToNextMinor(from: "0.1.0")),
```

# Dependencies
[Euclid](https://github.com/nicklockwood/Euclid) is a Swift library for creating and manipulating 3D geometry and is used extensively within this project for mesh generation and vector operations.