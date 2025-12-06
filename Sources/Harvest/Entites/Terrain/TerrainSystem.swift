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
    
    internal static func unitHeight(for elevation: Int) -> Double {
        
        (Constant.baseHeight * Double(elevation)) + Constant.apexHeight
    }
    
    internal init(scene: Scene) {}
    
    internal func update(context: SceneUpdateContext) {
        
        guard let stairs = context.scene.find(entity: .stairs) as? Stairs,
              let terrain = context.scene.find(entity: .terrain) as? Terrain else { return }
        
        terrain.clean { slice, chunk in
            
            update(chunk: chunk,
                   slice: slice)
        }
    }
}

extension TerrainSystem {
    
    private func update(chunk: TerrainChunk,
                        slice: HexagonalGridDataSourceSlice<TerrainVertex>) -> Bool {
        
        let polygons = slice.tiles.reduce(into: [Euclid.Polygon]()) { result, item in
            
            let (_, tile) = item
            
            let stencil = tile.triangle.stencil(.tile)
            
            result.append(contentsOf: render(tile: tile,
                                             stencil: stencil))
        }
        
        guard !polygons.isEmpty else { return false }
        
        let mesh = Mesh(polygons)
        
        chunk.mesh = mesh.translated(by: -chunk.triangle.position(chunk.scale))
        
        return true
    }
    
    private func render(tile: HexagonalGridDataSourceTile<TerrainVertex>,
                        stencil: Triangle.Stencil) -> [Euclid.Polygon] {
        
        let origin = tile.triangle.position(.tile)
        
        return tile.vertices.reduce(into: [Euclid.Polygon]()) { result, vertex in
            
            guard let corner = tile.triangle.corner(vertex.value.vertex) else { return }
            
            let kite = tile.triangle.kite(index: corner.rawValue)
            
            let angle = Angle(radians: Triangle.Rotation.step * Double(-corner.rawValue))
            let rotation = Rotation.yaw(angle)
            
            let polygons = render(tile: tile,
                                  vertex: vertex.value.vertex,
                                  stencil: stencil,
                                  kite: kite,
                                  biome: vertex.value.biome,
                                  elevation: vertex.value.elevation)
            
            result.append(contentsOf: polygons.translated(by: -origin).rotated(by: rotation).translated(by: origin))
        }
    }
    
    private func render(tile: HexagonalGridDataSourceTile<TerrainVertex>,
                        vertex: Triangle.Vertex,
                        stencil: Triangle.Stencil,
                        kite: Triangle.Kite,
                        biome: Biome,
                        elevation: Int) -> [Euclid.Polygon] {
        
        let identifier = tile.triangle.vertex.position.identifier % vertex.position.identifier
        let apexColor = biome.terrain.color(for: identifier,
                                            [.primary,
                                             .secondary,
                                             .tertiary])
        
        let apexElevation = Vector(0.0, Self.unitHeight(for: elevation), 0.0)
        let vertices = kite.vertices.map { stencil.vertex($0) + apexElevation }
        let apexPath = vertices.path(apexColor)
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
            
            let crownPath = [v5, v4, v2, v3].path(apexColor)
            let mantlePath = [v3, v2, v0 + mantleElevation, v1 + mantleElevation].path(biome.terrain.color(for: .quaternary))
            
            guard let crown = Polygon(shape: crownPath),
                  let mantle = Polygon(shape: mantlePath) else { continue }
            
            polygons.append(contentsOf: [crown, mantle])
        }
        
        return polygons
    }
}
