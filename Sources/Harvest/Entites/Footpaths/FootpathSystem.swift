//
//  FootpathSystem.swift
//
//  Created by Zack Brown on 11/11/2025.
//

import AppKit
import Bivouac
import Cobble
import Deltille
import Euclid
import Lattice
import RealityKit
import Yield

@MainActor
internal struct FootpathSystem: System {
    
    internal init(scene: Scene) {}
    
    internal func update(context: SceneUpdateContext) {
        
        guard let world = context.scene.find(anchor: .world) as? AnchorEntity,
              let footpaths = world.find(entity: .footpaths) as? Footpaths,
              let terrain = world.find(entity: .terrain) as? Terrain else { return }
        
        footpaths.clean { chunk, sieve, wedge in
            
            let terrainWedge = terrain.wedge(for: chunk.triangle.sieve(for: .chunk))
            
            guard !terrainWedge.isEmpty else { return false }
            
            return update(grid: footpaths,
                          chunk: chunk,
                          wedge: wedge,
                          terrainWedge: terrainWedge)
        }
    }
}

extension FootpathSystem {
    
    private func update(grid: Footpaths,
                        chunk: FootpathChunk,
                        wedge: DataStoreWedge<FootpathVertex>,
                        terrainWedge: DataStoreWedge<TerrainVertex>) -> Bool {
        
        print("Cleaning Footpath Chunk")
        
//        var invalid: [Triangle.Vertex] = []
//        
//        let polygons = wedge.tiles.reduce(into: [Euclid.Polygon]()) { result, tile in
//            
//            guard let terrainTile = terrainWedge.tile(for: tile.triangle.vertex) else {
//            
//                invalid.append(tile.triangle.vertex)
//                
//                return
//            }
//            
//            invalid.append(contentsOf: Set(tile.vertices.keys).subtracting(terrainTile.vertices.keys))
//            
//            result.append(contentsOf: render(tile: tile,
//                                            terrainTile: terrainTile))
//        }
//        
//        grid.remove(values: invalid)
//        
//        guard !polygons.isEmpty else { return false }
//        
//        let mesh = Mesh(polygons)
//        
//        chunk.mesh = mesh.translated(by: -chunk.triangle.position(chunk.scale))
        
        return true
    }
    
//    private func render(tile: HexagonalDataStoreTile<FootpathVertex>,
//                        terrainTile: HexagonalDataStoreTile<TerrainVertex>) -> [Euclid.Polygon] {
//        
//        var polygons: [Euclid.Polygon] = []
//        
//        var visited: Set<Triangle.Vertex> = []
//        
//        for (_, value) in tile.vertices {
//            
//            guard !visited.contains(value.vertex),
//                  let elevation = terrainTile.vertices[value.vertex]?.elevation else { continue }
//            
//            var vertices = [value.vertex]
//            
//            for (vertex, other) in tile.vertices {
//                
//                guard vertex != value.vertex,
//                      let terrainVertex = terrainTile.vertices[vertex],
//                      value.design == other.design,
//                      elevation == terrainVertex.elevation else { continue }
//                
//                vertices.append(vertex)
//            }
//            
//            visited.formUnion(vertices)
//            
//            let apexElevation = Vector(0.0, Terrain.apex(for: elevation), 0.0)
//            
//            let wedge = Wedge(tile.triangle,
//                              vertices)
//            
//            let part = render(design: value.design,
//                              wedge: wedge)
//            
//            let offset = terrainTile.triangle.position(.tile)
//            let angle = Angle(radians: wedge.orientation)
//            let rotation = Rotation.yaw(angle)
//            
//            let transformed = part.rotated(by: rotation).translated(by: offset + apexElevation)
//            
//            polygons.append(contentsOf: transformed.polygons)
//        }
//        
//        return polygons
//    }
//    
//    private func render(design: Design,
//                        wedge: Wedge) -> Mesh {
//        
//        do {
//            
//            let asset = Asset.footpath(design,
//                                       wedge)
//            
//            return try AssetCache.shared.load(mesh: asset)
//            
//        }
//        catch {
//
//            fatalError("Error loading asset: \(error.localizedDescription)")
//        }
//    }
}
