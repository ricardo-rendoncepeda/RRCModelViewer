//
//  RRCShaderPoints.m
//  RRCModelViewer
//
//  Created by RRC on 1/25/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

#import "RRCShaderPoints.h"

@implementation RRCShaderPoints

#pragma mark - init
- (instancetype)init
{
    if(self = [super initWithVertexShader:@"Points" fragmentShader:@"Points"])
    {
    }
    return self;
}

#pragma mark - Render
- (void)renderModel:(RRCOpenglesModel *)model inScene:(RRCSceneEngine *)scene
{
    [super renderModel:model inScene:scene];
    
    // Draw Model
    glDrawArrays(GL_POINTS, 0, model.count);
}

@end
