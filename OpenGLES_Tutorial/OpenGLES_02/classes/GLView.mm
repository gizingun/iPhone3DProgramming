//
//  GLView.m
//  OpenGLES_01
//
//  Created by hyunuk on 2017. 10. 18..
//  Copyright © 2017년 gizingun. All rights reserved.
//

#import "GLView.h"
#import "IRenderingEngine.hpp"
#import <GLKit/GLKit.h>

@implementation GLView
{
    EAGLContext *mContext;
    IRenderingEngine *mRenderingEngine;
    float mTimestamp;
}

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupGLViewrWithFrame:frame];
    }
    return self;
}

- (void)dealloc
{
    if (mRenderingEngine) {
        mRenderingEngine->~IRenderingEngine();
        mRenderingEngine = NULL;
    }
}

#pragma mark - Override methods

- (void)removeFromSuperview
{
    [super removeFromSuperview];
}

#pragma mark - Selector methods

- (void)drawView:(CADisplayLink *)displayLink
{
    if (displayLink != nil) {
//        float elapsedSeconds = displayLink.timestamp - mTimestamp;
//        mTimestamp = displayLink.timestamp;
//        mRenderingEngine->UpdateAnimation(elapsedSeconds);
    }
    
    GLKMatrix4 modelMat = GLKMatrix4Identity;
    GLKMatrix4 projectMat = GLKMatrix4MakeOrtho(0, 1, 0, 1, -1, 1);
    
    mRenderingEngine->ApplyProjection(projectMat.m);
    mRenderingEngine->ApplyModel(modelMat.m);
    mRenderingEngine->Render();
    [mContext presentRenderbuffer:GL_RENDERBUFFER];
}

#pragma mark - Private methods

- (void)setupGLViewrWithFrame:(CGRect)frame
{
    CAEAGLLayer *eaglLayer = (CAEAGLLayer *)super.layer;
    [eaglLayer setOpaque:YES];
    [eaglLayer setDrawableProperties:@{kEAGLDrawablePropertyRetainedBacking:@(YES), kEAGLDrawablePropertyColorFormat:kEAGLColorFormatRGBA8}];
    
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    mContext = [[EAGLContext alloc] initWithAPI:api];
    [EAGLContext setCurrentContext:mContext];
    
    mRenderingEngine = CreateRenderer2();
    [mContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:eaglLayer];
    
    mRenderingEngine->Initialize((int)frame.size.width, (int)frame.size.height);
    
    [self drawView: nil];
    mTimestamp = CACurrentMediaTime();
}


@end
