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
    }
    return self;
}

#pragma mark - Render
- (void)renderModel:(RRCOpenglesModel *)model inScene:(RRCSceneEngine *)scene
{
    [super renderModel:model inScene:scene];
    
    // Draw Model
    glLineWidth(4.00);
    for(int i=0; i<model.count; i+=3)
        glDrawArrays(GL_LINES, i, 2);
}

@end