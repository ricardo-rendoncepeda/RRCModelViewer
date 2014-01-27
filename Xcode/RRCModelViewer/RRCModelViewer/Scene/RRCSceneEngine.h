//
//  RRCSceneEngine.h
//  RRCModelViewer
//
//  Created by Ricardo on 1/26/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

@interface RRCSceneEngine : NSObject

typedef NS_ENUM(NSInteger, RRCSceneEngineTransformations)
{
    RRCSceneEngineTransformations_NEW = 0,
    RRCSceneEngineTransformations_SCALE,
    RRCSceneEngineTransformations_TRANSLATE,
    RRCSceneEngineTransformations_ROTATE,
};

@property (assign, nonatomic, readonly) GLKMatrix4 projectionMatrix;
@property (assign, nonatomic, readonly) GLKMatrix4 modelViewMatrix;
@property (assign, nonatomic, readonly) GLKMatrix3 normalMatrix;
@property (assign, nonatomic, readwrite) RRCSceneEngineTransformations transformation;

- (instancetype)initWithFOV:(float)fov aspect:(float)aspect near:(float)near far:(float)far scale:(float)scale position:(GLKVector2)position orientation:(GLKVector3)orientation;

@end
