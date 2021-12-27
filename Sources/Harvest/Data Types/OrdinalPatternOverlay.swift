//
//  OrdinalPatternOverlay.swift
//
//  Created by Zack Brown on 18/11/2021.
//

import Meadow
import SpriteKit

public class OrdinalPatternOverlay: SKNode {
    
    enum Constants {
        
        static let nodeSize = CGSize(width: 0.5, height: 0.5)
    }
    
    private let northWest = SKSpriteNode(color: .clear, size: Constants.nodeSize)
    private let northEast = SKSpriteNode(color: .clear, size: Constants.nodeSize)
    private let southEast = SKSpriteNode(color: .clear, size: Constants.nodeSize)
    private let southWest = SKSpriteNode(color: .clear, size: Constants.nodeSize)
    
    override init() {
        
        super.init()
        
        addChild(northWest)
        addChild(northEast)
        addChild(southEast)
        addChild(southWest)
        
        northWest.position = CGPoint(x: -(Constants.nodeSize.width / 2.0), y: -(Constants.nodeSize.height / 2.0))
        northEast.position = CGPoint(x: (Constants.nodeSize.width / 2.0), y: -(Constants.nodeSize.height / 2.0))
        southEast.position = CGPoint(x: (Constants.nodeSize.width / 2.0), y: (Constants.nodeSize.height / 2.0))
        southWest.position = CGPoint(x: -(Constants.nodeSize.width / 2.0), y: (Constants.nodeSize.height / 2.0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension OrdinalPatternOverlay {
    
    func configure(with pattern: OrdinalPattern<SurfaceMaterial>) {
        
        northWest.color = pattern.value(for: .northWest).spriteColor.osColor
        northEast.color = pattern.value(for: .northEast).spriteColor.osColor
        southEast.color = pattern.value(for: .southEast).spriteColor.osColor
        southWest.color = pattern.value(for: .southWest).spriteColor.osColor
    }
}
