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
    
    private static let query = EntityQuery(where: .has(TerrainComponent.self))
    
    init(scene: Scene) {}
    
    internal func update(context: SceneUpdateContext) {
        
        for entity in context.entities(matching: Self.query,
                                       updatingSystemWhen: .rendering) {
            
            guard let terrain = entity as? Terrain else { continue }
            
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
                           slice: slice)
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
                        slice: HeightMapSlice) {
        
        var tiles: [Triangle.Vertex : TerrainTile] = [:]
        
        //loop through each vertex that needs to be rendered
        for (vertex, _) in slice.vertices {
            
            //loop through each of the connected tiles
            for tile in vertex.tiles {
                
                let triangle = tile.transpose(.tile,
                                              .chunk)
                
                //check the tile is within the current chunk and
                //that we have not already mapped this tile
                guard triangle == chunk.triangle,
                      tiles[tile.vertex] == nil else { continue }
                
                //gather each vertex in the height map for this tile
                let vertices = tile.vertices.compactMap {
                    
                    slice.vertices[$0]
                }
                
                tiles[tile.vertex] = .init(triangle: tile,
                                           vertices: vertices)
            }
        }
        
        render(chunk: chunk,
               tiles: tiles)
        
        chunk.isDirty = false
    }
    
    private func render(chunk: TerrainChunk,
                        tiles: [Triangle.Vertex : TerrainTile]) {
        
        do {
            var mesh = Mesh.empty
            
            for (_, tile) in tiles {
                
                mesh = mesh.union(render(tile: tile))
            }
            
            mesh = mesh.translated(by: -chunk.triangle.position(.chunk))
            
            let descriptor = MeshDescriptor(triangles: mesh.translated(by: Vector(0.0, 0.05, 0.0)))
            
            let resource = try MeshResource.generate(from: [descriptor])
            
            chunk.model = .init(mesh: resource,
                                materials: [SimpleMaterial(color: .gray,
                                                           isMetallic: false)])
        }
        catch {
            
            fatalError("Error genering mesh for chunk \(chunk.triangle.id): \(error.localizedDescription)")
        }
    }
    
    private func render(tile: TerrainTile) -> Mesh {
        
        let stencil = Triangle.zero.stencil(.tile)
        let offset = tile.triangle.position(.tile)
        let step = Triangle.Rotation.step
        let pattern = tile.triangle.pattern
        
        print("Tile \(tile.triangle.id) has pattern: \(pattern)")
        
        guard !tile.isUniform else {
            
            let kite = Triangle.Kite.uniform
            
            let template =  kite.mesh(stencil,
                                      Double(tile.anyHeight),
                                      .green)
            
            let angle = Angle(radians: tile.triangle.rotation)
            
            return template.transformed(by: .init(offset: offset,
                                                  rotation: .yaw(angle)))
        }
        
        var mesh = Mesh.empty
        
        for heightMap in tile.vertices {
            
            guard let corner = tile.triangle.corner(heightMap.vertex) else { continue }
            
            let kite = tile.triangle.pattern.kites[corner.rawValue]
            
            let template = kite.mesh(stencil,
                                     Double(heightMap.height),
                                     .blue)
            
            let angle = Angle(radians: (step * Double(-corner.rawValue) + tile.triangle.rotation))
            
            mesh = mesh.union(template.rotated(by: .yaw(angle)))
        }
        
        return mesh.translated(by: offset)
    }
}
