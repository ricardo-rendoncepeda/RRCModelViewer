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

static NSString* const kRRCModelName = @"mushroom";

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
    
    // Load view
    [self loadOpenglesView];
    
    // Initialize shaders
    self.shaderLines = [RRCShaderLines new];
    self.shaderPoints = [RRCShaderPoints new];
    self.shaderBlinnPhong = [RRCShaderBlinnPhong new];
    
    // Load scene
    [self loadSceneEngine];
    
    // Load model
    [self loadOpenglesModel];
    
    // Load texture
    [self loadTexture];
}

#pragma mark - Load
- (void)loadOpenglesView
{
    self.openglesView = [[RRCOpenglesView alloc] initWithFrame:CGRectMake(0.00, 0.00, self.view.frame.size.height, self.view.frame.size.width)];
    [self.view insertSubview:self.openglesView atIndex:0];
    
    CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateWithDisplayLink:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)loadSceneEngine
{
    self.sceneEngine = [[RRCSceneEngine alloc] initWithFOV:90.00
                                                    aspect:(self.view.bounds.size.width / self.view.bounds.size.height)
                                                      near:0.10
                                                       far:10.00
                                                     scale:1.00
                                                  position:GLKVector2Make(0.00, -2.00)
                                               orientation:GLKVector3Make(90.00, 160.00, 0.00)];
}

- (void)loadOpenglesModel
{
    RRCColladaParser* parser = [[RRCColladaParser alloc] initWithXML:[NSString stringWithFormat:@"Models/%@", kRRCModelName]];
    
    if([parser didParseXML])
    {
        NSLog(@"%@:- Successfully parsed XML", [self class]);
        self.openglesModel = [[RRCOpenglesModel alloc] initWithCollada:parser.collada];
        if([self.openglesModel didConvertCollada])
        {
            NSLog(@"%@:- Successfully converted COLLADA", [self class]);
        }
        else
        {
            NSLog(@"%@:- Error converting COLLADA", [self class]);
            exit(1);
        }
    }
    else
    {
        NSLog(@"%@:- Error parsing XML", [self class]);
        exit(1);
    }
}

- (void)loadTexture
{
    UIImage* textureImage = [UIImage imageNamed:[NSString stringWithFormat:@"Models/%@", kRRCModelName]];
    CGImageRef cgImage = textureImage.CGImage;
    CFDataRef data = CGDataProviderCopyData(CGImageGetDataProvider(cgImage));
    
    glGenTextures(1, &_texture);
    glBindTexture(GL_TEXTURE_2D, _texture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, CGImageGetWidth(cgImage), CGImageGetHeight(cgImage), 0, GL_RGBA, GL_UNSIGNED_BYTE, CFDataGetBytePtr(data));
    
    CFRelease(data);
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
    [self.shaderBlinnPhong renderModel:self.openglesModel withScene:self.sceneEngine texture:self.switchTexture.on xRay:self.switchXRay.on];
    
    // Graphics View
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
        [self.sceneEngine rotate:GLKVector3Make(rotation.x, rotation.y, 0.00) withMultiplier:0.50];
    }
    else if(sender.numberOfTouches == 2)
    {
        CGPoint translation = [sender translationInView:sender.view];
        float x = translation.x/sender.view.frame.size.width;
        float y = translation.y/sender.view.frame.size.height;
        [self.sceneEngine translate:GLKVector2Make(x, -y) withMultiplier:5.00];
    }
}

- (IBAction)rotation:(UIRotationGestureRecognizer *)sender
{
    float rotation = [sender rotation];
    [self.sceneEngine rotate:GLKVector3Make(0.00, 0.00, rotation) withMultiplier:GLKMathDegreesToRadians(1.00)];
}

@end
