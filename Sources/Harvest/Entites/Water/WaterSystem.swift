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
    
    internal init(scene: Scene) {}
    
    internal func update(context: SceneUpdateContext) {
        
        guard let terrain = context.scene.find(entity: .terrain) as? Terrain,
              let water = context.scene.find(entity: .water) as? Water else { return }
        
//        var emptyRegions: [TriangularRegion<WaterChunk>] = []
//        
//        for region in water.dirtyRegions {
//            
//            for chunk in region.dirtyChunks {
//            
//                update(chunk: chunk,
//                       terrain: terrain,
//                       water: water)
//            
//                if chunk.isEmpty {
//                    
//                    chunk.removeFromParent()
//                }
//            }
//            
//            if region.isEmpty {
//                
//                emptyRegions.append(region)
//            }
//        }
//        
//        emptyRegions.forEach {
//            
//            $0.removeFromParent()
//        }
    }
}

extension WaterSystem {
    
    private func update(chunk: WaterChunk,
                        terrain: Terrain,
                        water: Water) {
        
        var invalidTiles: [Triangle] = []
        
        let polygons = chunk.data.reduce(into: [Euclid.Polygon]()) { result, item in
            
            let (triangle, tile) = item
            let biome = terrain.tile(for: triangle)
            
            guard !biome.hasThreeVertices ||
                  biome.base > tile.elevation else {
                
                invalidTiles.append(triangle)
                
                return
            }
            
            result.append(contentsOf: render(tile: tile,
                                             water: water))
        }
        
        invalidTiles.forEach {
            
            chunk.set(nil,
                      for: $0)
        }
        
        guard !polygons.isEmpty else { return }
        
        let mesh = Mesh(polygons)
        
        chunk.mesh = mesh.translated(by: -chunk.triangle.position(chunk.scale))
        chunk.isDirty = false
    }
    
    private func render(tile: WaterTile,
                        water: Water) -> [Euclid.Polygon] {
        
        let apexElevation = Vector(0.0, (Double(tile.elevation) * TerrainSystem.Constant.baseHeight) - TerrainSystem.Constant.apexHeight, 0.0)
        let vertices = tile.triangle.vertices.map { $0.position(.tile) + apexElevation }
        let apexPath = vertices.path(tile.waterType.colorPalette.primary)
        
        guard let apex = Polygon(shape: apexPath) else { return [] }
        
        var polygons = [apex]
        
        for edge in tile.triangle.edges {
         
            let adjacent = tile.triangle.neighbour(edge)

            let elevation = water.value(for: adjacent)?.elevation ?? 0

            guard tile.elevation > elevation else { continue }
            
            let mantleElevation = Vector(0.0, (Double(elevation) * TerrainSystem.Constant.baseHeight) - TerrainSystem.Constant.apexHeight, 0.0)
            
            let corners = edge.corners.map {

                tile.triangle.vertex($0).position(.tile)
            }
            
            let face =  corners.reversed().map { $0 + mantleElevation } +
                        corners.map { $0 + apexElevation }

            let path = face.path(tile.waterType.colorPalette.secondary)

            guard let polygon = Polygon(shape: path) else { continue }

            polygons.append(polygon)
        }
        
        return polygons
    }
}
