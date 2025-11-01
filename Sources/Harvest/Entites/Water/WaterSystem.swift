//
//  WaterSystem.swift
//
//  Created by Zack Brown on 26/10/2025.
//

import AppKit
import Deltille
import Euclid
import RealityKit

@MainActor
internal struct WaterSystem: System {
    
    private static let query = EntityQuery(where: .has(WaterComponent.self))
    
    internal init(scene: Scene) {}
    
    internal func update(context: SceneUpdateContext) {
        
        guard let biosphere = context.scene.find(entity: .biosphere) as? Biosphere,
              let water = context.scene.find(entity: .water) as? Water else { return }
        
        for entity in context.entities(matching: Self.query,
                                       updatingSystemWhen: .rendering) {
            
            guard let chunk = entity as? WaterChunk,
                  chunk.isDirty else { continue }
            
            update(chunk: chunk,
                   biosphere: biosphere,
                   water: water)
            
            if chunk.isEmpty {
                
                chunk.removeFromParent()
            }
        }
    }
}

extension WaterSystem {
    
    private func update(chunk: WaterChunk,
                        biosphere: Biosphere,
                        water: Water) {
        
        let stencil = chunk.triangle.stencil(chunk.scale)
        
        var mesh = Mesh.empty
        
        var invalidTiles: [Triangle] = []
        
        for (triangle, tile) in chunk.waterComponent.tiles {
            
            let terrain = biosphere.tile(for: triangle)
            
            guard tile.elevation >= terrain.apex else {
                
                invalidTiles.append(triangle)
                
                continue
            }
            
            let part = render(tile: tile,
                              water: water)
            
            mesh = mesh.merge(part)
        }
        
        if !invalidTiles.isEmpty {
            
            chunk.remove(tiles: invalidTiles)
        }
        
        guard !mesh.polygons.isEmpty else { return }
        
        mesh = mesh.translated(by: -chunk.triangle.position(.chunk))
        
        let apex = Vector(0.0, mesh.bounds.max.y, 0.0)
        
        let perimeter: [SIMD3<Float>] = stencil.perimeter.map { .init($0) } +
                                        stencil.perimeter.map { .init($0 + apex) }
        
        let resource = MeshResource(mesh: mesh)
        let shape = ShapeResource.generateConvex(from: perimeter)
        
        let model = ModelComponent(mesh: resource,
                                   materials: [SimpleMaterial(color: .systemBlue,
                                                              isMetallic: false)])
        
        chunk.model = model
        chunk.collision = .init(shapes: [shape],
                                isStatic: true)
        
        chunk.isDirty = false
    }
    
    private func render(tile: WaterTile,
                        water: Water) -> Mesh {
        
        let apex = Vector(0.0, TerrainAssetCacheComponent.baseHeight * Double(tile.elevation), 0.0)
        
        var mesh = tile.triangle.mesh(.tile).translated(by: apex)
        
        for edge in tile.triangle.edges {
            
            let adjacent = tile.triangle.neighbour(edge)
            
            let elevation = water.get(tile: adjacent)?.elevation ?? 0
            
            let base = Vector(0.0, TerrainAssetCacheComponent.baseHeight * Double(elevation), 0.0)
            
            guard tile.elevation > elevation else { continue }
            
            let corners = edge.corners.map {
                
                tile.triangle.vertex($0).position(.tile)
            }
            
            let face =  corners.reversed().map { $0 + base } +
                        corners.map { $0 + apex }
            
            let path = face.path(.red)
            
            guard let polygon = Polygon(shape: path) else { continue }
            
            mesh = mesh.merge(Mesh([polygon]))
        }
        
        return mesh
    }
}
