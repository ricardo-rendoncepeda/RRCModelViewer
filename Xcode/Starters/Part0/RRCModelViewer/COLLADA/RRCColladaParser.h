//
//  RRCColladaParser.h
//  RRCModelViewer
//
//  Created by Ricardo on 1/18/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

#import "RRCColladaObject.h"

@interface RRCColladaParser : NSObject

@property (strong, nonatomic, readonly) RRCColladaObject* collada;

- (instancetype)initWithXML:(NSString*)xml;
- (BOOL)didParseXML;
- (void)logCOLLADA;

@end
