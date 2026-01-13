#version 460

in vec3 vaPosition;
in vec4 vaColor;
in vec2 vaUV0;
in ivec2 vaUV2;
in vec3 vaNormal;
in vec4 at_tangent;


uniform vec3 chunkOffset;
uniform vec3 cameraPosition;
uniform mat4 modelViewMatrix;
uniform mat4 gbufferModelViewInverse;
uniform mat4 projectionMatrix;
uniform mat3 normalMatrix;

out vec2 texCoord;
out vec2 lightmapCoords;
out vec3 foliageColor;
out vec3 viewSpacePosition;
out vec3 geoNormal;
out vec4 tangent;

void main() {

    tangent = vec4(normalize(normalMatrix* at_tangent.rgb), at_tangent.a);

    vec3 worldGeoNormal = mat3(gbufferModelViewInverse)* geoNormal;

    geoNormal = normalMatrix* vaNormal;

    texCoord = vaUV0;
    foliageColor = vaColor.rgb;
    lightmapCoords = vaUV2* (1.0 / 256.0) + (1.0 / 32.0);

    vec4 viewSpacePositionVec4 = modelViewMatrix * vec4(vaPosition+chunkOffset,1);
    viewSpacePosition = viewSpacePositionVec4.rgb;


    gl_Position = projectionMatrix* viewSpacePositionVec4;
}