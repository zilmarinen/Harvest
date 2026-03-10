//
//  WaterSystem.swift
//
//  Created by Zack Brown on 26/10/2025.
//

import AppKit
import Deltille
import Euclid
import Lattice
import RealityKit

@MainActor
internal struct WaterSystem: System {
    
    internal init(scene: Scene) {}
    
    internal func update(context: SceneUpdateContext) {
        
        guard let terrain = context.scene.find(entity: .terrain) as? Terrain,
              let water = context.scene.find(entity: .water) as? Water else { return }
        
        water.clean { slice, chunk in
            
            let terrainSlice = terrain.slice(for: chunk.triangle.sieve(for: .chunk))
            
            return update(grid: water,
                          chunk: chunk,
                          slice: slice,
                          terrainSlice: terrainSlice)
        }
    }
}

extension WaterSystem {
    
    private func update(grid: Water,
                        chunk: WaterChunk,
                        slice: TriangularDataStoreSlice<WaterTile>,
                        terrainSlice: HexagonalDataStoreSlice<TerrainVertex>?) -> Bool {
        
        var invalid: [Triangle.Vertex] = []
        
        let polygons = slice.tiles.reduce(into: [Euclid.Polygon]()) { result, tile in
            
            guard terrainSlice?.tile(for: tile.origin.vertex)?.base ?? 0 < tile.elevation else {
                
                invalid.append(tile.origin.vertex)
                
                return
            }
            
            result.append(contentsOf: render(tile: tile,
                                             slice: slice))
        }
        
        grid.remove(values: invalid)
        
        guard !polygons.isEmpty else { return false }
        
        let mesh = Mesh(polygons)
        
        chunk.mesh = mesh.translated(by: -chunk.triangle.position(chunk.scale))
        
        return true
    }
    
    private func render(tile: WaterTile,
                        slice: TriangularDataStoreSlice<WaterTile>) -> [Euclid.Polygon] {
        
        let identifier = tile.origin.vertex.position.identifier
        let apexColor = tile.waterType.colorPalette.color(for: identifier,
                                                          [.primary,
                                                           .secondary,
                                                           .tertiary])
        
        let apexElevation = Vector(0.0, (Double(tile.elevation) * TerrainSystem.Constant.baseHeight) - TerrainSystem.Constant.apexHeight, 0.0)
        let vertices = tile.origin.vertices.map { $0.position(.tile) + apexElevation }
        let apexPath = vertices.path(apexColor)
        
        guard let apex = Polygon(shape: apexPath) else { return [] }
        
        var polygons = [apex]
        
        for edge in tile.origin.edges {
         
            let adjacent = tile.origin.neighbour(edge)
            let elevation = slice.tile(for: adjacent.vertex)?.elevation ?? 0
            
            guard tile.elevation > elevation else { continue }
            
            let mantleElevation = Vector(0.0, (Double(elevation) * TerrainSystem.Constant.baseHeight) - TerrainSystem.Constant.apexHeight, 0.0)
            
            let corners = edge.corners.map {

                tile.origin.vertex($0).position(.tile)
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
