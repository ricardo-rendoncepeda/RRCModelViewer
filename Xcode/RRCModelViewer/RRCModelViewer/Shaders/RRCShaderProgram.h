//
//  RRCShaderProgram.h
//  RRCModelViewer
//
//  Created by RRC on 1/25/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

@interface RRCShaderProgram : NSObject

- (GLuint)programWithVertexShader:(const char*)vsh fragmentShader:(const char*)fsh;

@end
