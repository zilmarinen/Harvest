//
//  FootprintTile2D.swift
//
//  Created by Zack Brown on 03/05/2021.
//

import Foundation
import Meadow
import SpriteKit

public class FootprintTile2D: SKSpriteNode, Responder2D, Soilable {
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    public let coordinate: Coordinate
    
    required init(coordinate: Coordinate) {
            
        self.coordinate = coordinate
        
        super.init(texture: nil, color: .systemPink, size: CGSize(width: 1, height: 1))
        
        anchorPoint = .zero
        blendMode = .replace
        zPosition = 1
        
        becomeDirty()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        //
        
        return true
    }
}
