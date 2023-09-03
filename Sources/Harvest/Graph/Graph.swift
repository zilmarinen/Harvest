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
    
    private(set) var regions: [R]
    
    required override public init() {
        
        self.regions = []
        
        super.init()
    }
    
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func find(region coordinate: Coordinate) -> R? { regions.first { $0.coordinate == coordinate } }
    
    public func find(tile coordinate: Coordinate) -> T? { find(region: coordinate.convert(from: .tile, to: .region))?.find(tile: coordinate) }
    
    @discardableResult
    public func add(tile footprint: Grid.Footprint) -> T? {
        
        let origin = footprint.origin.origin.convert(from: .tile, to: .region)
        
        let region = find(region: origin) ?? R(coordinate: origin)
        
        let tile = region.add(tile: footprint)
        
        guard region.parent == nil else { return tile }
        
        regions.append(region)
        
        addChildNode(region)
        
        return tile
    }
}
