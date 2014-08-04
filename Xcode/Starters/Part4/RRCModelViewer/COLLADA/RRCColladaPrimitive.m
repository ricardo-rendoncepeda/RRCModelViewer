//
//  RRCColladaPrimitive.m
//  RRCModelViewer
//
//  Created by Ricardo on 1/18/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

#import "RRCColladaPrimitive.h"

@implementation RRCColladaPrimitive

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if(self = [super init])
    {
        _type = [self typeFromString:[dictionary objectForKey:@"type"]];
        _primitives = [self arrayFromString:[dictionary objectForKey:@"p"]];
        _inputs = [dictionary objectForKey:@"inputs"];
    }
    return self;
}

- (GLPrimitiveType)typeFromString:(NSString*)string
{
    if([string isEqualToString:@"polylist"])
        return GLPrimitiveType_POLYLIST;
    else if([string isEqualToString:@"triangles"])
        return GLPrimitiveType_TRIANGLES;
    
    return 0;
}

- (NSArray*)arrayFromString:(NSString*)string
{
    NSArray* ia = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSMutableArray* integerArray = [NSMutableArray new];
    
    for(NSString* i in ia)
    {
        if(![i isEqualToString:@""])
            [integerArray addObject:i];
    }
    
    return integerArray;
}

@end
