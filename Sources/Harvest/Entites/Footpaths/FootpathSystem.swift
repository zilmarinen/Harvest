//
//  FootpathSystem.swift
//
//  Created by Zack Brown on 11/11/2025.
//

import AppKit
import Bivouac
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
        
        footpaths.clean { wedge, chunk in
            
            let terrainWedge = terrain.wedge(for: chunk.triangle.sieve(for: .chunk))
            
            guard !terrainWedge.isEmpty else { return false }
            
            return update(chunk: chunk,
                          wedge: wedge,
                          terrainWedge: terrainWedge)
        }
    }
}

extension FootpathSystem {
    
    private func update(chunk: FootpathChunk,
                        wedge: HexagonalDataStoreWedge<FootpathType>,
                        terrainWedge: HexagonalDataStoreWedge<TerrainVertex>) -> Bool {
        
        var mesh = Mesh.empty
        
        for tile in wedge.tiles {
            
            guard let terrainTile = terrainWedge.tile(for: tile.tile.vertex) else { continue }
            
            //
            guard let vertex = tile.vertices.first else { continue }
            //
            
            let vertices = tile.vertices.keys.map { $0 }
            
            let apexElevation = Vector(0.0, TerrainSystem.unitHeight(for: terrainTile.apex) + 0.0001, 0.0)
            
            let wedge = Wedge(tile.tile,
                              vertices)
            
            let part = Mesh.footpath(tile.tile,
                                     wedge,
                                     vertex.value.colorPalette)
            
            mesh = mesh.union(part.translated(by: apexElevation))
        }
        
        chunk.mesh = mesh.translated(by: -chunk.triangle.position(chunk.scale))
        
        return true
    }
}


