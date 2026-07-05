//
//  PortalSystem.swift
//  Harvest
//
//  Created by Zack Brown on 14/02/2026.
//

import AppKit
import Deltille
import Euclid
import Lattice
import RealityKit

@MainActor
internal struct PortalSystem: System {
    
    internal init(scene: Scene) {}
    
    internal func update(context: SceneUpdateContext) {
        
        guard let world = context.scene.find(anchor: .world) as? AnchorEntity,
              let portals = world.find(entity: .portals) as? Portals,
              let terrain = world.find(entity: .terrain) as? Terrain else { return }
        
        portals.clean { chunk, sieve, wedge in
            
            let terrainWedge = terrain.wedge(for: sieve)
            
            return update(grid: portals,
                          chunk: chunk,
                          wedge: wedge,
                          weave: terrainWedge.weave(sieve))
        }
    }
}

extension PortalSystem {
    
    private func update(grid: Portals,
                        chunk: PortalChunk,
                        wedge: DataStoreWedge<PortalTile>,
                        weave: DataStoreWeave<TerrainVertex>) -> Bool {
        
        print("Cleaning Portal Chunk")
        
        var invalid: [Triangle] = []
        
        let polygons = wedge.data.reduce(into: [Euclid.Polygon]()) { result, tile in
            
            let triangle = Triangle(tile.value.vertex)
            
            guard let terrainTile = weave.value(for: triangle),
                  terrainTile.floor > 0 else {
                
                invalid.append(triangle)
                
                return
            }
            
            result.append(contentsOf: render(tile: terrainTile))
        }
        
        grid.remove(values: invalid)
        
        guard !polygons.isEmpty else { return false }
        
        let mesh = Mesh(polygons)
        
        chunk.mesh = mesh.translated(by: -chunk.tile.position(chunk.scale))
        
        return true
    }
    
    private func render(tile: DataStoreStitch<TerrainVertex>) -> [Euclid.Polygon] {
        
        let apex = Vector(0.0,
                          Terrain.apex(for: tile.base) + 0.01,
                          0.0)
        
        let baseVertices = tile.triangle.vertices.map {
            
            $0.position(.tile) + apex
        }
        let peakVertices = baseVertices.map {
            
            $0 + Vector(0.0, 0.5, 0.0)
        }
        
        guard let peak = Polygon.surface(peakVertices,
                                         .red) else { return [] }
        
        var polygons = [peak]
        
        for i in baseVertices.indices {
            
            let j = (i + 1) % baseVertices.count
            
            let v0 = baseVertices[i]
            let v1 = baseVertices[j]
            let v2 = peakVertices[j]
            let v3 = peakVertices[i]
            
            guard let surface = Polygon.surface([v0, v1, v2, v3],
                                                .red) else { continue }
            
            polygons.append(surface)
        }
        
        return polygons
    }
}
