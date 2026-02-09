//
//  BuildingSystem.swift
//
//  Created by Zack Brown on 27/12/2025.
//

import AppKit
import Deltille
import Euclid
import Lintel
import RealityKit

@MainActor
internal struct BuildingSystem: System {
    
    internal init(scene: Scene) {}
    
    internal func update(context: SceneUpdateContext) {
        
        guard let buildings = context.scene.find(entity: .buildings) as? Buildings,
              let terrain = context.scene.find(entity: .terrain) as? Terrain else { return }
        
        buildings.clean { slice, chunk in
            
            let terrainSlice = terrain.slice(for: chunk.triangle.sieve(for: .chunk))
            
            guard !terrainSlice.isEmpty else { return false }
            
            return update(grid: buildings,
                          chunk: chunk,
                          slice: slice,
                          terrainSlice: terrainSlice)
        }
    }
}

extension BuildingSystem {
    
    private func update(grid: Buildings,
                        chunk: BuildingChunk,
                        slice: TriangularGridDataSourceSlice<BuildingFootprint>,
                        terrainSlice: HexagonalGridDataSourceSlice<TerrainVertex>) -> Bool {
        
        var invalidTiles: [Triangle] = []
        
        let unique = Set(slice.tiles)
        
        let mesh = unique.reduce(into: Mesh.empty) { result, buildingTile in
            
            guard let terrainTile = terrainSlice.tile(for: buildingTile.origin) else {
                
                invalidTiles.append(buildingTile.origin)
                
                return
            }
            
            let apexElevation = Vector(0.0, TerrainSystem.unitHeight(for: terrainTile.base), 0.0)
            
            let angle = Angle(radians: buildingTile.origin.rotation)
            let rotation = Rotation.yaw(angle)
            
            let building = Mesh.building(buildingTile.septomino)

            result = result.merge(building.rotated(by: rotation).translated(by: buildingTile.origin.position(.tile) + apexElevation))
        }
        
        grid.remove(values: invalidTiles)
        
        guard !mesh.polygons.isEmpty else { return false }
        
        chunk.mesh = mesh.translated(by: -chunk.triangle.position(chunk.scale))
        
        return true
    }
}
