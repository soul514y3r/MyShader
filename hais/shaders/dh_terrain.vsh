#version 460 compatibility

uniform vec3 shadowLightPosition;
uniform mat4 gbufferModelViewInverse;

out vec2 texCoord;
out vec4 blockColor;
out vec2 lightmapCoords;
out vec3 viewSpacePosition;
out vec3 geoNormal;

void main() {

    vec3 shadowLightDirection = normalize(shadowLightPosition);

    vec3 worldGeoNormal = mat3(gbufferModelViewInverse)* geoNormal;

    float lightBrightness = clamp(dot(shadowLightDirection, worldGeoNormal),0.15,1.0);

    geoNormal = gl_NormalMatrix* gl_Normal;

    blockColor = gl_Color;
    lightmapCoords = (gl_TextureMatrix[2] * gl_MultiTexCoord2).xy;

    viewSpacePosition = (gl_ModelViewMatrix * gl_Vertex).xyz;

    gl_Position = ftransform();
}