//
//  EditorScene.swift
//  Harvest
//
//  Created by Zack Brown on 30/10/2026.
//

import Deltille
import SpriteKit

internal class EditorScene: SKScene {
    
    internal let terrain = Terrain()
    internal let water = Water()
    
    override init() {
    
        super.init(size: .zero)
        
        addChild(terrain)
        addChild(water)
        
        let node = SKShapeNode.init(circleOfRadius: 7.0)
        
        node.strokeColor = .systemPink
        node.fillColor = .white
        node.lineWidth = 2.0
        
        addChild(node)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
