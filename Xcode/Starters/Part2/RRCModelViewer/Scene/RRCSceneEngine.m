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
@property (assign, nonatomic, readwrite) float beginScale;
@property (assign, nonatomic, readwrite) float endScale;
@property (assign, nonatomic, readwrite) GLKVector2 beginTranslation;
@property (assign, nonatomic, readwrite) GLKVector2 endTranslation;
@property (assign, nonatomic, readwrite) GLKVector3 beginRotation;
@property (assign, nonatomic, readwrite) GLKQuaternion endRotation;

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

#pragma mark - init
- (instancetype)initWithFOV:(float)fov aspect:(float)aspect near:(float)near far:(float)far scale:(float)scale position:(GLKVector2)position orientation:(GLKVector3)orientation
{
    if(self = [super init])
    {
        // Vectors
        _vectorRight = GLKVector3Make(1.00, 0.00, 0.00);
        _vectorUp = GLKVector3Make(0.00, 1.00, 0.00);
        _vectorFront = GLKVector3Make(0.00, 0.00, 1.00);
        
        // Depth
        _depth = (near+far)/2.00;
        
        // Transformations
        _beginScale = _endScale = scale;
        _beginTranslation = _endTranslation = position;
        _beginRotation = orientation;
        
        _endRotation = GLKQuaternionIdentity;
        orientation = GLKVector3MultiplyScalar(orientation, GLKMathDegreesToRadians(1.00));
        _endRotation = GLKQuaternionMultiply(GLKQuaternionMakeWithAngleAndVector3Axis(-orientation.x, _vectorRight), _endRotation);
        _endRotation = GLKQuaternionMultiply(GLKQuaternionMakeWithAngleAndVector3Axis(-orientation.y, _vectorUp), _endRotation);
        _endRotation = GLKQuaternionMultiply(GLKQuaternionMakeWithAngleAndVector3Axis(-orientation.z, _vectorFront), _endRotation);
        
        // Projection Matrix
        _projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(fov), aspect, near, far);
    }
    return self;
}

#pragma mark - Properties
- (GLKMatrix4)modelViewMatrix
{
    GLKMatrix4 modelViewMatrix = GLKMatrix4Identity;
    modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, self.endTranslation.x, self.endTranslation.y, -_depth);
    modelViewMatrix = GLKMatrix4Multiply(modelViewMatrix, GLKMatrix4MakeWithQuaternion(self.endRotation));
    modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, self.endScale, self.endScale, self.endScale);
    
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

#pragma mark - Methods
- (void)beginTransformations
{
    self.beginScale = self.endScale;
    self.beginTranslation = GLKVector2Make(0.00, 0.00);
    self.beginRotation = GLKVector3Make(0.00, 0.00, 0.00);
}

- (void)scale:(float)s
{
    self.endScale = s*self.beginScale;
}

- (void)translate:(GLKVector2)t withMultiplier:(float)m
{
    t = GLKVector2MultiplyScalar(t, m);
    float dx = self.endTranslation.x + (t.x-self.beginTranslation.x);
    float dy = self.endTranslation.y + (t.y-self.beginTranslation.y);
    
    self.beginTranslation = GLKVector2Make(t.x, t.y);
    self.endTranslation = GLKVector2Make(dx, dy);
}

- (void)rotate:(GLKVector3)r withMultiplier:(float)m
{
    m = GLKMathDegreesToRadians(m);
    float dx = r.x - self.beginRotation.x;
    float dy = r.y - self.beginRotation.y;
    float dz = r.z - self.beginRotation.z;
    
    self.beginRotation = GLKVector3Make(r.x, r.y, r.z);
    self.endRotation = GLKQuaternionMultiply(GLKQuaternionMakeWithAngleAndVector3Axis(dx*m, _vectorUp), self.endRotation);
    self.endRotation = GLKQuaternionMultiply(GLKQuaternionMakeWithAngleAndVector3Axis(dy*m, _vectorRight), self.endRotation);
    self.endRotation = GLKQuaternionMultiply(GLKQuaternionMakeWithAngleAndVector3Axis(-dz, _vectorFront), self.endRotation);
}

@end
