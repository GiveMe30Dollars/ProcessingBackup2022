String path;
int frameLimit;
boolean recording = false;

void recordStart(String path_){
  recordStart(path,-1);
}

void recordStart(String path_, int fL_){
  path = path_;
  frameLimit = fL_;
  recording = true;
  frameCount = 0;
}

void recordUpdate(){
  if (!recording){
    print("\nNOT RECORDING.");
    return;
  }
  print("\nRECORDING:    "+frameCount + "     " + frameRate);
  saveFrame(path + "/####.png");
  if(frameLimit <= 0) return;
  if (frameCount >= frameLimit){
    recording = false;
  }
}

void recordEnd(){
  print("FORCE END.");
  recording = false;
}
