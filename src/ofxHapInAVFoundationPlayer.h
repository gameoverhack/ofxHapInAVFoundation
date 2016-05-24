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
    
    ofTexture * getTexture();

private:
    ofTexture _texture;
    void *hapDelegate;
};