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
    
    internal let material: CustomMaterial
    
    private var meshes: [Triangle.Septomino : Mesh] = [:]
    
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

extension FoliageAssetCacheComponent {
    
    internal func mesh(for septomino: Triangle.Septomino) -> Mesh {
        
        if let mesh = meshes[septomino] {
            
            return mesh
        }
        
        let mesh = Mesh.foliage(septomino,
                                .columnar,
                                .init(.green, .yellow),
                                .init(.red, .blue))
        
        meshes[septomino] = mesh
        
        return mesh
    }
}
