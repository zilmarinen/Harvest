//
//  Tileset.swift
//
//  Created by Zack Brown on 15/12/2020.
//

import Foundation
import Meadow

public protocol Tileset {
    
    associatedtype T = TilesetTile
    
    var tiles: [T] { get }
}
