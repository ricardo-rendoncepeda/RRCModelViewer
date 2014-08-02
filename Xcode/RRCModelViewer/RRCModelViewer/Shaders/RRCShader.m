//
//  RRCShader.m
//  RRCModelViewer
//
//  Created by RRC on 1/25/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

#import "RRCShader.h"

@implementation RRCShader

#pragma mark - init
- (instancetype)initWithVertexShader:(NSString*)vsh fragmentShader:(NSString*)fsh
{
    if(self = [super init])
    {
        // Program
        _program = [self programWithVertexShader:vsh fragmentShader:fsh];
        
        // Attributes
        _aPosition = glGetAttribLocation(self.program, "aPosition");
        
        // Uniforms
        _uProjectionMatrix = glGetUniformLocation(self.program, "uProjectionMatrix");
        _uModelViewMatrix = glGetUniformLocation(self.program, "uModelViewMatrix");
    }
    return self;
}

#pragma mark - Program
- (GLuint)programWithVertexShader:(NSString*)vsh fragmentShader:(NSString*)fsh
{
    // Build shaders
    GLuint vertexShader = [self shaderWithName:vsh type:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self shaderWithName:fsh type:GL_FRAGMENT_SHADER];
    
    // Create program
    GLuint programHandle = glCreateProgram();
    
    // Attach shaders
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, fragmentShader);
    
    // Link program
    glLinkProgram(programHandle);
    
    // Check for errors
    GLint linkSuccess;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE)
    {
        GLchar messages[1024];
        glGetProgramInfoLog(programHandle, sizeof(messages), 0, &messages[0]);
        NSLog(@"%@:- GLSL Program Error: %s", [self class], messages);
    }
    
    // Delete shaders
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
    
    return programHandle;
}

- (GLuint)shaderWithName:(NSString*)name type:(GLenum)type
{
    // Load the shader file
    NSString* file;
    if(type == GL_VERTEX_SHADER)
        file = [[NSBundle mainBundle] pathForResource:name ofType:@"vsh"];
    else if(type == GL_FRAGMENT_SHADER)
        file = [[NSBundle mainBundle] pathForResource:name ofType:@"fsh"];
    
    // Create the shader source
    const GLchar* source = (GLchar*)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    
    // Create the shader object
    GLuint shaderHandle = glCreateShader(type);
    
    // Load the shader source
    glShaderSource(shaderHandle, 1, &source, 0);
    
    // Compile the shader
    glCompileShader(shaderHandle);
    
    // Check for errors
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE)
    {
        GLchar messages[1024];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        NSLog(@"%@:- GLSL Shader Error: %s", [self class], messages);
    }
    
    return shaderHandle;
}

#pragma mark - Render
- (void)renderModel:(RRCOpenglesModel *)model inScene:(RRCSceneEngine *)scene
{
    // Program
    glUseProgram(self.program);
    
    // Projection Matrix
    glUniformMatrix4fv(self.uProjectionMatrix, 1, 0, scene.projectionMatrix.m);
    
    // ModelView Matrix
    glUniformMatrix4fv(self.uModelViewMatrix, 1, 0, scene.modelViewMatrix.m);
    
    // Positions
    if(model.positions)
    {
        glEnableVertexAttribArray(self.aPosition);
        glVertexAttribPointer(self.aPosition, 3, GL_FLOAT, GL_FALSE, 0, model.positions);
    }
}

@end
