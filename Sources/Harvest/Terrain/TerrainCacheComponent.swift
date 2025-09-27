//
//  TerrainCacheComponent.swift
//  Harvest
//
//  Created by Zack Brown on 08/09/2025.
//

import AppKit
import Deltille
import Euclid
import RealityKit
import Regolith

internal struct TerrainCacheComponent: Component {
    
    typealias Materials = [TerrainType : (apex: Material,
                                          base: Material)]
    
    internal static let apexHeight = 0.1
    internal static let baseHeight = 0.5
    
    private let stencil = Triangle.zero.stencil(.tile)
    
    private let materials: Materials
    
    private let apex: [Triangle.Kite : Mesh]
    private let base: [Triangle.Kite : Mesh]
    
    internal init() {
        
        let stencil = Triangle.zero.stencil(.tile)
        let kites = Triangle.Kite.allCases
        
        self.apex = kites.reduce(into: [Triangle.Kite : Mesh](), { result, kite in
            
            result[kite] = kite.mesh(stencil,
                                     Self.apexHeight,
                                     .red)
        })
        
        self.base = kites.reduce(into: [Triangle.Kite : Mesh](), { result, kite in
            
            result[kite] = kite.mesh(stencil,
                                     Self.baseHeight,
                                     .red)
        })
        
        self.materials = TerrainType.allCases.reduce(into: Materials(), { result, terrainType in
            
            let apexMaterial = SimpleMaterial(color: NSColor(terrainType.apexColor),
                                              isMetallic: false)
            
            let baseMaterial = SimpleMaterial(color: NSColor(terrainType.baseColor),
                                              isMetallic: false)
            
            result[terrainType] = (apex: apexMaterial,
                                   base: baseMaterial)
        })
    }
}

extension TerrainCacheComponent {
    
    internal func apex(for kite: Triangle.Kite,
                       terrainType: TerrainType) -> Mesh {
        
        apex[kite] ?? .empty
    }
    
    internal func base(for kite: Triangle.Kite,
                       terrainType: TerrainType) -> Mesh {
        
        base[kite] ?? .empty
    }
}
