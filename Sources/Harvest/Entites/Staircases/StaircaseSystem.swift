//
//  StaircaseSystem.swift
//
//  Created by Zack Brown on 16/11/2025.
//

import AppKit
import Deltille
import Euclid
import Lattice
import Newel
import RealityKit

@MainActor
internal struct StaircaseSystem: System {
    
    internal enum Constant {
        
        static let apexHeight = 0.1
        static let baseHeight = 0.5
    }
    
    internal init(scene: Scene) {}
    
    internal func update(context: SceneUpdateContext) {
        
        guard let staircases = context.scene.find(entity: .staircases) as? Staircases,
              let terrain = context.scene.find(entity: .terrain) as? Terrain else { return }
        
        staircases.clean { slice, chunk in
            
            let terrainSlice = terrain.slice(for: chunk.triangle.sieve(for: .chunk))
            
            guard !terrainSlice.isEmpty else { return false }
            
            return update(grid: staircases,
                          chunk: chunk,
                          slice: slice,
                          terrainSlice: terrainSlice)
        }
    }
}

extension StaircaseSystem {
    
    private func update(grid: Staircases,
                        chunk: StaircaseChunk,
                        slice: TriangularDataStoreSlice<StaircaseTile>,
                        terrainSlice: HexagonalDataStoreSlice<TerrainVertex>) -> Bool {
        
        var invalid: [Triangle.Vertex] = []
        
        let unique = Set(slice.tiles)
        
        let mesh = unique.reduce(into: Mesh.empty) { result, staircaseTile in
            
            guard let terrainTile = terrainSlice.tile(for: staircaseTile.origin.vertex) else {
                
                invalid.append(staircaseTile.origin.vertex)
                
                return
            }
            
            let apexElevation = Vector(0.0, TerrainSystem.unitHeight(for: terrainTile.base), 0.0)
            
            let angle = Angle(radians: staircaseTile.origin.rotation)
            let rotation = Rotation.yaw(angle)
            
            let staircase = Mesh.staircase(staircaseTile.staircaseType,
                                           7,
                                           TerrainSystem.Constant.baseHeight,
                                           .ascending)

            result = result.merge(staircase.rotated(by: rotation).translated(by: staircaseTile.origin.position(.tile) + apexElevation))
        }
        
        grid.remove(values: invalid)
        
        guard !mesh.polygons.isEmpty else { return false }
        
        chunk.mesh = mesh.translated(by: -chunk.triangle.position(chunk.scale))
        
        return true
    }
}
