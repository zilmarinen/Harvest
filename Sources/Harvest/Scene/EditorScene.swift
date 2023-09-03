//
//  EditorScene.swift
//
//  Created by Zack Brown on 01/09/2023.
//

import Foundation
import SceneKit

public final class EditorScene: SCNScene {
    
    private let camera = Camera()
    
    private let foliage = Foliage()
    private let terrain = Terrain()
    
    required override public init() {
        
        super.init()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
