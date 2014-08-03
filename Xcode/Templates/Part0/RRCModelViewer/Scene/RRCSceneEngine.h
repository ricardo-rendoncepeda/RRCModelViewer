//
//  RRCSceneEngine.h
//  RRCModelViewer
//
//  Created by Ricardo on 1/26/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

@interface RRCSceneEngine : NSObject

@property (assign, nonatomic, readonly) GLKMatrix4 projectionMatrix;
@property (assign, nonatomic, readonly) GLKMatrix4 modelViewMatrix;
@property (assign, nonatomic, readonly) GLKMatrix3 normalMatrix;

- (instancetype)initWithFOV:(float)fov aspect:(float)aspect near:(float)near far:(float)far scale:(float)scale position:(GLKVector2)position orientation:(GLKVector3)orientation;
- (void)beginTransformations;
- (void)scale:(float)s;
- (void)translate:(GLKVector2)t withMultiplier:(float)m;
- (void)rotate:(GLKVector3)r withMultiplier:(float)m;

@end
