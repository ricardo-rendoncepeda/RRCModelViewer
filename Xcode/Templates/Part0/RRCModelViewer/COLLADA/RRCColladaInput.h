//
//  RRCColladaInput.h
//  RRCModelViewer
//
//  Created by Ricardo on 1/18/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

#import "RRCColladaObject.h"
#import "RRCColladaSource.h"

@interface RRCColladaInput : RRCColladaObject

typedef NS_ENUM(NSInteger, RRCColladaInputSemantic)
{
    RRCColladaInputSemantic_POSITION = 1,
    RRCColladaInputSemantic_VERTEX,
    RRCColladaInputSemantic_NORMAL,
    RRCColladaInputSemantic_TEXCOORD,
};

@property (strong, nonatomic, readonly) NSString* source;
@property (assign, nonatomic, readonly) RRCColladaInputSemantic semantic;
@property (assign, nonatomic, readonly) NSInteger offset;

- (RRCColladaInputSemantic)semanticFromString:(NSString*)string;

@end
