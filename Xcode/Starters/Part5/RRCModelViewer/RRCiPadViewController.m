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
@property (weak, nonatomic) IBOutlet UILabel* labelHeader;

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
    
    // UI
    self.labelHeader.text = @"Ricardo Rendon Cepeda\nSIGGRAPH 2014";
    
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
    self.openglesView = [[RRCOpenglesView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.height, self.view.frame.size.width)];
    [self.view insertSubview:self.openglesView atIndex:0];
    
    CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateWithDisplayLink:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)loadOpenglesModel
{
    RRCColladaParser* colladaParser = [[RRCColladaParser alloc] initWithXML:@"Models/mushroom"];
    if([colladaParser didParseXML])
    {
        NSLog(@"Model parsed!");
        
        self.openglesModel = [[RRCOpenglesModel alloc] initWithCollada:colladaParser.collada];
        if([self.openglesModel didConvertCollada])
        {
            NSLog(@"Model converted!");
        }
    }
}

- (void)loadShaders
{
    self.shaderBlinnPhong = [[RRCShaderBlinnPhong alloc] init];
    self.shaderLines = [[RRCShaderLines alloc] init];
    self.shaderPoints = [[RRCShaderPoints alloc] init];
}

- (void)loadTexture
{
    UIImage* textureImage = [UIImage imageNamed:@"Models/mushroom"];
    CGImageRef textureCGImage = textureImage.CGImage;
    CFDataRef textureData = CGDataProviderCopyData(CGImageGetDataProvider(textureCGImage));
    
    glGenTextures(1, &_texture);
    glBindTexture(GL_TEXTURE_2D, _texture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, CGImageGetWidth(textureCGImage), CGImageGetHeight(textureCGImage), 0, GL_RGBA, GL_UNSIGNED_BYTE, CFDataGetBytePtr(textureData));
    
    CFRelease(textureData);
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
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // Lines
    if(self.switchLines.on)
        [self.shaderLines renderModel:self.openglesModel inScene:self.sceneEngine];
    
    // Points
    if(self.switchPoints.on)
        [self.shaderPoints renderModel:self.openglesModel inScene:self.sceneEngine];
    
    // Blinn-Phong
    [self.shaderBlinnPhong renderModel:self.openglesModel inScene:self.sceneEngine withTexture:self.switchTexture.on xRay:self.switchXRay.on];
    
    // Graphics view
    [self.openglesView update];
}

#pragma mark - IBActions
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    [self.sceneEngine beginTransformations];
    return YES;
}

- (IBAction)pinch:(UIPinchGestureRecognizer *)sender
{
    float scale = [sender scale];
    [self.sceneEngine scale:scale];
}

- (IBAction)pan:(UIPanGestureRecognizer *)sender
{
    if(sender.numberOfTouches == 1)
    {
        CGPoint rotation = [sender translationInView:sender.view];
        [self.sceneEngine rotate:GLKVector3Make(rotation.x, rotation.y, 0.0) withMultiplier:0.5];
    }
    else if(sender.numberOfTouches == 2)
    {
        CGPoint translation = [sender translationInView:sender.view];
        float x = translation.x/sender.view.frame.size.width;
        float y = translation.y/sender.view.frame.size.height;
        [self.sceneEngine translate:GLKVector2Make(x, -y) withMultiplier:4.0];
    }
}

- (IBAction)rotation:(UIRotationGestureRecognizer *)sender
{
    float rotation = [sender rotation];
    [self.sceneEngine rotate:GLKVector3Make(0.0, 0.0, rotation) withMultiplier:1.0];
}

- (IBAction)longPress:(UILongPressGestureRecognizer *)sender
{
    self.switchTexture.on = YES;
    self.switchXRay.on = NO;
    self.switchLines.on = NO;
    self.switchPoints.on = NO;
    
    self.sceneEngine = [[RRCSceneEngine alloc] initWithFOV:90.00
                                                    aspect:(self.view.bounds.size.width/self.view.bounds.size.height)
                                                      near:0.10
                                                       far:10.00
                                                     scale:1.00
                                                  position:GLKVector2Make(0.00, -2.00)
                                               orientation:GLKVector3Make(90.00, 160.00, 0.00)];
}

@end
