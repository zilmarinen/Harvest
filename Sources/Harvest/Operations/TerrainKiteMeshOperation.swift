//
//  TerrainKiteMeshOperation.swift
//
//  Created by Zack Brown on 10/09/2023.
//

import Bivouac
import Euclid
import Foundation
import PeakOperation
import Regolith

internal class TerrainKiteMeshOperation: ConcurrentOperation,
                                         ProducesResult {
    
    internal struct Prefabs {
        
        var meshes: [String : Mesh] = [:]
        
        internal func mesh(for kite: Grid.Triangle.Kite,
                           elevation: Grid.Triangle.Kite.Elevation,
                           terrainType: TerrainType) -> Mesh {
            
            return meshes["\(kite.id)_\(elevation.id)_\(terrainType.id)"] ?? Mesh([])
        }
        
        internal mutating func append(mesh: Mesh,
                                      kite: Grid.Triangle.Kite,
                                      elevation: Grid.Triangle.Kite.Elevation,
                                      terrainType: TerrainType) {
            
            meshes["\(kite.id)_\(elevation.id)_\(terrainType.id)"] = mesh
        }
    }
    
    public var output: Result<Prefabs, Error> = Result { throw ResultError.noResult }
    
    private let triangle = Grid.Triangle(.zero)
    private var stencil: Grid.Triangle.Stencil { triangle.stencil(for: .tile) }
    
    override func execute() {
        
        internalQueue.maxConcurrentOperationCount = 1
        
        let group = DispatchGroup()
        
        var prefabs = Prefabs()
        
        for terrainType in TerrainType.allCases {
            
            for elevation in Grid.Triangle.Kite.Elevation.allCases {
        
                for kite in Grid.Triangle.Kite.allCases {
                
                    let operation = KiteMeshOperation(kite: kite,
                                                      colorPalette: terrainType.colorPalette,
                                                      elevation: elevation,
                                                      stencil: stencil)
                    
                    group.enter()
                    
                    operation.enqueue(on: internalQueue) { result in
                        
                        switch result {
                            
                        case .success(let mesh): prefabs.append(mesh: mesh,
                                                                kite: kite,
                                                                elevation: elevation,
                                                                terrainType: terrainType)
                            
                        case .failure(let error): fatalError(error.localizedDescription)
                        }
                        
                        group.leave()
                    }
                }
            }
        }
        
        group.wait()
        
        output = .success(prefabs)
        
        finish()
    }
}
