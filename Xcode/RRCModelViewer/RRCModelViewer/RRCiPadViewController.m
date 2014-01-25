//
//  RRCiPadViewController.m
//  RRCModelViewer
//
//  Created by RRC on 1/25/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

#import "RRCiPadViewController.h"
#import "RRCColladaParser.h"
#import "RRCOpenglesModel.h"

static NSString* const kRRCModel = @"Mushroom";

@interface RRCiPadViewController ()

@property (strong, nonatomic, readwrite) RRCOpenglesModel* model;

@end

@implementation RRCiPadViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%@:- viewDidLoad", [self class]);
    
    // Set up context
    EAGLContext* context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:context];
    
    // Set up view
    GLKView* glkview = (GLKView *)self.view;
    glkview.context = context;
    
    // OpenGL ES Settings
    glClearColor(0.50f, 0.50f, 0.50f, 1.00f);
    glEnable(GL_CULL_FACE);
    glEnable(GL_DEPTH_TEST);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

- (void)update
{
}

@end
