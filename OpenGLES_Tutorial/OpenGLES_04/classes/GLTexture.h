//
//  GLTexture.h
//  OpenGLES
//
//  Created by HyunukKim on 2017. 10. 23..
//  Copyright © 2017년 gizingun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface GLTexture : NSObject
{
}

@property(nonatomic, readonly) GLuint   textureID;
@property(nonatomic, readonly) GLubyte  *imageData;
@property(nonatomic, readonly) size_t   width;
@property(nonatomic, readonly) size_t   height;

+(id)textureWithImagePath:(NSString *)path;
-(id)initWithImagePath:(NSString *)path;
-(BOOL)bindTexture;

@end
