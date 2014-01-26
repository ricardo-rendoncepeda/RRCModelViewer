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

static NSString* const kRRCModel = @"Mushroom";

@interface RRCiPadViewController ()

@property (strong, nonatomic, readwrite) RRCOpenglesModel* model;
@property (strong, nonatomic, readwrite) RRCShaderLines* shaderLines;
@property (strong, nonatomic, readwrite) RRCShaderPoints* shaderPoints;

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
    
    // Initialize Shaders
    self.shaderLines = [RRCShaderLines new];
    self.shaderPoints = [RRCShaderPoints new];
    
    // Load Model
    [self loadModel];
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
    glUniformMatrix4fv(self.shaderLines.uProjectionMatrix, 1, 0, projectionMatrix.m);
    glUniformMatrix4fv(self.shaderPoints.uProjectionMatrix, 1, 0, projectionMatrix.m);
    
    // ModelView Matrix
    GLKMatrix4 modelViewMatrix = GLKMatrix4Identity;
    modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, 0.0f, 0.0f, -5.0f);
    modelViewMatrix = GLKMatrix4RotateX(modelViewMatrix, GLKMathDegreesToRadians(-90.0f));
    modelViewMatrix = GLKMatrix4RotateZ(modelViewMatrix, GLKMathDegreesToRadians(90.0f));
    modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, 0.75f, 0.75f, 0.75f);
    glUniformMatrix4fv(self.shaderLines.uModelViewMatrix, 1, 0, modelViewMatrix.m);
    glUniformMatrix4fv(self.shaderPoints.uModelViewMatrix, 1, 0, modelViewMatrix.m);
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
    glDrawArrays(GL_LINES, 0, self.model.count);
    
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
}

- (void)update
{
}

@end
