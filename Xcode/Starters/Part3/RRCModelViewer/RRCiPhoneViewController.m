//
//  RRCiPhoneViewController.m
//  RRCModelViewer
//
//  Created by Ricardo on 1/18/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

#import "RRCiPhoneViewController.h"
#import "RRCColladaParser.h"
#import "RRCOpenglesModel.h"

static NSString* const kRRCModelName = @"mushroom";

@interface RRCiPhoneViewController ()

// Model
@property (strong, nonatomic, readwrite) RRCOpenglesModel* openglesModel;

// Effect
@property (strong, nonatomic, readwrite) GLKBaseEffect* effect;

@end

@implementation RRCiPhoneViewController

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
    
    // Set up context
    EAGLContext* context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:context];
    
    // Set up view
    GLKView* glkView = (GLKView*)self.view;
    glkView.context = context;
    
    // OpenGL ES settings
    glClearColor(92.0/255.0, 171.0/255.0, 46.0/255.0, 1.0);
    glEnable(GL_CULL_FACE);
    glEnable(GL_DEPTH_TEST);
    
    // Load model
    [self loadOpenglesModel];
    
    // Create effect
    [self createEffect];
    
    // Set matrices
    [self setMatrices];
}

#pragma mark - Model
- (void)loadOpenglesModel
{
    RRCColladaParser* parser = [[RRCColladaParser alloc] initWithXML:[NSString stringWithFormat:@"Models/%@", kRRCModelName]];
    if([parser didParseXML])
    {
        NSLog(@"%@:- Successfully parsed XML", [self class]);
        self.openglesModel = [[RRCOpenglesModel alloc] initWithCollada:parser.collada];
        if([self.openglesModel didConvertCollada])
            NSLog(@"%@:- Successfully converted COLLADA", [self class]);
        else
            [NSException raise:@"Error converting COLLADA" format:nil];
    }
    else
        [NSException raise:@"Error parsing XML" format:nil];
}

#pragma mark - Effect
- (void)createEffect
{
    // Initialize
    self.effect = [[GLKBaseEffect alloc] init];
    
    // Light
    self.effect.light0.enabled = GL_TRUE;
    self.effect.light0.position = GLKVector4Make(10.0, 10.0, 5.0, 1.0);
    self.effect.lightingType = GLKLightingTypePerPixel;
    
    // Material
    self.effect.material.diffuseColor = GLKVector4Make(0.8, 0.8, 0.8, 1.0);
    self.effect.material.specularColor = GLKVector4Make(0.2, 0.2, 0.2, 1.0);
    
    // Texture
    NSDictionary* options = @{GLKTextureLoaderOriginBottomLeft: @YES};
    NSError* error;
    NSString* path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Models/%@", kRRCModelName] ofType:@".png"];
    GLKTextureInfo* texture = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
    if(!texture)
        NSLog(@"%@:- Error loading texture: %@", [self class], [error localizedDescription]);
    
    self.effect.texture2d0.name = texture.name;
    self.effect.texture2d0.enabled = true;
}

#pragma mark - Matrices
- (void)setMatrices
{
    // Projection matrix
    GLfloat aspectRatio = self.view.bounds.size.width/self.view.bounds.size.height;
    GLfloat fieldOfView = GLKMathDegreesToRadians(90.0);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(fieldOfView, aspectRatio, 0.1, 10.0);
    self.effect.transform.projectionMatrix = projectionMatrix;
    
    // ModelView matrix
    GLKMatrix4 modelViewMatrix = GLKMatrix4Identity;
    modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, 0.0, -1.5, -5.0);
    modelViewMatrix = GLKMatrix4RotateY(modelViewMatrix, GLKMathDegreesToRadians(200.0));
    modelViewMatrix = GLKMatrix4RotateX(modelViewMatrix, GLKMathDegreesToRadians(-90.0));
    modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, 0.67, 0.67, 0.67);
    self.effect.transform.modelviewMatrix = modelViewMatrix;
}

#pragma mark - Render
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // Prepare effect
    [self.effect prepareToDraw];
    
    // Positions
    if(self.openglesModel.positions)
    {
        glEnableVertexAttribArray(GLKVertexAttribPosition);
        glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, self.openglesModel.positions);
    }
    
    // Normals
    if(self.openglesModel.normals)
    {
        glEnableVertexAttribArray(GLKVertexAttribNormal);
        glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 0, self.openglesModel.normals);
    }
    
    // Texels
    if(self.openglesModel.texels)
    {
        glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
        glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, self.openglesModel.texels);
    }
    
    // Draw Model
    glDrawArrays(GL_TRIANGLES, 0, self.openglesModel.count);
}

@end
