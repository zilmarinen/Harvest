//
//  TerrainSystem.swift
//  Harvest
//
//  Created by Zack Brown on 27/08/2025.
//

import AppKit
import Deltille
import Euclid
import RealityKit
import Regolith

@MainActor
internal struct TerrainSystem: System {
    
    private static let query = EntityQuery(where: .has(TerrainCacheComponent.self))
    
    init(scene: Scene) {}
    
    internal func update(context: SceneUpdateContext) {
        
        for entity in context.entities(matching: Self.query,
                                       updatingSystemWhen: .rendering) {
            
            guard let terrain = entity as? Terrain,
                  let cache = terrain.components[TerrainCacheComponent.self] else { continue }
            
            var emptyRegions: [TerrainRegion] = []
            
            for region in terrain.dirtyRegions {
                
                var emptyChunks: [TerrainChunk] = []
                
                for chunk in region.dirtyChunks {
                    
                    let slice = terrain.heightMap.slice(for: chunk.triangle)
                    
                    guard !slice.vertices.isEmpty else {
                        
                        emptyChunks.append(chunk)
                        
                        continue
                    }
                    
                    update(chunk: chunk,
                           slice: slice,
                           cache: cache)
                }
                
                emptyChunks.forEach {
                    
                    region.removeChild($0)
                }
                
                if region.isEmpty {
                    
                    emptyRegions.append(region)
                }
            }
            
            emptyRegions.forEach {
                
                terrain.removeChild($0)
            }
        }
    }
}

extension TerrainSystem {
    
    private func update(chunk: TerrainChunk,
                        slice: HeightMapSlice,
                        cache: TerrainCacheComponent) {
        
        let tiles = slice.sieve.tiles.reduce(into: [Triangle.Vertex : TerrainTile]()) { result, tile in
            
            let vertices = tile.vertices.compactMap {
                
                slice.vertices[$0]
            }
            
            guard !vertices.isEmpty else { return }
            
            result[tile.vertex] = .init(triangle: tile,
                                        vertices: vertices)
        }
        
        do {
            
            try render(chunk: chunk,
                       tiles: tiles,
                       cache: cache)
            
            chunk.isDirty = false
        }
        catch {
            
            fatalError("Error genering mesh for chunk \(chunk.triangle.id): \(error.localizedDescription)")
        }
    }
    
    private func render(chunk: TerrainChunk,
                        tiles: [Triangle.Vertex : TerrainTile],
                        cache: TerrainCacheComponent) throws {
        
        let stencil = Triangle.zero.stencil(.tile)
        
        var mesh = Mesh.empty
        
        for (_, tile) in tiles {
            
            mesh = mesh.merge(render(tile: tile,
                                     stencil: stencil,
                                     cache: cache))
        }
        
        mesh = mesh.translated(by: -chunk.triangle.position(.chunk))
        
        let model = ModelComponent(mesh: .init(mesh: mesh),
                                   materials: [cache.material])
        
        chunk.model = model
    }
    
    private func render(tile: TerrainTile,
                        stencil: Triangle.Stencil,
                        cache: TerrainCacheComponent) -> Mesh {
        
        let origin = tile.triangle.position(.tile)
        let step = Triangle.Rotation.step
        let baseHeight = TerrainCacheComponent.baseHeight
        let tileRotation = Angle(radians: tile.triangle.rotation)
        
        guard !tile.isUniform else {
            
            let apex = cache.apex(for: .uniform,
                                  terrainType: tile.uniformMaterial)
            
            let offset = Vector(0.0, baseHeight * Double(tile.uniformHeight), 0.0)
            
            return apex.rotated(by: .yaw(tileRotation)).translated(by: origin + offset)
        }
        
        var mesh = Mesh.empty
        
        for heightMap in tile.vertices {
            
            guard let corner = tile.triangle.corner(heightMap.vertex) else { continue }
            
            let kite = tile.triangle.kite(index: corner.rawValue)
            
            let apex = cache.apex(for: kite,
                                  terrainType: heightMap.material)
            let base = cache.base(for: kite,
                                  terrainType: heightMap.material)
            
            let offset = Vector(0.0, baseHeight * Double(heightMap.height), 0.0)
            let angle = tileRotation + .init(radians: (step * Double(-corner.rawValue)))
            
            for i in 0..<heightMap.height {
                
                let translation = Vector(0.0, baseHeight * Double(i), 0.0)
                
                mesh = mesh.union(base.rotated(by: .yaw(angle)).translated(by: translation))
            }
            
            mesh = mesh.union(apex.rotated(by: .yaw(angle)).translated(by: offset))
        }
        
        return mesh.translated(by: origin)
    }
}
