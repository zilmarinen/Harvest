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
        
        guard let terrain = context.scene.find(entity: .terrain) as? Terrain,
              let foliage = context.scene.find(entity: .foliage) as? Foliage else { return }
        
        foliage.clean { slice, chunk in
            
            let terrainSlice = terrain.slice(for: chunk.triangle.sieve(for: .chunk))
            
            guard !terrainSlice.isEmpty else { return false }
            
            return update(grid: foliage,
                          chunk: chunk,
                          slice: slice,
                          terrainSlice: terrainSlice)
        }
    }
}

extension FoliageSystem {
    
    private func update(grid: Foliage,
                        chunk: FoliageChunk,
                        slice: TriangularDataStoreSlice<FoliageTile>,
                        terrainSlice: HexagonalDataStoreSlice<TerrainVertex>) -> Bool {
        
        var invalid: [Triangle.Vertex] = []
        
        let polygons = slice.tiles.reduce(into: [Euclid.Polygon]()) { result, triangle in
            
            guard let terrainTile = terrainSlice.tile(for: triangle.origin.vertex),
                  let elevation = terrainTile.uniformElevation else {
                
                invalid.append(triangle.origin.vertex)
                
                return
            }
            
            result.append(contentsOf: render(terrainTile: terrainTile,
                                             elevation: elevation))
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
            
            let septomino = self.septomino(for: terrainTile.tile)
            
            let mesh = try AssetCache.shared.load(mesh: .foliage(.antlia))
            
            let apexElevation = Vector(0.0, (Double(elevation) * TerrainSystem.Constant.baseHeight) + TerrainSystem.Constant.apexHeight, 0.0)
            let origin = terrainTile.tile.position(.tile)
            let angle = Angle(radians: terrainTile.tile.rotation)
            let rotation = Rotation.yaw(angle)
            
            return mesh.polygons.rotated(by: rotation).translated(by: origin + apexElevation)
        }
        catch {
            
            fatalError("Error loading asset: \(error.localizedDescription)")
        }
    }
    
    private func septomino(for triangle: Triangle) -> Triangle.Septomino {
        
        let septominos = Triangle.Septomino.allCases
        
        return septominos[abs(triangle.vertex.position.identifier) % septominos.count]
    }
}
