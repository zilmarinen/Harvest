//
//  WaterSystem.swift
//
//  Created by Zack Brown on 26/10/2025.
//

import AppKit
import Deltille
import Euclid
import RealityKit

@MainActor
internal struct WaterSystem: System {
    
    internal init(scene: Scene) {}
    
    internal func update(context: SceneUpdateContext) {
        
        guard let terrain = context.scene.find(entity: .terrain) as? Terrain,
              let water = context.scene.find(entity: .water) as? Water else { return }
        
        water.clean { dataSource, chunk in
            
            let terrainSlice = terrain.slice(for: chunk.triangle)
            
            return update(chunk: chunk,
                          dataSource: dataSource,
                          terrainSlice: terrainSlice)
        }
    }
}

extension WaterSystem {
    
    private func update(chunk: WaterChunk,
                        dataSource: TriangularChunkDataSource<WaterTile>,
                        terrainSlice: HexagonalGridDataSourceSlice<TerrainVertex>?) -> Bool {
        
        var invalidTiles: [Triangle] = []
        
        let polygons = dataSource.data.reduce(into: [Euclid.Polygon]()) { result, item in
            
            let (triangle, waterTile) = item
            
            guard terrainSlice?.tile(for: triangle)?.base ?? 0 < waterTile.elevation else {
                
                invalidTiles.append(triangle)
                
                return
            }
            
            result.append(contentsOf: render(tile: waterTile,
                                             dataSource: dataSource))
        }
        
        dataSource.remove(values: invalidTiles)
        
        guard !polygons.isEmpty else { return false }
        
        let mesh = Mesh(polygons)
        
        chunk.mesh = mesh.translated(by: -chunk.triangle.position(chunk.scale))
        
        return !dataSource.isEmpty
    }
    
    private func render(tile: WaterTile,
                        dataSource: TriangularChunkDataSource<WaterTile>) -> [Euclid.Polygon] {
        
        let identifier = tile.triangle.vertex.position.identifier
        let apexColor = tile.waterType.colorPalette.color(for: identifier,
                                                          [.primary,
                                                           .secondary,
                                                           .tertiary])
        
        let apexElevation = Vector(0.0, (Double(tile.elevation) * TerrainSystem.Constant.baseHeight) - TerrainSystem.Constant.apexHeight, 0.0)
        let vertices = tile.triangle.vertices.map { $0.position(.tile) + apexElevation }
        let apexPath = vertices.path(apexColor)
        
        guard let apex = Polygon(shape: apexPath) else { return [] }
        
        var polygons = [apex]
        
        for edge in tile.triangle.edges {
         
            let adjacent = tile.triangle.neighbour(edge)
            let elevation = dataSource.value(for: adjacent)?.elevation ?? 0
            
            guard tile.elevation > elevation else { continue }
            
            let mantleElevation = Vector(0.0, (Double(elevation) * TerrainSystem.Constant.baseHeight) - TerrainSystem.Constant.apexHeight, 0.0)
            
            let corners = edge.corners.map {

                tile.triangle.vertex($0).position(.tile)
            }
            
            let face =  corners.reversed().map { $0 + mantleElevation } +
                        corners.map { $0 + apexElevation }

            let path = face.path(tile.waterType.colorPalette.quaternary)

            guard let polygon = Polygon(shape: path) else { continue }

            polygons.append(polygon)
        }
        
        return polygons
    }
}
