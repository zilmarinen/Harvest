//
//  Surface2D.swift
//
//  Created by Zack Brown on 10/03/2021.
//

import Meadow
import SpriteKit

public class Surface2D: Grid2D<SurfaceChunk2D, SurfaceTile2D> {
    
    public enum Overlay {
        
        case coordinate
        case edge
        case elevation
        case material
        case none
    }
    
    lazy var tilemap: SurfaceTilemap = {
        
        guard let tilemap = try? SurfaceTilemap() else { fatalError("Error loading surface tilemap") }
        
        return tilemap
    }()
    
    public var overlay: Overlay = .material {
        
        didSet {
            
            if oldValue != overlay {
                
                for tile in tiles {
                    
                    tile.becomeDirty()
                }
            }
        }
    }
    
    @discardableResult override public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        let (even, odd) = sortedTiles
        
        for tile in even {
            
            tile.collapse()
        }
        
        for tile in odd {
            
            tile.collapse()
        }
        
        return super.clean()
    }
}
