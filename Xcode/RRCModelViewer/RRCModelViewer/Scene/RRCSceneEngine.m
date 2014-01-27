//
//  RRCSceneEngine.m
//  RRCModelViewer
//
//  Created by Ricardo on 1/26/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

#import "RRCSceneEngine.h"

@interface RRCSceneEngine ()

// Transformations
@property (assign, nonatomic, readwrite) float pScale;
@property (assign, nonatomic, readwrite) float cScale;
@property (assign, nonatomic, readwrite) GLKVector2 pTranslation;
@property (assign, nonatomic, readwrite) GLKVector2 cTranslation;
@property (assign, nonatomic, readwrite) GLKVector3 pRotation;
@property (assign, nonatomic, readwrite) GLKQuaternion cRotation;

@end

@implementation RRCSceneEngine
{
    // Vectors
    GLKVector3  _vectorRight;
    GLKVector3  _vectorUp;
    GLKVector3  _vectorFront;

    // Depth
    float       _depth;
}

- (instancetype)initWithFOV:(float)fov aspect:(float)aspect near:(float)near far:(float)far scale:(float)scale position:(GLKVector2)position orientation:(GLKVector3)orientation
{
    if(self = [super init])
    {
        // Vectors
        _vectorRight = GLKVector3Make(1.0f, 0.0f, 0.0f);
        _vectorUp = GLKVector3Make(0.0f, 1.0f, 0.0f);
        _vectorFront = GLKVector3Make(0.0f, 0.0f, 1.0f);
        
        // Depth
        _depth = (near+far)/2.0f;
        
        // Transformations
        _pScale = _cScale = scale;
        _pTranslation = _cTranslation = position;
        _pRotation = orientation;
        
        _cRotation = GLKQuaternionIdentity;
        orientation = GLKVector3Make(GLKMathDegreesToRadians(orientation.x), GLKMathDegreesToRadians(orientation.y), GLKMathDegreesToRadians(orientation.z));
        _cRotation = GLKQuaternionMultiply(GLKQuaternionMakeWithAngleAndVector3Axis(-orientation.x, _vectorRight), _cRotation);
        _cRotation = GLKQuaternionMultiply(GLKQuaternionMakeWithAngleAndVector3Axis(-orientation.y, _vectorUp), _cRotation);
        _cRotation = GLKQuaternionMultiply(GLKQuaternionMakeWithAngleAndVector3Axis(-orientation.z, _vectorFront), _cRotation);
        
        // Projection Matrix
        _projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(fov), aspect, near, far);
    }
    return self;
}

- (GLKMatrix4)modelViewMatrix
{
    GLKMatrix4 modelViewMatrix = GLKMatrix4Identity;
    modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, _cTranslation.x, _cTranslation.y, -_depth);
    modelViewMatrix = GLKMatrix4Multiply(modelViewMatrix, GLKMatrix4MakeWithQuaternion(_cRotation));
    modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, _cScale, _cScale, _cScale);
    
    return modelViewMatrix;
}

- (GLKMatrix3)normalMatrix
{
    bool invertible;
    GLKMatrix3 normalMatrix = GLKMatrix4GetMatrix3(GLKMatrix4InvertAndTranspose(self.modelViewMatrix, &invertible));
    if(!invertible)
        NSLog(@"%@:- ModelView Matrix is not invertible", [self class]);
    
    return normalMatrix;
}

@end
