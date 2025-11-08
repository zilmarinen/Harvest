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
internal struct WaterSystem: @preconcurrency System {
    
    internal static var dependencies: [SystemDependency] = [.after(TerrainSystem.self)]
    
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
            
            if terrain.hasThreeVertices,
               tile.elevation <= terrain.apex {
                
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
        
        chunk.mesh = mesh
        chunk.isDirty = false
    }
    
    private func render(tile: WaterTile,
                        water: Water) -> Mesh {
        
        let apex = Vector(0.0, (TerrainSystem.Constant.baseHeight * Double(tile.elevation)) - TerrainSystem.Constant.apexHeight, 0.0)
        
        var mesh = tile.triangle.mesh(.tile,
                                      tile.waterType.colorPalette.primary).translated(by: apex)
        
        for edge in tile.triangle.edges {
            
            let adjacent = tile.triangle.neighbour(edge)
            
            let elevation = water.get(tile: adjacent)?.elevation ?? 0
            
            let base = Vector(0.0, TerrainSystem.Constant.baseHeight * Double(elevation), 0.0)
            
            guard tile.elevation > elevation else { continue }
            
            let corners = edge.corners.map {
                
                tile.triangle.vertex($0).position(.tile)
            }
            
            let face =  corners.reversed().map { $0 + base } +
                        corners.map { $0 + apex }
            
            let path = face.path(tile.waterType.colorPalette.secondary)
            
            guard let polygon = Polygon(shape: path) else { continue }
            
            mesh = mesh.merge(Mesh([polygon]))
        }
        
        return mesh
    }
}
