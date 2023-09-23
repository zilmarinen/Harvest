//
//  EditorScene.swift
//
//  Created by Zack Brown on 01/09/2023.
//

import Bivouac
import Foundation
import SceneKit

public final class EditorScene: Scene {
    
    public let foliage = Foliage()
    public let terrain = Terrain()
    
    required public init() {
        
        super.init()
        
        rootNode.addChildNode(foliage)
        rootNode.addChildNode(terrain)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public override func update(delta: TimeInterval,
                                time: TimeInterval) {
        
        foliage.clean()
        terrain.clean()
    }
}
