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
        
        foliage.clean { chunk, wedge in
            
            let terrainWedge = terrain.wedge(for: chunk.triangle.sieve(for: .chunk))
            
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
                        wedge: TriangularDataStoreWedge<FoliageTile>,
                        terrainWedge: HexagonalDataStoreWedge<TerrainVertex>) -> Bool {
        
        print("Cleaning Foliage Chunk")
        
        var invalid: [Triangle.Vertex] = []
        
        let polygons = wedge.tiles.reduce(into: [Euclid.Polygon]()) { result, triangle in
            
            guard let terrainTile = terrainWedge.tile(for: triangle.origin) else {
                
                invalid.append(triangle.origin)
                
                return
            }
            
            result.append(contentsOf: render(terrainTile: terrainTile,
                                             elevation: terrainTile.apex))
        }
        
        grid.remove(values: invalid)
        
        guard !polygons.isEmpty else { return false }
        
        let mesh = Mesh(polygons)
        
        chunk.mesh = mesh.translated(by: -chunk.triangle.position(chunk.scale))
        
        return true
    }
    
    private func render(terrainTile: HexagonalDataStoreTile<TerrainVertex>,
                        elevation: Int) -> [Euclid.Polygon] {
        
        do {
            
            let septominos = Triangle.Septomino.allCases
            
            let septomino = septominos[abs(terrainTile.triangle.vertex.position.identifier) % septominos.count]
            
            let mesh = try AssetCache.shared.load(mesh: .foliage(septomino))
            
            let apexElevation = Vector(0.0, Terrain.apex(for: elevation), 0.0)
            let origin = terrainTile.triangle.position(.tile)
            let angle = Angle(radians: terrainTile.triangle.orientation)
            let rotation = Rotation.yaw(angle)
            
            return mesh.polygons.rotated(by: rotation).translated(by: origin + apexElevation)
        }
        catch {
            
            fatalError("Error loading asset: \(error.localizedDescription)")
        }
    }
}
