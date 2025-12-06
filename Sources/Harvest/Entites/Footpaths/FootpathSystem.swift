//
//  FootpathSystem.swift
//
//  Created by Zack Brown on 11/11/2025.
//

import AppKit
import Cobble
import Deltille
import Euclid
import Lattice
import RealityKit

@MainActor
internal struct FootpathSystem: System {
    
    internal init(scene: Scene) {}
    
    internal func update(context: SceneUpdateContext) {
        
        guard let terrain = context.scene.find(entity: .terrain) as? Terrain,
              let footpaths = context.scene.find(entity: .footpaths) as? Footpaths else { return }
        
//        var emptyRegions: [TriangularRegion<FootpathChunk>] = []
//        
//        for region in footpaths.dirtyRegions {
//            
//            var emptyChunks: [FootpathChunk] = []
//            
//            for chunk in region.dirtyChunks {
//                
//                let slice = footpaths.dataSource.slice(for: chunk.triangle,
//                                                       .chunk)
//                
//                guard !slice.vertices.isEmpty else {
//                    
//                    emptyChunks.append(chunk)
//                    
//                    continue
//                }
//                
//                update(chunk: chunk,
//                       footpathSlice: slice,
//                       biomeSlice: terrain.slice(for: chunk.triangle,
//                                                 .chunk))
//            }
//            
//            emptyChunks.forEach {
//                
//                $0.removeFromParent()
//            }
//            
//            if region.isEmpty {
//                
//                emptyRegions.append(region)
//            }
//        }
//        
//        emptyRegions.forEach {
//            
//            $0.removeFromParent()
//        }
    }
}

extension FootpathSystem {
    
    private func update(chunk: FootpathChunk,
                        footpathSlice: HexagonalGridDataSourceSlice<FootpathType>,
                        biomeSlice: HexagonalGridDataSourceSlice<TerrainVertex>) {
        
        var mesh = Mesh.empty
        
        for (_, tile) in footpathSlice.tiles {
            
            guard let biomeTile = biomeSlice.tiles[tile.triangle] else { continue }
            
            let vertices = tile.vertices.keys.map { $0 }
            
            let apexElevation = Vector(0.0, (Double(biomeTile.apex) * TerrainSystem.Constant.baseHeight) + TerrainSystem.Constant.apexHeight + 0.0001, 0.0)
            
            let wedge = Wedge(tile.triangle,
                              vertices)
            
            let part = Mesh.footpath(tile.triangle,
                                     wedge)
            
            mesh = mesh.union(part.translated(by: apexElevation))
        }
        
        chunk.mesh = mesh.translated(by: -chunk.triangle.position(chunk.scale))
        chunk.isDirty = false
    }
}


