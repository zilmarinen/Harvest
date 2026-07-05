//
//  BuildingSystem.swift
//
//  Created by Zack Brown on 27/12/2025.
//

import AppKit
import Deltille
import Euclid
import Lattice
import Lintel
import RealityKit
import Yield

@MainActor
internal struct BuildingSystem: System {
    
    internal init(scene: Scene) {}
    
    internal func update(context: SceneUpdateContext) {
        
        guard let world = context.scene.find(anchor: .world) as? AnchorEntity,
              let buildings = world.find(entity: .buildings) as? Buildings,
              let terrain = world.find(entity: .terrain) as? Terrain else { return }
        
        buildings.clean { chunk, sieve, wedge in
            
            let terrainWedge = terrain.wedge(for: sieve)
            
            guard !terrainWedge.isEmpty else { return false }
            
            return update(grid: buildings,
                          chunk: chunk,
                          wedge: wedge,
                          weave: terrainWedge.weave(sieve))
        }
    }
}

extension BuildingSystem {
    
    private func update(grid: Buildings,
                        chunk: BuildingChunk,
                        wedge: DataStoreWedge<BuildingTile>,
                        weave: DataStoreWeave<TerrainVertex>) -> Bool {
        
        print("Cleaning Building Chunk")
        
        var invalid: [Triangle] = []
        
        //TODO: Find unique items
        let unique = Set(wedge.data.values)
        
        let polygons = unique.reduce(into: [Euclid.Polygon]()) { result, buildingTile in
            
            let triangle = Triangle(buildingTile.vertex)
            
            guard let terrainTile = weave.value(for: triangle) else {
                
                invalid.append(triangle)
                
                return
            }
            
            result.append(contentsOf: render(buildingTile: buildingTile,
                                             terrainTile: terrainTile,
                                             elevation: terrainTile.apex))
        }
        
        grid.remove(values: invalid)
        
        guard !polygons.isEmpty else { return false }
        
        let mesh = Mesh(polygons)
        
        chunk.mesh = mesh.translated(by: -chunk.tile.position(chunk.scale))
        
        return true
    }
    
    private func render(buildingTile: BuildingTile,
                        terrainTile: DataStoreStitch<TerrainVertex>,
                        elevation: Int) -> [Euclid.Polygon] {
        
        do {
            
            let mesh = try AssetCache.shared.load(mesh: .building(buildingTile.septomino))
            
            let apexElevation = Vector(0.0, Terrain.apex(for: elevation), 0.0)
            let origin = terrainTile.triangle.position(.tile)
            let angle = Angle(radians: terrainTile.triangle.orientation + buildingTile.rotation.radians)
            let rotation = Rotation.yaw(angle)
            
            return mesh.polygons.rotated(by: rotation).translated(by: origin + apexElevation)
        }
        catch {
            
            fatalError("Error loading asset: \(error.localizedDescription)")
        }
    }
}
