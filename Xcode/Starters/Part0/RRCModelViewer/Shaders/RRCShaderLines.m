//
//  RRCShaderLines.m
//  RRCModelViewer
//
//  Created by RRC on 1/25/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

#import "RRCShaderLines.h"

@implementation RRCShaderLines

#pragma mark - init
- (instancetype)init
{
    if(self = [super initWithVertexShader:@"Lines" fragmentShader:@"Lines"])
    {
        // Attributes
        _aPosition = glGetAttribLocation(self.program, "aPosition");
        
        // Uniforms
        _uProjectionMatrix = glGetUniformLocation(self.program, "uProjectionMatrix");
        _uModelViewMatrix = glGetUniformLocation(self.program, "uModelViewMatrix");
    }
    return self;
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
    glEnableVertexAttribArray(self.aPosition);
    glVertexAttribPointer(self.aPosition, 3, GL_FLOAT, GL_FALSE, 0, model.positions);
    
    // Draw Model
    glLineWidth(4.00);
    for(int i=0; i<model.count; i+=3)
        glDrawArrays(GL_LINES, i, 2);
}

@end