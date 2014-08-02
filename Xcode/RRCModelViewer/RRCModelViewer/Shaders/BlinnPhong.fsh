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

void main(void)
{
    vec3 N = normalize(vNormal);
    vec3 L = vec3(1.0, 1.0, 0.5);
    vec3 E = vec3(0.0, 0.0, 1.0);
    vec3 H = normalize(L+E);
    
    vec3 ambient = vec3(0.2);
    vec3 diffuse = vec3(0.7);
    vec3 specular = vec3(0.1);
    float exponent = 1.0;
    
    float df = max(0.0, dot(N,L));
    float sf = max(0.0, dot(N,H));
    sf = pow(sf, exponent);
    
    vec3 surface = ambient + (df*diffuse) + (sf*specular);
    vec3 texture = vec3(texture2D(uTexture, vTexel));
    
    vec3 color = surface;
    if(uSwitchTexture)
        color *= texture;
    
    float alpha = 1.0;
    if(uSwitchXRay)
        alpha = 0.5;
    
    gl_FragColor = vec4(color, alpha);
}
