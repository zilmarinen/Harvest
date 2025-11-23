//
//  HexagonalGridDataSourceTile.swift
//
//  Created by Zack Brown on 23/11/2025.
//

import Deltille

internal struct HexagonalGridDataSourceTile<V: Codable> {
    
    internal let triangle: Triangle
    internal let vertices: [Triangle.Vertex : V]
}

extension HexagonalGridDataSourceTile {
    
    internal var hasThreeVertices: Bool { vertices.count == 3 }
}
