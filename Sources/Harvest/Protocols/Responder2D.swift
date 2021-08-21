//
//  Responder2D.swift
//
//  Created by Zack Brown on 26/04/2021.
//

import Meadow

protocol Responder2D: Soilable {
    
    var responder: Responder2D? { get }
    
    var map: Map2D? { get }
}

extension Responder2D {
    
    var responder: Responder2D? { ancestor as? Responder2D }
    
    var map: Map2D? { responder?.map }
}
