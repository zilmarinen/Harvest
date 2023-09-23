//
//  FoliageTilingOperation.swift
//
//  Created by Zack Brown on 22/09/2023.
//

import Euclid
import Foundation
import PeakOperation
import SceneKit

internal class FoliageTilingOperation: ConcurrentOperation,
                                       ConsumesResult {
    
    public var input: Result<FoliageRenderOperation.Prefabs, Error> = Result { throw ResultError.noResult }
    
    private let chunks: [FoliageChunk]
    
    init(chunks: [FoliageChunk]) {
        
        self.chunks = chunks
        
        super.init()
    }
    
    override func execute() {
        
        let group = DispatchGroup()
        
        do {
            
            let prefabs = try input.get()
            
            for chunk in chunks {
                
                let operation = FoliageChunkMeshOperation(chunk: chunk,
                                                          prefabs: prefabs)
                
                group.enter()
                
                operation.enqueue(on: internalQueue) { result in
                    
                    switch result {
                    case .failure(let error): fatalError(error.localizedDescription)
                    default: break
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

