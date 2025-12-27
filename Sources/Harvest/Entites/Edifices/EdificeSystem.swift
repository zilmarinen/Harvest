//
//  EdificeSystem.swift
//
//  Created by Zack Brown on 27/12/2025.
//

import AppKit
import Deltille
import Euclid
import Lintel
import RealityKit

@MainActor
internal struct EdificeSystem: System {
    
    internal init(scene: Scene) {}
    
    internal func update(context: SceneUpdateContext) {
        
        guard let edifices = context.scene.find(entity: .edifices) as? Edifices,
              let terrain = context.scene.find(entity: .terrain) as? Terrain else { return }
        
        edifices.clean { slice, chunk in
            
            let terrainSlice = terrain.slice(for: chunk.triangle.sieve(for: .chunk))
            
            guard !terrainSlice.isEmpty else { return false }
            
            return update(grid: edifices,
                          chunk: chunk,
                          slice: slice,
                          terrainSlice: terrainSlice)
        }
    }
}

extension EdificeSystem {
    
    private func update(grid: Edifices,
                        chunk: EdificeChunk,
                        slice: TriangularGridDataSourceSlice<EdificeFootprint>,
                        terrainSlice: HexagonalGridDataSourceSlice<TerrainVertex>) -> Bool {
        
        var invalidTiles: [Triangle] = []
        
        let unique = Set(slice.tiles)
        
        let mesh = unique.reduce(into: Mesh.empty) { result, edificeTile in
            
            guard let terrainTile = terrainSlice.tile(for: edificeTile.origin) else {
                
                invalidTiles.append(edificeTile.origin)
                
                return
            }
            
            let apexElevation = Vector(0.0, TerrainSystem.unitHeight(for: terrainTile.base), 0.0)
            
            let angle = Angle(radians: edificeTile.origin.rotation)
            let rotation = Rotation.yaw(angle)
            
            let edifice = Mesh.building(edificeTile.septomino)

            result = result.merge(edifice.rotated(by: rotation).translated(by: edificeTile.origin.position(.tile) + apexElevation))
        }
        
        grid.remove(values: invalidTiles)
        
        guard !mesh.polygons.isEmpty else { return false }
        
        chunk.mesh = mesh.translated(by: -chunk.triangle.position(chunk.scale))
        
        return true
    }
}
