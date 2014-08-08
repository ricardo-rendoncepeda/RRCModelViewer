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

@interface RRCiPhoneViewController ()

@property (strong, nonatomic, readwrite) RRCOpenglesModel* openglesModel;
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
    
    // Load
    [self loadGlkitView];
    [self loadOpenglesModel];
    [self loadGlkitEffect];
    [self loadGlkitTexture];
    [self loadSceneMatrices];
}

#pragma mark - Load
- (void)loadGlkitView
{
    // Set up context
    EAGLContext* context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:context];
    
    // Set up view
    GLKView* glkitView = (GLKView*)self.view;
    glkitView.context = context;
    
    // OpenGL ES settings
    glClearColor(0.36, 0.67, 0.18, 1.0);
    glEnable(GL_CULL_FACE);
    glEnable(GL_DEPTH_TEST);
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

- (void)loadGlkitEffect
{
    // Initialize
    self.effect = [[GLKBaseEffect alloc] init];
    
    // Light
    self.effect.light0.enabled = YES;
    self.effect.light0.position = GLKVector4Make(10.0, 10.0, 5.0, 1.0);
    
    // Material
    self.effect.material.ambientColor = GLKVector4Make(0.2, 0.2, 0.2, 1.0);
    self.effect.material.diffuseColor = GLKVector4Make(0.8, 0.8, 0.8, 1.0);
    self.effect.material.specularColor = GLKVector4Make(0.4, 0.4, 0.4, 1.0);
}

- (void)loadGlkitTexture
{
    NSDictionary* options = @{GLKTextureLoaderOriginBottomLeft: @YES};
    UIImage* image = [UIImage imageNamed:@"Models/mushroom"];
    GLKTextureInfo* texture = [GLKTextureLoader textureWithCGImage:image.CGImage options:options error:nil];
    
    self.effect.texture2d0.enabled = YES;
    self.effect.texture2d0.name = texture.name;
}

- (void)loadSceneMatrices
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
    // Clear view
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // Prepare effect
    [self.effect prepareToDraw];
    
    // Positions
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, self.openglesModel.positions);
    
    // Normals
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 0, self.openglesModel.normals);
    
    // Texels
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, self.openglesModel.texels);
    
    // Draw model
    glDrawArrays(GL_TRIANGLES, 0, self.openglesModel.count);
}

@end
