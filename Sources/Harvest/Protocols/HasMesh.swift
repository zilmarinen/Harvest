//
//  HasMesh.swift
//
//  Created by Zack Brown on 05/11/2025.
//

import Euclid
import RealityKit

internal protocol HasMesh: Entity,
                           HasModel {
    
    var mesh: Mesh? { get }
    var material: CustomMaterial? { get }
}

extension HasMesh {
    
    internal func updateModel() {
        
        guard let mesh,
              let material else { return }
        
        
        let resource = MeshResource(mesh: mesh)
        
        self.model = .init(mesh: resource,
                           materials: [material])
        
        guard let self = self as? HasCollision else { return }
        
        Task {
            
            let shape = try await ShapeResource.generateStaticMesh(from: resource)
            
            self.collision = .init(shapes: [shape],
                                   isStatic: true)
        }
    }
}
