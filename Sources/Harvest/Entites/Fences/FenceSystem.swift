//
//  FenceSystem.swift
//  Harvest
//
//  Created by Zack Brown on 03/05/2026.
//

import AppKit
import Bivouac
import Deltille
import Euclid
import Lattice
import Palisade
import RealityKit
import Yield

@MainActor
internal struct FenceSystem: System {
    
    internal init(scene: Scene) {}
    
    internal func update(context: SceneUpdateContext) {
        
        guard let fences = context.scene.find(entity: .fences) as? Fences,
              let terrain = context.scene.find(entity: .terrain) as? Terrain else { return }
        
        fences.clean { chunk, wedge in
            
            let terrainWedge = terrain.wedge(for: chunk.triangle.sieve(for: .chunk))
            
            guard !terrainWedge.isEmpty else { return false }
            
            return update(grid: fences,
                          chunk: chunk,
                          wedge: wedge,
                          terrainWedge: terrainWedge)
        }
    }
}

extension FenceSystem {
    
    private func update(grid: Fences,
                        chunk: FenceChunk,
                        wedge: HexagonalDataStoreWedge<FenceVertex>,
                        terrainWedge: HexagonalDataStoreWedge<TerrainVertex>) -> Bool {
        
        var invalid: [Triangle.Vertex] = []
        
        let polygons = wedge.tiles.reduce(into: [Euclid.Polygon]()) { result, tile in
            
            guard let terrainTile = terrainWedge.tile(for: tile.triangle.vertex) else {
            
                invalid.append(tile.triangle.vertex)
                
                return
            }
            
            invalid.append(contentsOf: Set(tile.vertices.keys).subtracting(terrainTile.vertices.keys))
            
            result.append(contentsOf: render(tile: tile,
                                            terrainTile: terrainTile))
        }
        
        grid.remove(values: invalid)
        
        guard !polygons.isEmpty else { return false }
        
        let mesh = Mesh(polygons)
        
        chunk.mesh = mesh.translated(by: -chunk.triangle.position(chunk.scale))
        
        return true
    }
    
    private func render(tile: HexagonalDataStoreTile<FenceVertex>,
                        terrainTile: HexagonalDataStoreTile<TerrainVertex>) -> [Euclid.Polygon] {
        
        var polygons: [Euclid.Polygon] = []
        
        var visited: Set<Triangle.Vertex> = []
        
        for (_, value) in tile.vertices {
            
            guard !visited.contains(value.vertex),
                  let elevation = terrainTile.vertices[value.vertex]?.elevation else { continue }
            
            var vertices = [value.vertex]
            
            var doorway = value.segment == .doorway
            
            for (vertex, other) in tile.vertices {
                
                guard vertex != value.vertex,
                      let terrainVertex = terrainTile.vertices[vertex],
                      value.rampart == other.rampart,
                      elevation == terrainVertex.elevation else { continue }
                
                vertices.append(vertex)
                
                doorway = doorway || other.segment == .doorway
            }
            
            visited.union(vertices)
            
            let apexElevation = Vector(0.0, Terrain.apex(for: elevation), 0.0)
            
            let wedge = Wedge(tile.triangle,
                              vertices)
            
            let segment: Segment = {
                
                switch wedge {
                    
                case .corner(let triangle,
                             let corner):
                    
                    guard doorway else {
                        
                        return .wall(wedge: wedge)
                    }
                    
                    return .doorwayCorner(triangle: triangle,
                                          corner: corner)
                    
                case .edge(let triangle,
                           let edge):
                    
                    guard doorway,
                          let corner = edge.corners.first else {
                        
                        return .wall(wedge: wedge)
                    }
                    
                    let mirrored = triangle.vertex(corner) != value.vertex
                    
                    return .doorwayEdge(triangle: triangle,
                                        edge: edge,
                                        mirrored: mirrored)
                    
                case .tile:
                    
                    return .wall(wedge: wedge)
                }
            }()
            
            let part = render(rampart: value.rampart,
                              segment: segment)
            
            let offset = terrainTile.triangle.position(.tile)
            let angle = Angle(radians: wedge.orientation)
            let rotation = Rotation.yaw(angle)
            
            let transformed = part.rotated(by: rotation).translated(by: offset + apexElevation)
            
            polygons.append(contentsOf: transformed.polygons)
        }
        
        return polygons
    }
    
    private func render(rampart: Rampart,
                        segment: Segment) -> Mesh {
        
        do {
            
            let asset = Asset.fence(rampart,
                                    segment)
            
            return try AssetCache.shared.load(mesh: asset)
            
        }
        catch {

            fatalError("Error loading asset: \(error.localizedDescription)")
        }
    }
}
