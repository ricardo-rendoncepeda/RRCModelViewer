// Vertex Shader

static char* const LinesVSH = STRINGIFY
(
 // Attributes
 attribute vec3 aPosition;
 
 // Uniforms
 uniform mat4 uProjectionMatrix;
 uniform mat4 uModelViewMatrix;
 
 void main(void)
 {
     gl_Position = uProjectionMatrix * uModelViewMatrix * vec4(aPosition, 1.0);
 }
);