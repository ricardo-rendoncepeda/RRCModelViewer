//
//  RRCColladaPrimitive.h
//  RRCModelViewer
//
//  Created by Ricardo on 1/18/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

#import "RRCColladaObject.h"

@interface RRCColladaPrimitive : RRCColladaObject

typedef NS_ENUM(NSInteger, GLPrimitiveType)
{
    GLPrimitiveType_POLYLIST = 1,
    GLPrimitiveType_TRIANGLES,
};

@property (readwrite) GLPrimitiveType type;
@property (strong, nonatomic) NSArray* primitives;
@property (strong, nonatomic) NSArray* inputs;

@end
