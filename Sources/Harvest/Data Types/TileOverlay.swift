//
//  TileOverlay.swift
//
//  Created by Zack Brown on 18/11/2021.
//

import Meadow
import SpriteKit

public class TileOverlay: SKSpriteNode {
    
    enum Style {
        
        case corners
        case grid
    }
    
    private let style: Style
    
    required init(style: Style) {
        
        self.style = style
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
