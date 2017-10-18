//
//  GLView.m
//  HelloArrow
//
//  Created by hyunuk on 2017. 10. 16..
//  Copyright © 2017년 snowcorp. All rights reserved.
//

#import "GLView.h"
#import <OpenGLES/ES2/gl.h>

@implementation GLView

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)super.layer;
        [eaglLayer setOpaque:YES];
        
        EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
        m_context = [[EAGLContext alloc] initWithAPI:api];
        
        
    }
    
    return self;
}

@end
