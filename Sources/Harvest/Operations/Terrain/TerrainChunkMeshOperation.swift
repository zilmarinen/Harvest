//
//  TerrainChunkMeshOperation.swift
//
//  Created by Zack Brown on 10/09/2023.
//

import Bivouac
import Euclid
import Foundation
import PeakOperation
import Regolith

internal class TerrainChunkMeshOperation: ConcurrentOperation,
                                          ProducesResult {
    
    public var output: Result<Mesh, Error> = Result { throw ResultError.noResult }
    
    private let chunk: TerrainChunk
    private let heightMap: TerrainHeightMap
    private let prefabs: TerrainKiteRenderOperation.Prefabs
    
    init(chunk: TerrainChunk,
         heightMap: TerrainHeightMap,
         prefabs: TerrainKiteRenderOperation.Prefabs) {
        
        self.chunk = chunk
        self.heightMap = heightMap
        self.prefabs = prefabs
        
        super.init()
    }
    
    override func execute() {
        
        let nodes = heightMap.nodes(within: chunk.coordinate)
        
        var mesh = Mesh([])
        var triangles = Set<Grid.Triangle>()
        
        for node in nodes.values {
            
            for triangle in node.vertex.triangles {
                
                guard !triangles.contains(triangle),
                      !heightMap.isUniform(triangle: triangle) else {
                    
                    triangles.insert(triangle)
                    
                    continue
                }
                
                guard let vertex = triangle.index(of: node.vertex) else { continue }
                
                mesh = mesh.merge(self.mesh(for: node,
                                            triangle: triangle,
                                            vertex: vertex))
            }
        }
        
        for triangle in triangles {
            
            guard let node = nodes[triangle.vertex(.v0)] else { continue }
            
            mesh = mesh.merge(self.mesh(for: node,
                                        triangle: triangle))
        }
        
        output = .success(mesh.translated(by: -chunk.coordinate.convert(to: .chunk)))
        
        finish()
    }
}

extension TerrainChunkMeshOperation {
    
    internal func mesh(for node: TerrainHeightMap.Node,
                       triangle: Grid.Triangle) -> Mesh {
        
        let position = triangle.position.convert(to: .tile)
        
        let rotation = Rotation(axis: .up,
                                angle: Angle(degrees: triangle.rotation))
        
        let offset = Vector(0.0,
                            (Grid.Triangle.Kite.base * Double(node.elevation)),
                            0.0)
        
        let transform = Transform(offset: position + offset,
                                  rotation: rotation)
        
        return prefabs.mesh(for: .uniform,
                            elevation: .apex,
                            terrainType: node.terrainType).transformed(by: transform)
    }
    
    internal func mesh(for node: TerrainHeightMap.Node,
                       triangle: Grid.Triangle,
                       vertex: Grid.Triangle.Vertex) -> Mesh {
        
        let position = triangle.position.convert(to: .tile)
        
        let patternRotation = Grid.Triangle.stepRotation * Double(-vertex.rawValue)
        
        let rotation = Rotation(axis: .up,
                                angle: Angle(degrees: patternRotation + triangle.rotation))
        
        let kite = triangle.kites[vertex.rawValue]
        
        var mesh = Mesh([])
        
        if !heightMap.isOccluded(triangle: triangle,
                                 vertex: vertex) {
            
            for elevation in 0..<node.elevation {
                
                let prefab = prefabs.mesh(for: kite,
                                          elevation: .base,
                                          terrainType: node.terrainType)
                
                let offset = Vector(0.0,
                                    (Grid.Triangle.Kite.base * Double(elevation)),
                                    0.0)
                
                let transform = Transform(offset: position + offset,
                                          rotation: rotation)
                
                mesh = mesh.union(prefab.transformed(by: transform))
            }
        }
        
        let prefab = prefabs.mesh(for: kite,
                                  elevation: .apex,
                                  terrainType: node.terrainType)
        
        let offset = Vector(0.0,
                            (Grid.Triangle.Kite.base * Double(node.elevation)),
                            0.0)
        
        let transform = Transform(offset: position + offset,
                                  rotation: rotation)
        
        return mesh.union(prefab.transformed(by: transform))
    }
}
