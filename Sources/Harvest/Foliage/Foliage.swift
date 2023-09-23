//
//  Foliage.swift
//
//  Created by Zack Brown on 02/09/2023.
//

import Bivouac
import SceneKit

public final class Foliage: Graph<FoliageRegion, FoliageChunk, FoliageTile>,
                            Cleanable  {
    
    internal var isDirty: Bool = false
    
    internal var operationQueue = OperationQueue()
}

extension Foliage {
 
    public func add(foliageType: FoliageType,
                    at coordinate: Coordinate) {
        
        let footprint = Grid.Footprint(origin: coordinate,
                                       area: foliageType.area)
        
        guard let tile = add(tile: footprint) else { return }
        
        tile.foliageType = foliageType
        
        guard let region = find(region: coordinate.convert(from: .tile,
                                                           to: .region)),
              let chunk = region.find(chunk: coordinate.convert(from: .tile,
                                                                to: .chunk)) else { return }
        
        chunk.becomeDirty()
    }
}

extension Foliage {
    
    internal func clean() {
        
        guard isDirty,
              operationQueue.operationCount == 0 else { return }
        
        isDirty = false
     
        let dirtyRegions = regions.filter { $0.isDirty }
        let dirtyChunks = dirtyRegions.flatMap { $0.chunks.filter { $0.isDirty } }
        
        let renderOperation = FoliageRenderOperation()
        let tilingOperation = FoliageTilingOperation(chunks: dirtyChunks)
        
        renderOperation.passesResult(to: tilingOperation).enqueue(on: operationQueue)
        
        dirtyRegions.forEach { $0.isDirty = false }
        dirtyChunks.forEach { $0.isDirty = false }
    }
}
