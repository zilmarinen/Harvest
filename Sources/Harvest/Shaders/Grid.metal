//
//  Grid.metal
//  Harvest
//
//  Created by Zack Brown on 18/11/2026.
//

#include "Harvest.metal"

// MARK: Constants

constant float lineWidth = 0.1;

constant float sqrt2d3 = 0.4714045208;    // sqrt(2.0) / 3.0
constant float pid4 = 0.7853981634;       // pi / 4.0

constant float sqrt3m1d2 = 0.36602540378; // sqrt(3.0) - 1.0 / 2.0
constant float sqrt3m3d6 = 0.211324865;   // abs(sqrt(3.0) - 3.0 / 6.0)

constant float4 background = float4(0.298, 0.2705, 0.2549, 1.0);

// MARK: Signed Distance

// Signed distance from point p to the triangle (c0, c1, c2).
// Negative inside the triangle, positive outside.
float triangleSDF(float2 p,
                  float2 c0,
                  float2 c1,
                  float2 c2) {
    
    float2 p0 = c1 - c0;
    float2 p1 = c2 - c1;
    float2 p2 = c0 - c2;
    
    float2 v0 = p - c0;
    float2 v1 = p - c1;
    float2 v2 = p - c2;
    
    float2 d0 = v0 - p0 * clamp(dot(v0, p0) / dot(p0, p0), 0.0, 1.0);
    float2 d1 = v1 - p1 * clamp(dot(v1, p1) / dot(p1, p1), 0.0, 1.0);
    float2 d2 = v2 - p2 * clamp(dot(v2, p2) / dot(p2, p2), 0.0, 1.0);
    
    float o = p0.x * p2.y - p0.y * p2.x;
    
    float2 d = min(min(float2(dot(d0, d0), o * (v0.x * p0.y - v0.y * p0.x)),
                       float2(dot(d1, d1), o * (v1.x * p1.y - v1.y * p1.x))),
                       float2(dot(d2, d2), o * (v2.x * p2.y - v2.y * p2.x)));
    
    return -sqrt(d.x) * sign(d.y);
}

// MARK: Grid

float grid(float2 worldXZ,
           float length) {
    
    float c = cos(-pid4);
    float s = sin(-pid4);
    float scale = 1.0 / length;
    
    float2 offset = float2(0.0, (sqrt2d3 * 2.0) * length);
    
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

// MARK: Grid Vertex

vertex Fragment gridVertex(uint id [[vertex_id]]) {
    
    //generate a triangle that extends beyond clip space
    float2 position = float2((id << 1) & 2,
                             id & 2);
    
    return { .position = float4(position * 2.0 - 1.0, 0.0, 1.0) };
}

// MARK: Grid Fragment

fragment float4 gridFragment(Fragment in [[stage_in]],
                             constant float2 &camera [[buffer(0)]],
                             constant float2 &viewport [[buffer(1)]],
                             constant float &lattice [[buffer(2)]],
                             constant float &drawGrid [[buffer(3)]]) {
    
    float2 pixel = in.position.xy;
    
    float2 world = (pixel - 0.5 * viewport) / lattice + camera;
    
    float g = drawGrid > 0.5 ? grid(world,
                                    lattice) : 0.0;
    
    float4 line = float4((1.0 - background) / 2.0);

    return mix(background,
               line,
               g);
}

// MARK: Mesh Vertex

vertex Fragment meshVertex(uint id [[vertex_id]],
                           constant float2 &camera [[buffer(0)]],
                           constant float2 &viewport [[buffer(1)]],
                           constant float &lattice [[buffer(2)]],
                           device const Vertex *vertices [[buffer(3)]]) {

    Vertex v = vertices[id];

    float2 pixel = (v.position - camera) * lattice + 0.5 * viewport;

    float2 clip = (2.0 * float2(pixel.x,
                                viewport.y - pixel.y) / viewport) - 1.0;

    return { .position = float4(clip, 0.0, 1.0),
             .color = v.color };
}

// MARK: Mesh Fragment

fragment float4 meshFragment(Fragment in [[stage_in]]) {

    return in.color;
}
