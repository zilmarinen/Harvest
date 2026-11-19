//
//  shaders.metal
//  Harvest
//
//  Created by Zack Brown on 18/11/2026.
//

#include <metal_stdlib>
using namespace metal;

// MARK: Constants

constant float lineWidth = 1.0;

constant float sqrt3 = 1.7320508076;   // sqrt(3.0)
constant float sqrt3d2 = 0.8660254038; // sqrt(3.0) / 2.0
constant float sqrt3d3 = 0.5773502692; // sqrt(3.0) / 3.0

constant float pid4 = 0.7853981634; // pi / 4

constant float sqrt3m1d2 = 0.36602540378;
constant float sqrt3m3d6 = 0.211324865;

// MARK: Camera

struct Camera {
    
    float2 position;
    float  scale;
    float2 viewport;
    
};

// MARK: Cursor

struct Cursor {
    
    float2 corner0;
    float2 corner1;
    float2 corner2;
    
};

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
           float size,
           float scale) {
    
    float c = cos(-pid4);
    float s = sin(-pid4);
    float invSize = 1.0 / size;
    
    float2 offset = float2(0.0, 0.0);
    
    float2x2 rotation = float2x2(c, -s, s, c);
    
    float2 position = (rotation * ((worldXZ * sqrt3d3) + offset)) * invSize;
    
    float2 index = floor(position + (position.x + position.y) * sqrt3m1d2);
    float2 corner = index + (index.x + index.y) * -sqrt3m3d6;
    
    float2 relative = position - corner;
    
    float side = relative.x > relative.y ? 0.0 : 1.0;
    
    float2 derivative = float2(1.0 - side, side);
    
    float2 c0 = float2(0.0, 0.0);
    float2 c2 = derivative + float2(-sqrt3m3d6);
    float2 c1 = float2(1.0) + 2.0 * -sqrt3m3d6;
    
    float sdf = triangleSDF(relative, c0, c1, c2) * size * scale / lineWidth;
    
    float outline = abs(sdf) - 0.5;
    
    return 1.0 - smoothstep(-0.5,
                            0.5,
                            outline);
}

// MARK: Cursor

float cursorOutline(float2 worldXZ,
                    Cursor cursor,
                    float scale) {
    
    float sdf = triangleSDF(worldXZ,
                            cursor.corner0,
                            cursor.corner1,
                            cursor.corner2) * scale / lineWidth;
    
    float outline = abs(sdf) - 0.5;
    
    return 1.0 - smoothstep(-0.5,
                            0.5,
                            outline);
}

// MARK: Editor Pass

struct EditorVertexOutput {
    
    float4 position [[position]];
    
};

vertex EditorVertexOutput editorVertex(uint id [[vertex_id]]) {
    
    float2 position = float2((id << 1) & 2,
                             id & 2);
    
    EditorVertexOutput out;
    
    out.position = float4(position * 2.0 - 1.0,
                          0.0,
                          1.0);
    
    return out;
}

fragment float4 editorFragment(EditorVertexOutput in [[stage_in]],
                               constant Camera &camera [[buffer(0)]],
                               constant Cursor &cursor [[buffer(1)]],
                               constant float &showGrid [[buffer(2)]],
                               constant float4 &background [[buffer(3)]]) {
    
    float2 pixel = in.position.xy;
    
    float2 world = (pixel - 0.5 * camera.viewport) / camera.scale + camera.position;
    
    float4 color = background;
    
    if (showGrid > 0.5) {
        
        float g = grid(world,
                       camera.scale,
                       camera.scale);
        
        color = mix(color,
                    float4(1.0, 1.0, 1.0, 1.0),
                    float4(g, g, g, g));
    }
    
    float c = cursorOutline(world,
                            cursor,
                            camera.scale);
    
    color = mix(color,
                float4(1.0, 0.0, 0.8, 1.0),
                float4(c, c, c, c));
    
    return color;
}

// MARK: Mesh Pass

struct MeshVertex {
    
    float2 position;
    float4 color;
    
};

struct MeshVertexOutput {
    
    float4 position [[position]];
    float4 color;
    
};

vertex MeshVertexOutput meshVertex(uint id [[vertex_id]],
                                   constant Camera &camera [[buffer(0)]],
                                   device const MeshVertex *vertices [[buffer(1)]]) {
    
    MeshVertex v = vertices[id];
    
    float2 pixel = (v.position - camera.position) * camera.scale + 0.5 * camera.viewport;
    
    float2 clip = (2.0 * float2(pixel.x,
                                camera.viewport.y - pixel.y) / camera.viewport) - 1.0;
    
    MeshVertexOutput out;
    
    out.position = float4(clip,
                          0.0,
                          1.0);
    out.color = v.color;
    
    return out;
}

fragment float4 meshFragment(MeshVertexOutput in [[stage_in]]) {
    
    return in.color;
}

