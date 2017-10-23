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
#import "GLTexture.h"

@implementation GLView
{
    EAGLContext *mContext;
    IRenderingEngine *mRenderingEngine;
    GLTexture *texture;
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
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat adjustScreenRatio = screenHeight / screenWidth;
    
    GLKMatrix4 modelMat = GLKMatrix4Identity;
    GLKMatrix4 projectMat = GLKMatrix4MakeOrtho(-1, 1, -adjustScreenRatio, adjustScreenRatio, -1, 1);
    
    mRenderingEngine->ApplyProjection(projectMat.m);
    mRenderingEngine->ApplyModel(modelMat.m);
    mRenderingEngine->Render();
    if ([texture bindTexture]) {
        mRenderingEngine->BindTexture([texture textureID]);
    }
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
    
    NSString *texturePath = [[NSBundle mainBundle] pathForResource:@"gl" ofType:@"png"];
    texture = [GLTexture textureWithImagePath:texturePath];
    
    [self drawView: nil];
    mTimestamp = CACurrentMediaTime();
}


@end
