//
//  DualRegion.swift
//
//  Created by Zack Brown on 02/09/2023.
//

import Bivouac
import SceneKit

public class DualRegion<C: DualChunk>: SCNNode {
    
    internal let coordinate: Coordinate
    internal var chunks: [C]
    
    required public init(coordinate: Coordinate) {
        
        self.coordinate = coordinate
        self.chunks = []
        
        super.init()
        
        self.position = SCNVector3(coordinate.convert(to: .region))
    }
    
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    internal func clear() {
    
        chunks.forEach { $0.removeFromParentNode() }
        
        chunks.removeAll()
    }
    
    internal func find(chunk coordinate: Coordinate) -> C? { chunks.first { $0.coordinate == coordinate } }
    
    internal func add(chunk coordinate: Coordinate) {
        
        let origin = coordinate.convert(from: .tile,
                                        to: .chunk)
        
        let chunk = find(chunk: origin) ?? C(coordinate: origin)
        
        guard chunk.parent == nil else { return }
            
        chunks.append(chunk)
        
        addChildNode(chunk)
    }
}
