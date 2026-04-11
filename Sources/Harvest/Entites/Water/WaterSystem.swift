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
        
        water.clean { chunk, wedge in
            
            update(grid: water,
                   chunk: chunk,
                   wedge: wedge,
                   terrain: terrain)
        }
    }
}

extension WaterSystem {
    
    private func update(grid: Water,
                        chunk: WaterChunk,
                        wedge: TriangularDataStoreWedge<WaterTile>,
                        terrain: Terrain) -> Bool {
        
        let terrainWedge = terrain.wedge(for: chunk.triangle.sieve(for: .chunk))
        
        var invalid: [Triangle.Vertex] = []
        
        let polygons = wedge.tiles.reduce(into: [Euclid.Polygon]()) { result, tile in
            
            guard tile.elevation > terrainWedge.tile(for: tile.origin)?.floor ?? 0 else {
                
                invalid.append(tile.origin)
                
                return
            }
            
            let triangle = Triangle(tile.origin)
            
            let adjacent = triangle.edges.reduce(into: [Triangle.Edge : WaterTile]()) { result, edge in
                
                let neighbour = triangle.neighbour(edge)
                
                guard let value = wedge.tile(for: neighbour.vertex) else { return }
                
                result[edge] = value
            }
            
            result.append(contentsOf: render(tile: tile,
                                             adjacent: adjacent))
        }
        
        grid.remove(values: invalid)
        
        guard !polygons.isEmpty else { return false }
        
        let mesh = Mesh(polygons)
        
        chunk.mesh = mesh.translated(by: -chunk.triangle.position(chunk.scale))
        
        return true
    }
    
    private func render(tile: WaterTile,
                        adjacent: [Triangle.Edge : WaterTile]) -> [Euclid.Polygon] {
        
        let apexElevation = Vector(0.0, Water.apex(for: tile.elevation), 0.0)
        let apexColor = tile.waterType.colorPalette.color(for: tile.origin.position.identifier,
                                                          [.primary,
                                                           .secondary,
                                                           .tertiary])
        let triangle = Triangle(tile.origin)
        
        let vertices = triangle.vertices.position(.tile)
        
        guard let surface = Polygon.surface(vertices.map { $0 + apexElevation },
                                            apexColor) else { return [] }
        
        var polygons = [surface]
        
        for edge in triangle.edges {
            
            let adjacent = adjacent[edge]
            let adjacentElevation = adjacent?.elevation ?? 0
            
            guard tile.elevation > adjacentElevation,
                  let c0 = edge.corners.last,
                  let c1 = edge.corners.first else { continue }
            
            let intersectionElevation = Vector(0.0, Water.apex(for: adjacentElevation), 0.0)
            
            let v0 = triangle.vertex(c0).position(.tile)
            let v1 = triangle.vertex(c1).position(.tile)
            
            let a0 = v0 + apexElevation
            let a1 = v1 + apexElevation
            
            let i0 = v0 + intersectionElevation
            let i1 = v1 + intersectionElevation
            
            guard let face = Polygon.surface([i0, i1, a1, a0],
                                             tile.waterType.colorPalette.quaternary) else { continue }
            
            polygons.append(face)
        }
        
        return polygons
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    private func update(grid: Water,
                        chunk: WaterChunk,
                        wedge: TriangularDataStoreWedge<WaterTile>,
                        terrainWedge: HexagonalDataStoreWedge<TerrainVertex>?) -> Bool {
        false
//        var invalid: [Triangle.Vertex] = []
//        
//        let polygons = wedge.tiles.reduce(into: [Euclid.Polygon]()) { result, tile in
//            
//            guard terrainWedge?.tile(for: tile.origin)?.base ?? 0 < tile.elevation else {
//                
//                invalid.append(tile.origin)
//                
//                return
//            }
//            
//            result.append(contentsOf: render(tile: tile,
//                                             wedge: wedge))
//        }
//        
//        grid.remove(values: invalid)
//        
//        guard !polygons.isEmpty else { return false }
//        
//        let mesh = Mesh(polygons)
//        
//        chunk.mesh = mesh.translated(by: -chunk.triangle.position(chunk.scale))
//        
//        return true
//    }
//    
//    private func render(tile: WaterTile,
//                        wedge: TriangularDataStoreWedge<WaterTile>) -> [Euclid.Polygon] {
//        
//        let identifier = tile.origin.position.identifier
//        let apexColor = tile.waterType.colorPalette.color(for: identifier,
//                                                          [.primary,
//                                                           .secondary,
//                                                           .tertiary])
//        
//        let apexElevation = Vector(0.0, (Double(tile.elevation) * TerrainSystem.Constant.baseHeight) - TerrainSystem.Constant.apexHeight, 0.0)
//        let vertices = tile.origin.vertices.map { $0.position(.tile) + apexElevation }
//        let apexPath = vertices.path(apexColor)
//        
//        guard let apex = Polygon(apexPath) else { return [] }
//        
//        var polygons = [apex]
//        
//        let triangle = Triangle(tile.origin)
//        
//        for edge in triangle.edges {
//         
//            let adjacent = triangle.neighbour(edge)
//            let elevation = wedge.tile(for: adjacent.vertex)?.elevation ?? 0
//            
//            guard tile.elevation > elevation else { continue }
//            
//            let mantleElevation = Vector(0.0, (Double(elevation) * TerrainSystem.Constant.baseHeight) - TerrainSystem.Constant.apexHeight, 0.0)
//            
//            let corners = edge.corners.map {
//
//                triangle.vertex($0).position(.tile)
//            }
//            
//            let face =  corners.reversed().map { $0 + mantleElevation } +
//                        corners.map { $0 + apexElevation }
//
//            let path = face.path(tile.waterType.colorPalette.quaternary)
//
//            guard let polygon = Polygon(path) else { continue }
//
//            polygons.append(polygon)
//        }
//        
//        return polygons
    }
}
