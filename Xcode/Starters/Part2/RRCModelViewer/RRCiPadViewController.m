//
//  RRCiPadViewController.m
//  RRCModelViewer
//
//  Created by RRC on 1/25/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

#import "RRCiPadViewController.h"
#import "RRCOpenglesView.h"
#import "RRCColladaParser.h"
#import "RRCOpenglesModel.h"
#import "RRCShaderLines.h"
#import "RRCShaderPoints.h"
#import "RRCShaderBlinnPhong.h"
#import "RRCSceneEngine.h"

@interface RRCiPadViewController () <UIGestureRecognizerDelegate>

// View
@property (strong, nonatomic, readwrite) RRCOpenglesView* openglesView;

// Model
@property (strong, nonatomic, readwrite) RRCOpenglesModel* openglesModel;
@property (assign, nonatomic, readwrite) GLuint texture;

// Shaders
@property (strong, nonatomic, readwrite) RRCShaderLines* shaderLines;
@property (strong, nonatomic, readwrite) RRCShaderPoints* shaderPoints;
@property (strong, nonatomic, readwrite) RRCShaderBlinnPhong* shaderBlinnPhong;

// Scene
@property (strong, nonatomic, readwrite) RRCSceneEngine* sceneEngine;

// UI
@property (weak, nonatomic) IBOutlet UISwitch* switchTexture;
@property (weak, nonatomic) IBOutlet UISwitch* switchXRay;
@property (weak, nonatomic) IBOutlet UISwitch* switchLines;
@property (weak, nonatomic) IBOutlet UISwitch* switchPoints;

@end

@implementation RRCiPadViewController

#pragma mark - View
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@:- viewDidLoad", [self class]);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%@:- viewDidAppear", [self class]);
    
    // Load
    [self loadOpenglesView];
    [self loadOpenglesModel];
    [self loadShaders];
    [self loadTexture];
    [self loadSceneEngine];
}

#pragma mark - Load
- (void)loadOpenglesView
{
}

- (void)loadOpenglesModel
{
}

- (void)loadShaders
{
    self.shaderBlinnPhong = [[RRCShaderBlinnPhong alloc] init];
    self.shaderLines = [[RRCShaderLines alloc] init];
    self.shaderPoints = [[RRCShaderPoints alloc] init];
}

- (void)loadTexture
{
}

- (void)loadSceneEngine
{
}

#pragma mark - Render
- (void)updateWithDisplayLink:(CADisplayLink*)displayLink
{
}

#pragma mark - IBActions
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    [self.sceneEngine beginTransformations];
    return YES;
}

- (IBAction)pinch:(UIPinchGestureRecognizer *)sender
{
}

- (IBAction)pan:(UIPanGestureRecognizer *)sender
{
    if(sender.numberOfTouches == 1)
    {
    }
    else if(sender.numberOfTouches == 2)
    {
    }
}

- (IBAction)rotation:(UIRotationGestureRecognizer *)sender
{
}

@end
