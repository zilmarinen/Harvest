//
//  TerrainAssetCacheComponent.swift
//
//  Created by Zack Brown on 08/09/2025.
//

import AppKit
import Deltille
import Euclid
import RealityKit
import Regolith

internal class TerrainAssetCacheComponent: Component {
    
    internal static let apexHeight = 0.1
    internal static let baseHeight = 0.5
    
    private let stencil = Triangle.zero.stencil(.tile)
    
    internal let material: CustomMaterial
    
    private var apex: [Biome : [Triangle.Kite : Mesh]] = [:]
    private var base: [Biome : [Triangle.Kite : Mesh]] = [:]
    
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

extension TerrainAssetCacheComponent {
    
    internal func apex(for kite: Triangle.Kite,
                       biome: Biome) -> Mesh {
        
        var container = apex[biome] ?? [:]
        
        if let mesh = container[kite] {
            
            return mesh
        }
        
        let mesh = Mesh.kite(kite,
                             stencil,
                             Self.apexHeight,
                             biome.colorPalette.primary)
        
        container[kite] = mesh
        
        apex[biome] = container
        
        return mesh
    }
    
    internal func base(for kite: Triangle.Kite,
                       biome: Biome) -> Mesh {
        
        var container = base[biome] ?? [:]
        
        if let mesh = container[kite] {
            
            return mesh
        }
        
        let mesh = Mesh.kite(kite,
                             stencil,
                             Self.baseHeight,
                             biome.colorPalette.secondary)
        
        container[kite] = mesh
        
        base[biome] = container
        
        return mesh
    }
}
