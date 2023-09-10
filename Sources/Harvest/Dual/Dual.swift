//
//  Dual.swift
//
//  Created by Zack Brown on 02/09/2023.
//

import Bivouac
import SceneKit

public class Dual<R: DualRegion<C>,
                  C: DualChunk>: SCNNode {
    
    internal var regions: [R]
    
    required override public init() {
        
        self.regions = []
        
        super.init()
    }
    
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    internal func clear() {
    
        regions.forEach { $0.removeFromParentNode() }
        
        regions.removeAll()
    }
    
    internal func find(region coordinate: Coordinate) -> R? { regions.first { $0.coordinate == coordinate } }
    
    internal func add(vertex coordinate: Coordinate) -> Grid.Vertex? {
        
        guard coordinate.equalToOne else { return nil }
        
        let vertex = Grid.Vertex(coordinate)
        
        for triangle in vertex.triangles {
            
            let origin = triangle.position.convert(from: .tile,
                                                   to: .region)
            
            let region = find(region: origin) ?? R(coordinate: origin)
            
            region.add(chunk: coordinate)
            
            guard region.parent == nil else { continue }
            
            regions.append(region)
            
            addChildNode(region)
        }
        
        return vertex
    }
}
