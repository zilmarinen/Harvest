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
        
        guard let portals = context.scene.find(entity: .portals) as? Portals,
              let terrain = context.scene.find(entity: .terrain) as? Terrain else { return }
        
        portals.clean { slice, chunk in
            
            let terrainSlice = terrain.slice(for: chunk.triangle.sieve(for: .chunk))
            
            return update(grid: portals,
                          chunk: chunk,
                          slice: slice,
                          terrainSlice: terrainSlice)
        }
    }
}

extension PortalSystem {
    
    private func update(grid: Portals,
                        chunk: PortalChunk,
                        slice: TriangularGridDataSourceSlice<PortalTile>,
                        terrainSlice: HexagonalGridDataSourceSlice<TerrainVertex>) -> Bool {
        
        var invalidTiles: [Triangle] = []
        
        let polygons = slice.tiles.reduce(into: [Euclid.Polygon]()) { result, tile in
            
            guard let terrainTile = terrainSlice.tile(for: tile.triangle),
                  let elevation = terrainTile.uniformElevation else {
                
                invalidTiles.append(tile.triangle)
                
                return
            }
            
            result.append(contentsOf: render(tile: terrainTile,
                                             elevation: elevation))
        }
        
        grid.remove(values: invalidTiles)
        
        guard !polygons.isEmpty else { return false }
        
        let mesh = Mesh(polygons)
        
        chunk.mesh = mesh.translated(by: -chunk.triangle.position(chunk.scale))
        
        return true
    }
    
    private func render(tile: HexagonalGridDataSourceTile<TerrainVertex>,
                        elevation: Int) -> [Euclid.Polygon] {
        
        let apex = Vector(0.0,
                          TerrainSystem.unitHeight(for: elevation) + 0.01,
                          0.0)
        
        let vertices = tile.vertices.map { $0.key.position(.tile) + apex }
        
        let volume = Volume(vertices: vertices,
                            displacement: Triangle.Scale.tile.edgeLength / 2.0)
        
        return volume.mesh(.red).polygons
    }
}
