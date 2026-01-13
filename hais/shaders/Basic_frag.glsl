#version 460

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
in vec2 lightmapCoords;
in vec3 geoNormal;
in vec4 tangent;
in vec3 viewSpacePosition;

mat3 tbnNormalTangent(vec3 normal, vec3 tangent) {

    vec3 bitangent = cross(tangent, normal);
    return mat3(tangent, bitangent, normal);
}

void main() {

    
    vec4 outputColorData = texture(gtexture,texCoord);
    vec3 outputColor = pow(outputColorData.rgb,vec3(2.2)) * pow(foliageColor,vec3(2.2));
    float transparency = outputColorData.a;
    
    if (transparency < .1) {
        discard;
    }


    vec3 shadowLightDirection = normalize(mat3(gbufferModelViewInverse)* shadowLightPosition);

    vec3 worldGeoNormal = mat3(gbufferModelViewInverse)* geoNormal;

    vec3 worldTangent = mat3(gbufferModelViewInverse)* tangent.xyz;

    vec4 normalData = texture(normals,texCoord)*2.0-1.0;

    vec3 normalNormalSpace = vec3(normalData.xy, sqrt(1.0 - dot(normalData.xy, normalData.xy)));
    
    mat3 TBN = tbnNormalTangent(worldGeoNormal, worldTangent);

    vec3 normalWorldSpace = TBN * normalNormalSpace;

    vec4 specularData = texture(specular, texCoord);

    float perceptualSmoothness = specularData.r;
    
    float roughness = pow(1.0 - perceptualSmoothness, 2.0);

    float smoothness = 1-roughness;

    vec3 reflectionDirection = reflect(-shadowLightDirection,normalWorldSpace);

    vec3 fragFeetPlayerSpace = (gbufferModelViewInverse * vec4(viewSpacePosition, 1.0)).xyz;

    vec3 fragWorldSpace = fragFeetPlayerSpace + cameraPosition;

    vec3 viewDir = normalize(cameraPosition - fragWorldSpace);

    float diffuseLight = roughness* clamp(dot(shadowLightDirection,normalWorldSpace),0.0,1.0);

    float shininess = (1+(smoothness)*100);

    float specularLight = clamp(smoothness*pow(dot(reflectionDirection,viewDir),shininess),0,1);

    float ambientLight = .2;

    float lightBrightness = ambientLight + diffuseLight + specularLight;

    vec3 lightColor = pow(texture(lightmap, lightmapCoords).rgb,vec3(2.2));


    outputColor *= lightBrightness * lightColor;
    outColor0 = vec4(pow(outputColor, vec3(1/2.2)), transparency);

}