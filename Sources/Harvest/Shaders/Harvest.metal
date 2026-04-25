//
//  Harvest.metal
//  Harvest
//
//  Created by Zack Brown on 26/02/2026.
//

#ifndef Harvest
#define Harvest

#include <metal_stdlib>
#include <RealityKit/RealityKit.h>
#include <simd/simd.h>

using namespace metal;
using namespace realitykit;

//
//  Constants
//

constant float pi = 3.14159265358979;
constant float pid4 = 0.7853981634; // pi / 4
constant float sqrt2 = 1.4142135624;
constant float sqrt2d3 = 0.4714045208;
constant float sqrt3 = 1.7320508076;
constant float sqrt3d2 = 0.8660254038;
constant float sqrt3d3 = 0.5773502692;
constant float sqrt3d6 = 0.2886751346;

constant float sqrt3m1d2 = 0.36602540378;
constant float sqrt3m3d6 = 0.211324865;

constant float4 regionColor = float4(0.0509, 0.4509, 0.3019, 1.0);
constant float4 chunkColor = float4(0.949, 0.7294, 0.3215, 1.0);
constant float4 tileColor = float4(0.349, 0.145, 0.098, 1.0);

constant float lineWidth = 0.01;

//
//  Utilities
//

inline float dot2(float2 v) {
    
    return dot(v, v);
}

inline float triangleSDF(float2 p,
                         float2 c0,
                         float2 c1,
                         float2 c2) {
    
    float2 p0 = c1 - c0;
    float2 p1 = c2 - c1;
    float2 p2 = c0 - c2;
    
    float2 v0 = p - c0;
    float2 v1 = p - c1;
    float2 v2 = p - c2;
    
    float d0 = dot2(v0 - p0 * clamp(dot(v0, p0) / dot2(p0), 0.0, 1.0));
    float d1 = dot2(v1 - p1 * clamp(dot(v1, p1) / dot2(p1), 0.0, 1.0));
    float d2 = dot2(v2 - p2 * clamp(dot(v2, p2) / dot2(p2), 0.0, 1.0));
    
    float o = p0.x * p2.y - p0.y * p2.x;
    
    float2 d = min(min(float2(d0, o * (v0.x * p0.y - v0.y * p0.x)),
                       float2(d1, o * (v1.x * p1.y - v1.y * p1.x))),
                   float2(d2, o * (v2.x * p2.y - v2.y * p2.x)));
    
    return -sqrt(d.x) * sign(d.y);
}

inline float world_grid(float2 worldXZ,
                        float length) {
    
    float c = cos(pid4);
    float s = sin(pid4);
    float scale = 1.0 / length;
    
    float2 offset = float2((sqrt2d3 * 2.0) * length, 0.0);
    
    float2x2 rotation = float2x2(c, -s, s, c);
    
    float2 position = (rotation * ((worldXZ * sqrt2d3) + offset)) * scale;
    
    float2 index = floor(position + (position.x + position.y) * sqrt3m1d2);
    float2 corner = index + (index.x + index.y) * -sqrt3m3d6;
    
    float2 relative = position - corner;
    
    float side = relative.x > relative.y ? 0.0 : 1.0;
    
    float2 derivative = float2(1.0 - side, side);
    
    float2 c0 = float2(0.0, 0.0);
    float2 c2 = derivative + float2(-sqrt3m3d6);
    float2 c1 = float2(1.0) + 2.0 * -sqrt3m3d6;
    
    float sdf = triangleSDF(relative, c0, c1, c2) * length / lineWidth;
    
    float outline = abs(sdf) - 0.5;
    
    return 1.0 - smoothstep(-0.5,
                            0.5,
                            outline);
}

#endif
