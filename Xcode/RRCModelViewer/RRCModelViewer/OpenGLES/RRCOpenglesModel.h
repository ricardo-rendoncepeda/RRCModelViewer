//
//  RRCOpenglesModel.h
//  RRCModelViewer
//
//  Created by Ricardo on 1/18/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

#import "RRCColladaObject.h"

@interface RRCOpenglesModel : NSObject

@property (assign, nonatomic, readonly) int count;
@property (assign, nonatomic, readonly) float* positions;
@property (assign, nonatomic, readonly) float* normals;
@property (assign, nonatomic, readonly) float* texels;

- (instancetype)initWithCollada:(RRCColladaObject*)collada;
- (BOOL)didConvertCollada;
- (void)logOpenGLES;

@end
