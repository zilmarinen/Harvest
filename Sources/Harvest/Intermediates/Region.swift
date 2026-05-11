//
//  Region.swift
//
//  Created by Zack Brown on 13/09/2025.
//

import Deltille
import Lattice

@MainActor
//TODO: Rename to RegionSlice?
public struct Region: Codable,
                      @preconcurrency Equatable,
                      @preconcurrency Hashable {

    public let vertex: Triangle.Vertex
    
    public let buildings: TriangularLatticeSlice<BuildingChunk, BuildingTile>?
    public let fences: HexagonalLatticeSlice<FenceChunk, FenceVertex>?
    public let foliage: TriangularLatticeSlice<FoliageChunk, FoliageTile>?
    public let footpaths: HexagonalLatticeSlice<FootpathChunk, FootpathVertex>?
    public let portals: TriangularLatticeSlice<PortalChunk, PortalTile>?
    public let slopes: TriangularLatticeSlice<SlopeChunk, SlopeTile>?
    public let terrain: HexagonalLatticeSlice<TerrainChunk, TerrainVertex>?
    public let water: TriangularLatticeSlice<WaterChunk, WaterTile>?
    
    public func hash(into hasher: inout Hasher) {
        
        hasher.combine(vertex)
    }
    
    public static func == (lhs: Region,
                           rhs: Region) -> Bool {
        
        lhs.vertex == rhs.vertex
    }
}

extension Region {
    
    public var isEmpty: Bool {
        
        (terrain?.isEmpty ?? true) &&
        (water?.isEmpty ?? true)
    }
}

extension Region {
    
    public func remove(tiles region: Triangle) {
        
        let sieve = region.sieve(for: .region)
        
        let triangles = sieve.triangles.map { $0.vertex }
        let vertices = sieve.vertices
        
        buildings?.remove(values: triangles)
        fences?.remove(values: vertices)
        foliage?.remove(values: triangles)
        footpaths?.remove(values: vertices)
        portals?.remove(values: triangles)
        slopes?.remove(values: triangles)
        terrain?.remove(values: vertices)
        water?.remove(values: triangles)
    }
}

extension Region {
    
    public init(empty triangle: Triangle) {
        
        self.init(vertex: triangle.vertex,
                  buildings: nil,
                  fences: nil,
                  foliage: nil,
                  footpaths: nil,
                  portals: nil,
                  slopes: nil,
                  terrain: .init(empty: triangle),
                  water: nil)
    }
}
