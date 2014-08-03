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

static NSString* const kRRCModel = @"mushroom";

@interface RRCiPadViewController () <UIGestureRecognizerDelegate>

// View
@property (strong, nonatomic, readwrite) RRCOpenglesView* graphicsView;

// Model
@property (strong, nonatomic, readwrite) RRCOpenglesModel* graphicsModel;
@property (strong, nonatomic, readwrite) GLKTextureInfo* texture;

// Shaders
@property (strong, nonatomic, readwrite) RRCShaderLines* shaderLines;
@property (strong, nonatomic, readwrite) RRCShaderPoints* shaderPoints;
@property (strong, nonatomic, readwrite) RRCShaderBlinnPhong* shaderBlinnPhong;

// Scene
@property (strong, nonatomic, readwrite) RRCSceneEngine* scene;

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
    
    // Load view
    [self loadGraphicsView];
    
    // Initialize shaders
    self.shaderLines = [RRCShaderLines new];
    self.shaderPoints = [RRCShaderPoints new];
    self.shaderBlinnPhong = [RRCShaderBlinnPhong new];
    
    // Load scene
    [self loadScene];
    
    // Load model
    [self loadGraphicsModel];
    
    // Load texture
    [self loadTexture];
}

#pragma mark - Load
- (void)loadGraphicsView
{
    self.graphicsView = [[RRCOpenglesView alloc] initWithFrame:CGRectMake(0.00, 0.00, self.view.frame.size.height, self.view.frame.size.width)];
    [self.view insertSubview:self.graphicsView atIndex:0];
    
    CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateWithDisplayLink:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)loadScene
{
    self.scene = [[RRCSceneEngine alloc] initWithFOV:90.00
                                              aspect:(self.view.bounds.size.width / self.view.bounds.size.height)
                                                near:0.10
                                                 far:10.00
                                               scale:1.00
                                            position:GLKVector2Make(0.00, -1.50)
                                         orientation:GLKVector3Make(90.00, 160.00, 0.00)];
}

- (void)loadGraphicsModel
{
    RRCColladaParser* parser = [[RRCColladaParser alloc] initWithXML:[NSString stringWithFormat:@"Models/%@", kRRCModel]];
    
    if([parser didParseXML])
    {
        NSLog(@"%@:- Successfully parsed XML", [self class]);
        self.graphicsModel = [[RRCOpenglesModel alloc] initWithCollada:parser.collada];
        if([self.graphicsModel didConvertCollada])
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
    // Texture
    NSDictionary* options = @{GLKTextureLoaderOriginBottomLeft:@YES};
    NSError* error;
    NSString* path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Models/%@", kRRCModel] ofType:@".png"];
    self.texture = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
    
    if(self.texture == nil)
        NSLog(@"%@:- Error loading texture: %@", [self class], [error localizedDescription]);
}

#pragma mark - Render
- (void)updateWithDisplayLink:(CADisplayLink*)displayLink
{
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // Lines
    if(self.switchLines.on)
        [self.shaderLines renderModel:self.graphicsModel inScene:self.scene];
    
    // Points
    if(self.switchPoints.on)
        [self.shaderPoints renderModel:self.graphicsModel inScene:self.scene];
    
    // Blinn-Phong
    [self.shaderBlinnPhong renderModel:self.graphicsModel inScene:self.scene withTexture:self.texture boolTexture:self.switchTexture.on boolXRay:self.switchXRay.on];
    
    // Graphics View
    [self.graphicsView update];
}

#pragma mark - IBActions
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    [self.scene beginTransformations];
    
    return YES;
}

- (IBAction)pinch:(UIPinchGestureRecognizer *)sender
{
    // Pinch
    float scale = [sender scale];
    [self.scene scale:scale];
}

- (IBAction)pan:(UIPanGestureRecognizer *)sender
{
    // Pan (1 Finger)
    if(sender.numberOfTouches == 1)
    {
        CGPoint translation = [sender translationInView:sender.view];
        float x = translation.x/sender.view.frame.size.width;
        float y = translation.y/sender.view.frame.size.height;
        [self.scene translate:GLKVector2Make(x, -y) withMultiplier:5.00];
    }
    
    // Pan (2 Fingers)
    else if(sender.numberOfTouches == 2)
    {
        CGPoint rotation = [sender translationInView:sender.view];
        [self.scene rotate:GLKVector3Make(rotation.x, rotation.y, 0.00) withMultiplier:0.50];
    }
}

- (IBAction)rotation:(UIRotationGestureRecognizer *)sender
{
    // Rotation
    float rotation = [sender rotation];
    [self.scene rotate:GLKVector3Make(0.00, 0.00, rotation) withMultiplier:GLKMathDegreesToRadians(1.00)];
}

@end
