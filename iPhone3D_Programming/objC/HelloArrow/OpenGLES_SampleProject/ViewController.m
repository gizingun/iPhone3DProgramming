//
//  ViewController.m
//  OpenGLES_SampleProject
//
//  Created by hyunuk on 2017. 10. 19..
//  Copyright © 2017년 gizingun. All rights reserved.
//

#import "ViewController.h"
#import "GLView.h"

@interface ViewController ()
{
    GLView *glView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
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

@end
