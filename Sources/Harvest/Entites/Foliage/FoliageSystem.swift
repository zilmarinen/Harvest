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
    
    internal init(scene: Scene) {}
    
    internal func update(context: SceneUpdateContext) {
        
        guard let biosphere = context.scene.find(entity: .biosphere) as? Biosphere,
              let foliage = context.scene.find(entity: .foliage) as? Foliage else { return }
        
        var emptyRegions: [FoliageRegion] = []
        
        for region in foliage.dirtyRegions {
            
            for chunk in region.dirtyChunks {
                
                update(chunk: chunk,
                       biosphere: biosphere)
                
                if chunk.isEmpty {
                    
                    chunk.removeFromParent()
                }
            }
            
            if region.isEmpty {
                
                emptyRegions.append(region)
            }
        }
        
        emptyRegions.forEach {
            
            $0.removeFromParent()
        }
    }
}

extension FoliageSystem {
    
    private func update(chunk: FoliageChunk,
                        biosphere: Biosphere) {
        
        var invalidTiles: [Triangle] = []
        
        let polygons = chunk.tiles.reduce(into: [Euclid.Polygon]()) { result, item in
            
            let (triangle, _) = item
            let biome = biosphere.tile(for: triangle)
            
            guard let elevation = biome.uniformElevation else {
                
                invalidTiles.append(triangle)
                
                return
            }
            
            result.append(contentsOf: render(biome: biome,
                                             elevation: elevation))
        }
        
        invalidTiles.forEach {
            
            chunk.set(nil,
                      for: $0)
        }
        
        guard !polygons.isEmpty else { return }
        
        let mesh = Mesh(polygons)
        
        chunk.mesh = mesh.translated(by: -chunk.triangle.position(chunk.scale))
        chunk.isDirty = false
    }
    
    private func render(biome: HexagonalGridDataSourceTile<BiomeVertex>,
                        elevation: Int) -> [Euclid.Polygon] {
        
        guard let uniform = biome.vertices.first?.value.biome else { return [] }
        
        let apexElevation = Vector(0.0, (Double(elevation) * TerrainSystem.Constant.baseHeight) + TerrainSystem.Constant.apexHeight, 0.0)
        let origin = biome.triangle.position(.tile)
        let angle = Angle(radians: biome.triangle.rotation)
        let rotation = Rotation.yaw(angle)
        
        let mesh = Mesh.foliage(.antlia,
                                .columnar,
                                uniform.foliage,
                                uniform.foliage).rotated(by: rotation).translated(by: origin + apexElevation)
        
        return mesh.polygons
    }
}
