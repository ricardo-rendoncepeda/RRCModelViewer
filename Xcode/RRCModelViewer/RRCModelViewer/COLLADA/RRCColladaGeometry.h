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

@property (strong, nonatomic) NSString* identifier;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) RRCColladaMesh* mesh;

@end
