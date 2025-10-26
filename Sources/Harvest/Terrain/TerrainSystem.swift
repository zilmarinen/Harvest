//
//  TerrainSystem.swift
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
    
    private static let query = EntityQuery(where: .has(TerrainAssetCacheComponent.self))
    
    internal init(scene: Scene) {}
    
    internal func update(context: SceneUpdateContext) {
        
        guard let biosphere = context.scene.find(entity: .biosphere) as? Biosphere else { return }
        
        for entity in context.entities(matching: Self.query,
                                       updatingSystemWhen: .rendering) {
            
            guard let terrain = entity as? Terrain,
                  let cache = terrain.components[TerrainAssetCacheComponent.self] else { continue }
            
            var emptyRegions: [TerrainRegion] = []
            
            for region in terrain.dirtyRegions {
                
                var emptyChunks: [TerrainChunk] = []
                
                for chunk in region.dirtyChunks {
                    
                    let slice = biosphere.slice(for: chunk.triangle)
                    
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
                        slice: BiomeSlice,
                        cache: TerrainAssetCacheComponent) {
        
        let tiles = slice.sieve.tiles.reduce(into: [Triangle.Vertex : BiomeTile]()) { result, tile in
            
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
                        tiles: [Triangle.Vertex : BiomeTile],
                        cache: TerrainAssetCacheComponent) throws {
        
        let stencil = Triangle.zero.stencil(.tile)
        
        var mesh = Mesh.empty
        
        for (_, tile) in tiles {
            
            mesh = mesh.merge(render(tile: tile,
                                     stencil: stencil,
                                     cache: cache))
        }
        
        mesh = mesh.translated(by: -chunk.triangle.position(.chunk))
        
        let apex = Vector(0.0, mesh.bounds.max.y, 0.0)
        
        let perimeter: [SIMD3<Float>] = stencil.perimeter.map { .init($0) } +
                                        stencil.perimeter.map { .init($0 + apex) }
        
        let resource = MeshResource(mesh: mesh)
        let shape = ShapeResource.generateConvex(from: perimeter)
        
        let model = ModelComponent(mesh: resource,
                                   materials: [cache.material])
        
        chunk.model = model
        chunk.collision = .init(shapes: [shape],
                                isStatic: true)
    }
    
    private func render(tile: BiomeTile,
                        stencil: Triangle.Stencil,
                        cache: TerrainAssetCacheComponent) -> Mesh {
        
        let origin = tile.triangle.position(.tile)
        let step = Triangle.Rotation.step
        let baseHeight = TerrainAssetCacheComponent.baseHeight
        let tileRotation = Angle(radians: tile.triangle.rotation)
        
        if tile.isUniform,
           let biome = tile.biome,
           let elevation = tile.elevation {
            
            let apex = cache.apex(for: .uniform,
                                  biome: biome)
            
            let offset = Vector(0.0, baseHeight * Double(elevation), 0.0)
            
            return apex.rotated(by: .yaw(tileRotation)).translated(by: origin + offset)
        }
        
        var mesh = Mesh.empty
        
        for vertex in tile.vertices {
            
            guard let corner = tile.triangle.corner(vertex.vertex) else { continue }
            
            let kite = tile.triangle.kite(index: corner.rawValue)
            
            let apex = cache.apex(for: kite,
                                  biome: vertex.biome)
            let base = cache.base(for: kite,
                                  biome: vertex.biome)
            
            let offset = Vector(0.0, baseHeight * Double(vertex.elevation), 0.0)
            let angle = tileRotation + .init(radians: (step * Double(-corner.rawValue)))
            
            for i in 0..<vertex.elevation {
                
                let translation = Vector(0.0, baseHeight * Double(i), 0.0)
                
                mesh = mesh.union(base.rotated(by: .yaw(angle)).translated(by: translation))
            }
            
            mesh = mesh.union(apex.rotated(by: .yaw(angle)).translated(by: offset))
        }
        
        return mesh.translated(by: origin)
    }
}
