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
            
            let terrainWedge = terrain.wedge(for: sieve)
            
            guard !terrainWedge.isEmpty else { return false }
            
            return update(grid: footpaths,
                          chunk: chunk,
                          weave: wedge.weave(sieve),
                          terrainWeave: terrainWedge.weave(sieve))
        }
    }
}

extension FootpathSystem {
    
    private func update(grid: Footpaths,
                        chunk: FootpathChunk,
                        weave: DataStoreWeave<FootpathVertex>,
                        terrainWeave: DataStoreWeave<TerrainVertex>) -> Bool {
        
        print("Cleaning Footpath Chunk")
        
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
        
        chunk.mesh = mesh.translated(by: -chunk.triangle.position(chunk.scale))
        
        return true
    }
    
    private func render(tile: DataStoreStitch<FootpathVertex>,
                        terrainTile: DataStoreStitch<TerrainVertex>) -> [Euclid.Polygon] {
        
        var polygons: [Euclid.Polygon] = []
        
        var visited: Set<Triangle.Vertex> = []
        
        for (_, value) in tile.vertices {
            
            guard !visited.contains(value.vertex),
                  let elevation = terrainTile.vertices[value.vertex]?.elevation else { continue }
            
            var vertices = [value.vertex]
            
            for (vertex, other) in tile.vertices {
                
                guard vertex != value.vertex,
                      let terrainVertex = terrainTile.vertices[vertex],
                      value.design == other.design,
                      elevation == terrainVertex.elevation else { continue }
                
                vertices.append(vertex)
            }
            
            visited.formUnion(vertices)
            
            let apexElevation = Vector(0.0, Terrain.apex(for: elevation), 0.0)
            
            let wedge = Wedge(tile.triangle,
                              vertices)
            
            let part = render(design: value.design,
                              wedge: wedge)
            
            let offset = terrainTile.triangle.position(.tile)
            let angle = Angle(radians: wedge.orientation)
            let rotation = Rotation.yaw(angle)
            
            let transformed = part.rotated(by: rotation).translated(by: offset + apexElevation)
            
            polygons.append(contentsOf: transformed.polygons)
        }
        
        return polygons
    }
    
    private func render(design: Design,
                        wedge: Wedge) -> Mesh {
        
        do {
            
            let asset = Asset.footpath(design,
                                       wedge)
            
            return try AssetCache.shared.load(mesh: asset)
            
        }
        catch {

            fatalError("Error loading asset: \(error.localizedDescription)")
        }
    }
}
