//
//  RRCShaderProgram.h
//  RRCModelViewer
//
//  Created by RRC on 1/25/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

#define STRINGIFY(A) #A

@interface RRCShaderProgram : NSObject

// Program Handle
@property (assign, nonatomic, readwrite) GLuint program;

- (GLuint)programWithVertexShader:(const char*)vsh fragmentShader:(const char*)fsh;

@end
