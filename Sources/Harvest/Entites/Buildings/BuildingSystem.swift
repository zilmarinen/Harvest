//
//  BuildingSystem.swift
//
//  Created by Zack Brown on 27/12/2025.
//

import AppKit
import Deltille
import Euclid
import Lattice
import Lintel
import RealityKit

@MainActor
internal struct BuildingSystem: System {
    
    internal init(scene: Scene) {}
    
    internal func update(context: SceneUpdateContext) {
        
        guard let buildings = context.scene.find(entity: .buildings) as? Buildings,
              let terrain = context.scene.find(entity: .terrain) as? Terrain else { return }
        
        buildings.clean { wedge, chunk in
            
            let terrainWedge = terrain.wedge(for: chunk.triangle.sieve(for: .chunk))
            
            guard !terrainWedge.isEmpty else { return false }
            
            return update(grid: buildings,
                          chunk: chunk,
                          wedge: wedge,
                          terrainWedge: terrainWedge)
        }
    }
}

extension BuildingSystem {
    
    private func update(grid: Buildings,
                        chunk: BuildingChunk,
                        wedge: TriangularDataStoreWedge<BuildingTile>,
                        terrainWedge: HexagonalDataStoreWedge<TerrainVertex>) -> Bool {
        
        var invalid: [Triangle.Vertex] = []
        
        let unique = Set(wedge.tiles)
        
        let mesh = unique.reduce(into: Mesh.empty) { result, buildingTile in
            
            guard let terrainTile = terrainWedge.tile(for: buildingTile.origin.vertex) else {
                
                invalid.append(buildingTile.origin.vertex)
                
                return
            }
            
            let apexElevation = Vector(0.0, TerrainSystem.unitHeight(for: terrainTile.base), 0.0)
            
            let angle = Angle(radians: buildingTile.origin.rotation)
            let rotation = Rotation.yaw(angle)
            
            let building = Mesh.building(buildingTile.septomino)

            result = result.merge(building.rotated(by: rotation).translated(by: buildingTile.origin.position(.tile) + apexElevation))
        }
        
        grid.remove(values: invalid)
        
        guard !mesh.polygons.isEmpty else { return false }
        
        chunk.mesh = mesh.translated(by: -chunk.triangle.position(chunk.scale))
        
        return true
    }
}
