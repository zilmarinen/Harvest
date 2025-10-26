//
//  WaterComponent.swift
//
//  Created by Zack Brown on 26/10/2025.
//

import AppKit
import Deltille
import Euclid
import RealityKit

internal class WaterComponent: Component {
    
    internal var tiles: [Triangle : WaterTile] = [:]
}

internal protocol HasWaterComponent: Entity {
    
    var waterComponent: WaterComponent { get set }
    
    var isEmpty: Bool { get }
    
    func set(_ waterType: WaterType,
             _ elevation: Int,
             for triangle: Triangle)
}

extension HasWaterComponent {
    
    internal var waterComponent: WaterComponent {
        
        get {
            
            let component = components[WaterComponent.self] ?? .init()
            
            if components[WaterComponent.self] == nil {
                
                components[WaterComponent.self] = component
            }
            
            return component
        }
        
        set {
            
            components[WaterComponent.self] = newValue
        }
    }
    
    internal var isEmpty: Bool { waterComponent.tiles.isEmpty }
    
    internal func set(_ waterType: WaterType,
                      _ elevation: Int,
                      for triangle: Triangle) {
        
        guard elevation > 0 else {
            
            return waterComponent.tiles[triangle] = nil
        }
     
        waterComponent.tiles[triangle] = .init(triangle: triangle,
                                               waterType: waterType,
                                               elevation: elevation)
    }
}
