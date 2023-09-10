//
//  GraphRegion.swift
//
//  Created by Zack Brown on 02/09/2023.
//

import Bivouac
import SceneKit

public class GraphRegion<C: GraphChunk<T>,
                         T: GraphTile>: SCNNode {
    
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
    
    @discardableResult
    internal func add(tile footprint: Grid.Footprint) -> T? {
        
        let origin = footprint.origin.position.convert(from: .tile,
                                                       to: .chunk)
        
        let chunk = find(chunk: origin) ?? C(coordinate: origin)
        
        let tile = chunk.add(tile: footprint)
        
        guard chunk.parent == nil else { return tile }
            
        chunks.append(chunk)
        
        addChildNode(chunk)
        
        return tile
    }
}
