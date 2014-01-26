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

static NSString* const kRRCModel = @"Mushroom";

@interface RRCiPadViewController ()

// Model
@property (strong, nonatomic, readwrite) RRCOpenglesModel* model;
@property (strong, nonatomic, readwrite) GLKTextureInfo* texture;

// Shaders
@property (strong, nonatomic, readwrite) RRCShaderLines* shaderLines;
@property (strong, nonatomic, readwrite) RRCShaderPoints* shaderPoints;
@property (strong, nonatomic, readwrite) RRCShaderBlinnPhong* shaderBlinnPhong;

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
    
    // Load Model
    [self loadModel];
    
    // Load Texture
    [self loadTexture];
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
    const GLfloat aspectRatio = (GLfloat)(self.view.bounds.size.width) / (GLfloat)(self.view.bounds.size.height);
    const GLfloat fieldView = GLKMathDegreesToRadians(90.0f);
    const GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(fieldView, aspectRatio, 0.1f, 10.0f);
    glUniformMatrix4fv(self.shaderLines.uProjectionMatrix, 1, 0, projectionMatrix.m);
    glUniformMatrix4fv(self.shaderPoints.uProjectionMatrix, 1, 0, projectionMatrix.m);
    glUniformMatrix4fv(self.shaderBlinnPhong.uProjectionMatrix, 1, 0, projectionMatrix.m);
    
    // ModelView Matrix
    GLKMatrix4 modelViewMatrix = GLKMatrix4Identity;
    modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, 0.0f, 0.0f, -5.0f);
    modelViewMatrix = GLKMatrix4RotateX(modelViewMatrix, GLKMathDegreesToRadians(-90.0f));
    modelViewMatrix = GLKMatrix4RotateZ(modelViewMatrix, GLKMathDegreesToRadians(90.0f));
    modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, 0.95f, 0.95f, 0.95f);
    glUniformMatrix4fv(self.shaderLines.uModelViewMatrix, 1, 0, modelViewMatrix.m);
    glUniformMatrix4fv(self.shaderPoints.uModelViewMatrix, 1, 0, modelViewMatrix.m);
    glUniformMatrix4fv(self.shaderBlinnPhong.uModelViewMatrix, 1, 0, modelViewMatrix.m);
    
    // Normal Matrix
    bool invertible;
    GLKMatrix3 normalMatrix = GLKMatrix4GetMatrix3(GLKMatrix4InvertAndTranspose(modelViewMatrix, &invertible));
    if(!invertible)
        NSLog(@"%@:- ModelView Matrix is not invertible", [self class]);
    glUniformMatrix3fv(self.shaderBlinnPhong.uNormalMatrix, 1, 0, normalMatrix.m);
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

@end
