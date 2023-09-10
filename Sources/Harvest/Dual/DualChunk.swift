//
//  DualChunk.swift
//
//  Created by Zack Brown on 02/09/2023.
//

import Bivouac
import SceneKit

public class DualChunk: SCNNode {
    
    internal let coordinate: Coordinate
    
    required public init(coordinate: Coordinate) {
        
        self.coordinate = coordinate
        
        super.init()
        
        self.position = SCNVector3(coordinate.convert(to: .region) - coordinate.convert(to: .chunk))
    }
    
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
