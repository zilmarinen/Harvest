//
//  Harvest.metal
//  Harvest
//
//  Created by Zack Brown on 20/11/2026.
//

#ifndef HARVEST
#define HARVEST

#include <metal_stdlib>
using namespace metal;

// MARK: Fragment

struct Fragment {
    
    float4 position [[position]];
    float4 color;
};

// MARK: Vertex

struct Vertex {
    
    float2 position;
    float4 color;
};

#endif
