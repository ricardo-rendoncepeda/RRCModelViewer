//
//  RRCShader.h
//  RRCModelViewer
//
//  Created by RRC on 1/25/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

#import "RRCOpenglesModel.h"
#import "RRCSceneEngine.h"

@interface RRCShader : NSObject

// Program Handle
@property (assign, nonatomic, readwrite) GLuint program;

// Attribute Handles
@property (assign, nonatomic, readonly) GLint aPosition;

// Uniform Handles
@property (assign, nonatomic, readonly) GLint uProjectionMatrix;
@property (assign, nonatomic, readonly) GLint uModelViewMatrix;

- (instancetype)initWithVertexShader:(NSString*)vsh fragmentShader:(NSString*)fsh;
- (void)renderModel:(RRCOpenglesModel*)model inScene:(RRCSceneEngine*)scene;

@end
