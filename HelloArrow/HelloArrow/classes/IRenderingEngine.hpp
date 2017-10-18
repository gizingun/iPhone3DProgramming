//
//  IRenderingEngine.h
//  HelloArrow
//
//  Created by hyunuk on 2017. 10. 16..
//  Copyright © 2017년 snowcorp. All rights reserved.
//

#ifndef IRenderingEngine_h
#define IRenderingEngine_h

enum DeviceOrientation {
    DeviceOrientationUnknown,
    DeviceOrientationPortrait,
    DeviceOrientationPortraitUpsideDown,
    DeviceOrientationLandscapeLeft,
    DeviceOrientationLandscapeRight,
    DeviceOrientationFaceUp,
    DeviceOrientationFaceDown,
};

struct IRenderingEngine* CreateRenderer2();

// Interface to the OpenGL ES renderer; consumed by GLView.
struct IRenderingEngine {
    virtual void Initialize(int width, int height) = 0;
    virtual void Render() const = 0;
    virtual void UpdateAnimation(float timeStep) = 0;
    virtual void OnRotate(DeviceOrientation newOrientation) = 0;
    virtual ~IRenderingEngine() {}
};

#endif /* IRenderingEngine_h */
