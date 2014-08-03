//
//  RRCColladaMesh.h
//  RRCModelViewer
//
//  Created by Ricardo on 1/18/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

#import "RRCColladaObject.h"
#import "RRCColladaSource.h"
#import "RRCColladaVertices.h"
#import "RRCColladaPrimitive.h"

@interface RRCColladaMesh : RRCColladaObject

@property (strong, nonatomic, readonly) RRCColladaPrimitive* primitive;
@property (strong, nonatomic, readonly) RRCColladaVertices* vertices;
@property (strong, nonatomic, readonly) NSArray* sources;

@end
