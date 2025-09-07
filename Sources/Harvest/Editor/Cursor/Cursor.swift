//
//  Cursor.swift
//  Harvest
//
//  Created by Zack Brown on 18/08/2025.
//

import Deltille
import Euclid
import RealityKit

public class Cursor: Entity {
    
    internal let cursor: ModelEntity
    internal let region: ModelEntity
    internal let hex: ModelEntity
    internal let chunk: ModelEntity
    internal let tile: ModelEntity
    internal let vertex: ModelEntity
    
    public required init() {
        
        let triangle = Triangle.zero
        let hexagon = Hexagon.zero
        
        guard let region = try? ModelEntity(triangle.mesh(.region)),
              let hex = try? ModelEntity(hexagon.mesh(.chunk)),
              let chunk = try? ModelEntity(triangle.mesh(.chunk)),
              let tile = try? ModelEntity(triangle.mesh(.tile)),
              let vertex = try? ModelEntity(triangle.mesh(.sierpinski)) else { fatalError("Invalid triangle mesh") }
        
        let box = MeshResource.generateBox(size: 0.25)
        let material = SimpleMaterial(color: .systemMint,
                                      isMetallic: false)
        self.cursor = ModelEntity(mesh: box,
                                  materials: [material])
        
        self.region = region
        self.hex = hex
        self.chunk = chunk
        self.tile = tile
        self.vertex = vertex
        
        super.init()
        
        name = "Cursor"
        
        addChild(cursor)
        addChild(region)
        addChild(hex)
        addChild(chunk)
        addChild(tile)
        addChild(vertex)
        
        components.set(CursorComponent())
    }
}

extension Cursor {
    
    public func focus(on location: Vector) {
        
        components[CursorComponent.self]?.focus = location
    }
}
