//
//  FoliageChunkMeshOperation.swift
//  
//  Created by Zack Brown on 22/09/2023.
//

import Bivouac
import Euclid
import Foundation
import PeakOperation
import SceneKit
import Verdure

internal class FoliageChunkMeshOperation: ConcurrentOperation,
                                          ProducesResult {
    
    public var output: Result<Void, Error> = Result { throw ResultError.noResult }
    
    private let chunk: FoliageChunk
    private let prefabs: FoliageRenderOperation.Prefabs
    
    init(chunk: FoliageChunk,
         prefabs: FoliageRenderOperation.Prefabs) {
        
        self.chunk = chunk
        self.prefabs = prefabs
        
        super.init()
    }
    
    override func execute() {
        
        chunk.removeAllChildren()
        
        for tile in chunk.tiles {
            
            let mesh = prefabs.mesh(foliageType: tile.foliageType)
            
            let position = tile.footprint.origin.position.convert(to: .tile)
            let elevation = Vector(0.0, (Grid.Triangle.Kite.base * Double(tile.elevation)) + Grid.Triangle.Kite.apex, 0.0)
            
            let node = SCNNode()
            
            node.position = SCNVector3(position + elevation)
            node.geometry = SCNGeometry(mesh)
            
            chunk.addChildNode(node)
        }
        
        output = .success(())
        
        finish()
    }
}
