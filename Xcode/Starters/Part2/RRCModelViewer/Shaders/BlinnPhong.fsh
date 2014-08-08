// FRAGMENT SHADER

// Precision
precision highp float;

// Varying
varying vec3 vNormal;
varying vec2 vTexel;

// Uniforms
uniform sampler2D uTexture;
uniform bool uSwitchTexture;
uniform bool uSwitchXRay;

vec4 calculateSurface(void)
{
    vec3 normal = normalize(vNormal);
    vec3 light = vec3(1.0, 1.0, 0.5);
    vec3 eye = vec3(0.0, 0.0, 1.0);
    vec3 halfway = normalize(light+eye);
    
    vec3 ambient = vec3(0.2, 0.2, 0.2);
    vec3 diffuse = vec3(0.8, 0.8, 0.8);
    vec3 specular = vec3(0.4, 0.4, 0.4);
    float exponent = 128.0;
    
    float df = max(0.0, dot(normal, light));
    float sf = max(0.0, dot(normal, halfway));
    sf = pow(sf, exponent);
    
    vec3 shading = ambient + (df*diffuse) + (sf*specular);
    
    return vec4(shading, 1.0);
}

void main(void)
{
    vec4 surface = calculateSurface();
    vec4 texture = texture2D(uTexture, vTexel);
    
    vec4 color = surface*texture;
    gl_FragColor = color;
}
