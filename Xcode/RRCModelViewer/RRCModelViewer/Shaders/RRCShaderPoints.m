//
//  RRCShaderPoints.m
//  RRCModelViewer
//
//  Created by RRC on 1/25/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

#import "RRCShaderPoints.h"

// Shaders
#include "Points.vsh"
#include "Points.fsh"

@implementation RRCShaderPoints

- (instancetype)init
{
    if(self = [super init])
    {
        // Program
        self.program = [self programWithVertexShader:PointsVSH fragmentShader:PointsFSH];
        
        // Attributes
        _aPosition = glGetAttribLocation(self.program, "aPosition");
        
        // Uniforms
        _uProjectionMatrix = glGetUniformLocation(self.program, "uProjectionMatrix");
        _uModelViewMatrix = glGetUniformLocation(self.program, "uModelViewMatrix");
    }
    return self;
}

@end
