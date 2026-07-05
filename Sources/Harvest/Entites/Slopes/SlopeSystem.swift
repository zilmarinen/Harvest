//
//  SlopeSystem.swift
//
//  Created by Zack Brown on 16/11/2025.
//

import AppKit
import Deltille
import Euclid
import Lattice
import Newel
import RealityKit
import Yield

@MainActor
internal struct SlopeSystem: System {
    
    internal init(scene: Scene) {}
    
    internal func update(context: SceneUpdateContext) {
        
        guard let world = context.scene.find(anchor: .world) as? AnchorEntity,
              let slopes = world.find(entity: .slopes) as? Slopes,
              let terrain = world.find(entity: .terrain) as? Terrain else { return }
        
        slopes.clean { chunk, sieve, wedge in
            
            let terrainWedge = terrain.wedge(for: sieve)
            
            guard !terrainWedge.isEmpty else { return false }
            
            return update(grid: slopes,
                          chunk: chunk,
                          wedge: wedge,
                          weave: terrainWedge.weave(sieve))
        }
    }
}

extension SlopeSystem {
    
    private func update(grid: Slopes,
                        chunk: SlopeChunk,
                        wedge: DataStoreWedge<SlopeTile>,
                        weave: DataStoreWeave<TerrainVertex>) -> Bool {
        
        print("Cleaning Slope Chunk")
        
        var invalid: [Triangle] = []
        
        //TODO: Find unique items
        let unique = Set(wedge.data.values)
        
        let mesh = unique.reduce(into: Mesh.empty) { result, tile in
            
            let triangle = Triangle(tile.vertex)
            
            guard let terrainTile = weave.value(for: triangle) else {
                
                invalid.append(triangle)
                
                return
            }
            
            let part = render(tile: tile)
            
            let elevation = Vector(0.0, Terrain.apex(for: terrainTile.base), 0.0)
            
            let offset = triangle.position(.tile)
            let angle = Angle(radians: tile.rotation.radians + triangle.orientation)
            let rotation = Rotation.yaw(angle)
            
            let transformed = part.rotated(by: rotation).translated(by: offset + elevation)
            
            result = result.merge(transformed)
        }
        
        grid.remove(values: invalid)
        
        guard !mesh.polygons.isEmpty else { return false }
        
        chunk.mesh = mesh.translated(by: -chunk.tile.position(chunk.scale))
        
        return true
    }
    
    private func render(tile: SlopeTile) -> Mesh {
        
        do {
            
            let asset = Asset.slope(tile.slope,
                                    tile.rise,
                                    tile.cast)
            
            return try AssetCache.shared.load(mesh: asset)
            
        }
        catch {

            fatalError("Error loading asset: \(error.localizedDescription)")
        }
    }
}
