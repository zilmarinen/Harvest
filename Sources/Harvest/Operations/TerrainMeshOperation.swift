//
//  TerrainMeshOperation.swift  
//
//  Created by Zack Brown on 10/09/2023.
//

import Euclid
import Foundation
import PeakOperation
import SceneKit

internal class TerrainMeshOperation: ConcurrentOperation,
                                     ConsumesResult {
    
    public var input: Result<TerrainKiteMeshOperation.Prefabs, Error> = Result { throw ResultError.noResult }
    
    private let chunks: [TerrainChunk]
    private let heightMap: TerrainHeightMap
    
    init(chunks: [TerrainChunk],
         heightMap: TerrainHeightMap) {
        
        self.chunks = chunks
        self.heightMap = heightMap
        
        super.init()
    }
    
    override func execute() {
        
        let group = DispatchGroup()
        
        do {
            
            let prefabs = try input.get()
            
            for chunk in chunks {
                
                let operation = TerrainChunkMeshOperation(chunk: chunk,
                                                          heightMap: heightMap,
                                                          prefabs: prefabs)
                
                group.enter()
                
                operation.enqueue(on: internalQueue) { result in
                    
                    switch result {
                        
                    case .success(let mesh):
                        
                        chunk.geometry = SCNGeometry(mesh)
                        
                        let node = SCNNode()
                        
                        node.geometry = SCNGeometry(wireframe: mesh)
                        
                        chunk.addChildNode(node)
                        
                    case .failure(let error): fatalError(error.localizedDescription)
                    }
                    
                    group.leave()
                }
            }
        }
        catch {
            
            fatalError(error.localizedDescription)
        }
        
        group.wait()
        
        finish()
    }
}

