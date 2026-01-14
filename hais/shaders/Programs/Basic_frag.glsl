

uniform sampler2D gtexture;
uniform sampler2D lightmap;
uniform sampler2D normals;
uniform sampler2D specular;

uniform vec3 cameraPosition;
uniform vec3 shadowLightPosition;
uniform mat4 gbufferModelViewInverse;
uniform mat4 modelViewMatrixInverse;

/*DRAWBUFFERS: 0 */
layout(location = 0) out vec4 outColor0;

in vec2 texCoord;
in vec3 foliageColor;


void main() {

    
    vec4 outputColorData = texture(gtexture,texCoord);
    vec3 albedo = pow(outputColorData.rgb,vec3(2.2)) * pow(foliageColor,vec3(2.2));
    float transparency = outputColorData.a;


   
    outColor0 = vec4(pow(albedo, vec3(1/2.2)), transparency);

}