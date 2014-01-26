//
//  RRCShaderBlinnPhong.m
//  RRCModelViewer
//
//  Created by RRC on 1/26/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

#import "RRCShaderBlinnPhong.h"

// Shaders
#include "BlinnPhong.vsh"
#include "BlinnPhong.fsh"

@implementation RRCShaderBlinnPhong

- (instancetype)init
{
    if(self = [super init])
    {
        // Program
        self.program = [self programWithVertexShader:BlinnPhongVSH fragmentShader:BlinnPhongFSH];
        
        // Attributes
        _aPosition = glGetAttribLocation(self.program, "aPosition");
        _aNormal = glGetAttribLocation(self.program, "aNormal");
        _aTexel = glGetAttribLocation(self.program, "aTexel");
        
        // Uniforms
        _uProjectionMatrix = glGetUniformLocation(self.program, "uProjectionMatrix");
        _uModelViewMatrix = glGetUniformLocation(self.program, "uModelViewMatrix");
        _uNormalMatrix = glGetUniformLocation(self.program, "uNormalMatrix");
        _uTexture = glGetUniformLocation(self.program, "uTexture");
    }
    return self;
}

@end
