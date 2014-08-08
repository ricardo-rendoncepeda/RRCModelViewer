//
//  RRCOpenglesTexture.m
//  RRCModelViewer
//
//  Created by Ricardo on 8/7/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

#import "RRCOpenglesTexture.h"

@interface RRCOpenglesTexture ()

@property (assign, nonatomic, readwrite) GLuint texture;

@end

@implementation RRCOpenglesTexture

- (instancetype)initWithName:(NSString *)textureName
{
    if(self = [super init])
    {
        UIImage* textureImage = [UIImage imageNamed:textureName];
        CGImageRef textureCGImage = textureImage.CGImage;
        CFDataRef textureData = CGDataProviderCopyData(CGImageGetDataProvider(textureCGImage));
        
        glGenTextures(1, &_texture);
        glBindTexture(GL_TEXTURE_2D, _texture);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, CGImageGetWidth(textureCGImage), CGImageGetHeight(textureCGImage), 0, GL_RGBA, GL_UNSIGNED_BYTE, CFDataGetBytePtr(textureData));
        
        CFRelease(textureData);
    }
    return self;
}

@end
