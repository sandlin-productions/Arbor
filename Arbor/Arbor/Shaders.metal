//
//  Shaders.metal
//  Arbor
//
//  Created by Stephen Sandlin on 5/21/23.
//

#include <metal_stdlib>
using namespace metal;

// Vertex structure
struct VertexIn {
    float4 position [[attribute(0)]];
};

struct VertexOut {
    float4 position [[position]];
    float4 color;
};

// Vertex Shader
vertex VertexOut vertexShader(VertexIn in [[stage_in]]) {
    VertexOut out;

    // Simple scale matrix to "zoom out"
    float4x4 scaleMatrix = float4x4(
        float4(0.3, 0.0, 0.0, 0.0),
        float4(0.0, 0.3, 0.0, 0.0),
        float4(0.0, 0.0, 1.0, 0.0),
        float4(0.0, 0.0, 0.0, 1.0)
    );

    out.position = scaleMatrix * in.position;
    out.color = float4(0.4, 0.2, 0.1, 1.0); // Brownish color
    return out;
}
// Fragment Shader
fragment float4 fragmentShader(VertexOut in [[stage_in]]) {
    return in.color; // Output the branch color
}
