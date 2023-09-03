//
//  TerrainRegion.swift
//
//  Created by Zack Brown on 01/09/2023.
//

import Bivouac
import SceneKit

public final class TerrainRegion: DualRegion<TerrainChunk> {
    
    private var terrain: Terrain? { parent as? Terrain }
    internal var heightMap: TerrainHeightMap? { terrain?.heightMap }
}

