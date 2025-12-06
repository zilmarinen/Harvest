//
//  TileDataSource.swift
//
//  Created by Zack Brown on 12/11/2025.
//

import Deltille
import RealityKit

internal class DataSource<K: Codable & Hashable,
                          V: Codable>: Component,
                                       Codable {
    
    internal var data: [K : V] = [:]
    
    internal var isEmpty: Bool { data.isEmpty }
}

internal protocol HasDataSource: Entity {
    
    associatedtype K: Codable & Hashable
    associatedtype V: Codable
    
    var dataSource: DataSource<K, V> { get }
    
    var data: [K : V] { get }
    
    func merge(_ other: DataSource<K, V>)
    
    func value(for key: K) -> V?
    
    func set(_ value: V?,
             for key: K)
    
    func remove(values keys: [K])
}

extension HasDataSource {
    
    internal var data: [K : V] { dataSource.data }
    
    internal var isEmpty: Bool { dataSource.isEmpty }
}

extension HasDataSource {
    
    internal func merge(_ other: DataSource<K, V>) {
        
        dataSource.data.merge(other.data) { (current, _) in current }
    }
    
    internal func value(for key: K) -> V? {
        
        dataSource.data[key]
    }
    
    internal func remove(values keys: [K]) {
        
        keys.forEach {
            
            dataSource.data.removeValue(forKey: $0)
        }
    }
}
