//
//  RRCColladaSource.h
//  RRCModelViewer
//
//  Created by Ricardo on 1/18/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

#import "RRCColladaObject.h"

@interface RRCColladaSource : RRCColladaObject

@property (strong, nonatomic, readonly) NSString* identifier;
@property (strong, nonatomic, readonly) NSArray* floatArray;
@property (assign, nonatomic, readonly) NSInteger size;
@property (assign, nonatomic, readonly) NSInteger count;
@property (assign, nonatomic, readonly) NSInteger stride;

@end
