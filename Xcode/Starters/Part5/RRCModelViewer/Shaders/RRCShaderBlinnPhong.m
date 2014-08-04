//
//  RRCShaderBlinnPhong.m
//  RRCModelViewer
//
//  Created by RRC on 1/26/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

#import "RRCShaderBlinnPhong.h"

@implementation RRCShaderBlinnPhong

#pragma mark - init
- (instancetype)init
{
    if(self = [super initWithVertexShader:@"BlinnPhong" fragmentShader:@"BlinnPhong"])
    {
        // Attributes
        _aNormal = glGetAttribLocation(self.program, "aNormal");
        _aTexel = glGetAttribLocation(self.program, "aTexel");
        
        // Uniforms
        _uNormalMatrix = glGetUniformLocation(self.program, "uNormalMatrix");
        _uTexture = glGetUniformLocation(self.program, "uTexture");
        _uSwitchTexture = glGetUniformLocation(self.program, "uSwitchTexture");
        _uSwitchXRay = glGetUniformLocation(self.program, "uSwitchXRay");
    }
    return self;
}

#pragma mark - Render
- (void)renderModel:(RRCOpenglesModel *)model inScene:(RRCSceneEngine *)scene withTexture:(BOOL)texture xRay:(BOOL)xRay
{
    [super renderModel:model inScene:scene];
    
    glUniform1i(self.uSwitchTexture, texture);
    glUniform1i(self.uSwitchXRay, xRay);
    
    // Normal Matrix
    glUniformMatrix3fv(self.uNormalMatrix, 1, 0, scene.normalMatrix.m);
    
    // Normals
    if(model.normals)
    {
        glEnableVertexAttribArray(self.aNormal);
        glVertexAttribPointer(self.aNormal, 3, GL_FLOAT, GL_FALSE, 0, model.normals);
    }
    
    // Texels
    if(model.texels)
    {
        glUniform1i(self.uTexture, 0);
        glEnableVertexAttribArray(self.aTexel);
        glVertexAttribPointer(self.aTexel, 2, GL_FLOAT, GL_FALSE, 0, model.texels);
    }
    
    // Draw Model
    glDrawArrays(GL_TRIANGLES, 0, model.count);
}

@end
