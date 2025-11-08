//
//  FoliageSystem.swift
//
//  Created by Zack Brown on 25/10/2025.
//

import AppKit
import Deltille
import Euclid
import RealityKit
import Verdure

@MainActor
internal struct FoliageSystem: System {
    
    private static let query = EntityQuery(where: .has(FoliageAssetCacheComponent.self))
    
    internal init(scene: Scene) {}
    
    internal func update(context: SceneUpdateContext) {
        
        guard let biosphere = context.scene.find(entity: .biosphere) as? Biosphere else { return }
        
        for entity in context.entities(matching: Self.query,
                                       updatingSystemWhen: .rendering) {
            
            guard let foliage = entity as? Foliage,
                  let cache = foliage.components[FoliageAssetCacheComponent.self] else { continue }
            
            var emptyRegions: [FoliageRegion] = []
            
            for region in foliage.dirtyRegions {
                
                var emptyChunks: [FoliageChunk] = []
                
                for chunk in region.dirtyChunks {
                    
                    guard !chunk.isEmpty else {
                        
                        emptyChunks.append(chunk)
                        
                        continue
                    }
                    
                    update(chunk: chunk,
                           biosphere: biosphere,
                           cache: cache)
                }
                
                emptyChunks.forEach {
                    
                    region.removeChild($0)
                }
                
                if region.isEmpty {
                    
                    emptyRegions.append(region)
                }
            }
            
            emptyRegions.forEach {
                
                foliage.removeChild($0)
            }
        }
    }
    
    private func update(chunk: FoliageChunk,
                        biosphere: Biosphere,
                        cache: FoliageAssetCacheComponent) {
        
        var mesh = Mesh.empty
        
        for (triangle, septomino) in chunk.foliageComponent.foliage {
            
            let foliage = cache.mesh(for: septomino)
            
            let tile = biosphere.tile(for: triangle)
            
            let elevation = Double(tile.uniformElevation ?? 0)
            
            let position = triangle.position(.tile)
            
            let rotation = Angle(radians: triangle.rotation)
            
            let offset = Vector(position.x,
                                (elevation * TerrainSystem.Constant.baseHeight) + TerrainSystem.Constant.apexHeight,
                                 position.z)
            
            mesh = mesh.merge(foliage.rotated(by: .yaw(rotation)).translated(by: offset))
        }
        
        mesh = mesh.translated(by: -chunk.triangle.position(.chunk))
        
        let resource = MeshResource(mesh: mesh)
        
        let model = ModelComponent(mesh: resource,
                                   materials: [SimpleMaterial()])
        
        chunk.model = model
        
        chunk.isDirty = false
    }
}
