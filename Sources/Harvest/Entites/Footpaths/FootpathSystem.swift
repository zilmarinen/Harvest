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
        
        guard let footpaths = context.scene.find(entity: .footpaths) as? Footpaths,
              let terrain = context.scene.find(entity: .terrain) as? Terrain else { return }
        
        footpaths.clean { slice, chunk in
            
            let terrainSlice = terrain.slice(for: chunk.triangle,
                                             .chunk)
            
            guard !terrainSlice.isEmpty else { return false }
            
            return update(chunk: chunk,
                          slice: slice,
                          terrainSlice: terrainSlice)
        }
    }
}

extension FootpathSystem {
    
    private func update(chunk: FootpathChunk,
                        slice: HexagonalGridDataSourceSlice<FootpathType>,
                        terrainSlice: HexagonalGridDataSourceSlice<TerrainVertex>) -> Bool {
        
        var mesh = Mesh.empty
        
        for (_, tile) in slice.tiles {
            
            guard let terrainTile = terrainSlice.tiles[tile.triangle] else { continue }
            
            //
            guard let vertex = tile.vertices.first else { continue }
            //
            
            let vertices = tile.vertices.keys.map { $0 }
            
            let apexElevation = Vector(0.0, TerrainSystem.unitHeight(for: terrainTile.apex) + 0.0001, 0.0)
            
            let wedge = Wedge(tile.triangle,
                              vertices)
            
            let part = Mesh.footpath(tile.triangle,
                                     wedge,
                                     vertex.value.colorPalette)
            
            mesh = mesh.union(part.translated(by: apexElevation))
        }
        
        chunk.mesh = mesh.translated(by: -chunk.triangle.position(chunk.scale))
        
        return true
    }
}


