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
    
    internal enum Constant {
        
        static let apexHeight = 0.1
        static let baseHeight = 0.5
    }
    
    internal init(scene: Scene) {}
    
    internal func update(context: SceneUpdateContext) {
        
        guard let biosphere = context.scene.find(entity: .biosphere) as? Biosphere,
              let stairs = context.scene.find(entity: .stairs) as? Stairs,
              let terrain = context.scene.find(entity: .terrain) as? Terrain else { return }
        
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
                       stairs: stairs)
            }
            
            emptyChunks.forEach {
                
                $0.removeFromParent()
            }
            
            if region.isEmpty {
                
                emptyRegions.append(region)
            }
        }
        
        emptyRegions.forEach {
            
            $0.removeFromParent()
        }
    }
}

extension TerrainSystem {
    
    private func update(chunk: TerrainChunk,
                        slice: BiomeSlice,
                        stairs: Stairs) {
        
        let stairChunk = stairs.chunk(for: chunk.triangle,
                                         .chunk)
        
        let polygons = slice.tiles.reduce(into: [Euclid.Polygon]()) { result, item in
            
            let (_, tile) = item
            
            guard stairChunk?.value(for: tile.triangle) == nil else { return }
            
            result.append(contentsOf: render(tile: tile))
        }
        
        guard !polygons.isEmpty else { return }
        
        let mesh = Mesh(polygons)
        
        chunk.mesh = mesh.translated(by: -chunk.triangle.position(chunk.scale))
        chunk.isDirty = false
    }
    
    private func render(tile: BiomeTile) -> [Euclid.Polygon] {
        
        let stencil = tile.triangle.stencil(.tile)
        
        guard let biome = tile.uniformBiome,
              let elevation = tile.uniformElevation else {
            
            return render(tile: tile,
                          stencil: stencil)
        }
        
        return render(tile: tile,
                      stencil: stencil,
                      kite: .uniform,
                      biome: biome,
                      elevation: elevation)
    }
    
    private func render(tile: BiomeTile,
                        stencil: Triangle.Stencil) -> [Euclid.Polygon] {
        
        let origin = tile.triangle.position(.tile)
        
        return tile.vertices.reduce(into: [Euclid.Polygon]()) { result, vertex in
            
            guard let corner = tile.triangle.corner(vertex.vertex) else { return }
            
            let kite = tile.triangle.kite(index: corner.rawValue)
            
            let angle = Angle(radians: Triangle.Rotation.step * Double(-corner.rawValue))
            let rotation = Rotation.yaw(angle)
            
            let polygons = render(tile: tile,
                                  stencil: stencil,
                                  kite: kite,
                                  biome: vertex.biome,
                                  elevation: vertex.elevation)
            
            result.append(contentsOf: polygons.translated(by: -origin).rotated(by: rotation).translated(by: origin))
        }
    }
    
    private func render(tile: BiomeTile,
                        stencil: Triangle.Stencil,
                        kite: Triangle.Kite,
                        biome: Biome,
                        elevation: Int) -> [Euclid.Polygon] {
        
        let apexElevation = Vector(0.0, (Double(elevation) * Constant.baseHeight) + Constant.apexHeight, 0.0)
        let vertices = kite.vertices.map { stencil.vertex($0) + apexElevation }
        let apexPath = vertices.path(biome.colorPalette.primary)
        let tileBase = tile.base
        
        guard let apex = Polygon(shape: apexPath) else { return [] }
        
        var polygons = [apex]
        
        guard kite != .uniform,
              elevation > tileBase else { return polygons }
        
        let crownElevation = Vector(0.0, Double(elevation) * Constant.baseHeight, 0.0)
        let mantleElevation = Vector(0.0, Double(tileBase) * Constant.baseHeight, 0.0)
        
        let edgePath = kite.vertices.suffix(kite.vertices.count - 1).map { stencil.vertex($0) }
        
        for i in edgePath.indices {
            
            let v0 = edgePath[i]
            let v1 = edgePath[(i + 1) % edgePath.count]
            
            let v2 = v0 + crownElevation
            let v3 = v1 + crownElevation
            let v4 = v0 + apexElevation
            let v5 = v1 + apexElevation
            
            let crownPath = [v5, v4, v2, v3].path(biome.colorPalette.primary)
            let mantlePath = [v3, v2, v0 + mantleElevation, v1 + mantleElevation].path(biome.colorPalette.secondary)
            
            guard let crown = Polygon(shape: crownPath),
                  let mantle = Polygon(shape: mantlePath) else { continue }
            
            polygons.append(contentsOf: [crown, mantle])
        }
        
        return polygons
    }
}
