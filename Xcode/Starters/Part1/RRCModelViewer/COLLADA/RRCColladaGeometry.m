//
//  RRCColladaGeometry.m
//  RRCModelViewer
//
//  Created by Ricardo on 1/18/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

#import "RRCColladaGeometry.h"

@implementation RRCColladaGeometry

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if(self = [super initWithDictionary:dictionary])
    {
        _identifier = [dictionary objectForKey:@"identifier"];
        _name = [dictionary objectForKey:@"name"];
        _mesh = [dictionary objectForKey:@"mesh"];
    }
    return self;
}

@end
