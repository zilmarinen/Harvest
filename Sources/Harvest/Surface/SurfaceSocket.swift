//
//  SurfaceSocket.swift
//
//  Created by Zack Brown on 16/11/2021.
//

public struct SurfaceSocket: Codable, Hashable {
    
    public var inner: Bool = false
    public var outer: Bool = false
    
    public init(inner: Bool = false, outer: Bool = false) {
        
        self.inner = inner
        self.outer = outer
    }
}
