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
        
        guard let world = context.scene.find(anchor: .world) as? AnchorEntity,
              let fences = world.find(entity: .fences) as? Fences,
              let terrain = world.find(entity: .terrain) as? Terrain else { return }
        
        fences.clean { chunk, sieve, wedge in
            
            let terrainWedge = terrain.wedge(for: sieve)
            
            guard !terrainWedge.isEmpty else { return false }
            
            return update(grid: fences,
                          chunk: chunk,
                          weave: wedge.weave(sieve),
                          terrainWeave: terrainWedge.weave(sieve))
        }
    }
}

extension FenceSystem {
    
    private func update(grid: Fences,
                        chunk: FenceChunk,
                        weave: DataStoreWeave<FenceVertex>,
                        terrainWeave: DataStoreWeave<TerrainVertex>) -> Bool {
        
        print("Cleaning Fence Chunk")
        
        var invalid: [Triangle.Vertex] = []
        
        let polygons = weave.data.reduce(into: [Euclid.Polygon]()) { result, vertex in
            
            guard let terrainTile = terrainWeave.value(for: vertex.value.triangle) else {
            
                invalid.append(contentsOf: vertex.value.triangle.vertices)
                
                return
            }
            
            result.append(contentsOf: render(tile: vertex.value,
                                            terrainTile: terrainTile))
        }
        
        grid.remove(values: invalid)
        
        guard !polygons.isEmpty else { return false }
        
        let mesh = Mesh(polygons)
        
        chunk.mesh = mesh.translated(by: -chunk.tile.position(chunk.scale))
        
        return true
    }
    
    private func render(tile: DataStoreStitch<FenceVertex>,
                        terrainTile: DataStoreStitch<TerrainVertex>) -> [Euclid.Polygon] {
        
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
            
            visited.formUnion(vertices)
            
            let apexElevation = Vector(0.0, Terrain.apex(for: elevation), 0.0)
            
            let wedge = Wedge(tile.triangle,
                              vertices)
            
            let segment: Segment = {
                
                switch wedge {
                    
                case .corner(let triangle,
                             let corner):
                    
                    guard doorway else { return .wall(wedge: wedge) }
                    
                    return .doorwayCorner(triangle: triangle,
                                          corner: corner)
                    
                case .edge(let triangle,
                           let edge):
                    
                    guard doorway,
                          let corner = edge.corners.first else { return .wall(wedge: wedge) }
                    
                    let vertex = triangle.vertex(corner)
                    let mirrored = tile.vertices[vertex]?.segment != .doorway
                    
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
