//
//  GLView.m
//  HelloArrow
//
//  Created by hyunuk on 2017. 10. 16..
//  Copyright © 2017년 snowcorp. All rights reserved.
//

#import "GLView.h"
#import <OpenGLES/ES2/gl.h>
#import "IRenderingEngine.hpp"

@implementation GLView
{
    EAGLContext *m_context;
    IRenderingEngine *m_renderingEngine;
    float m_timestamp;
}

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)super.layer;
        [eaglLayer setOpaque:YES];
        
        EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
        m_context = [[EAGLContext alloc] initWithAPI:api];
        [EAGLContext setCurrentContext:m_context];
        
        m_renderingEngine = CreateRenderer2();
        
        [m_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:eaglLayer];
        
        m_renderingEngine->Initialize((int)frame.size.width, (int)frame.size.height);
        
        [self drawView: nil];
        m_timestamp = CACurrentMediaTime();
        
        CADisplayLink* displayLink;
        displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawView:)];
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                          forMode:NSDefaultRunLoopMode];

        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    
    return self;
}

#pragma mark - Public methods

- (void)drawView:(CADisplayLink *)displayLink
{
    if (displayLink != nil) {
        float elapsedSeconds = displayLink.timestamp - m_timestamp;
        m_timestamp = displayLink.timestamp;
        m_renderingEngine->UpdateAnimation(elapsedSeconds);
    }
    
    m_renderingEngine->Render();
    [m_context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)didRotate:(NSNotification *)notification
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    m_renderingEngine->OnRotate((DeviceOrientation) orientation);
    [self drawView: nil];
}

@end
