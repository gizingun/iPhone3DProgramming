//
//  ViewController.m
//  OpenGLES_01
//
//  Created by hyunuk on 2017. 10. 18..
//  Copyright © 2017년 gizingun. All rights reserved.
//

#import "ViewController.h"
#import "GLView.h"

@interface ViewController ()
{
    GLView *glView;
    
    CADisplayLink *mDisplayLink;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    mDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawView:)];
    [mDisplayLink addToRunLoop:[NSRunLoop currentRunLoop]
                       forMode:NSDefaultRunLoopMode];
    
    glView = [[GLView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:glView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    if (glView) {
        [glView removeFromSuperview];
        glView = nil;
    }

    glView = [[GLView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [self.view addSubview:glView];
}

#pragma mark - Selector methods

- (void)drawView:(CADisplayLink *)displayLink
{
    [glView drawView:displayLink];
}
@end
