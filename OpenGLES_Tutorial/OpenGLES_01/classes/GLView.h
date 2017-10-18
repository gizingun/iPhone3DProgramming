//
//  GLView.h
//  OpenGLES_01
//
//  Created by hyunuk on 2017. 10. 18..
//  Copyright © 2017년 gizingun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>

@interface GLView : UIView
{
    CAEAGLLayer        *eaglLayer;         //: 1
    EAGLContext        *context;             //: 2
    GLuint            colorRenderBuffer;    //: 3
}

@end
