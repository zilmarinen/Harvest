//
//  GridRegionDataSource.swift
//
//  Created by Zack Brown on 20/12/2025.
//

import RealityKit

internal protocol GridRegionDataSource: Entity {
    
    associatedtype C
    associatedtype K: Codable & Hashable
    associatedtype V: Codable
    
    func merge(_ chunk: C)
    
    func value(for key: K) -> V?
    
    func set(_ value: V?,
             for key: K)
}
