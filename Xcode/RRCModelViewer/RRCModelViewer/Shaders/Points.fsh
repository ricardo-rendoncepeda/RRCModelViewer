// Fragment Shader

static GLchar* const PointsFSH = STRINGIFY
(
 void main(void)
 {
     gl_FragColor = vec4(vec3(0.0), 1.0);
 }
);