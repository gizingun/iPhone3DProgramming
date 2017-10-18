//
//  GLView.m
//  OpenGLES_01
//
//  Created by hyunuk on 2017. 10. 18..
//  Copyright © 2017년 gizingun. All rights reserved.
//

#import "GLView.h"

@implementation GLView

+(Class)layerClass
{
    return [CAEAGLLayer class];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setupLayer];
        [self setupContext];
        [self setupRenderBuffer];
        [self setupFrameBuffer];
        [self setupDisplayLink];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupLayer];
        [self setupContext];
        [self setupRenderBuffer];
        [self setupFrameBuffer];
        [self setupDisplayLink];
    }
    return self;
}

#pragma mark - Private methods

- (void)setupLayer
{
    eaglLayer = (CAEAGLLayer *)self.layer;
    [eaglLayer setOpaque:YES];
}

-(void)setupContext
{
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    context = [[EAGLContext alloc] initWithAPI:api];
    if(context == nil)
    {
        NSLog(@"OpenGLES 1.0 Context 초기화 실패");
        exit(1);
    }
    
    if(![EAGLContext setCurrentContext:context])
    {
        NSLog(@"현재 OpenGL context 설정 실패");
        exit(1);
    }
}

-(void)setupRenderBuffer
{
    glGenRenderbuffers(1, &colorRenderBuffer); //: OpenGL이 렌더버퍼를 생성하고 핸들값을 받아 온다.
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderBuffer); //: 렌더 버퍼 핸들을 렌더 버퍼에 바인딩 한다
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:eaglLayer]; //: 컨텍스트가 CAEAGLLayer에 비트맵을 담을 공간을 할당한다.
}

-(void)setupFrameBuffer
{
    GLuint framebuffer;
    glGenFramebuffers(1, &framebuffer);  //: 프레임버퍼 생성및핸들값 가져오기
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer); //: 프레임버퍼에 핸들값 바인딩하기
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderBuffer);  //: 프레임버퍼의 컬러렌더링버퍼 슬롯에 컬러렌더링버퍼 꼽기
}

-(void)setupDisplayLink
{
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

-(void)render:(CADisplayLink *)displayLink
{
    glClearColor(1.0, 0.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    [context presentRenderbuffer:GL_RENDERBUFFER];
}

@end
