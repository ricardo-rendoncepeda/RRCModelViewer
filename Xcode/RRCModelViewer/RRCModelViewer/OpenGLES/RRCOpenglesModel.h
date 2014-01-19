//
//  RRCOpenglesModel.h
//  RRCModelViewer
//
//  Created by Ricardo on 1/18/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

#import "RRCColladaObject.h"

@interface RRCOpenglesModel : NSObject

@property (readonly) int count;
@property (readonly) float* positions;
@property (readonly) float* normals;
@property (readonly) float* texels;

- (instancetype)initWithCollada:(RRCColladaObject*)collada;
- (BOOL)didConvertCollada;
- (void)logOpenGLES;

@end
