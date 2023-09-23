//
//  TerrainHeightMap.swift
//
//  Created by Zack Brown on 01/09/2023.
//

import Bivouac

public final class TerrainHeightMap {
    
    public struct Node {
        
        internal var vertex: Grid.Vertex
        internal var elevation: Int
        internal var terrainType: TerrainType
    }
    
    internal var nodes: [Coordinate : Node] = [:]
    
    internal func clear() { nodes.removeAll() }
    
    internal func node(at vertex: Coordinate) -> Node? { nodes[vertex] }
    
    internal func remove(node vertex: Coordinate) { nodes.removeValue(forKey: vertex) }
    
    internal func set(elevation: Int,
                      terrainType: TerrainType,
                      for vertex: Grid.Vertex) {
        
        guard vertex.position.equalToOne else { return }
        
        var node = node(at: vertex.position) ?? Node(vertex: vertex,
                                                     elevation: elevation,
                                                     terrainType: terrainType)
        
        node.elevation = elevation
        node.terrainType = terrainType
        
        nodes[vertex.position] = node
    }
}

extension TerrainHeightMap {
    
    internal func nodes(within chunk: Coordinate) -> [Coordinate : Node] { nodes.filter { $0.value.vertex.triangles.first { $0.position.convert(from: .tile, to: .chunk) == chunk } != nil } }
    
    internal func isUniform(triangle: Grid.Triangle) -> Bool {
        
        guard let n0 = node(at: triangle.vertex(.v0)),
              let n1 = node(at: triangle.vertex(.v1)),
              let n2 = node(at: triangle.vertex(.v2)) else { return false }
        
        guard n0.elevation == n1.elevation,
              n0.elevation == n2.elevation,
              n0.terrainType == n1.terrainType,
              n1.terrainType == n2.terrainType else { return false }
        
        return true
    }
    
    internal func isOccluded(triangle: Grid.Triangle,
                             vertex: Grid.Triangle.Vertex) -> Bool {
        
        guard let elevation = node(at: triangle.vertex(vertex))?.elevation else { return false }
        
        for adjacent in vertex.vertices {
            
            guard let node = node(at: triangle.vertex(adjacent)),
                  node.elevation >= elevation else { return false }
        }
        
        return true
    }
}
