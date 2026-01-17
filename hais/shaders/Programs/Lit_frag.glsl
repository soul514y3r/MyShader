#version 460

 // [512 1024 2048 4096 8192]

uniform sampler2D gtexture;
uniform sampler2D lightmap;
uniform sampler2D normals;
uniform sampler2D specular;
uniform sampler2D depthtex0;
uniform sampler2D shadowtex0;
uniform sampler2D shadowcolor0;
uniform sampler2D shadowtex1;

uniform vec3 cameraPosition;
uniform vec3 shadowLightPosition;
uniform mat4 gbufferModelViewInverse;
uniform mat4 modelViewMatrixInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;
uniform float viewWidth;
uniform float viewHeight;

/*DRAWBUFFERS: 0 */
layout(location = 0) out vec4 outColor0;


in vec2 texCoord;
in vec3 foliageColor;
in vec2 lightmapCoords;
in vec3 geoNormal;
in vec4 tangent;
in vec3 viewSpacePosition;

#include "/Programs/Functions.glsl"


void main() {
    
    vec4 outputColorData = texture(gtexture,texCoord);
    vec3 albedo = pow(outputColorData.rgb,vec3(2.2)) * pow(foliageColor,vec3(2.2));
    float transparency = outputColorData.a;
    
    if (transparency < .1) {
        discard;
    }

    vec3 outputColor = lightingCalculations(albedo);

    outColor0 = vec4(pow(outputColor, vec3(1/2.2)), transparency);

}