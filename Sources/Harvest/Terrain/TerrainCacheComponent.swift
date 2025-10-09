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

internal class TerrainCacheComponent: Component {
    
    internal static let apexHeight = 0.1
    internal static let baseHeight = 0.5
    
    private let stencil = Triangle.zero.stencil(.tile)
    
    internal let material: CustomMaterial
    
    private var apex: [TerrainType : [Triangle.Kite : Mesh]] = [:]
    private var base: [TerrainType : [Triangle.Kite : Mesh]] = [:]
    
    internal init() {
        
        do {
            
            guard let device = MTLCreateSystemDefaultDevice() else { fatalError("Error creating default metal device") }
            
            let library = try device.makeDefaultLibrary(bundle: .module)
            
            let surface = CustomMaterial.SurfaceShader(named: "customMaterialSurface",
                                                       in: library)
            
            let geometry = CustomMaterial.GeometryModifier(named: "customMaterialGeometry",
                                                           in: library)
            
            self.material = try CustomMaterial(surfaceShader: surface,
                                               geometryModifier: geometry,
                                               lightingModel: .lit)
        }
        catch {
            
            fatalError("Error creating custom material: \(error)")
        }
    }
}

extension TerrainCacheComponent {
    
    internal func apex(for kite: Triangle.Kite,
                       terrainType: TerrainType) -> Mesh {
        
        var container = apex[terrainType] ?? [:]
        
        if let mesh = container[kite] {
            
            return mesh
        }
        
        let mesh = kite.mesh(stencil,
                             Self.apexHeight,
                             terrainType.apexColor)
        
        container[kite] = mesh
        
        apex[terrainType] = container
        
        return mesh
    }
    
    internal func base(for kite: Triangle.Kite,
                       terrainType: TerrainType) -> Mesh {
        
        var container = base[terrainType] ?? [:]
        
        if let mesh = container[kite] {
            
            return mesh
        }
        
        let mesh = kite.mesh(stencil,
                             Self.baseHeight,
                             terrainType.baseColor)
        
        container[kite] = mesh
        
        base[terrainType] = container
        
        return mesh
    }
}
