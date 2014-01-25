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

static NSString* const kRRCModel = @"Mushroom";

@interface RRCiPhoneViewController ()

@property (strong, nonatomic, readwrite) GLKBaseEffect* effect;
@property (strong, nonatomic, readwrite) RRCOpenglesModel* model;

@end

@implementation RRCiPhoneViewController

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
    
    // Create effect
    [self createEffect];

    // Load model
    [self loadModel];
}

- (void)createEffect
{
    // Initialize
    self.effect = [[GLKBaseEffect alloc] init];
    
    // Texture
    NSDictionary* options = @{GLKTextureLoaderOriginBottomLeft:@YES};
    NSError* error;
    NSString* path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Models/%@Texture", kRRCModel] ofType:@".png"];
    GLKTextureInfo* texture = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
    
    if(texture == nil)
        NSLog(@"%@:- Error loading texture: %@", [self class], [error localizedDescription]);
    
    self.effect.texture2d0.name = texture.name;
    self.effect.texture2d0.enabled = true;
    
    // Light
    self.effect.light0.enabled = GL_TRUE;
    self.effect.light0.position = GLKVector4Make(0.25f, 0.75f, 0.75f, 1.0f);
    self.effect.lightingType = GLKLightingTypePerPixel;
    
    // Material
    self.effect.material.diffuseColor = GLKVector4Make(0.75f, 0.75f, 0.75f, 1.0f);
    self.effect.material.specularColor = GLKVector4Make(0.25f, 0.25f, 0.25f, 1.0f);
}

- (void)loadModel
{
    RRCColladaParser* parser = [[RRCColladaParser alloc] initWithXML:[NSString stringWithFormat:@"Models/%@", kRRCModel]];
    
    if([parser didParseXML])
    {
        NSLog(@"%@:- Successfully parsed XML", [self class]);
        self.model = [[RRCOpenglesModel alloc] initWithCollada:parser.collada];
        if([self.model didConvertCollada])
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

- (void)setMatrices
{
    // Projection Matrix
    const GLfloat aspectRatio = (GLfloat)(self.view.bounds.size.width) / (GLfloat)(self.view.bounds.size.height);
    const GLfloat fieldView = GLKMathDegreesToRadians(90.0f);
    const GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(fieldView, aspectRatio, 0.1f, 10.0f);
    self.effect.transform.projectionMatrix = projectionMatrix;
    
    // ModelView Matrix
    GLKMatrix4 modelViewMatrix = GLKMatrix4Identity;
    modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, 0.0f, 0.0f, -5.0f);
    modelViewMatrix = GLKMatrix4RotateX(modelViewMatrix, GLKMathDegreesToRadians(-90.0f));
    modelViewMatrix = GLKMatrix4RotateZ(modelViewMatrix, GLKMathDegreesToRadians(90.0f));
    modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, 0.55f, 0.55f, 0.55f);
    self.effect.transform.modelviewMatrix = modelViewMatrix;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // Prepare effect
    [self.effect prepareToDraw];
    
    // Set matrices
    [self setMatrices];
    
    // Positions
    if(self.model.positions)
    {
        glEnableVertexAttribArray(GLKVertexAttribPosition);
        glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, self.model.positions);
    }
    
    // Normals
    if(self.model.normals)
    {
        glEnableVertexAttribArray(GLKVertexAttribNormal);
        glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 0, self.model.normals);
    }
    
    // Texels
    if(self.model.texels)
    {
        glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
        glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, self.model.texels);
    }
    
    // Draw Model
    glDrawArrays(GL_TRIANGLES, 0, self.model.count);
}

- (void)update
{
}

@end
