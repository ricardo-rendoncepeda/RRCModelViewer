//
//  RRCShaderLines.m
//  RRCModelViewer
//
//  Created by RRC on 1/25/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

#import "RRCShaderLines.h"

// Shaders
#include "Lines.vsh"
#include "Lines.fsh"

@implementation RRCShaderLines

- (instancetype)init
{
    if(self = [super init])
    {
        // Program
        self.program = [self programWithVertexShader:LinesVSH fragmentShader:LinesFSH];
        
        // Attributes
        _aPosition = glGetAttribLocation(self.program, "aPosition");
        
        // Uniforms
        _uProjectionMatrix = glGetUniformLocation(self.program, "uProjectionMatrix");
        _uModelViewMatrix = glGetUniformLocation(self.program, "uModelViewMatrix");
    }
    return self;
}

@end