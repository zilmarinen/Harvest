//
//  FoliageRenderOperation.swift
//
//  Created by Zack Brown on 22/09/2023.
//

import Bivouac
import Euclid
import Foundation
import PeakOperation
import Verdure

internal class FoliageRenderOperation: ConcurrentOperation,
                                       ProducesResult {
    
    internal struct Prefabs {
        
        var meshes: [FoliageType : Mesh] = [:]
        
        internal func mesh(foliageType: FoliageType) -> Mesh {
            
            return meshes[foliageType] ?? Mesh([])
        }
        
        internal mutating func append(mesh: Mesh,
                                      foliageType: FoliageType) {
            
            meshes[foliageType] = mesh
        }
    }
    
    public var output: Result<Prefabs, Error> = Result { throw ResultError.noResult }
    
    override func execute() {
        
        internalQueue.maxConcurrentOperationCount = 1
        
        let group = DispatchGroup()
        
        var prefabs = Prefabs()
        
        for foliageType in FoliageType.allCases {
            
            let operation = FoliageMeshOperation(foliageType: foliageType)
            
            group.enter()
            
            operation.enqueue(on: internalQueue) { result in

                switch result {

                case .success(let mesh): prefabs.append(mesh: mesh,
                                                        foliageType: foliageType)

                case .failure(let error): fatalError(error.localizedDescription)
                }

                group.leave()
            }
        }
        
        group.wait()
        
        output = .success(prefabs)
        
        finish()
    }
}
