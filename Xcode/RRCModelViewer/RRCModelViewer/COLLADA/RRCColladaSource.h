//
//  RRCColladaSource.h
//  RRCModelViewer
//
//  Created by Ricardo on 1/18/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

#import "RRCColladaObject.h"

@interface RRCColladaSource : RRCColladaObject

@property (strong, nonatomic) NSString* identifier;
@property (strong, nonatomic) NSArray* floatArray;
@property (readwrite) NSInteger size;
@property (readwrite) NSInteger count;
@property (readwrite) NSInteger stride;

@end
