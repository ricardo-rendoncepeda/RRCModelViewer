// Fragment Shader

static char* const BlinnPhongFSH = STRINGIFY
(
// Varying
 varying highp vec3 vNormal;
 varying highp vec2 vTexel;
 
 // Uniforms
 uniform sampler2D uTexture;
 
 void main(void)
 {
     highp vec3 N = normalize(vNormal);
     highp vec3 L = vec3(1.0, 1.0, 0.5);
     highp vec3 E = vec3(0.0, 0.0, 1.0);
     highp vec3 H = normalize(L+E);
     
     lowp vec3 ambient = vec3(0.2);
     lowp vec3 diffuse = vec3(0.7);
     lowp vec3 specular = vec3(0.1);
     highp float exponent = 1.0;
     
     highp float df = max(0.0, dot(N,L));
     highp float sf = max(0.0, dot(N,H));
     sf = pow(sf, exponent);
     
     lowp vec3 surface = ambient + (df*diffuse) + (sf*specular);
     lowp vec3 texture = vec3(texture2D(uTexture, vTexel));
     
     gl_FragColor = vec4(surface*texture, 0.5);
 }
);