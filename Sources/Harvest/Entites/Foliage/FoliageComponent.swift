//
//  FoliageComponent.swift
//
//  Created by Zack Brown on 25/10/2025.
//

import AppKit
import Deltille
import Euclid
import RealityKit
import Verdure

internal class FoliageComponent: Component,
                                 Codable {
    
    internal var tiles: [Triangle : Triangle.Septomino] = [:]
}

internal protocol HasFoliageComponent: Entity {
    
    var foliageComponent: FoliageComponent { get set }
    
    var tiles: [Triangle : Triangle.Septomino] { get }
    
    var isEmpty: Bool { get }
    
    func set(foliage triangle: Triangle)
}

extension HasFoliageComponent {
    
    internal var foliageComponent: FoliageComponent {
        
        get {
            
            let component = components[FoliageComponent.self] ?? .init()
            
            if components[FoliageComponent.self] == nil {
                
                components[FoliageComponent.self] = component
            }
            
            return component
        }
        
        set {
            
            components[FoliageComponent.self] = newValue
        }
    }
    
    internal var tiles: [Triangle : Triangle.Septomino] { foliageComponent.tiles }
    
    internal var isEmpty: Bool { tiles.isEmpty }
    
    internal func set(foliage triangle: Triangle) {
        
        foliageComponent.tiles[triangle] = triangle.septomino
    }
}
