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
        
        let scale = Triangle.Scale.region
    
        let color: NSColor = region.triangle.isPointy ? .black : .white
        
        let material = SimpleMaterial(color: color,
                                      isMetallic: false)
        
        guard let entity = try? ModelEntity(region.triangle.mesh(scale)) else { return }
        
        entity.position = .init(Vector(0.0, 0.002, 0.0))
        entity.components[ModelComponent.self]?.materials = [material]
        
        world.addChild(entity)
    }
}
