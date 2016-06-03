//
//  ofxHapInAVFoundationPlayer.cpp
//  ofxHapInAVFoundation_example
//
//  Created by Joshua Batty on 24/05/2016.
//
//

#include "ofxHapInAVFoundationPlayer.h"
#import "HapInAVFTestAppDelegate.h"

// Was working off Memo's suggestions here https://forum.openframeworks.cc/t/objc-classes-within-of-app/2319/8
// And stealing ideas from ofxSyphon

//----------------------------------------------------------
void ofxHapInAVFoundation::setup(){

    hapDelegate = [[HapInAVFTestAppDelegate alloc] init];
    [hapDelegate awakeFromNib]; //-- Not sure if I need to call this here?

}

//----------------------------------------------------------
void ofxHapInAVFoundation::load(string _pathName){
    NSString *nsPathName = [NSString stringWithCString:_pathName.c_str() encoding:[NSString defaultCStringEncoding]];

    dispatch_async(dispatch_get_main_queue(), ^{
        [hapDelegate loadFileAtPath:nsPathName];
    });

}

//----------------------------------------------------------
void ofxHapInAVFoundation::update(){
    [hapDelegate renderCallback];
}

//--------------------------------------------------------------
void ofxHapInAVFoundation::draw(int x, int y, int w, int h) {

    //if(isLoaded() && isReady()) {
    
    HapPixelBufferTexture* hapTexture = [hapDelegate getHapTexture];
    if(hapTexture == nil) return;
    if(image.getWidth() != hapTexture.width || image.getHeight() != hapTexture.height){
        ofLogNotice() << "allocate OF video texture: " << hapTexture.width << "  x  " << hapTexture.height;
        //videoTexture.allocate(hapTexture.width, hapTexture.height, GL_RGBA);
        image.allocate(hapTexture.width, hapTexture.height, OF_IMAGE_COLOR_ALPHA);
        [hapDelegate setExternalRGB:image.getPixels().getData()];
        
        //videoTexture.texData.pixelType = GL_UNSIGNED_INT_8_8_8_8_REV;
        
    }

    //[hapTexture setExternalTextureID:videoTexture.getTextureData().textureID];
    
    // gameover: so something like this should work but at the moment i just get a white texture
    // this is either because I'm not sharing the context properly, not using a shader or possibly
    // because the GL texture decoding is not working totaly right on the HAP side of things - I say this
    // because when I run their demo app it's not working correctly - something is wrong with the sizes

    
//    videoTexture.setUseExternalTextureID([hapTexture textureNames][0]);
//    videoTexture.texData.textureTarget = GL_TEXTURE_2D;
//    videoTexture.texData.width = hapTexture.width;
//    videoTexture.texData.height = hapTexture.height;
//    videoTexture.texData.tex_w = hapTexture.width;
//    videoTexture.texData.tex_h = hapTexture.height;
//    videoTexture.texData.tex_t = hapTexture.width;
//    videoTexture.texData.tex_u = hapTexture.height;
//    videoTexture.texData.glInternalFormat = GL_BGRA;
//    videoTexture.texData.bFlipTexture = YES;
//    videoTexture.texData.bAllocated = YES;
//    videoTexture.setTextureMinMagFilter(GL_LINEAR, GL_LINEAR);
//    videoTexture.setTextureWrap(GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);
//    videoTexture.bind();

//    if(ofIsGLProgrammableRenderer() == false) {
//        videoTexture.bind();
//        glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
//        videoTexture.unbind();
//    }
    image.update();
    image.draw(x, y, w, h);
//        ofTexture * texturePtr = getTexturePtr();
//        if( texturePtr != NULL ){
//            if( texturePtr->isAllocated() ){
//              //  cout << "hello? ? " << endl;
//                texturePtr->draw(x, y, w, h);
//            }
//        }
   //}
}

//--------------------------------------------------------------
ofTexture * ofxHapInAVFoundation::getTexturePtr() {
    
//    if( bUseTextureCache == false ){
//        return NULL;
//    }
//    
//    if(isLoaded() == false || isReady() == false) {
//        return &videoTexture;
//    }
//    
//    if(bUpdateTexture == false) {
//        return &videoTexture;
//    }
    
    initTextureCache();
    
    //bUpdateTexture = false;
    
    return &videoTexture;
}

//--------------------------------------------------------------
void ofxHapInAVFoundation::initTextureCache(){
    
    CVImageBufferRef imageBuffer = [hapDelegate getCurrentFrame];
    if(imageBuffer == nil) {
        return;
    }
    
    CVPixelBufferLockBaseAddress(imageBuffer, kCVPixelBufferLock_ReadOnly);
    
    /**
     *  video texture cache is available.
     *  this means we don't have to copy any pixels,
     *  and we can reuse the already existing video texture.
     *  this is very fast! :)
     */
    
    /**
     *  CVOpenGLESTextureCache does this operation for us.
     *  it automatically returns a texture reference which means we don't have to create the texture ourselves.
     *  this creates a slight problem because when we create an ofTexture objects, it also creates a opengl texture for us,
     *  which is unecessary in this case because the texture already exists.
     *  so... we can use ofTexture::setUseExternalTextureID() to get around this.
     */
    
    int videoTextureW = getWidth();
    int videoTextureH = getHeight();
    videoTexture.allocate(videoTextureW, videoTextureH, GL_RGBA);
    
    ofTextureData & texData = videoTexture.getTextureData();
    texData.tex_t = 1.0f; // these values need to be reset to 1.0 to work properly.
    texData.tex_u = 1.0f; // assuming this is something to do with the way ios creates the texture cache.
    
    CVReturn err;
    unsigned int textureCacheID;
    
    err = CVOpenGLTextureCacheCreateTextureFromImage(nullptr,
                                                     _videoTextureCache,
                                                     imageBuffer,
                                                     nullptr,
                                                     &_videoTextureRef);
    
    textureCacheID = CVOpenGLTextureGetName(_videoTextureRef);
    
    videoTexture.setUseExternalTextureID(textureCacheID);
    videoTexture.setTextureMinMagFilter(GL_LINEAR, GL_LINEAR);
    videoTexture.setTextureWrap(GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE);
    if(ofIsGLProgrammableRenderer() == false) {
        videoTexture.bind();
        glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
        videoTexture.unbind();
    }
    
    if(err) {
        ofLogError("ofAVFoundationPlayer") << "initTextureCache(): error creating texture cache from image " << err << ".";
    }
    
    CVPixelBufferUnlockBaseAddress(imageBuffer, kCVPixelBufferLock_ReadOnly);
    
    CVOpenGLTextureCacheFlush(_videoTextureCache, 0);
    if(_videoTextureRef) {
        CVOpenGLTextureRelease(_videoTextureRef);
        _videoTextureRef = nullptr;
    }
}

//--------------------------------------------------------------
float ofxHapInAVFoundation::getWidth() const {
    if(hapDelegate == nullptr) {
        return 0;
    }
    return [hapDelegate getWidth];
}

//--------------------------------------------------------------
float ofxHapInAVFoundation::getHeight() const {
    if(hapDelegate == nullptr) {
        return 0;
    }
    return [hapDelegate getHeight];
}