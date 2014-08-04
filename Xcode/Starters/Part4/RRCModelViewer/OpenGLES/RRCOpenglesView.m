//
//  RRCOpenglesView.m
//  RRCModelViewer
//
//  Created by Ricardo on 8/2/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

#import "RRCOpenglesView.h"

@interface RRCOpenglesView ()

// EAGL
@property (strong, nonatomic, readonly) CAEAGLLayer* eaglLayer;
@property (strong, nonatomic, readonly) EAGLContext* eaglContext;

// Buffers
@property (assign, nonatomic, readonly) GLuint frameBuffer;
@property (assign, nonatomic, readonly) GLuint depthBuffer;
@property (assign, nonatomic, readonly) GLuint colorBuffer;

@end

@implementation RRCOpenglesView

#pragma mark - Override
+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

#pragma mark - Initializer
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        // Layer
        _eaglLayer = (CAEAGLLayer*)self.layer;
        _eaglLayer.opaque = YES;
        
        // Context
        _eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        [EAGLContext setCurrentContext:_eaglContext];
        
        // OpenGL ES
        glClearColor(0.36, 0.67, 0.18, 1.00);
        glEnable(GL_CULL_FACE);
        glEnable(GL_DEPTH_TEST);
        glEnable(GL_BLEND);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        glViewport(0, 0, frame.size.width, frame.size.height);
        
        // Buffers
        glGenFramebuffers(1, &_frameBuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
        
        glGenRenderbuffers(1, &_depthBuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, _depthBuffer);
        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, self.frame.size.width, self.frame.size.height);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthBuffer);
        
        glGenRenderbuffers(1, &_colorBuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, _colorBuffer);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorBuffer);
        [self.eaglContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:self.eaglLayer];

    }
    return self;
}

#pragma mark - Update
- (void)update
{
    [self.eaglContext presentRenderbuffer:GL_RENDERBUFFER];
}

@end
