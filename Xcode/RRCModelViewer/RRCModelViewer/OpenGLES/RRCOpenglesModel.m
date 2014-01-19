//
//  RRCOpenglesModel.m
//  RRCModelViewer
//
//  Created by Ricardo on 1/18/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

#import "RRCOpenglesModel.h"
#import "RRCColladaGeometry.h"

@interface RRCOpenglesModel ()

@property (strong, nonatomic) RRCColladaObject* collada;

@end

@implementation RRCOpenglesModel

- (instancetype)initWithCollada:(RRCColladaObject *)collada
{
    if(self = [super init])
    {
        NSLog(@"RRCOpenglesObject:- initWithCollada: %@", collada);
        _collada = collada;
    }
    return self;
}

- (BOOL)didConvertCollada
{
    RRCColladaGeometry* geometry = (RRCColladaGeometry*)self.collada;
    
    // Calculate Count
    _count = geometry.mesh.primitive.primitives.count/geometry.mesh.primitive.inputs.count;
    if(_count == 0)
        return NO;
    
    // Get IDs and Offsets
    NSString* positionsIdentifier;
    NSString* normalsIdentifier;
    NSString* texelsIdentifier;
    NSInteger positionsOffset;
    NSInteger normalsOffset;
    NSInteger texelsOffset;
    for(RRCColladaInput* input in geometry.mesh.primitive.inputs)
    {
        if((input.semantic == RRCColladaInputSemantic_VERTEX) && (geometry.mesh.vertices.semantic == RRCColladaInputSemantic_POSITION))
        {
            if([geometry.mesh.vertices.identifier isEqualToString:input.source])
            {
                positionsIdentifier = geometry.mesh.vertices.source;
                positionsOffset = input.offset;
            }
        }
        else if(input.semantic == RRCColladaInputSemantic_NORMAL)
        {
            normalsIdentifier = input.source;
            normalsOffset = input.offset;
        }
        else if(input.semantic == RRCColladaInputSemantic_TEXCOORD)
        {
            texelsIdentifier = input.source;
            texelsOffset = input.offset;
        }
    }
    
    _positions = [self arrayWithIdentifier:positionsIdentifier offset:positionsOffset geometry:geometry];
    _normals = [self arrayWithIdentifier:normalsIdentifier offset:normalsOffset geometry:geometry];
    _texels = [self arrayWithIdentifier:texelsIdentifier offset:texelsOffset geometry:geometry];
    
    return YES;
}

- (float*)arrayWithIdentifier:(NSString*)identifier offset:(NSInteger)offset geometry:(RRCColladaGeometry*)geometry
{
    if(!identifier)
        return nil;
    
    // Get Source
    RRCColladaSource* source;
    for(RRCColladaSource* s in geometry.mesh.sources)
    {
        if([s.identifier isEqualToString:identifier])
            source = s;
    }
    
    // Extract Indices
    NSMutableArray* indices = [NSMutableArray new];
    for(int i=0; i<geometry.mesh.primitive.primitives.count; i+=geometry.mesh.primitive.inputs.count)
        [indices addObject:[geometry.mesh.primitive.primitives objectAtIndex:i+offset]];
    
    // Allocate Array
    float* array = (float*)malloc(sizeof(float) * _count * source.stride);
    
    // Populate Arrays
    for(int i=0; i<indices.count; i++)
    {
        NSInteger index = [[indices objectAtIndex:i] integerValue];
        for(int j=0; j<source.stride; j++)
            array[(i*source.stride)+j] = [[source.floatArray objectAtIndex:(index*source.stride)+j] floatValue];
    }
    
    return array;
}

- (void)logOpenGLES
{
    NSLog(@"RRCOpenglesModel:- logOpenGLES");
    NSLog(@"-count: %i", self.count);
    if(self.positions)
        NSLog(@"-positions: YES");
    else
        NSLog(@"-positions: NO");
    if(self.normals)
        NSLog(@"-normals: YES");
    else
        NSLog(@"-normals: NO");
    if(self.texels)
        NSLog(@"-texels: YES");
    else
        NSLog(@"-texels: NO");
}

@end
