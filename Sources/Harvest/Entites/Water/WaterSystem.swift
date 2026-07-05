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
        
        guard let world = context.scene.find(anchor: .world) as? AnchorEntity,
              let terrain = world.find(entity: .terrain) as? Terrain,
              let water = world.find(entity: .water) as? Water else { return }
        
        water.clean { chunk, sieve, wedge in
            
            let terrainWedge = terrain.wedge(for: sieve)
            
            return update(grid: water,
                          chunk: chunk,
                          wedge: wedge,
                          weave: terrainWedge.weave(sieve))
        }
    }
}

extension WaterSystem {
    
    private func update(grid: Water,
                        chunk: WaterChunk,
                        wedge: DataStoreWedge<WaterTile>,
                        weave: DataStoreWeave<TerrainVertex>) -> Bool {
        
        print("Cleaning Water Chunk \(chunk.tile.id)")
        
        var invalid: [Triangle] = []
        
        let polygons = wedge.data.reduce(into: [Euclid.Polygon]()) { result, tile in
            
            let triangle = Triangle(tile.value.vertex)
            
            guard tile.value.elevation > weave.value(for: triangle)?.floor ?? 0 else {
                
                invalid.append(.init(tile.value.vertex))
                
                return
            }
            
            result.append(contentsOf: render(tile: tile.value,
                                             wedge: wedge))
        }
        
        grid.remove(values: invalid)
        
        guard !polygons.isEmpty else { return false }
        
        let mesh = Mesh(polygons)
        
        chunk.mesh = mesh.translated(by: -chunk.tile.position(chunk.scale))
        
        return true
    }
    
    private func render(tile: WaterTile,
                        wedge: DataStoreWedge<WaterTile>) -> [Euclid.Polygon] {
        
        let apexElevation = Vector(0.0, Water.apex(for: tile.elevation), 0.0)
        let apexColor = tile.waterType.colorPalette.color(for: tile.vertex.position.identifier,
                                                          [.primary,
                                                           .secondary,
                                                           .tertiary])
        let triangle = Triangle(tile.vertex)
        
        let vertices = triangle.vertices.position(.tile)
        
        guard let surface = Polygon.surface(vertices.map { $0 + apexElevation },
                                            apexColor) else { return [] }
        
        var polygons = [surface]
        
        for edge in triangle.edges {
            
            let neighbour = triangle.neighbour(edge)
            let adjacent = wedge.value(for: neighbour.vertex)
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
}
