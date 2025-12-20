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
        
        guard let terrain = context.scene.find(entity: .terrain) as? Terrain,
              let foliage = context.scene.find(entity: .foliage) as? Foliage else { return }
        
        foliage.clean { dataSource, chunk in
            
            let terrainSlice = terrain.slice(for: chunk.triangle)
            
            guard !terrainSlice.isEmpty else { return false }
            
            return update(chunk: chunk,
                          dataSource: dataSource,
                          terrainSlice: terrainSlice)
        }
    }
}

extension FoliageSystem {
    
    private func update(chunk: FoliageChunk,
                        dataSource: TriangularChunkDataSource<Triangle>,
                        terrainSlice: HexagonalGridDataSourceSlice<TerrainVertex>) -> Bool {
        
        var invalidTiles: [Triangle] = []
        
        let polygons = dataSource.data.reduce(into: [Euclid.Polygon]()) { result, item in
            
            let (triangle, _) = item
            
            guard let terrainTile = terrainSlice.tile(for: triangle),
                  let elevation = terrainTile.uniformElevation else {
                
                invalidTiles.append(triangle)
                
                return
            }
            
            result.append(contentsOf: render(terrainTile: terrainTile,
                                             elevation: elevation))
        }
        
        dataSource.remove(values: invalidTiles)
        
        guard !polygons.isEmpty else { return false }
        
        let mesh = Mesh(polygons)
        
        chunk.mesh = mesh.translated(by: -chunk.triangle.position(chunk.scale))
        
        return !dataSource.isEmpty
    }
    
    private func render(terrainTile: HexagonalGridDataSourceTile<TerrainVertex>,
                        elevation: Int) -> [Euclid.Polygon] {
        
        guard let uniform = terrainTile.vertices.first?.value.biome else { return [] }
        
        let apexElevation = Vector(0.0, (Double(elevation) * TerrainSystem.Constant.baseHeight) + TerrainSystem.Constant.apexHeight, 0.0)
        let origin = terrainTile.triangle.position(.tile)
        let angle = Angle(radians: terrainTile.triangle.rotation)
        let rotation = Rotation.yaw(angle)
        
        let mesh = Mesh.foliage(.antlia,
                                .columnar,
                                uniform.foliage,
                                uniform.foliage).rotated(by: rotation).translated(by: origin + apexElevation)
        
        return mesh.polygons
    }
}
