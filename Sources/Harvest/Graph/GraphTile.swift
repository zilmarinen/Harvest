//
//  GraphTile.swift
//
//  Created by Zack Brown on 02/09/2023.
//

import Bivouac
import Foundation

public class GraphTile {
    
    internal let footprint: Grid.Footprint
    
    required public init(footprint: Grid.Footprint) {
        
        self.footprint = footprint
    }
    
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
