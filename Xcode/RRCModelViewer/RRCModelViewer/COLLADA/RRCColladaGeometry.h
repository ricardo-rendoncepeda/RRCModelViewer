//
//  RRCColladaGeometry.h
//  RRCModelViewer
//
//  Created by Ricardo on 1/18/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

#import "RRCColladaObject.h"
#import "RRCColladaMesh.h"

@interface RRCColladaGeometry : RRCColladaObject

@property (strong, nonatomic, readonly) NSString* identifier;
@property (strong, nonatomic, readonly) NSString* name;
@property (strong, nonatomic, readonly) RRCColladaMesh* mesh;

@end
