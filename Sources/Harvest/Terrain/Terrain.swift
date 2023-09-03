//
//  Terrain.swift
//
//  Created by Zack Brown on 01/09/2023.
//

import Bivouac
import SceneKit

public final class Terrain: Dual<TerrainRegion, TerrainChunk> {
    
    private(set) var heightMap = TerrainHeightMap()
}
