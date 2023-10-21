//
//  Graph.swift
//
//  Created by Zack Brown on 02/09/2023.
//

import Bivouac
import SceneKit

public class Graph<R: GraphRegion<C, T>,
                   C: GraphChunk<T>,
                   T: GraphTile>: SCNNode {
    
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
    
    @discardableResult
    internal func add(tile footprint: Grid.Footprint) -> T? {
        
        let origin = footprint.origin.position.convert(from: .tile,
                                                       to: .region)
        
        let region = find(region: origin) ?? R(coordinate: origin)
        
        let tile = region.add(tile: footprint)
        
        guard region.parent == nil else { return tile }
        
        regions.append(region)
        
        addChildNode(region)
        
        return tile
    }
}
