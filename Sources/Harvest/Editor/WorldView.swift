//
//  WorldView.swift
//
//  Created by Zack Brown on 13/08/2025.
//

import AppKit
import Deltille
import Euclid
import RealityKit

public class WorldView: EditorView {
    
    public required init(frame: NSRect) {
        
        super.init(frame: frame)
        
        world.anchor?.addChild(WorldFloorPlane())
    }
}

extension WorldView {
    
    public func clear() {
        
        for child in world.children {
            
            guard let child = child as? ModelEntity else { continue }
            
            child.removeFromParent()
        }
    }
    
    public func add(region: Region) {
        
        let triangle = Triangle(region.origin)
        
        let material = SimpleMaterial(color: triangle.isPointy ? .black : .white,
                                      isMetallic: false)
        
        let vertices = triangle.vertices.map {
            
            Vertex($0.position(.region),
                   .unitY,
                   nil,
                   triangle.isPointy ? .black : .white)
        }
        
        guard let polygon = Polygon(vertices) else { return }
        
        let mesh = Mesh([polygon])
        
        guard let entity = try? ModelEntity(mesh) else { return }
        
        entity.position = .init(Vector(0.0, 0.002, 0.0))
        entity.components[ModelComponent.self]?.materials = [material]
        
        world.addChild(entity)
    }
}

internal class WorldFloorPlane: Entity,
                                HasMesh {
    
    internal var mesh: Mesh?
    
    internal var material: CustomMaterial? { ShaderProgram.shared.material(for: .grid) }
    
    internal required init() {
        
        super.init()
        
        let size = 100.0
        
        let vectors = [Vector(-size, 0.0, size),
                       Vector(size, 0.0, size),
                       Vector(size, 0.0, -size),
                       Vector(-size, 0.0, -size)]
        
        let vertices = vectors.map {
            
            Vertex($0,
                   .unitY,
                   nil,
                   Color("F2E3B3"))
        }
        
        guard let polygon = Polygon(vertices) else { return }
        
        self.mesh = Mesh([polygon])
        
        updateModel()
    }
}
