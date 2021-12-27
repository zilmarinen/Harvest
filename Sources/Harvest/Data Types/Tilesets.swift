//
//  Tilesets.swift
//
//  Created by Zack Brown on 07/10/2021.
//

import Foundation

public struct Tilesets {
    
    //let footpath: FootpathTileset
    let surface: SurfaceTileset
    
    public init() throws {
     
        do {
        
            //footpath = try FootpathTileset()
            surface = try SurfaceTileset()
        }
        catch {
            
            throw(error)
        }
    }
}
