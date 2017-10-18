//
//  ArrowViewController.m
//  HelloArrow
//
//  Created by hyunuk on 2017. 10. 18..
//  Copyright © 2017년 snowcorp. All rights reserved.
//

#import "ArrowViewController.h"
#import "GLView.h"

@interface ArrowViewController ()
{
    GLView *glView;
}
@end

@implementation ArrowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
