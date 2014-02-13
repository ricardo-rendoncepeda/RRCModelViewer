//
//  RRCShaderBlinnPhong.h
//  RRCModelViewer
//
//  Created by RRC on 1/26/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

#import "RRCShader.h"

@interface RRCShaderBlinnPhong : RRCShader

// Attribute Handles
@property (assign, nonatomic, readonly) GLint aPosition;
@property (assign, nonatomic, readonly) GLint aNormal;
@property (assign, nonatomic, readonly) GLint aTexel;

// Uniform Handles
@property (assign, nonatomic, readonly) GLint uProjectionMatrix;
@property (assign, nonatomic, readonly) GLint uModelViewMatrix;
@property (assign, nonatomic, readonly) GLint uNormalMatrix;
@property (assign, nonatomic, readonly) GLint uTexture;

@end
