//
//  RRCColladaInput.m
//  RRCModelViewer
//
//  Created by Ricardo on 1/18/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

#import "RRCColladaInput.h"

@implementation RRCColladaInput

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if(self = [super init])
    {
        _semantic = [self semanticFromString:[dictionary objectForKey:@"semantic"]];
        _source = [[dictionary objectForKey:@"source"] stringByReplacingOccurrencesOfString:@"#" withString:@""];
        _offset = [[dictionary objectForKey:@"offset"] integerValue];
    }
    return self;
}

- (RRCColladaInputSemantic)semanticFromString:(NSString*)string
{
    if([string isEqualToString:@"POSITION"])
        return RRCColladaInputSemantic_POSITION;
    else if([string isEqualToString:@"VERTEX"])
        return RRCColladaInputSemantic_VERTEX;
    else if([string isEqualToString:@"NORMAL"])
        return RRCColladaInputSemantic_NORMAL;
    else if([string isEqualToString:@"TEXCOORD"])
        return RRCColladaInputSemantic_TEXCOORD;
    
    return 0;
}

@end
