//
//  StairSystem.swift
//
//  Created by Zack Brown on 16/11/2025.
//

import AppKit
import Deltille
import Euclid
import Newel
import RealityKit

@MainActor
internal struct StairSystem: System {
    
    internal enum Constant {
        
        static let apexHeight = 0.1
        static let baseHeight = 0.5
    }
    
    internal init(scene: Scene) {}
    
    internal func update(context: SceneUpdateContext) {
        
        guard let stairs = context.scene.find(entity: .stairs) as? Stairs,
              let terrain = context.scene.find(entity: .terrain) as? Terrain else { return }
        
        stairs.clean { slice, chunk in
            
            let terrainSlice = terrain.slice(for: chunk.triangle.sieve(for: .chunk))
            
            guard !terrainSlice.isEmpty else { return false }
            
            return update(chunk: chunk,
                          slice: slice,
                          terrainSlice: terrainSlice)
        }
    }
}

extension StairSystem {
    
    private func update(chunk: StairChunk,
                        slice: TriangularGridDataSourceSlice<StairFootprint>,
                        terrainSlice: HexagonalGridDataSourceSlice<TerrainVertex>) -> Bool {
        
        var invalidTiles: [Triangle] = []
        
        let unique = Set(slice.tiles)
        
        let mesh = unique.reduce(into: Mesh.empty) { result, stairTile in
            
            guard let terrainTile = terrainSlice.tile(for: stairTile.origin) else {
                
                invalidTiles.append(stairTile.origin)
                
                return
            }
            
            let apexElevation = Vector(0.0, TerrainSystem.unitHeight(for: terrainTile.base), 0.0)
            
            let angle = Angle(radians: stairTile.origin.rotation)
            let rotation = Rotation.yaw(angle)
            
            let stairs = Mesh.staircase(stairTile.stoop,
                                        7,
                                        TerrainSystem.Constant.baseHeight,
                                        .ascending)

            result = result.merge(stairs.rotated(by: rotation).translated(by: stairTile.origin.position(.tile) + apexElevation))
        }
        
        //dataSource.remove(values: invalidTiles)
        
        guard !mesh.polygons.isEmpty else { return false }
        
        chunk.mesh = mesh.translated(by: -chunk.triangle.position(chunk.scale))
        
        return true
    }
}
