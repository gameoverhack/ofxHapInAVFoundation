#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){

    hap.setup();
    hap.load("/Volumes/GhostDriver/Users/gameover/Code/hap-quicktime-playback-demo/HapQuickTimePlayback/SampleHap.mov");//"Volumes/GhostDriver/Users/gameover/Desktop/PsychoHAPTest.mov");
}

//--------------------------------------------------------------
void ofApp::update(){
    hap.update();
}

//--------------------------------------------------------------
void ofApp::draw(){
    ofSetColor(255,255,255);
    hap.draw(0,0,ofGetWidth(),ofGetHeight());
}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){

}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){

}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y ){

}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseEntered(int x, int y){

}

//--------------------------------------------------------------
void ofApp::mouseExited(int x, int y){

}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){

}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){ 

}
