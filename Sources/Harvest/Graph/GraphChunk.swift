//
//  GraphChunk.swift
//
//  Created by Zack Brown on 02/09/2023.
//

import Bivouac
import SceneKit

public class GraphChunk<T: GraphTile>: SCNNode {
    
    internal let coordinate: Coordinate
    internal var tiles: [T]
    
    required public init(coordinate: Coordinate) {
        
        self.coordinate = coordinate
        self.tiles = []
        
        super.init()
        
        self.position = SCNVector3(coordinate.convert(to: .chunk) - coordinate.convert(from: .chunk, to: .region).convert(to: .region))
    }
    
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    internal func clear() { tiles.removeAll() }
    
    internal func find(tile coordinate: Coordinate) -> T? { tiles.first { $0.footprint.intersects(rhs: coordinate) } }
    
    @discardableResult
    internal func add(tile footprint: Grid.Footprint) -> T? {
        
        guard find(tile: footprint.origin.position) == nil else { return nil }
        
        let tile = T(footprint: footprint)
        
        tiles.append(tile)
        
        return tile
    }
}
