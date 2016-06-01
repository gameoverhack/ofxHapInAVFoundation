//
//  ofxHapInAVFoundationPlayer.h
//  ofxHapInAVFoundation_example
//
//  Created by Joshua Batty on 24/05/2016.
//
//

#include "ofMain.h"

#ifdef __OBJC__
#import "HapInAVFTestAppDelegate.h"
#endif

class ofxHapInAVFoundation {
public:
    void setup();
    void load(string _pathName);

    void update();
    
    void draw(int x, int y, int w, int h);
    ofTexture * getTexturePtr();
    void initTextureCache();

    float getWidth() const;
    float getHeight() const;
    
private:
    ofTexture videoTexture;
    
#ifdef __OBJC__
    HapInAVFTestAppDelegate * hapDelegate;
#else
    void * hapDelegate;
#endif
    
    CVOpenGLTextureCacheRef _videoTextureCache = nullptr;
    CVOpenGLTextureRef _videoTextureRef = nullptr;
};