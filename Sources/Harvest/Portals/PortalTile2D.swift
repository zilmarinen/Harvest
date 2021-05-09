//
//  PortalTile2D.swift
//
//  Created by Zack Brown on 03/05/2021.
//

import Foundation
import Meadow
import SpriteKit

public class PortalTile2D: FootprintTile2D {
    
    var direction: Cardinal = .north {
        
        didSet {
            
            if oldValue != direction {
                
                becomeDirty()
            }
        }
    }
    
    public override func clean() -> Bool {
        
        guard super.clean() else { return false }
        
        removeAllChildren()
        
        var nodeSize = size
        var nodePosition = CGPoint.zero
        
        switch direction {
        
        case .north,
             .south:
            
            nodeSize.height /= 2
            nodePosition.y = (direction == .south ? nodePosition.y : nodeSize.height)
            
        case .east,
             .west:
            
            nodeSize.width /= 2
            nodePosition.x = (direction == .east ? nodePosition.x : nodeSize.width)
        }
        
        let node = SKSpriteNode(color: .systemPink, size: nodeSize)
        
        node.anchorPoint = .zero
        node.position = nodePosition
        node.zPosition = 1
        
        addChild(node)
        
        return true
    }
}
