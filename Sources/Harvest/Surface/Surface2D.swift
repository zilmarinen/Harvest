//
//  Surface2D.swift
//
//  Created by Zack Brown on 10/03/2021.
//

import Meadow
import SpriteKit

public class Surface2D: Grid2D<SurfaceChunk2D, SurfaceTile2D> {
    
    public enum Overlay {
        
        case elevation
        case none
    }
    
    public var overlay: Overlay = .elevation {
        
        didSet {
            
            if oldValue != overlay {
                
                for tile in tiles {
                    
                    tile.becomeDirty()
                }
            }
        }
    }
}
