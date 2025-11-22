//
//  HexagonalDataSource.swift
//
//  Created by Zack Brown on 22/11/2025.
//

internal class HexagonalDataSource<V: Codable>: HexagonalGrid<HexagonalRegion<HexagonalChunk<V>, V>,
                                                HexagonalChunk<V>,
                                                V> {}
