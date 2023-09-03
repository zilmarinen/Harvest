//
//  DualChunk.swift
//
//  Created by Zack Brown on 02/09/2023.
//

import Bivouac
import SceneKit

public class DualChunk: SCNNode {
    
    public let coordinate: Coordinate
    
    required public init(coordinate: Coordinate) {
        
        self.coordinate = coordinate
        
        super.init()
    }
    
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
