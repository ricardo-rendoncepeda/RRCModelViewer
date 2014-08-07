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
        _aPosition = glGetAttribLocation(self.program, "aPosition");
        _aNormal = glGetAttribLocation(self.program, "aNormal");
        _aTexel = glGetAttribLocation(self.program, "aTexel");
        
        // Uniforms
        _uProjectionMatrix = glGetUniformLocation(self.program, "uProjectionMatrix");
        _uModelViewMatrix = glGetUniformLocation(self.program, "uModelViewMatrix");
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
    // Program
    glUseProgram(self.program);
    
    // Projection Matrix
    glUniformMatrix4fv(self.uProjectionMatrix, 1, 0, scene.projectionMatrix.m);
    
    // ModelView Matrix
    glUniformMatrix4fv(self.uModelViewMatrix, 1, 0, scene.modelViewMatrix.m);
    
    // Normal Matrix
    glUniformMatrix3fv(self.uNormalMatrix, 1, 0, scene.normalMatrix.m);
    
    // Switches
    glUniform1i(self.uSwitchTexture, texture);
    glUniform1i(self.uSwitchXRay, xRay);
    
    // Positions
    glEnableVertexAttribArray(self.aPosition);
    glVertexAttribPointer(self.aPosition, 3, GL_FLOAT, GL_FALSE, 0, model.positions);
    
    // Normals
    glEnableVertexAttribArray(self.aNormal);
    glVertexAttribPointer(self.aNormal, 3, GL_FLOAT, GL_FALSE, 0, model.normals);
    
    // Texels
    glUniform1i(self.uTexture, 0);
    glEnableVertexAttribArray(self.aTexel);
    glVertexAttribPointer(self.aTexel, 2, GL_FLOAT, GL_FALSE, 0, model.texels);
    
    // Draw Model
    glDrawArrays(GL_TRIANGLES, 0, model.count);
}

@end
