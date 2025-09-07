//
//  WorldView.swift
//  Harvest
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
    
    public func add(region coordinate: Coordinate) {
        
        let scale = Triangle.Scale.chunk
        
        let triangle = Triangle(coordinate)
    
        let color: NSColor = triangle.isPointy ? .black : .white
        
        let material = SimpleMaterial(color: color,
                                      isMetallic: false)
        
        guard let entity = try? ModelEntity(triangle.mesh(.tile)) else { return }
        
        entity.position = .init(Vector(0.0, 0.002, 0.0))
        entity.components[ModelComponent.self]?.materials = [material]
        
        world.addChild(entity)
    }
}
