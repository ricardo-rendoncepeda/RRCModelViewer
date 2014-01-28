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
#import "RRCShaderLines.h"
#import "RRCShaderPoints.h"
#import "RRCShaderBlinnPhong.h"
#import "RRCSceneEngine.h"

static NSString* const kRRCModel = @"Fishman";

@interface RRCiPadViewController ()

// Model
@property (strong, nonatomic, readwrite) RRCOpenglesModel* model;
@property (strong, nonatomic, readwrite) GLKTextureInfo* texture;

// Shaders
@property (strong, nonatomic, readwrite) RRCShaderLines* shaderLines;
@property (strong, nonatomic, readwrite) RRCShaderPoints* shaderPoints;
@property (strong, nonatomic, readwrite) RRCShaderBlinnPhong* shaderBlinnPhong;

// Scene
@property (strong, nonatomic, readwrite) RRCSceneEngine* scene;

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
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    // Initialize Shaders
    self.shaderLines = [RRCShaderLines new];
    self.shaderPoints = [RRCShaderPoints new];
    self.shaderBlinnPhong = [RRCShaderBlinnPhong new];
    
    // Load Scene
    [self loadScene];
    
    // Load Model
    [self loadModel];
    
    // Load Texture
    [self loadTexture];
}

- (void)loadScene
{
    self.scene = [[RRCSceneEngine alloc] initWithFOV:90.0f
                                              aspect:(float)(self.view.bounds.size.width / self.view.bounds.size.height)
                                                near:0.1f
                                                 far:10.0f
                                               scale:0.95f
                                            position:GLKVector2Make(0.0f, 0.95f)
                                         orientation:GLKVector3Make(90.0f, -90.0f, 0.0f)];
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

- (void)loadTexture
{
    // Texture
    NSDictionary* options = @{GLKTextureLoaderOriginBottomLeft:@YES};
    NSError* error;
    NSString* path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Models/%@Texture", kRRCModel] ofType:@".png"];
    self.texture = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
    
    if(self.texture == nil)
        NSLog(@"%@:- Error loading texture: %@", [self class], [error localizedDescription]);
}

- (void)setMatrices
{
    // Projection Matrix
    glUniformMatrix4fv(self.shaderLines.uProjectionMatrix, 1, 0, self.scene.projectionMatrix.m);
    glUniformMatrix4fv(self.shaderPoints.uProjectionMatrix, 1, 0, self.scene.projectionMatrix.m);
    glUniformMatrix4fv(self.shaderBlinnPhong.uProjectionMatrix, 1, 0, self.scene.projectionMatrix.m);
    
    // ModelView Matrix
    glUniformMatrix4fv(self.shaderLines.uModelViewMatrix, 1, 0, self.scene.modelViewMatrix.m);
    glUniformMatrix4fv(self.shaderPoints.uModelViewMatrix, 1, 0, self.scene.modelViewMatrix.m);
    glUniformMatrix4fv(self.shaderBlinnPhong.uModelViewMatrix, 1, 0, self.scene.modelViewMatrix.m);
    
    // Normal Matrix
    glUniformMatrix3fv(self.shaderBlinnPhong.uNormalMatrix, 1, 0, self.scene.normalMatrix.m);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // LINES
    glUseProgram(self.shaderLines.program);
    
    // Set Matrices
    [self setMatrices];
    
    // Positions
    if(self.model.positions)
    {
        glEnableVertexAttribArray(self.shaderLines.aPosition);
        glVertexAttribPointer(self.shaderLines.aPosition, 3, GL_FLOAT, GL_FALSE, 0, self.model.positions);
    }
    
    // Draw Model
    glLineWidth(4.0f);
    glDrawArrays(GL_LINE_STRIP, 0, self.model.count);
    
    // POINTS
    glUseProgram(self.shaderPoints.program);
    
    // Set Matrices
    [self setMatrices];
    
    // Positions
    if(self.model.positions)
    {
        glEnableVertexAttribArray(self.shaderPoints.aPosition);
        glVertexAttribPointer(self.shaderPoints.aPosition, 3, GL_FLOAT, GL_FALSE, 0, self.model.positions);
    }
    
    // Draw Model
    glDrawArrays(GL_POINTS, 0, self.model.count);
    
    // GEOMETRY
    glUseProgram(self.shaderBlinnPhong.program);
    
    // Set Matrices
    [self setMatrices];
    
    // Positions
    if(self.model.positions)
    {
        glEnableVertexAttribArray(self.shaderBlinnPhong.aPosition);
        glVertexAttribPointer(self.shaderBlinnPhong.aPosition, 3, GL_FLOAT, GL_FALSE, 0, self.model.positions);
    }
    
    // Normals
    if(self.model.normals)
    {
        glEnableVertexAttribArray(self.shaderBlinnPhong.aNormal);
        glVertexAttribPointer(self.shaderBlinnPhong.aNormal, 3, GL_FLOAT, GL_FALSE, 0, self.model.normals);
    }
    
    // Texels
    if(self.model.texels)
    {
        glBindTexture(GL_TEXTURE_2D, self.texture.name);
        glUniform1i(self.shaderBlinnPhong.uTexture, 0);
        glEnableVertexAttribArray(self.shaderBlinnPhong.aTexel);
        glVertexAttribPointer(self.shaderBlinnPhong.aTexel, 2, GL_FLOAT, GL_FALSE, 0, self.model.texels);
    }
    
    // Draw Model
    glDrawArrays(GL_TRIANGLES, 0, self.model.count);
}

- (void)update
{
}

#pragma mark - IBActions
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.scene beginTransformations];
}

- (IBAction)pinch:(UIPinchGestureRecognizer *)sender
{
    // Pinch
    if((self.scene.transformation == RRCSceneEngineTransformations_NEW) || (self.scene.transformation == RRCSceneEngineTransformations_SCALE))
    {
        float scale = [sender scale];
        [self.scene scale:scale];
    }
}

- (IBAction)pan:(UIPanGestureRecognizer *)sender
{
    // Pan (1 Finger)
    if((sender.numberOfTouches == 1) &&
       ((self.scene.transformation == RRCSceneEngineTransformations_NEW) || (self.scene.transformation == RRCSceneEngineTransformations_TRANSLATE)))
    {
        CGPoint translation = [sender translationInView:sender.view];
        float x = translation.x/sender.view.frame.size.width;
        float y = translation.y/sender.view.frame.size.height;
        [self.scene translate:GLKVector2Make(x, y) withMultiplier:5.0f];
    }
    
    // Pan (2 Fingers)
    else if((sender.numberOfTouches == 2) &&
            ((self.scene.transformation == RRCSceneEngineTransformations_NEW) || (self.scene.transformation == RRCSceneEngineTransformations_ROTATE)))
    {
        CGPoint rotation = [sender translationInView:sender.view];
        [self.scene rotate:GLKVector3Make(rotation.x, rotation.y, 0.0f) withMultiplier:0.5f];
    }
}

- (IBAction)rotation:(UIRotationGestureRecognizer *)sender
{
    // Rotation
    if((self.scene.transformation == RRCSceneEngineTransformations_NEW) || (self.scene.transformation == RRCSceneEngineTransformations_ROTATE))
    {
        float rotation = [sender rotation];
        [self.scene rotate:GLKVector3Make(0.0f, 0.0f, rotation) withMultiplier:GLKMathDegreesToRadians(1.0)];
    }
}

@end
