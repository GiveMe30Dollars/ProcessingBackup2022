import com.hamoid.*;

int frameLimit;
VideoExport export;

void recordStart(int fL_, String name){
  frameLimit = fL_;
  export = new VideoExport(this, name);
  export.setFrameRate(60);
  export.setQuality(51,0);
  export.startMovie();
}

void recordUpdate(){
  print("RECORDING:    "+frameCount + "     " + frameRate + "\n");
  export.saveFrame();
  if(frameLimit <= 0) return;
  if (frameCount >= frameLimit){
    export.endMovie();
    noLoop();
  }
}

void recordEnd(){
  print("FORCE END.");
  export.endMovie();
  noLoop();
}
