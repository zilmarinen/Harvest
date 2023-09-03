//
//  GraphChunk.swift
//
//  Created by Zack Brown on 02/09/2023.
//

import Bivouac
import SceneKit

public class GraphChunk<T: GraphTile>: SCNNode {
    
    public let coordinate: Coordinate
    internal var tiles: [T]
    
    required public init(coordinate: Coordinate) {
        
        self.coordinate = coordinate
        self.tiles = []
        
        super.init()
    }
    
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    internal func find(tile coordinate: Coordinate) -> T? { tiles.first { $0.footprint.intersects(rhs: coordinate) } }
    
    @discardableResult
    internal func add(tile footprint: Grid.Footprint) -> T? {
        
        guard find(tile: footprint.origin.origin) == nil else { return nil }
        
        let tile = T(footprint: footprint)
        
        tiles.append(tile)
        
        return tile
    }
}
