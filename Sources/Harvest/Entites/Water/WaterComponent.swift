//
//  WaterComponent.swift
//
//  Created by Zack Brown on 26/10/2025.
//

import AppKit
import Deltille
import Euclid
import RealityKit

internal class WaterComponent: Component,
                               Codable {
    
    internal var tiles: [Triangle : WaterTile] = [:]
}

internal protocol HasWaterComponent: Entity {
    
    var waterComponent: WaterComponent { get set }
    
    var tiles: [Triangle : WaterTile] { get }
    
    var isEmpty: Bool { get }
    
    func get(tile triangle: Triangle) -> WaterTile?
    
    func set(_ waterType: WaterType,
             _ elevation: Int,
             for triangle: Triangle)
    
    func remove(tiles: [Triangle])
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
    
    internal var tiles: [Triangle : WaterTile] { waterComponent.tiles }
    
    internal var isEmpty: Bool { tiles.isEmpty }
    
    internal func get(tile triangle: Triangle) -> WaterTile? {
     
        waterComponent.tiles[triangle]
    }
}
