//
//  RRCModelViewerTests.m
//  RRCModelViewerTests
//
//  Created by Ricardo on 1/18/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RRCColladaParser.h"
#import "RRCOpenglesModel.h"

@interface RRCModelViewerTests : XCTestCase

@end

@implementation RRCModelViewerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCourse
{
    // "Hello, World!"
    NSLog(@"Hello, World!");
}

- (void)testParser
{
    RRCColladaParser* colladaParser = [[RRCColladaParser alloc] initWithXML:@"Models/mushroom"];
    if([colladaParser didParseXML])
    {
        NSLog(@"Model parsed!");
        [colladaParser logCOLLADA];
        
        RRCOpenglesModel* openglesModel = [[RRCOpenglesModel alloc] initWithCollada:colladaParser.collada];
        if([openglesModel didConvertCollada])
        {
            NSLog(@"Model converted!");
            [openglesModel logOpenGLES];
        }
    }
}

@end
