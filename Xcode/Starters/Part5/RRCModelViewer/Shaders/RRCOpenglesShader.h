//
//  RRCOpenglesShader.h
//  RRCModelViewer
//
//  Created by RRC on 1/25/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

#import "RRCOpenglesModel.h"

@interface RRCOpenglesShader : NSObject

// Program Handle
@property (assign, nonatomic, readwrite) GLuint program;

- (instancetype)initWithVertexShader:(NSString*)vsh fragmentShader:(NSString*)fsh;

@end
