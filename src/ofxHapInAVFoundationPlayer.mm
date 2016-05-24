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
    // Need pool
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    NSMutableArray *hapNSMutableArray;
    // Assign our void pointer a copy of the mutable array
    hapDelegate = hapNSMutableArray;
    
    hapDelegate = [[NSMutableArray alloc] init];
    id tempHap = [[HapInAVFTestAppDelegate alloc] init];
    
    [tempHap awakeFromNib]; //-- Not sure if I need to call this here?
    [hapDelegate addObject:tempHap];
    [tempHap release];
    
    [pool drain];
}

//----------------------------------------------------------
void ofxHapInAVFoundation::load(string _pathName){
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

    id tempHap = [[HapInAVFTestAppDelegate alloc] init];

    NSString *nsPathName = [NSString stringWithCString:_pathName.c_str() encoding:[NSString defaultCStringEncoding]];
    [tempHap loadFileAtPath:nsPathName];
    [hapDelegate addObject:tempHap];
    [tempHap release];
    
    [pool drain];
}

//----------------------------------------------------------
void ofxHapInAVFoundation::update(){
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    [hapDelegate makeObjectsPerformSelector:@selector(renderCallback)];
    [pool drain];
}

//----------------------------------------------------------
ofTexture* ofxHapInAVFoundation::getTexture(){
    
  //  CVImageBufferRef imageBuffer = [hapDelegate hapTexture];
    
    return &_texture;
}