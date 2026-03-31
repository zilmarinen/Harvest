//
//  TerrainSystem.swift
//
//  Created by Zack Brown on 27/08/2025.
//

import Alluvium
import AppKit
import Deltille
import Euclid
import Lattice
import RealityKit

@MainActor
internal struct TerrainSystem: System {
    
    internal init(scene: Scene) {}
    
    internal func update(context: SceneUpdateContext) {
        
        guard let buildings = context.scene.find(entity: .buildings) as? Buildings,
              let staircases = context.scene.find(entity: .staircases) as? Staircases,
              let terrain = context.scene.find(entity: .terrain) as? Terrain else { return }
        
        terrain.clean { chunk, wedge in
            
            return update(chunk: chunk,
                          wedge: wedge,
                          buildings: buildings,
                          staircases: staircases)
        }
    }
}

extension TerrainSystem {

    private func update(chunk: TerrainChunk,
                        wedge: HexagonalDataStoreWedge<TerrainVertex>,
                        buildings: Buildings,
                        staircases: Staircases) -> Bool {
        
        let polygons = wedge.tiles.reduce(into: [Euclid.Polygon]()) { result, tile in
            
            guard buildings.value(for: tile.triangle.vertex) == nil,
                  staircases.value(for: tile.triangle.vertex) == nil else { return }
            
            result.append(contentsOf: render(tile: tile))
        }
        
        guard !polygons.isEmpty else { return false }
        
        let mesh = Mesh(polygons)
        
        chunk.mesh = mesh.translated(by: -chunk.triangle.position(chunk.scale))
        
        return true
    }
    
    private func render(tile: HexagonalDataStoreTile<TerrainVertex>) -> [Euclid.Polygon] {
        
        let triangle = tile.triangle
        let origin = triangle.position(.tile)
        let stencil = triangle.stencil(.tile)
        let base = tile.base
        
        return tile.vertices.reduce(into: [Euclid.Polygon]()) { result, vertex in
            
            guard let corner = triangle.corner(vertex.value.vertex) else { return }
            
            let kite = triangle.kite(index: corner.rawValue)
            
            let identifier = triangle.vertex.position.identifier % vertex.key.position.identifier
            let biome = vertex.value.biome
            
            let surfaceColor = biome.terrain.color(for: identifier,
                                                   [.primary,
                                                    .secondary,
                                                    .tertiary])
            let baseColor = biome.terrain.color(for: .quaternary)
            let colorPalette = ColorPalette(surfaceColor,
                                            baseColor)
            
            let polygons = render(vertex: vertex.value,
                                  corner: corner,
                                  kite: kite,
                                  stencil: stencil,
                                  base: base,
                                  colorPalette: colorPalette)
            
            result.append(contentsOf: polygons)
        }
    }
    
    private func render(vertex: TerrainVertex,
                        corner: Triangle.Corner,
                        kite: Triangle.Kite,
                        stencil: Triangle.Stencil,
                        base: Int,
                        colorPalette: ColorPalette) -> [Euclid.Polygon] {
        
        let apexElevation = Vector(0.0, Terrain.unitHeight(for: vertex.elevation), 0.0)
        
        let rotation = Rotation(turns: corner.rawValue)
        
        let vertices = kite.vertices.rotate(rotation).map {
            
            return stencil.vertex($0) + apexElevation
        }
        
        let apexPath = vertices.map {
            
            Vertex($0,
                   .unitY,
                   nil,
                   colorPalette.primary)
        }
        
        guard let apex = Polygon(apexPath) else { return [] }
        return [apex]
//        var polygons = [apex]
//        
//        guard vertex.elevation > base else { return polygons }
//        
//        let crownElevation = Vector(0.0, Double(vertex.elevation) * Terrain.Constant.baseHeight, 0.0)
//        let mantleElevation = Vector(0.0, Double(base) * Terrain.Constant.baseHeight, 0.0)
//        
//        let edgePath = kite.vertices.suffix(kite.vertices.count - 1).map { stencil.vertex($0) }
//        
//        for i in edgePath.indices {
//            
//            let v0 = edgePath[i]
//            let v1 = edgePath[(i + 1) % edgePath.count]
//            
//            let v2 = v0 + crownElevation
//            let v3 = v1 + crownElevation
//            let v4 = v0 + apexElevation
//            let v5 = v1 + apexElevation
////            
////            let crownPath = [v5, v4, v2, v3].path(colorPalette.primary)
////            let mantlePath = [v3, v2, v0 + mantleElevation, v1 + mantleElevation].path(colorPalette.secondary)
////            
////            guard let crown = Polygon(crownPath),
////                  let mantle = Polygon(mantlePath) else { continue }
////            
////            polygons.append(contentsOf: [crown, mantle])
//        }
//        
//        return polygons
    }
}
