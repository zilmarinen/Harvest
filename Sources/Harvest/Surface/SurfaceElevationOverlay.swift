//
//  SurfaceElevationOverlay.swift
//
//  Created by Zack Brown on 26/11/2021.
//

import Meadow
import SpriteKit

public class SurfaceElevationOverlay: SKNode {
    
    enum Constants {
        
        static let nodeSize = CGSize(width: 0.5, height: 0.5)
    }
    
    private let northWest = SKLabelNode()
    private let northEast = SKLabelNode()
    private let southEast = SKLabelNode()
    private let southWest = SKLabelNode()
    
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
        
        for node in [northWest, northEast, southEast, southWest] {
            
            node.fontSize = 3
            node.fontColor = .black
            node.blendMode = .replace
            node.verticalAlignmentMode = .center
            node.xScale = 0.1
            node.yScale = -0.1
            node.zPosition = 1
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension SurfaceElevationOverlay {
    
    func configure(with pattern: OrdinalPattern<Int>) {
        
        northWest.text = "\(pattern.value(for: .northWest))"
        northEast.text = "\(pattern.value(for: .northEast))"
        southEast.text = "\(pattern.value(for: .southEast))"
        southWest.text = "\(pattern.value(for: .southWest))"
    }
}
