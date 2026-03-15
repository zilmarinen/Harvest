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
        
        staircases.clean { chunk, wedge in
            
            let terrainWedge = terrain.wedge(for: chunk.triangle.sieve(for: .chunk))
            
            guard !terrainWedge.isEmpty else { return false }
            
            return update(grid: staircases,
                          chunk: chunk,
                          wedge: wedge,
                          terrainWedge: terrainWedge)
        }
    }
}

extension StaircaseSystem {
    
    private func update(grid: Staircases,
                        chunk: StaircaseChunk,
                        wedge: TriangularDataStoreWedge<StaircaseTile>,
                        terrainWedge: HexagonalDataStoreWedge<TerrainVertex>) -> Bool {
        false
//        var invalid: [Triangle.Vertex] = []
//        
//        let unique = Set(wedge.tiles)
//        
//        let mesh = unique.reduce(into: Mesh.empty) { result, staircaseTile in
//            
//            guard let terrainTile = terrainWedge.tile(for: staircaseTile.origin) else {
//                
//                invalid.append(staircaseTile.origin)
//                
//                return
//            }
//            
//            let apexElevation = Vector(0.0, TerrainSystem.unitHeight(for: terrainTile.base), 0.0)
//            
//            let tile = Triangle(staircaseTile.origin)
//            let angle = Angle(radians: tile.rotation)
//            let rotation = Rotation.yaw(angle)
//            
//            let staircase = Mesh.staircase(staircaseTile.staircaseType,
//                                           7,
//                                           TerrainSystem.Constant.baseHeight,
//                                           .ascending)
//
//            result = result.merge(staircase.rotated(by: rotation).translated(by: staircaseTile.origin.position(.tile) + apexElevation))
//        }
//        
//        grid.remove(values: invalid)
//        
//        guard !mesh.polygons.isEmpty else { return false }
//        
//        chunk.mesh = mesh.translated(by: -chunk.triangle.position(chunk.scale))
//        
//        return true
    }
}
