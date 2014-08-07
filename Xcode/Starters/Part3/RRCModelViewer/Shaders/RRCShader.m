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
    }
    return self;
}

#pragma mark - Program
- (GLuint)programWithVertexShader:(NSString*)vsh fragmentShader:(NSString*)fsh
{
    // Program
    GLuint programHandle = glCreateProgram();
    
    // Shaders
    GLuint vertexShader = [self shaderWithName:vsh type:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self shaderWithName:fsh type:GL_FRAGMENT_SHADER];
    
    // Attach & Link
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, fragmentShader);
    glLinkProgram(programHandle);
    
    GLint linkSuccess;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
    if(linkSuccess == GL_FALSE)
    {
        GLchar messages[1024];
        glGetProgramInfoLog(programHandle, sizeof(messages), 0, &messages[0]);
        NSLog(@"%@:- GLSL Program Error: %s", [self class], messages);
    }
    
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
    
    return programHandle;
}

- (GLuint)shaderWithName:(NSString*)name type:(GLenum)type
{
    // File
    NSString* file;
    if(type == GL_VERTEX_SHADER)
        file = [[NSBundle mainBundle] pathForResource:name ofType:@"vsh"];
    else if(type == GL_FRAGMENT_SHADER)
        file = [[NSBundle mainBundle] pathForResource:name ofType:@"fsh"];
    
    // Source & Object
    const GLchar* source = (GLchar*)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    GLuint shaderHandle = glCreateShader(type);
    glShaderSource(shaderHandle, 1, &source, 0);
    
    // Compile
    glCompileShader(shaderHandle);
    
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if(compileSuccess == GL_FALSE)
    {
        GLchar messages[1024];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        NSLog(@"%@:- GLSL Shader Error: %s", [self class], messages);
    }
    
    return shaderHandle;
}

@end
