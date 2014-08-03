//
//  RRCColladaSource.m
//  RRCModelViewer
//
//  Created by Ricardo on 1/18/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

#import "RRCColladaSource.h"

@implementation RRCColladaSource

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if(self = [super init])
    {
        _identifier = [dictionary objectForKey:@"identifier"];
        _floatArray = [self arrayFromString:[dictionary objectForKey:@"floatArray"]];
        _size = [[dictionary objectForKey:@"size"] intValue];
        _count = [[dictionary objectForKey:@"count"] intValue];
        _stride = [[dictionary objectForKey:@"stride"] intValue];
    }
    return self;
}

- (NSArray*)arrayFromString:(NSString*)string
{
    NSArray* floats = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSMutableArray* floatArray = [NSMutableArray new];
    
    for(NSString* f in floats)
    {
        if(![f isEqualToString:@""])
            [floatArray addObject:f];
    }
    
    return floatArray;
}

@end
