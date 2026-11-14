//
//  grid.fsh
//  Harvest
//
//  Created by Zack Brown on 12/11/2026.
//

constant float lineWidth = 1.0;
constant float pid4 = 0.7853981634; // pi / 4
constant float sqrt2d3 = 0.4714045208;
constant float sqrt3d2 = 0.8660254038;
constant float sqrt3m1d2 = 0.36602540378;
constant float sqrt3m3d6 = 0.211324865;

//float dot2(vec2 v) {
//    
//    return dot(v, v);
//}
//
//float triangleSDF(vec2 p,
//                  vec2 c0,
//                  vec2 c1,
//                  vec2 c2) {
//    
//    vec2 p0 = c1 - c0;
//    vec2 p1 = c2 - c1;
//    vec2 p2 = c0 - c2;
//    
//    vec2 v0 = p - c0;
//    vec2 v1 = p - c1;
//    vec2 v2 = p - c2;
//    
//    float d0 = dot2(v0 - p0 * clamp(dot(v0, p0) / dot2(p0), 0.0, 1.0));
//    float d1 = dot2(v1 - p1 * clamp(dot(v1, p1) / dot2(p1), 0.0, 1.0));
//    float d2 = dot2(v2 - p2 * clamp(dot(v2, p2) / dot2(p2), 0.0, 1.0));
//    
//    float o = p0.x * p2.y - p0.y * p2.x;
//    
//    vec2 d = min(min(vec2(d0, o * (v0.x * p0.y - v0.y * p0.x)),
//                     vec2(d1, o * (v1.x * p1.y - v1.y * p1.x))),
//                     vec2(d2, o * (v2.x * p2.y - v2.y * p2.x)));
//    
//    return -sqrt(d.x) * sign(d.y);
//}
//
//float world_grid(vec2 worldXZ,
//                 float size) {
//    
//    float c = cos(pid4);
//    float s = sin(pid4);
//    float scale = 1.0 / size;
//    
//    vec2 offset = vec2((sqrt2d3 * 2.0) * size, 0.0);
//    
//    mat2 rotation = mat2(c, -s, s, c);
//    
//    vec2 position = (rotation * ((worldXZ * sqrt2d3) + offset)) * scale;
//    
//    vec2 index = floor(position + (position.x + position.y) * sqrt3m1d2);
//    vec2 corner = index + (index.x + index.y) * -sqrt3m3d6;
//    
//    vec2 relative = position - corner;
//    
//    float side = relative.x > relative.y ? 0.0 : 1.0;
//    
//    vec2 derivative = vec2(1.0 - side, side);
//    
//    vec2 c0 = vec2(0.0, 0.0);
//    vec2 c2 = derivative + vec2(-sqrt3m3d6);
//    vec2 c1 = vec2(1.0) + 2.0 * -sqrt3m3d6;
//    
//    float sdf = triangleSDF(relative, c0, c1, c2) * size / lineWidth;
//    
//    float outline = abs(sdf) - 0.5;
//    
//    return 1.0 - smoothstep(-0.5,
//                            0.5,
//                            outline);
//}
//
//void main() {
//    
//    float grid = world_grid(gl_FragCoord.xy, lattice);
//    
//    vec4 black = vec4(0.0, 0.0, 0.0, 1.0);
//    vec4 background = vec4(1.0, 1.0, 1.0, 1.0);
//    
//    gl_FragColor = mix(background, black, grid);
//}

float triLineDistance(vec2 p, vec2 n, float spacing) {
    float t = dot(p, n) / spacing;
    return abs(fract(t + 0.5) - 0.5) * spacing;
}

float triLineCoverage(float dist, float width) {
    return clamp(0.5 * width + 0.5 - dist, 0.0, 1.0);
}

void main() {
    float cellSize  = 32.0;           // triangle edge length, in pixels
    float lineWidth = 1.0;            // in pixels
    float sqrt3d2   = 0.8660254038;   // sqrt(3) / 2

    // Move pixel centres onto whole numbers so horizontal lines are crisp.
    // Works with Metal's top-left origin as well as OpenGL's bottom-left.
    vec2 p = gl_FragCoord.xy - vec2(0.5, 0.5);

    float spacing = lattice;// * sqrt3d2;

    vec2 n0 = vec2(0.0, 1.0);
    vec2 n1 = vec2(sqrt3d2, 0.5);
    vec2 n2 = vec2(-sqrt3d2, 0.5);

    float c0 = triLineCoverage(triLineDistance(p, n0, spacing), lineWidth);
    float c1 = triLineCoverage(triLineDistance(p, n1, spacing), lineWidth);
    float c2 = triLineCoverage(triLineDistance(p, n2, spacing), lineWidth);

    float grid = max(c0, max(c1, c2));

    vec3 background = vec3(0.117647, 0.117647, 0.117647);
    vec3 lineColor  = vec3(0.35);

    vec3 rgb = mix(background, lineColor, grid);
    float alpha = 1.0;

    gl_FragColor = vec4(rgb * alpha, alpha);   // premultiplied
}
