//
//  TileDataSource.swift
//
//  Created by Zack Brown on 12/11/2025.
//

import Deltille
import RealityKit

internal class TileDataSource<T: Codable>: Component,
                                           Codable {
    
    internal var tiles: [Triangle : T] = [:]
    
    internal var isEmpty: Bool { tiles.isEmpty }
}

internal protocol HasTileDataSource: TriangularEntity {
    
    associatedtype T: Codable
    
    var dataSource: TileDataSource<T> { get }
    
    var tiles: [Triangle : T] { get }
    
    var isEmpty: Bool { get }
    
    func value(for tile: Triangle) -> T?
    
    func set(_ value: T?,
             for tile: Triangle)
}

extension HasTileDataSource {
    
    internal var tiles: [Triangle : T] { dataSource.tiles }
    
    internal var isEmpty: Bool { dataSource.isEmpty }
}
