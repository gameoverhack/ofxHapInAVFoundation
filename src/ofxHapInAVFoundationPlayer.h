//
//  ofxHapInAVFoundationPlayer.h
//  ofxHapInAVFoundation_example
//
//  Created by Joshua Batty on 24/05/2016.
//
//

#include "ofMain.h"

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
    void *hapDelegate;
    
    CVOpenGLTextureCacheRef _videoTextureCache = nullptr;
    CVOpenGLTextureRef _videoTextureRef = nullptr;
};