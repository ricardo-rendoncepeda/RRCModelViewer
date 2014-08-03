//
//  RRCColladaMesh.m
//  RRCModelViewer
//
//  Created by Ricardo on 1/18/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

#import "RRCColladaMesh.h"

@implementation RRCColladaMesh

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if(self = [super initWithDictionary:dictionary])
    {
        _primitive = [dictionary objectForKey:@"primitive"];
        _vertices = [dictionary objectForKey:@"vertices"];
        _sources = [dictionary objectForKey:@"sources"];
    }
    return self;
}

@end
