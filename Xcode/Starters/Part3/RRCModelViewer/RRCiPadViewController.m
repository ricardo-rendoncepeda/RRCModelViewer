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
#import "RRCOpenglesTexture.h"
#import "RRCShaderLines.h"
#import "RRCShaderPoints.h"
#import "RRCShaderBlinnPhong.h"
#import "RRCSceneEngine.h"

@interface RRCiPadViewController () <UIGestureRecognizerDelegate>

@property (strong, nonatomic, readwrite) RRCOpenglesView* openglesView;
@property (strong, nonatomic, readwrite) RRCOpenglesModel* openglesModel;
@property (strong, nonatomic, readwrite) RRCOpenglesTexture* openglesTexture;
@property (strong, nonatomic, readwrite) RRCShaderLines* shaderLines;
@property (strong, nonatomic, readwrite) RRCShaderPoints* shaderPoints;
@property (strong, nonatomic, readwrite) RRCShaderBlinnPhong* shaderBlinnPhong;
@property (strong, nonatomic, readwrite) RRCSceneEngine* sceneEngine;

#pragma mark - IBOutlets
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
    [self loadOpenglesShaders];
    [self loadOpenglesTexture];
    [self loadSceneEngine];
}

#pragma mark - Load
- (void)loadOpenglesView
{
    self.openglesView = [[RRCOpenglesView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    [self.view insertSubview:self.openglesView atIndex:0];
    
    CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateWithDisplayLink:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)loadOpenglesModel
{
    RRCColladaParser* colladaParser = [[RRCColladaParser alloc] initWithXML:@"Models/mushroom"];
    if([colladaParser didParseXML])
    {
        // Model parsed!
        
        self.openglesModel = [[RRCOpenglesModel alloc] initWithCollada:colladaParser.collada];
        if([self.openglesModel didConvertCollada])
        {
            // Model converted!
        }
    }
}

- (void)loadOpenglesShaders
{
    self.shaderBlinnPhong = [[RRCShaderBlinnPhong alloc] init];
    self.shaderLines = [[RRCShaderLines alloc] init];
    self.shaderPoints = [[RRCShaderPoints alloc] init];
}

- (void)loadOpenglesTexture
{
    self.openglesTexture = [[RRCOpenglesTexture alloc] initWithName:@"Models/mushroom"];
}

- (void)loadSceneEngine
{
    self.sceneEngine = [[RRCSceneEngine alloc] initWithFOV:90.0
                                                    aspect:(self.view.bounds.size.width/self.view.bounds.size.height)
                                                      near:0.1
                                                       far:10.0
                                                     scale:1.0
                                                  position:GLKVector2Make(0.0, -2.0)
                                               orientation:GLKVector3Make(90.0, 160.0, 0.0)];
}

#pragma mark - Render
- (void)updateWithDisplayLink:(CADisplayLink*)displayLink
{
    // Clear view
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // Blinn-Phong
    //[self.shaderBlinnPhong renderModel:self.openglesModel inScene:self.sceneEngine withTexture:YES xRay:NO];
    
    // Lines
    //[self.shaderLines renderModel:self.openglesModel inScene:self.sceneEngine];
    
    // Points
    //[self.shaderPoints renderModel:self.openglesModel inScene:self.sceneEngine];
    
    // Update view
    //[self.openglesView update];
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
