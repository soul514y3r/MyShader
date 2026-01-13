#version 460

in vec3 vaPosition;
in vec4 vaColor;
in vec2 vaUV0;


uniform vec3 chunkOffset;
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

out vec2 texCoord;
out vec3 foliageColor;


void main() {


    texCoord = vaUV0;
    foliageColor = vaColor.rgb;

    vec4 viewSpacePositionVec4 = modelViewMatrix * vec4(vaPosition+chunkOffset,1);

    gl_Position = projectionMatrix* viewSpacePositionVec4;
}