//
//  FoliageAssetCacheComponent.swift
//
//  Created by Zack Brown on 25/10/2025.
//

import AppKit
import Deltille
import Euclid
import RealityKit
import Verdure

internal class FoliageAssetCacheComponent: Component {
    
    private var meshes: [Triangle.Septomino : Mesh] = [:]
}

extension FoliageAssetCacheComponent {
    
    internal func mesh(for septomino: Triangle.Septomino) -> Mesh {
        
        if let mesh = meshes[septomino] {
            
            return mesh
        }
        
        let mesh = Mesh.foliage(septomino,
                                .columnar,
                                .init(.white, .gray),
                                .init(.gray, .black))
        
        meshes[septomino] = mesh
        
        return mesh
    }
}
