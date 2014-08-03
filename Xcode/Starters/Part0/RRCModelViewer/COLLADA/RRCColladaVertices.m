//
//  RRCColladaVertices.m
//  RRCModelViewer
//
//  Created by Ricardo on 1/18/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

#import "RRCColladaVertices.h"

@implementation RRCColladaVertices

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if(self = [super initWithDictionary:dictionary])
    {
        _identifier = [dictionary objectForKey:@"identifier"];
    }
    return self;
}

@end
