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
            
            update(chunk: chunk,
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
        let pattern = triangle.pattern
        let stencil = triangle.stencil(.tile)
        
        let i = (abs(triangle.vertex.position.identifier) % 3)
        let j = (i + 1) % 3
        let k = (i + 2) % 3
        
        let c0 = triangle.corners[i]
        let c1 = triangle.corners[j]
        let c2 = triangle.corners[k]
        
        let tv0 = triangle.vertex(c0)
        let tv1 = triangle.vertex(c1)
        let tv2 = triangle.vertex(c2)
        
        let v0 = tile.vertices[tv0]
        let v1 = tile.vertices[tv1]
        let v2 = tile.vertices[tv2]
        
        let r0 = Rotation(turns: i)
        let r1 = Rotation(turns: j)
        let r2 = Rotation(turns: k)
        
        let k0 = pattern.kites[i]
        let k1 = pattern.kites[j]
        let k2 = pattern.kites[k]
        
        let o0 = k0.vertices.rotate(r0)
        let o1 = k1.vertices.rotate(r1)
        let o2 = k2.vertices.rotate(r2)
        
        let pairs = [(v0, o0),
                     (v1, o1),
                     (v2, o2)]
        
        var polygons: [Euclid.Polygon] = []
        
        for s in pairs.indices {
            
            let t = (s + 1) % pairs.count
            let u = (s + 2) % pairs.count
            
            let (vertex, outline) = pairs[s]
            let (lv, lo) = pairs[t]
            let (rv, ro) = pairs[u]
            
            guard let vertex else { continue }
            
            polygons.append(contentsOf: render(vertex: vertex,
                                               outline: outline,
                                               stencil: stencil,
                                               leftElevation: lv?.elevation ?? 0,
                                               leftOutline: lo,
                                               rightElevation: rv?.elevation ?? 0,
                                               rightOutline: ro))
        }
        
        return polygons
    }
    
    private func render(vertex: TerrainVertex,
                        outline: [Triangle.Stencil.Vertex],
                        stencil: Triangle.Stencil,
                        leftElevation: Int,
                        leftOutline: [Triangle.Stencil.Vertex],
                        rightElevation: Int,
                        rightOutline: [Triangle.Stencil.Vertex]) -> [Euclid.Polygon] {
        
        let apexElevation = Vector(0.0, Terrain.apexHeight(for: vertex.elevation), 0.0)
        let baseElevation = Vector(0.0, Terrain.baseHeight(for: vertex.elevation), 0.0)
        let surfaceColor = vertex.biome.terrain.color(for: vertex.vertex.position.identifier,
                                                      [.primary,
                                                       .secondary,
                                                       .tertiary])
        let baseColor = vertex.biome.terrain.color(for: .quaternary)
        let colorPalette = ColorPalette(surfaceColor,
                                        baseColor)
        
        let vertices = outline.map { stencil.vertex($0) }
        
        guard let surface = Polygon.surface(vertices.map { $0 + apexElevation },
                                            colorPalette.primary) else { return [] }
        
        guard vertex.elevation > leftElevation ||
                vertex.elevation > rightElevation else { return [surface] }
        
        let outline = outline.dropFirst()
        
        var polygons = [surface]
        
        for i in outline.indices.dropLast() {
            
            let j = (i + 1)
            
            let sv0 = outline[i]
            let sv1 = outline[j]
            
            let lor = leftOutline.contains(sv0) && leftOutline.contains(sv1)
            
            let adjacentElevation = lor ? leftElevation : rightElevation
            let adjacentOutline = lor ? leftOutline : rightOutline
            
            guard vertex.elevation > adjacentElevation else { continue }
            
            let intersectionElevation = Vector(0.0, Terrain.apexHeight(for: adjacentElevation), 0.0)
            
            let v0 = stencil.vertex(sv0)
            let v1 = stencil.vertex(sv1)
            
            let a0 = v0 + apexElevation
            let a1 = v1 + apexElevation
            
            let b0 = v0 + baseElevation
            let b1 = v1 + baseElevation
            
            let i0 = v0 + intersectionElevation
            let i1 = v1 + intersectionElevation
            
            guard let apex = Polygon.surface([b0, b1, a1, a0],
                                             colorPalette.primary),
                  let base = Polygon.surface([i0, i1, b1, b0],
                                             colorPalette.secondary) else { continue }
            
            polygons.append(contentsOf: [apex,
                                         base])
        }
        
        return polygons
    }
}
