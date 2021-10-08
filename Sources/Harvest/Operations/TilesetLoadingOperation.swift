//
//  TilesetLoadingOperation.swift
//
//  Created by Zack Brown on 07/10/2021.
//

import Meadow
import PeakOperation

public class TilesetLoadingOperation: ConcurrentOperation, ConsumesResult, ProducesResult {
    
    public var input: Result<TextureAtlas, Error> = Result { throw ResultError.noResult }
    public var output: Result<(TextureAtlas, Tilesets), Error> = Result { throw ResultError.noResult }
    
    public override func execute() {
        
        do {
            
            let atlast = try input.get()
            
            let tileset = try Tilesets()
            
            output = .success((atlast, tileset))
        }
        catch {
            
            output = .failure(error)
        }
        
        finish()
    }
}
