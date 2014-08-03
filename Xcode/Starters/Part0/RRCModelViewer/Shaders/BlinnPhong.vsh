// VERTEX SHADER

// Attributes
attribute vec3 aPosition;
attribute vec3 aNormal;
attribute vec2 aTexel;

// Uniforms
uniform mat4 uProjectionMatrix;
uniform mat4 uModelViewMatrix;
uniform mat3 uNormalMatrix;

// Varying
varying vec3 vNormal;
varying vec2 vTexel;

void main(void)
{
    vNormal = uNormalMatrix * aNormal;
    vTexel = vec2(aTexel.x, 1.0-aTexel.y);
    
    gl_Position = uProjectionMatrix * uModelViewMatrix * vec4(aPosition, 1.0);
}
