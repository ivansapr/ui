#version 460 core
precision highp float;

#include <flutter/runtime_effect.glsl>

// A 2-dimentional vector representing the width & height,
// respectively of the area the shader is being applied to
uniform vec2 uSize;

uniform float uTime;
// The input image sampler the shader will be applied to
uniform sampler2D tInput;

// A 4-dimentional vector corresponding to the R,G, B, and A channels
// of the color to be returned from this shader for every pixel
out vec4 fragColor;

void main()
{
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 cp = -1.0 + 2.0 * fragCoord / uSize.xy;
    float cl = length(cp);
    vec2 uv = fragCoord / uSize.xy + (cp / cl) * cos(cl * 1.0 - uTime * 10.0 ) * 0.02;
    uv = (uv - 0.5) * 1 + 0.5;
    fragColor = texture(tInput, uv);
}