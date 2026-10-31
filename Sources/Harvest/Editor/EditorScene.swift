//
//  EditorScene.swift
//  Harvest
//
//  Created by Zack Brown on 30/10/2026.
//

import SpriteKit

internal class EditorScene: SKScene {
    
    internal let terrain = Terrain()
    internal let water = Water()
    
    override init() {
    
        super.init()
        
        addChild(terrain)
        addChild(water)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
