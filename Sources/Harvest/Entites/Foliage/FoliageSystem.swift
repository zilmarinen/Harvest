//
//  FoliageSystem.swift
//
//  Created by Zack Brown on 25/10/2025.
//

import AppKit
import Deltille
import Euclid
import Lattice
import RealityKit
import Verdure
import Yield

@MainActor
internal struct FoliageSystem: System {
    
    internal init(scene: Scene) {}
    
    internal func update(context: SceneUpdateContext) {
        
        guard let world = context.scene.find(anchor: .world) as? AnchorEntity,
              let foliage = world.find(entity: .foliage) as? Foliage,
              let terrain = world.find(entity: .terrain) as? Terrain else { return }
        
        foliage.clean { chunk, sieve, wedge in
            
            let terrainWedge = terrain.wedge(for: chunk.tile.sieve(for: .chunk))
            
            guard !terrainWedge.isEmpty else { return false }
            
            return update(grid: foliage,
                          chunk: chunk,
                          wedge: wedge,
                          terrainWedge: terrainWedge)
        }
    }
}

extension FoliageSystem {
    
    private func update(grid: Foliage,
                        chunk: FoliageChunk,
                        wedge: DataStoreWedge<FoliageVertex>,
                        terrainWedge: DataStoreWedge<TerrainVertex>) -> Bool {
        
        print("Cleaning Foliage Chunk")
        
        var invalid: [Triangle.Vertex] = []
        
        let polygons = wedge.data.reduce(into: [Euclid.Polygon]()) { result, tile in
            
            guard let terrainVertex = terrainWedge.value(for: tile.value.vertex) else {
                
                invalid.append(tile.value.vertex)
                
                return
            }
            
            result.append(contentsOf: render(terrainVertex: terrainVertex))
        }
        
        grid.remove(values: invalid)
        
        guard !polygons.isEmpty else { return false }
        
        let mesh = Mesh(polygons)
        
        chunk.mesh = mesh.translated(by: -chunk.tile.position(chunk.scale))
        
        return true
    }
    
    private func render(terrainVertex: TerrainVertex) -> [Euclid.Polygon] {
        
        do {
            
            let septominos = Triangle.Septomino.allCases
            
            let septomino = septominos[abs(terrainVertex.vertex.position.identifier) % septominos.count]
            
            let mesh = try AssetCache.shared.load(mesh: .foliage(septomino))
            
            let apexElevation = Vector(0.0, Terrain.apex(for: terrainVertex.elevation), 0.0)
            let origin = terrainVertex.vertex.position(.tile)
//            let angle = Angle(radians: terrainTile.triangle.orientation)
//            let rotation = Rotation.yaw(angle)
            
            //return mesh.polygons.rotated(by: rotation).translated(by: origin + apexElevation)
            return mesh.polygons.translated(by: origin + apexElevation)
        }
        catch {
            
            fatalError("Error loading asset: \(error.localizedDescription)")
        }
    }
}
