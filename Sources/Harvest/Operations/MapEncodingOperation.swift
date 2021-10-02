//
//  MapEncodingOperation.swift
//
//  Created by Zack Brown on 29/09/2021.
//

import Foundation
import PeakOperation

public class MapEncodingOperation: ConcurrentOperation, ProducesResult {
 
    public var output: Result<Data, Error> = Result { throw ResultError.noResult }
    
    let map: Map2D
    
    public init(map: Map2D) {
        
        self.map = map
        
        super.init()
    }
    
    public override func execute() {
        
        do {
            
            let data = try JSONEncoder().encode(map)
            
            output = .success(data)
        }
        catch {
            
            output = .failure(error)
        }
        
        finish()
    }
}
