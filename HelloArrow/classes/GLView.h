//
//  GLView.h
//  HelloArrow
//
//  Created by hyunuk on 2017. 10. 16..
//  Copyright © 2017년 snowcorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRenderingEngine.hpp"

@interface GLView : UIView
{
    @private
    EAGLContext *m_context;
    IRenderingEngine *m_renderingEngine;
    float m_timestamp;
}

@end