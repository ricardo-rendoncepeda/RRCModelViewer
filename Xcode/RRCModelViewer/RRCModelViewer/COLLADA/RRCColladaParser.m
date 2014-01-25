//
//  RRCColladaParser.m
//  RRCModelViewer
//
//  Created by Ricardo on 1/18/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

#import "RRCColladaParser.h"
#import "RRCColladaGeometry.h"

@interface RRCColladaParser () <NSXMLParserDelegate>

// NSXMLParser
@property (strong, nonatomic) NSMutableString* elementValue;

// Objects
@property (strong, nonatomic) RRCColladaGeometry* geometry;
@property (strong, nonatomic) RRCColladaSource* source;
@property (strong, nonatomic) RRCColladaVertices* vertices;
@property (strong, nonatomic) RRCColladaPrimitive* primitive;
@property (strong, nonatomic) RRCColladaMesh* mesh;

// Dictionaries
@property (strong, nonatomic) NSDictionary* geometryDictionary;
@property (strong, nonatomic) NSDictionary* sourceDictionary;
@property (strong, nonatomic) NSDictionary* verticesDictionary;
@property (strong, nonatomic) NSDictionary* primitiveDictionary;
@property (strong, nonatomic) NSDictionary* meshDictionary;

// Arrays
@property (strong, nonatomic) NSMutableArray* inputsArray;
@property (strong, nonatomic) NSMutableArray* sourcesArray;

// Others
@property (strong, nonatomic) NSMutableString* primitiveString;

@end

@implementation RRCColladaParser
{
    NSString*   _xml;
    BOOL        _verticesActive;
    BOOL        _primitiveActive;
    BOOL        _pActive;
}

- (instancetype)initWithXML:(NSString *)xml
{
    if(self = [super init])
    {
        NSLog(@"%@:- initWithXML: %@", [self class], xml);
        
        // Variables
        _verticesActive = NO;
        _primitiveActive = NO;
        _pActive = NO;
        
        // NSXMLParser
        _xml = xml;
    }
    return self;
}

- (BOOL)didParseXML
{
    NSData* xmlData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:_xml withExtension:@"xml"]];
    
    if(xmlData)
    {
        NSXMLParser* xmlParser = [[NSXMLParser alloc] initWithData:xmlData];
        xmlParser.delegate = self;
        
        if([xmlParser parse])
        {
            _collada = self.geometry;
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - NSXMLParserDelegate
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if(!self.elementValue)
        self.elementValue = [[NSMutableString alloc] initWithString:string];
    else
        [self.elementValue appendString:string];
    
    if(_pActive)
        [self.primitiveString appendString:string];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    // RRCGeometryObject
    if([elementName isEqualToString:@"geometry"])
    {
        self.geometryDictionary = [NSMutableDictionary new];
        
        [self.geometryDictionary setValue:[attributeDict objectForKey:@"id"] forKey:@"identifier"];
        [self.geometryDictionary setValue:[attributeDict objectForKey:@"name"] forKey:@"name"];
    }
    
    // RRCMeshObject
    else if([elementName isEqualToString:@"mesh"])
    {
        self.meshDictionary = [NSMutableDictionary new];
        self.sourcesArray = [NSMutableArray new];
    }
    
    // RRCSourceObject
    else if([elementName isEqualToString:@"source"])
    {
        self.sourceDictionary = [NSMutableDictionary new];
        
        [self.sourceDictionary setValue:[attributeDict objectForKey:@"id"] forKey:@"identifier"];
    }
    
    else if([elementName isEqualToString:@"float_array"])
    {
        [self.sourceDictionary setValue:[attributeDict objectForKey:@"count"] forKey:@"size"];
    }
    
    else if([elementName isEqualToString:@"accessor"])
    {
        [self.sourceDictionary setValue:[attributeDict objectForKey:@"count"] forKey:@"count"];
        [self.sourceDictionary setValue:[attributeDict objectForKey:@"stride"] forKey:@"stride"];
    }
    
    // RRCVerticesObject
    if([elementName isEqualToString:@"vertices"])
    {
        _verticesActive = YES;
        
        self.verticesDictionary = [NSMutableDictionary new];
        
        [self.verticesDictionary setValue:[attributeDict objectForKey:@"id"] forKey:@"identifier"];
    }
    
    // RRCInputObject
    if([elementName isEqualToString:@"input"])
    {
        if(_verticesActive)
        {
            [self.verticesDictionary setValue:[attributeDict objectForKey:@"semantic"] forKey:@"semantic"];
            [self.verticesDictionary setValue:[attributeDict objectForKey:@"source"] forKey:@"source"];
        }
        else if(_primitiveActive)
        {
            NSDictionary* inputDictionary = @{@"semantic": [attributeDict objectForKey:@"semantic"],
                                              @"source": [attributeDict objectForKey:@"source"],
                                              @"offset": [attributeDict objectForKey:@"offset"]};
            
            [self.inputsArray addObject:[[RRCColladaInput alloc] initWithDictionary:inputDictionary]];
        }
    }
    
    // RRCPrimitiveObject
    if([elementName isEqualToString:@"polylist"] || [elementName isEqualToString:@"trianRRCes"])
    {
        _primitiveActive = YES;
        
        self.inputsArray = [NSMutableArray new];
        self.primitiveDictionary = [NSMutableDictionary new];
        self.primitiveString = [NSMutableString new];
    }
    
    if([elementName isEqualToString:@"p"])
        _pActive = YES;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    // RRCGeometryObject
    if([elementName isEqualToString:@"geometry"])
    {
        [self.geometryDictionary setValue:self.mesh forKey:@"mesh"];
        
        self.geometry = [[RRCColladaGeometry alloc] initWithDictionary:self.geometryDictionary];
        
        self.geometryDictionary = nil;
    }
    
    // RRCMeshObject
    if([elementName isEqualToString:@"mesh"])
    {
        [self.meshDictionary setValue:self.primitive forKey:@"primitive"];
        [self.meshDictionary setValue:self.vertices forKey:@"vertices"];
        [self.meshDictionary setValue:self.sourcesArray forKey:@"sources"];
        
        self.mesh = [[RRCColladaMesh alloc] initWithDictionary:self.meshDictionary];
        
        self.meshDictionary = nil;
    }
    
    // RRCSourceObject
    if([elementName isEqualToString:@"source"])
    {
        self.source = [[RRCColladaSource alloc] initWithDictionary:self.sourceDictionary];
        
        [self.sourcesArray addObject:self.source];
        
        self.sourceDictionary = nil;
    }
    
    if([elementName isEqualToString:@"float_array"])
    {
        [self.sourceDictionary setValue:self.elementValue forKey:@"floatArray"];
    }
    
    // RRCVerticesObject
    if([elementName isEqualToString:@"vertices"])
    {
        _verticesActive = NO;
        
        self.vertices = [[RRCColladaVertices alloc] initWithDictionary:self.verticesDictionary];
        
        self.verticesDictionary = nil;
    }
    
    // RRCPrimitiveObject
    if([elementName isEqualToString:@"polylist"] || [elementName isEqualToString:@"trianRRCes"])
    {
        [self.primitiveDictionary setValue:elementName forKey:@"type"];
        [self.primitiveDictionary setValue:self.primitiveString forKey:@"p"];
        [self.primitiveDictionary setValue:self.inputsArray forKey:@"inputs"];
        
        self.primitive = [[RRCColladaPrimitive alloc] initWithDictionary:self.primitiveDictionary];
        
        self.primitiveString = nil;
        self.inputsArray = nil;
        
        _primitiveActive = NO;
    }
    
    if([elementName isEqualToString:@"p"])
    {
        [self.primitiveString appendString:@"\n"];
        
        _pActive = NO;
    }
    
    self.elementValue = nil;
}

- (void)logCOLLADA
{
    NSLog(@"%@:- logCOLLADA", [self class]);
    NSLog(@"-GEOMETRY");
    NSLog(@"-identifier: %@", self.geometry.identifier);
    NSLog(@"-name: %@", self.geometry.name);
    
    NSLog(@"-MESH");
    NSLog(@"--SOURCES");
    for(RRCColladaSource* source in self.geometry.mesh.sources)
    {
        NSLog(@"---identifier: %@", source.identifier);
        NSLog(@"---size: %i", source.size);
        NSLog(@"---count: %i", source.count);
        NSLog(@"---stride: %i", source.stride);
        NSLog(@"---floatArray: %i", source.floatArray.count);
    }
    
    NSLog(@"--VERTICES");
    NSLog(@"---semantic: %i", self.geometry.mesh.vertices.semantic);
    NSLog(@"---source: %@", self.geometry.mesh.vertices.source);
    NSLog(@"---offset: %i", self.geometry.mesh.vertices.offset);
    
    NSLog(@"--primitive");
    NSLog(@"---primitives: %i", self.geometry.mesh.primitive.primitives.count);
    NSLog(@"---INPUTS:");
    for(RRCColladaInput* input in self.geometry.mesh.primitive.inputs)
    {
        NSLog(@"----semantic: %i", self.geometry.mesh.vertices.semantic);
        NSLog(@"----source: %@", self.geometry.mesh.vertices.source);
        NSLog(@"----offset: %i", self.geometry.mesh.vertices.offset);
    }
}

@end
