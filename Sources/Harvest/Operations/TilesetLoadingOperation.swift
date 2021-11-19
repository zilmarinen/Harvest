//
//  TilesetLoadingOperation.swift
//
//  Created by Zack Brown on 07/10/2021.
//

import Meadow
import PeakOperation

public class TilesetLoadingOperation: ConcurrentOperation, ProducesResult {
    
    public var output: Result<Tilesets, Error> = Result { throw ResultError.noResult }
    
    public override func execute() {
        
        do {
            
            let tileset = try Tilesets()
            
            output = .success(tileset)
        }
        catch {
            
            output = .failure(error)
        }
        
        finish()
    }
}
